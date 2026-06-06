import 'package:flutter/material.dart';
import '../core/theme.dart';
import '../core/icons.dart';
import '../data/groups.dart';
import 'photo.dart';
import 'ui.dart';
import 'anim.dart';

/// Horizontal "N left of M" seats bar (SlotBar, orient='h', style='count').
class SlotBar extends StatelessWidget {
  final int booked, capacity;
  const SlotBar({super.key, required this.booked, required this.capacity});
  @override
  Widget build(BuildContext context) {
    final left = (capacity - booked).clamp(0, capacity);
    final frac = (booked / capacity).clamp(0.0, 1.0);
    final almost = left <= 6;
    final full = left <= 0;
    final fill = full ? C.mist : (almost ? C.saffron : C.emerald);
    final track = full ? C.hairline : (almost ? const Color(0x29E8A33D) : C.emeraldTint);
    final col = full ? C.mist : (almost ? C.saffronDark : C.emeraldDark);
    return Row(
      children: [
        Expanded(
          child: GrowBar(
            value: frac,
            color: fill,
            track: track,
            gradient: full
                ? null
                : LinearGradient(colors: [Color.alphaBlend(fill.withValues(alpha: 0.6), Colors.white), fill]),
          ),
        ),
        const SizedBox(width: 10),
        Text.rich(TextSpan(children: [
          TextSpan(text: full ? 'Full' : '$left', style: T.d(14, w: FontWeight.w800, color: col)),
          if (!full) TextSpan(text: ' left', style: T.b(12, w: FontWeight.w600, color: C.slate)),
          if (!full) TextSpan(text: '  of $capacity', style: T.b(12, w: FontWeight.w600, color: C.mist)),
        ])),
      ],
    );
  }
}

/// Male / Female counts (GenderSplit).
class GenderSplit extends StatelessWidget {
  final int male, female;
  final bool large;
  const GenderSplit({super.key, required this.male, required this.female, this.large = false});
  @override
  Widget build(BuildContext context) {
    final fs = large ? 13.0 : 11.5;
    return Row(mainAxisSize: MainAxisSize.min, children: [
      Icon(Icons.male_rounded, size: fs + 3, color: const Color(0xFF4E8FCC)),
      const SizedBox(width: 4),
      Text('$male', style: T.b(fs, w: FontWeight.w600, color: C.slate)),
      const SizedBox(width: 10),
      Icon(Icons.female_rounded, size: fs + 3, color: const Color(0xFFD06A99)),
      const SizedBox(width: 4),
      Text('$female', style: T.b(fs, w: FontWeight.w600, color: C.slate)),
    ]);
  }
}

/// Host avatar chip (HostChip).
class HostChip extends StatelessWidget {
  final TravelGroup? group;
  final VoidCallback? onTap;
  final bool light;
  const HostChip({super.key, required this.group, this.onTap, this.light = false});
  @override
  Widget build(BuildContext context) {
    final g = group;
    if (g == null) return const SizedBox.shrink();
    return Pressable(
      onTap: onTap,
      scale: 0.97,
      child: Container(
        padding: const EdgeInsets.fromLTRB(4, 4, 10, 4),
        decoration: BoxDecoration(
          color: light ? Colors.white.withValues(alpha: 0.85) : C.cloud,
          borderRadius: BorderRadius.circular(999),
        ),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          ClipOval(
            child: SizedBox(width: 22, height: 22, child: Photo(src: unsplash(g.img, 80), hue: g.hue, radius: 0)),
          ),
          const SizedBox(width: 7),
          Text(g.name, style: T.d(11.5, w: FontWeight.w700)),
          if (g.verified) ...[
            const SizedBox(width: 4),
            const Icon(Icons.check_rounded, size: 11, color: C.info),
          ],
        ]),
      ),
    );
  }
}

