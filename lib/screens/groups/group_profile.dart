import 'package:flutter/material.dart';
import '../../core/theme.dart';
import '../../core/icons.dart';
import '../../data/groups.dart';
import '../../data/content.dart' show ratingBars;
import '../../app_state.dart';
import '../../nav.dart';
import '../../widgets/photo.dart';
import '../../widgets/ui.dart';

class TravelGroupProfileScreen extends StatefulWidget {
  final TravelGroup group;
  const TravelGroupProfileScreen({super.key, required this.group});
  @override
  State<TravelGroupProfileScreen> createState() => _TravelGroupProfileScreenState();
}

class _TravelGroupProfileScreenState extends State<TravelGroupProfileScreen> {
  String seg = 'upcoming';

  @override
  Widget build(BuildContext context) {
    final g = widget.group;
    final c = AppScope.of(context);
    final topPad = MediaQuery.of(context).padding.top;
    final events = eventsByGroup(g.id);
    final past = g.past;
    return Scaffold(
      backgroundColor: C.cloud,
      body: AnimatedBuilder(
        animation: c,
        builder: (context, _) => ListView(
          padding: const EdgeInsets.only(bottom: 40),
          children: [
            // cover
            SizedBox(
              height: 168 + topPad,
              child: Stack(fit: StackFit.expand, children: [
                Image.network(unsplash(g.img, 800), fit: BoxFit.cover, errorBuilder: (_, _, _) => Container(color: hsl(g.hue.toDouble(), 0.45, 0.35))),
                DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [hsl(g.hue.toDouble(), 0.45, 0.40).withValues(alpha: 0.5), hsl(g.hue.toDouble(), 0.50, 0.22).withValues(alpha: 0.9)],
                    ),
                  ),
                ),
                Positioned(
                  top: topPad + 8,
                  left: 16,
                  right: 16,
                  child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    _glass('chevL', () => Navigator.pop(context)),
                    _glass('share', () {}),
                  ]),
                ),
              ]),
            ),
            // identity
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Transform.translate(
                  offset: const Offset(0, -46),
                  child: Container(
                    width: 92,
                    height: 92,
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(26), border: Border.all(color: C.cloud, width: 4), boxShadow: const [BoxShadow(color: Color(0x2E14201D), blurRadius: 20, offset: Offset(0, 8))]),
                    clipBehavior: Clip.antiAlias,
                    child: Photo(src: unsplash(g.img, 220), hue: g.hue, radius: 0),
                  ),
                ),
                Transform.translate(
                  offset: const Offset(0, -34),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Row(children: [
                      Flexible(child: Text(g.name, style: T.d(22, w: FontWeight.w800, spacing: -0.4))),
                      if (g.verified) ...[
                        const SizedBox(width: 6),
                        Container(width: 19, height: 19, decoration: const BoxDecoration(color: C.info, shape: BoxShape.circle), child: const Icon(Icons.check_rounded, size: 12, color: Colors.white)),
                      ],
                    ]),
                    Text(g.handle, style: T.b(13, w: FontWeight.w500, color: C.mist)),
                    const SizedBox(height: 12),
                    Text(g.tagline, style: T.b(13.5, w: FontWeight.w500, color: C.slate, height: 1.5)),
                    const SizedBox(height: 16),
                    TSButton(
                      full: true,
                      onTap: () => openChat(context, ChatCtx.group(g)),
                      child: const Row(mainAxisSize: MainAxisSize.min, children: [Ic('comment', size: 18, color: Colors.white), SizedBox(width: 8), Text('Chat with host')]),
                    ),
                  ]),
                ),
              ]),
            ),
            // badges
            SizedBox(
              height: 40,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                children: [
                  for (final b in _badges(g)) ...[
                    Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(horizontal: 13),
                      margin: const EdgeInsets.only(right: 8),
                      decoration: BoxDecoration(color: C.surface, borderRadius: BorderRadius.circular(999), border: Border.all(color: C.hairline), boxShadow: S.card),
                      child: Row(mainAxisSize: MainAxisSize.min, children: [
                        Ic(b.ic, size: 15, color: hsl(b.hue.toDouble(), 0.55, 0.45)),
                        const SizedBox(width: 6),
                        Text(b.l, style: T.d(12, w: FontWeight.w700)),
                      ]),
                    ),
                  ],
                ],
              ),
            ),
            // stats
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 15),
                decoration: BoxDecoration(color: C.surface, borderRadius: BorderRadius.circular(18), border: Border.all(color: C.hairline), boxShadow: S.card),
                child: Row(children: [
                  for (int i = 0; i < g.stats.length; i++)
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(border: i > 0 ? const Border(left: BorderSide(color: C.hairline)) : null),
                        child: Column(mainAxisSize: MainAxisSize.min, children: [
                          Text(thou(g.stats[i].n), style: T.d(21, w: FontWeight.w800)),
                          Text(g.stats[i].l, style: T.b(12, w: FontWeight.w500, color: C.mist)),
                        ]),
                      ),
                    ),
                ]),
              ),
            ),
            // about
            const Padding(padding: EdgeInsets.fromLTRB(20, 24, 20, 0), child: SectionHeader('About the group')),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(g.bio, style: T.b(14, color: C.slate, height: 1.65)),
                const SizedBox(height: 14),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  decoration: BoxDecoration(color: C.cloud, borderRadius: BorderRadius.circular(14), border: Border.all(color: C.hairline)),
                  child: Row(children: [
                    Container(width: 38, height: 38, decoration: const BoxDecoration(color: C.emeraldTint, shape: BoxShape.circle), child: const Ic('user', size: 19, color: C.emeraldDark)),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
                        Text(g.host.name, style: T.d(13, w: FontWeight.w700)),
                        Text('Lead organiser', style: T.b(12, w: FontWeight.w500, color: C.mist)),
                      ]),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                      decoration: BoxDecoration(color: Color.alphaBlend(C.success.withValues(alpha: 0.12), Colors.white), borderRadius: BorderRadius.circular(999)),
                      child: Row(mainAxisSize: MainAxisSize.min, children: [
                        const Ic('shield', size: 12, color: C.success),
                        const SizedBox(width: 4),
                        Text('Verified', style: T.b(11, w: FontWeight.w700, color: C.success)),
                      ]),
                    ),
                  ]),
                ),
              ]),
            ),
            // travel history
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 26, 20, 0),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
                  Expanded(child: Text('Travel history', style: T.d(20, w: FontWeight.w700, spacing: -0.3))),
                  Text('${events.length + past.length} trips', style: T.b(13, w: FontWeight.w500, color: C.mist)),
                ]),
                const SizedBox(height: 14),
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(color: C.emeraldTint, borderRadius: BorderRadius.circular(16)),
                  child: Row(children: [
                    _segBtn('upcoming', 'Upcoming', events.length),
                    _segBtn('past', 'Completed', past.length),
                  ]),
                ),
                const SizedBox(height: 14),
                if (seg == 'upcoming')
                  for (final ev in events)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _upcomingCard(ev, ev.booked + c.joinedCount(ev.id)),
                    )
                else
                  for (final p in past) Padding(padding: const EdgeInsets.only(bottom: 12), child: _pastCard(p)),
              ]),
            ),
            // reviews
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 26, 20, 0),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
                  Column(children: [
                    Text('${g.rating}', style: T.d(38, w: FontWeight.w800, height: 1)),
                    const SizedBox(height: 4),
                    Row(mainAxisSize: MainAxisSize.min, children: [for (int i = 0; i < 5; i++) const Icon(Icons.star_rounded, size: 13, color: C.saffron)]),
                    const SizedBox(height: 3),
                    Text('${g.reviewCount} reviews', style: T.b(11, w: FontWeight.w500, color: C.mist)),
                  ]),
                  const SizedBox(width: 18),
                  Expanded(
                    child: Column(children: [
                      for (final b in ratingBars)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 5),
                          child: Row(children: [
                            SizedBox(width: 10, child: Text('${b.s}', style: T.b(11, w: FontWeight.w600, color: C.slate))),
                            const SizedBox(width: 8),
                            Expanded(child: ClipRRect(borderRadius: BorderRadius.circular(99), child: LinearProgressIndicator(value: b.p / 100, minHeight: 6, backgroundColor: C.hairline, valueColor: const AlwaysStoppedAnimation(C.saffron)))),
                          ]),
                        ),
                    ]),
                  ),
                ]),
                const SizedBox(height: 16),
                for (final r in g.reviews)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(color: C.surface, borderRadius: BorderRadius.circular(16), border: Border.all(color: C.hairline)),
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Row(children: [
                          Container(width: 32, height: 32, decoration: BoxDecoration(color: hsl(r.name.length * 18.0, 0.4, 0.8), shape: BoxShape.circle), alignment: Alignment.center, child: Text(r.name[0], style: T.d(13, w: FontWeight.w700))),
                          const SizedBox(width: 10),
                          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(r.name, style: T.b(13, w: FontWeight.w600)), Text(r.when, style: T.b(11, w: FontWeight.w500, color: C.mist))])),
                          Row(mainAxisSize: MainAxisSize.min, children: [for (int i = 0; i < r.stars; i++) const Icon(Icons.star_rounded, size: 12, color: C.saffron)]),
                        ]),
                        const SizedBox(height: 7),
                        Text(r.text, style: T.b(13, color: C.slate, height: 1.5)),
                      ]),
                    ),
                  ),
              ]),
            ),
          ],
        ),
      ),
    );
  }

  List<({String ic, String l, int hue})> _badges(TravelGroup g) => [
        (ic: 'badge', l: g.badge, hue: 38),
        if (g.verified) (ic: 'shield', l: 'ID verified', hue: 150),
        (ic: 'star', l: '${g.rating} rating', hue: 38),
        (ic: 'cal', l: 'Since ${g.founded}', hue: 196),
      ];

  Widget _segBtn(String v, String label, int n) {
    final on = seg == v;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => seg = v),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(color: on ? C.surface : Colors.transparent, borderRadius: BorderRadius.circular(12), boxShadow: on ? S.card : null),
          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Text(label, style: T.d(13, w: FontWeight.w700, color: on ? C.emeraldDark : C.slate)),
            const SizedBox(width: 6),
            Text('$n', style: T.b(11, w: FontWeight.w700, color: on ? C.emerald : C.mist)),
          ]),
        ),
      ),
    );
  }

  Widget _upcomingCard(GroupEvent ev, int booked) => GestureDetector(
        onTap: () => openGroupEvent(context, ev),
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(color: C.surface, borderRadius: BorderRadius.circular(R.card), border: Border.all(color: C.hairline), boxShadow: S.card),
          child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            SizedBox(width: 84, height: 84, child: Photo(src: unsplash(ev.img, 280), hue: ev.hue, height: 84, radius: 14)),
            const SizedBox(width: 12),
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
                Text(ev.tourType.toUpperCase(), style: T.b(10, w: FontWeight.w700, color: C.emerald, spacing: 0.6)),
                Text(ev.title, maxLines: 1, overflow: TextOverflow.ellipsis, style: T.d(15, w: FontWeight.w700, height: 1.2, spacing: -0.2)),
                const SizedBox(height: 5),
                Row(children: [const Ic('cal', size: 12, color: C.emerald), const SizedBox(width: 3), Text(ev.dates, style: T.b(12, w: FontWeight.w500, color: C.slate))]),
                const SizedBox(height: 7),
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  Text.rich(TextSpan(children: [
                    TextSpan(text: taka(ev.price.budget), style: T.d(13, w: FontWeight.w700)),
                    TextSpan(text: '/person', style: T.b(10, w: FontWeight.w500, color: C.slate)),
                  ])),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                    decoration: BoxDecoration(color: C.emeraldTint, borderRadius: BorderRadius.circular(999)),
                    child: Text('${(ev.capacity - booked).clamp(0, ev.capacity)} seats left', style: T.b(11, w: FontWeight.w700, color: C.emeraldDark)),
                  ),
                ]),
              ]),
            ),
          ]),
        ),
      );

  Widget _pastCard(PastTrip p) => Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(color: C.surface, borderRadius: BorderRadius.circular(R.card), border: Border.all(color: C.hairline), boxShadow: S.card),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          SizedBox(width: 72, height: 72, child: Photo(src: unsplash(p.img, 240), hue: p.hue, height: 72, radius: 14)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
              Row(children: [
                Expanded(child: Text(p.title, maxLines: 1, overflow: TextOverflow.ellipsis, style: T.d(15, w: FontWeight.w700, height: 1.2, spacing: -0.2))),
                Row(mainAxisSize: MainAxisSize.min, children: [const Icon(Icons.star_rounded, size: 12, color: C.saffron), const SizedBox(width: 3), Text('${p.rating}', style: T.b(11, w: FontWeight.w700, color: C.slate))]),
              ]),
              const SizedBox(height: 5),
              Wrap(spacing: 10, children: [
                Row(mainAxisSize: MainAxisSize.min, children: [const Ic('pin', size: 12, color: C.mist), const SizedBox(width: 3), Text(p.location, style: T.b(12, w: FontWeight.w500, color: C.slate))]),
                Row(mainAxisSize: MainAxisSize.min, children: [const Ic('cal', size: 12, color: C.mist), const SizedBox(width: 3), Text(p.dates, style: T.b(12, w: FontWeight.w500, color: C.slate))]),
              ]),
              const SizedBox(height: 7),
              Row(mainAxisSize: MainAxisSize.min, children: [const Ic('users', size: 13, color: C.mist), const SizedBox(width: 5), Text('${p.travellers} travellers · Completed', style: T.b(11, w: FontWeight.w600, color: C.mist))]),
            ]),
          ),
        ]),
      );

  Widget _glass(String icon, VoidCallback onTap) => GestureDetector(
        onTap: onTap,
        child: Container(width: 40, height: 40, decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.22), shape: BoxShape.circle), child: Ic(icon, size: icon == 'share' ? 18 : 22, color: Colors.white)),
      );
}
