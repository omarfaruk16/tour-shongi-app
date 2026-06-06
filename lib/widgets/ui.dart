import 'package:flutter/material.dart';
import '../core/theme.dart';
import '../core/icons.dart';

/// ★ rating, optional number + review count (Stars).
class Stars extends StatelessWidget {
  final double rating;
  final double size;
  final bool showNum;
  final int? reviews;
  final Color color;
  const Stars(this.rating,
      {super.key, this.size = 13, this.showNum = true, this.reviews, this.color = C.saffron});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.star_rounded, size: size, color: color),
        if (showNum) ...[
          const SizedBox(width: 4),
          Text(rating.toString(),
              style: T.b(size, w: FontWeight.w600, color: C.ink)),
        ],
        if (reviews != null) ...[
          const SizedBox(width: 4),
          Text('(${thou(reviews!)})', style: T.b(size - 1, w: FontWeight.w500, color: C.mist)),
        ],
      ],
    );
  }
}

/// "3 tiers" glassy pill on card media (TierPill).
class TierPill extends StatelessWidget {
  final bool small;
  const TierPill({super.key, this.small = false});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: small ? 9 : 11, vertical: small ? 4 : 5),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.82),
        borderRadius: BorderRadius.circular(999),
        boxShadow: const [BoxShadow(color: Color(0x1F14201D), blurRadius: 8, offset: Offset(0, 2))],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.auto_awesome_rounded, size: small ? 11 : 12, color: C.saffron),
          const SizedBox(width: 5),
          Text('3 tiers', style: T.b(small ? 10 : 11, w: FontWeight.w600, color: C.ink)),
        ],
      ),
    );
  }
}

/// "20% OFF" amber ribbon (Ribbon).
class Ribbon extends StatelessWidget {
  final int off;
  const Ribbon(this.off, {super.key});
  @override
  Widget build(BuildContext context) {
    if (off == 0) return const SizedBox.shrink();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        gradient: G.gold,
        borderRadius: BorderRadius.circular(999),
        boxShadow: const [BoxShadow(color: Color(0x66C9821E), blurRadius: 10, offset: Offset(0, 3))],
      ),
      child: Text('$off% OFF', style: T.b(11, w: FontWeight.w700, color: Colors.white)),
    );
  }
}

/// Glassy favourite heart button (FavHeart).
class FavHeart extends StatelessWidget {
  final bool active;
  final VoidCallback onToggle;
  final double size;
  const FavHeart({super.key, required this.active, required this.onToggle, this.size = 36});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onToggle,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.82),
          shape: BoxShape.circle,
          boxShadow: const [BoxShadow(color: Color(0x2414201D), blurRadius: 8, offset: Offset(0, 2))],
        ),
        child: Icon(active ? Icons.favorite_rounded : Icons.favorite_border_rounded,
            size: 18, color: active ? C.error : C.slate),
      ),
    );
  }
}

/// Pill chip used in filters / category rows (Chip).
class TSChip extends StatelessWidget {
  final String label;
  final bool active;
  final VoidCallback onTap;
  const TSChip(this.label, {super.key, required this.active, required this.onTap});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
        decoration: BoxDecoration(
          color: active ? C.emeraldTint : C.surface,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: active ? C.emerald : C.hairline),
        ),
        child: Text(label,
            style: T.b(13, w: FontWeight.w600, color: active ? C.emeraldDark : C.slate)),
      ),
    );
  }
}

enum BtnVariant { primary, gold, outline, ghost }

/// Button (matches the prototype's Button variants) with a press-scale animation.
class TSButton extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final BtnVariant variant;
  final bool full;
  final bool large;
  final EdgeInsets? padding;
  const TSButton({
    super.key,
    required this.child,
    this.onTap,
    this.variant = BtnVariant.primary,
    this.full = false,
    this.large = false,
    this.padding,
  });

  @override
  State<TSButton> createState() => _TSButtonState();
}

class _TSButtonState extends State<TSButton> {
  bool _down = false;

