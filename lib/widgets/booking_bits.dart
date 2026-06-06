import 'package:flutter/material.dart';
import '../core/theme.dart';
import '../core/icons.dart';
import '../data/models.dart';

/// Animated taka value (RollingNumber).
class RollingNumber extends StatelessWidget {
  final int value;
  final TextStyle style;
  const RollingNumber(this.value, {super.key, required this.style});
  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: value.toDouble(), end: value.toDouble()),
      duration: const Duration(milliseconds: 420),
      curve: Curves.easeOutCubic,
      builder: (_, v, _) => Text(taka(v), style: style),
    );
  }
}

/// Segmented / compact tier selector (TierSelector).
class TierSelector extends StatelessWidget {
  final String value;
  final ValueChanged<String> onChange;
  final Base prices;
  final bool compact;
  const TierSelector(
      {super.key, required this.value, required this.onChange, required this.prices, this.compact = false});

  @override
  Widget build(BuildContext context) {
    if (compact) {
      return Row(
        children: [
          for (final t in tiers) ...[
            Expanded(child: _compactTile(t)),
            if (t != tiers.last) const SizedBox(width: 8),
          ],
        ],
      );
    }
    final idx = tiers.indexWhere((t) => t.key == value);
    return LayoutBuilder(builder: (context, c) {
      final segW = (c.maxWidth - 10) / 3;
      final sel = tiers[idx];
      return Container(
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: C.cloud,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: C.hairline),
        ),
        child: Stack(
          children: [
            AnimatedPositioned(
              duration: const Duration(milliseconds: 320),
              curve: Curves.easeOutBack,
              left: idx * segW,
              top: 0,
              bottom: 0,
              width: segW,
              child: Container(
                decoration: BoxDecoration(
                  gradient: sel.gradient ? G.gold : null,
                  color: sel.gradient ? null : C.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: sel.gradient ? null : Border.all(color: sel.color, width: 1.5),
                  boxShadow: const [BoxShadow(color: Color(0x1F14201D), blurRadius: 12, offset: Offset(0, 4))],
                ),
              ),
            ),
            Row(
              children: [
                for (final t in tiers)
                  Expanded(child: _segTile(t)),
              ],
            ),
          ],
        ),
      );
    });
  }

  Widget _segTile(Tier t) {
    final on = value == t.key;
    final onColor = t.gradient ? Colors.white : t.color;
    return GestureDetector(
      onTap: () => onChange(t.key),
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 9),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Ic(t.icon, size: 17, color: on ? onColor : C.mist),
            const SizedBox(height: 4),
            Text(t.short,
                style: T.b(11.5, w: on ? FontWeight.w700 : FontWeight.w600, color: on ? onColor : C.mist)),
          ],
        ),
      ),
    );
  }

  Widget _compactTile(Tier t) {
    final on = value == t.key;
    final accent = t.gradient ? C.saffronDark : t.color;
    return GestureDetector(
      onTap: () => onChange(t.key),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
        decoration: BoxDecoration(
          color: on ? Color.alphaBlend(accent.withValues(alpha: 0.10), Colors.white) : C.surface,
          borderRadius: BorderRadius.circular(13),
          border: Border.all(color: on ? accent : C.hairline, width: on ? 1.5 : 1),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Ic(t.icon, size: 17, color: accent),
            const SizedBox(height: 3),
            Text(t.short, style: T.b(11, w: FontWeight.w600, color: on ? accent : C.slate)),
          ],
        ),
      ),
    );
  }
}

/// 15-day price strip (PriceTable).
class PriceTable extends StatefulWidget {
  final List<PriceDay> days;
  final int selected;
  final ValueChanged<int> onPick;
  const PriceTable({super.key, required this.days, required this.selected, required this.onPick});
  @override
  State<PriceTable> createState() => _PriceTableState();
}

class _PriceTableState extends State<PriceTable> {
  final _controller = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // center "today" (index 7): each tile 62 + 9 gap
      if (_controller.hasClients) {
        final target = (7 * 71.0) - _controller.position.viewportDimension / 2 + 35;
        _controller.jumpTo(target.clamp(0, _controller.position.maxScrollExtent));
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final future = widget.days.where((d) => d.offset > 0).toList();
    var cheapest = widget.days[8];
    for (final d in future) {
      if (d.price < cheapest.price) cheapest = d;
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
          child: Row(
            children: [
              const Icon(Icons.auto_awesome_rounded, size: 15, color: C.saffron),
              const SizedBox(width: 7),
              Expanded(
                child: Text.rich(TextSpan(children: [
                  TextSpan(text: 'Cheapest soon: ', style: T.b(12.5, w: FontWeight.w500, color: C.slate)),
                  TextSpan(
                      text: '${cheapest.label} ${cheapest.dayNum} · ${taka(cheapest.price)}',
                      style: T.b(12.5, w: FontWeight.w700, color: C.success)),
                ])),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 96,
          child: ListView.separated(
            controller: _controller,
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: widget.days.length,
            separatorBuilder: (_, _) => const SizedBox(width: 9),
            itemBuilder: (_, i) => _tile(widget.days[i]),
          ),
        ),
      ],
    );
  }

  Widget _tile(PriceDay d) {
    final sel = widget.selected == d.offset;
    final tcol = d.trend == 'down' ? C.success : (d.trend == 'up' ? C.error : C.slate);
    return GestureDetector(
      onTap: () => widget.onPick(d.offset),
      child: Container(
        width: 62,
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 10),
        decoration: BoxDecoration(
          gradient: d.isToday ? G.gold : null,
          color: d.isToday ? null : (sel ? C.emeraldTint : C.surface),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: sel ? C.emerald : C.hairline, width: sel ? 1.5 : 1),
          boxShadow: d.isToday
              ? const [BoxShadow(color: Color(0x4DC9821E), blurRadius: 16, offset: Offset(0, 6))]
              : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(d.isToday ? 'Today' : d.label,
                style: T.b(11, w: FontWeight.w600, color: d.isToday ? Colors.white70 : C.mist)),
            const SizedBox(height: 4),
            Text('${d.dayNum} ${d.month}',
                style: T.b(12, w: FontWeight.w700, color: d.isToday ? Colors.white : C.ink)),
            const SizedBox(height: 4),
            Text('${(d.price / 1000).toStringAsFixed(1)}k',
                style: T.b(12, w: FontWeight.w700, color: d.isToday ? Colors.white : C.ink)),
            const SizedBox(height: 2),
            if (d.isToday)
              Text('base', style: T.b(9, w: FontWeight.w600, color: Colors.white70))
            else
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (d.trend != 'flat')
                    Icon(d.trend == 'down' ? Icons.trending_down_rounded : Icons.trending_up_rounded,
                        size: 11, color: tcol),
                  Text(
                    d.delta != 0
                        ? '${d.delta > 0 ? '+' : ''}${(d.delta / 100).round() / 10}k'
                        : '—',
                    style: T.b(9, w: FontWeight.w700, color: tcol),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