/// Small chat button (ChatBtn).
class ChatBtn extends StatelessWidget {
  final VoidCallback onTap;
  final bool float;
  const ChatBtn({super.key, required this.onTap, this.float = false});
  @override
  Widget build(BuildContext context) {
    return Pressable(
      onTap: onTap,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: float ? Colors.white.withValues(alpha: 0.9) : C.emeraldTint,
          shape: BoxShape.circle,
          boxShadow: float ? const [BoxShadow(color: Color(0x2914201D), blurRadius: 10, offset: Offset(0, 2))] : null,
        ),
        child: const Ic('comment', size: 18, color: C.emeraldDark),
      ),
    );
  }
}

/// Suitable-for chips (SuitChips).
class SuitChips extends StatelessWidget {
  final List<String> list;
  final int max;
  const SuitChips(this.list, {super.key, this.max = 3});
  @override
  Widget build(BuildContext context) {
    final shown = list.take(max).toList();
    final extra = list.length - shown.length;
    return Wrap(spacing: 6, runSpacing: 6, children: [
      for (final s in shown) _chip(s),
      if (extra > 0)
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
          decoration: BoxDecoration(color: C.cloud, borderRadius: BorderRadius.circular(999)),
          child: Text('+$extra', style: T.b(11, w: FontWeight.w600, color: C.slate)),
        ),
    ]);
  }

  Widget _chip(String s) {
    final m = suitableMeta[s] ?? (icon: 'users', hue: 158);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
      decoration: BoxDecoration(
        color: hsl(m.hue.toDouble(), 0.45, 0.96),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: hsl(m.hue.toDouble(), 0.40, 0.88)),
      ),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Ic(m.icon, size: 12, color: hsl(m.hue.toDouble(), 0.50, 0.45)),
        const SizedBox(width: 4),
        Text(s, style: T.b(11, w: FontWeight.w600)),
      ]),
    );
  }
}

/// Tall group event card for carousels (GroupEventCardTall).
class GroupEventCardTall extends StatelessWidget {
  final GroupEvent ev;
  final int booked;
  final VoidCallback onOpen, onChat;
  final void Function(TravelGroup) onHost;
  final double width;
  const GroupEventCardTall({
    super.key,
    required this.ev,
    required this.booked,
    required this.onOpen,
    required this.onChat,
    required this.onHost,
    this.width = 300,
  });
  @override
  Widget build(BuildContext context) {
    final group = groupById(ev.groupId);
    return Pressable(
      onTap: onOpen,
      scale: 0.98,
      child: Container(
        width: width,
        decoration: BoxDecoration(color: C.surface, borderRadius: BorderRadius.circular(R.card), boxShadow: S.card),
        clipBehavior: Clip.antiAlias,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
            child: Photo(
              src: unsplash(ev.img, 600),
              hue: ev.hue,
              height: 150,
              scrim: true,
              child: Stack(children: [
                Positioned(
                  top: 12,
                  left: 12,
                  child: Row(children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 5),
                      decoration: BoxDecoration(color: const Color(0xEB0C8A66), borderRadius: BorderRadius.circular(999)),
                      child: Row(mainAxisSize: MainAxisSize.min, children: [
                        const Ic('users', size: 13, color: Colors.white),
                        const SizedBox(width: 5),
                        Text('Group tour', style: T.b(11, w: FontWeight.w700, color: Colors.white)),
                      ]),
                    ),
                    if (ev.discount > 0) ...[const SizedBox(width: 7), Ribbon(ev.discount)],
                  ]),
                ),
                Positioned(top: 12, right: 12, child: ChatBtn(onTap: onChat, float: true)),
                Positioned(
                  left: 14,
                  right: 14,
                  bottom: 12,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(ev.title, maxLines: 1, overflow: TextOverflow.ellipsis,
                          style: T.d(18, w: FontWeight.w800, color: Colors.white, spacing: -0.3)),
                      const SizedBox(height: 3),
                      Row(children: [
                        const Icon(Icons.place_outlined, size: 13, color: Colors.white),
                        const SizedBox(width: 4),
                        Flexible(
                          child: Text('${ev.location} · ${ev.dates}',
                              maxLines: 1, overflow: TextOverflow.ellipsis,
                              style: T.b(12, w: FontWeight.w600, color: Colors.white.withValues(alpha: 0.95))),
                        ),
                      ]),
                    ],
                  ),
                ),
              ]),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                Expanded(child: HostChip(group: group, onTap: () => group != null ? onHost(group) : null)),
                Stars(ev.rating, reviews: ev.reviews, size: 12),
              ]),
              const SizedBox(height: 11),
              SuitChips(ev.suitableFor, max: 3),
              const SizedBox(height: 13),
              const Divider(height: 1, color: C.hairline),
              const SizedBox(height: 11),
              SlotBar(booked: booked, capacity: ev.capacity),
              const SizedBox(height: 11),
              Text('from', style: T.b(11, w: FontWeight.w500, color: C.mist)),
              Text.rich(TextSpan(children: [
                TextSpan(text: taka(ev.price.budget), style: T.d(18, w: FontWeight.w800, height: 1.05)),
                TextSpan(text: ' /person', style: T.b(11, w: FontWeight.w500, color: C.slate)),
              ])),
            ]),
          ),
        ]),
      ),
    );
  }
}