  @override
  Widget build(BuildContext context) {
    final variant = widget.variant;
    final full = widget.full;
    final large = widget.large;
    final padding = widget.padding;
    final onTap = widget.onTap;
    final child = widget.child;
    Gradient? grad;
    Color? bg;
    Color fg;
    Border? border;
    List<BoxShadow> shadow = const [];
    switch (variant) {
      case BtnVariant.primary:
        grad = G.emerald;
        fg = Colors.white;
        shadow = S.greenBtn;
        break;
      case BtnVariant.gold:
        grad = G.gold;
        fg = Colors.white;
        shadow = const [BoxShadow(color: Color(0x57C9821E), blurRadius: 20, offset: Offset(0, 8))];
        break;
      case BtnVariant.outline:
        bg = Colors.transparent;
        fg = C.emeraldDark;
        border = Border.all(color: C.emerald, width: 1.5);
        break;
      case BtnVariant.ghost:
        bg = C.emeraldTint;
        fg = C.emeraldDark;
        break;
    }
    final pad = padding ??
        EdgeInsets.symmetric(horizontal: large ? 24 : 20, vertical: large ? 16 : 12);
    return GestureDetector(
      onTapDown: onTap == null ? null : (_) => setState(() => _down = true),
      onTapUp: onTap == null ? null : (_) => setState(() => _down = false),
      onTapCancel: onTap == null ? null : () => setState(() => _down = false),
      onTap: onTap,
      child: AnimatedScale(
        scale: _down ? 0.96 : 1,
        duration: const Duration(milliseconds: 130),
        curve: Curves.easeOut,
        child: Container(
          width: full ? double.infinity : null,
          padding: pad,
          decoration: BoxDecoration(
            gradient: grad,
            color: bg,
            border: border,
            borderRadius: BorderRadius.circular(R.button),
            boxShadow: shadow,
          ),
          child: DefaultTextStyle(
            style: T.d(large ? 16 : 14.5, w: FontWeight.w700, color: fg),
            child: IconTheme(
              data: IconThemeData(color: fg, size: large ? 18 : 17),
              child: Row(
                mainAxisSize: full ? MainAxisSize.max : MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [child],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Section header with optional "See all" action (SectionHeader).
class SectionHeader extends StatelessWidget {
  final String title;
  final String? sub;
  final String action;
  final VoidCallback? onAction;
  const SectionHeader(this.title, {super.key, this.sub, this.action = 'See all', this.onAction});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: T.d(20, w: FontWeight.w700, spacing: -0.3)),
                if (sub != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 3),
                    child: Text(sub!, style: T.b(13, w: FontWeight.w500, color: C.mist)),
                  ),
              ],
            ),
          ),
          if (onAction != null)
            GestureDetector(
              onTap: onAction,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(action, style: T.b(13, w: FontWeight.w600, color: C.emerald)),
                  const SizedBox(width: 3),
                  const Icon(Icons.arrow_forward_rounded, size: 15, color: C.emerald),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

/// −/value/+ stepper (QtyStepper).
class QtyStepper extends StatelessWidget {
  final int value;
  final ValueChanged<int> onChange;
  final int min, max;
  const QtyStepper(this.value, this.onChange, {super.key, this.min = 1, this.max = 20});
  @override
  Widget build(BuildContext context) {
    Widget btn(bool dis, VoidCallback onTap, String name) => GestureDetector(
          onTap: dis ? null : onTap,
          child: Opacity(
            opacity: dis ? 0.4 : 1,
            child: Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: C.surface,
                shape: BoxShape.circle,
                border: Border.all(color: C.hairline),
              ),
              child: Ic(name, size: 16, color: C.emeraldDark),
            ),
          ),
        );
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        btn(value <= min, () => onChange(value - 1), 'minus'),
        const SizedBox(width: 14),
        SizedBox(
          width: 18,
          child: Text('$value',
              textAlign: TextAlign.center, style: T.b(16, w: FontWeight.w700)),
        ),
        const SizedBox(width: 14),
        btn(value >= max, () => onChange(value + 1), 'plus'),
      ],
    );
  }
}

/// Small rounded icon button used in headers (iconBtn style).
class IconBtn extends StatelessWidget {
  final String icon;
  final VoidCallback? onTap;
  final Color color;
  final Widget? badge;
  const IconBtn(this.icon, {super.key, this.onTap, this.color = C.ink, this.badge});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          color: C.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: C.hairline),
          boxShadow: const [BoxShadow(color: Color(0x0D14201D), blurRadius: 8, offset: Offset(0, 2))],
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [Ic(icon, size: 20, color: color), ?badge],
        ),
      ),
    );
  }
}