/// Wide group event list card (GroupEventCardWide).
class GroupEventCardWide extends StatelessWidget {
  final GroupEvent ev;
  final int booked;
  final VoidCallback onOpen, onChat;
  final void Function(TravelGroup) onHost;
  const GroupEventCardWide({
    super.key,
    required this.ev,
    required this.booked,
    required this.onOpen,
    required this.onChat,
    required this.onHost,
  });
  @override
  Widget build(BuildContext context) {
    final group = groupById(ev.groupId);
    return Pressable(
      onTap: onOpen,
      scale: 0.99,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(color: C.surface, borderRadius: BorderRadius.circular(R.card), boxShadow: S.card),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Stack(children: [
              SizedBox(width: 88, height: 92, child: Photo(src: unsplash(ev.img, 320), hue: ev.hue, height: 92, radius: 16)),
              if (ev.discount > 0)
                Positioned(top: 6, left: 6, child: Transform.scale(scale: 0.82, alignment: Alignment.topLeft, child: Ribbon(ev.discount))),
            ]),
            const SizedBox(width: 12),
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
                Text(ev.tourType.toUpperCase(), style: T.b(10, w: FontWeight.w700, color: C.emerald, spacing: 0.6)),
                const SizedBox(height: 3),
                Text(ev.title, maxLines: 2, overflow: TextOverflow.ellipsis, style: T.d(16, w: FontWeight.w700, height: 1.2, spacing: -0.2)),
                const SizedBox(height: 5),
                Wrap(spacing: 9, runSpacing: 4, children: [
                  Row(mainAxisSize: MainAxisSize.min, children: [
                    const Ic('pin', size: 13, color: C.emerald),
                    const SizedBox(width: 4),
                    Text(ev.location, style: T.b(12, w: FontWeight.w500, color: C.slate)),
                  ]),
                  Row(mainAxisSize: MainAxisSize.min, children: [
                    const Ic('cal', size: 13, color: C.mist),
                    const SizedBox(width: 4),
                    Text(ev.dates, style: T.b(12, w: FontWeight.w500, color: C.slate)),
                  ]),
                ]),
                const SizedBox(height: 7),
                HostChip(group: group, onTap: () => group != null ? onHost(group) : null),
              ]),
            ),
          ]),
          const SizedBox(height: 9),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Flexible(child: SuitChips(ev.suitableFor, max: 2)),
            GenderSplit(male: ev.male, female: ev.female),
          ]),
          const SizedBox(height: 9),
          const Divider(height: 1, color: C.hairline),
          const SizedBox(height: 10),
          SlotBar(booked: booked, capacity: ev.capacity),
          const SizedBox(height: 10),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text.rich(TextSpan(children: [
              TextSpan(text: taka(ev.price.budget), style: T.d(16, w: FontWeight.w800)),
              TextSpan(text: ' /person', style: T.b(11, w: FontWeight.w500, color: C.slate)),
            ])),
            ChatBtn(onTap: onChat),
          ]),
        ]),
      ),
    );
  }
}
