import 'package:flutter/material.dart';
import '../../core/theme.dart';
import '../../core/icons.dart';
import '../../data/models.dart';
import '../../data/groups.dart';
import '../../app_state.dart';
import '../../nav.dart';
import '../../widgets/photo.dart';
import '../../widgets/ui.dart';
import '../../widgets/anim.dart';
import '../../widgets/group_bits.dart';

class GroupEventDetailScreen extends StatefulWidget {
  final GroupEvent event;
  const GroupEventDetailScreen({super.key, required this.event});
  @override
  State<GroupEventDetailScreen> createState() => _GroupEventDetailScreenState();
}

class _GroupEventDetailScreenState extends State<GroupEventDetailScreen> {
  final _scroll = ScrollController();
  double _y = 0;

  @override
  void initState() {
    super.initState();
    _scroll.addListener(() => setState(() => _y = _scroll.offset));
  }

  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ev = widget.event;
    final c = AppScope.of(context);
    final group = groupById(ev.groupId)!;
    final topPad = MediaQuery.of(context).padding.top;
    final scrolled = _y > 250;

    return Scaffold(
      backgroundColor: C.cloud,
      body: AnimatedBuilder(
        animation: c,
        builder: (context, _) {
          final booked = ev.booked + c.joinedCount(ev.id);
          final left = (ev.capacity - booked).clamp(0, ev.capacity);
          final joined = c.joinedCount(ev.id) > 0;
          return Stack(children: [
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Transform.translate(
                offset: Offset(0, (-_y * 0.4).clamp(-200.0, 0.0)),
                child: SizedBox(height: 420, child: Photo(src: unsplash(ev.img, 1000), hue: ev.hue, height: 420, radius: 0, scrim: true)),
              ),
            ),
            SingleChildScrollView(
              controller: _scroll,
              child: Column(children: [
                const SizedBox(height: 332),
                Container(
                  decoration: const BoxDecoration(color: C.cloud, borderRadius: BorderRadius.vertical(top: Radius.circular(28))),
                  padding: const EdgeInsets.only(top: 22, bottom: 150),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    _b(_titleBlock(ev)),
                    _b(_hostCard(group)),
                    _section('Monitored by Tour Shongi', _InvigilatorCard(ev)),
                    _section("Seats & who's going", _CapacityPanel(ev: ev, booked: booked)),
                    _section('Suitable for', _suitable(ev)),
                    _section('About this trip', Text(ev.blurb, style: T.b(14, color: C.slate, height: 1.65))),
                    _section('The full travel plan', _planBlock(ev)),
                    _section("What's included", _includes(ev)),
                    _section('Travel buddies', _MembersStrip(booked: booked, male: ev.male, female: ev.female)),
                    _b2(_chatCard(group, ev)),
                    _section('Reviews of ${group.name}', _reviews(group)),
                  ]),
                ),
              ]),
            ),
            // top bar
            Container(
              padding: EdgeInsets.fromLTRB(18, topPad + 8, 18, 12),
              decoration: BoxDecoration(
                color: scrolled ? Colors.white.withValues(alpha: 0.9) : Colors.transparent,
                border: scrolled ? const Border(bottom: BorderSide(color: C.hairline)) : null,
              ),
              child: Row(children: [
                Pressable(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.9), shape: BoxShape.circle, boxShadow: const [BoxShadow(color: Color(0x2914201D), blurRadius: 10, offset: Offset(0, 2))]),
                    child: const Ic('chevL', size: 19, color: C.ink),
                  ),
                ),
              ]),
            ),
            // sticky join bar
            Positioned(left: 0, right: 0, bottom: 0, child: _joinBar(ev, left, joined, c)),
          ]);
        },
      ),
    );
  }

  Widget _b(Widget child) => Padding(padding: const EdgeInsets.symmetric(horizontal: 20), child: child);
  Widget _b2(Widget child) => Padding(padding: const EdgeInsets.fromLTRB(20, 24, 20, 0), child: child);

  Widget _section(String title, Widget child) => Padding(
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(title, style: T.d(18, w: FontWeight.w700, spacing: -0.3)),
          const SizedBox(height: 12),
          child,
        ]),
      );

  Widget _titleBlock(GroupEvent ev) => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Wrap(spacing: 8, runSpacing: 6, crossAxisAlignment: WrapCrossAlignment.center, children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 5),
            decoration: BoxDecoration(color: C.emeraldTint, borderRadius: BorderRadius.circular(999)),
            child: Row(mainAxisSize: MainAxisSize.min, children: [
              const Ic('users', size: 13, color: C.emeraldDark),
              const SizedBox(width: 5),
              Text(ev.tourType, style: T.b(11, w: FontWeight.w700, color: C.emeraldDark)),
            ]),
          ),
          _miniMeta('cal', ev.dates),
          _miniMeta('clock', '${ev.days} days'),
        ]),
        const SizedBox(height: 11),
        Text(ev.title, style: T.d(25, w: FontWeight.w800, height: 1.12, spacing: -0.5)),
        Text(ev.bn, style: T.bn(13, color: C.mist)),
        const SizedBox(height: 10),
        Wrap(spacing: 14, runSpacing: 6, crossAxisAlignment: WrapCrossAlignment.center, children: [
          Stars(ev.rating, reviews: ev.reviews),
          _miniMeta('pin', ev.location),
          _miniMeta('flag', 'from ${ev.departs}'),
        ]),
      ]);

  Widget _miniMeta(String icon, String text) => Row(mainAxisSize: MainAxisSize.min, children: [
        Ic(icon, size: 14, color: C.emerald),
        const SizedBox(width: 4),
        Text(text, style: T.b(12.5, w: FontWeight.w600, color: C.slate)),
      ]);

  Widget _hostCard(TravelGroup group) => Padding(
        padding: const EdgeInsets.only(top: 18),
        child: Pressable(
          onTap: () => openGroupProfile(context, group),
          scale: 0.99,
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: C.surface, borderRadius: BorderRadius.circular(18), border: Border.all(color: C.hairline), boxShadow: S.card),
            child: Row(children: [
              ClipRRect(borderRadius: BorderRadius.circular(14), child: SizedBox(width: 48, height: 48, child: Photo(src: unsplash(group.img, 140), hue: group.hue, radius: 0))),
              const SizedBox(width: 12),
              Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
                  Row(children: [
                    Flexible(child: Text(group.name, maxLines: 1, overflow: TextOverflow.ellipsis, style: T.d(15, w: FontWeight.w700))),
                    if (group.verified) ...[
                      const SizedBox(width: 5),
                      Container(width: 16, height: 16, decoration: const BoxDecoration(color: C.info, shape: BoxShape.circle), child: const Icon(Icons.check_rounded, size: 10, color: Colors.white)),
                    ],
                  ]),
                  const SizedBox(height: 3),
                  Row(children: [
                    const Icon(Icons.star_rounded, size: 12, color: C.saffron),
                    const SizedBox(width: 3),
                    Text('${group.rating}', style: T.b(12, w: FontWeight.w500, color: C.slate)),
                    const SizedBox(width: 8),
                    const Ic('badge', size: 12, color: C.saffronDark),
                    const SizedBox(width: 3),
                    Flexible(child: Text(group.badge, maxLines: 1, overflow: TextOverflow.ellipsis, style: T.b(12, w: FontWeight.w500, color: C.slate))),
                  ]),
                ]),
              ),
              Row(mainAxisSize: MainAxisSize.min, children: [
                Text('Profile', style: T.d(12, w: FontWeight.w700, color: C.emeraldDark)),
                const Ic('chevR', size: 15, color: C.emeraldDark),
              ]),
            ]),
          ),
        ),
      );

  Widget _suitable(GroupEvent ev) => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Text('This tour is a good fit for travellers like:', style: T.b(12.5, color: C.mist)),
        ),
        Wrap(spacing: 8, runSpacing: 8, children: [
          for (final s in ev.suitableFor) _bigSuit(s),
        ]),
      ]);

  Widget _bigSuit(String s) {
    final m = suitableMeta[s] ?? (icon: 'users', hue: 158);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 8),
      decoration: BoxDecoration(
        color: hsl(m.hue.toDouble(), 0.45, 0.96),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: hsl(m.hue.toDouble(), 0.40, 0.88)),
      ),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Ic(m.icon, size: 16, color: hsl(m.hue.toDouble(), 0.50, 0.45)),
        const SizedBox(width: 6),
        Text(s, style: T.b(13, w: FontWeight.w600)),
      ]),
    );
  }

  Widget _planBlock(GroupEvent ev) => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Wrap(spacing: 14, runSpacing: 8, children: [
            for (final e in planMeta.entries)
              Row(mainAxisSize: MainAxisSize.min, children: [
                Container(width: 18, height: 18, decoration: BoxDecoration(color: e.value.tint, borderRadius: BorderRadius.circular(6)), child: Ic(e.value.icon, size: 12, color: e.value.color)),
                const SizedBox(width: 5),
                Text(e.value.label, style: T.b(11, w: FontWeight.w600, color: C.slate)),
              ]),
          ]),
        ),
        _PlanTimeline(ev.plan),
      ]);

  Widget _includes(GroupEvent ev) => LayoutBuilder(builder: (context, c) {
        final w = (c.maxWidth - 10) / 2;
        return Wrap(spacing: 10, runSpacing: 10, children: [
          for (final inc in ev.includes)
            SizedBox(
              width: w,
              child: Row(children: [
                Container(width: 24, height: 24, decoration: const BoxDecoration(color: C.emeraldTint, shape: BoxShape.circle), child: const Icon(Icons.check_rounded, size: 14, color: C.emeraldDark)),
                const SizedBox(width: 9),
                Expanded(child: Text(inc, style: T.b(12.5, color: C.ink))),
              ]),
            ),
        ]);
      });

  Widget _chatCard(TravelGroup group, GroupEvent ev) => Pressable(
        onTap: () => openChat(context, ChatCtx.event(ev)),
        scale: 0.99,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            gradient: const LinearGradient(colors: [C.emeraldTint, Color(0xFFEEF7F3)]),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: C.emerald.withValues(alpha: 0.22)),
          ),
          child: Row(children: [
            Container(width: 42, height: 42, decoration: BoxDecoration(gradient: G.emerald, borderRadius: BorderRadius.circular(13)), child: const Ic('comment', size: 21, color: Colors.white)),
            const SizedBox(width: 12),
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
                Text('Chat with ${group.name}', maxLines: 1, overflow: TextOverflow.ellipsis, style: T.d(14, w: FontWeight.w700, color: C.emeraldDark)),
                Text('Ask about pickup, rooms or the plan', style: T.b(12, w: FontWeight.w500, color: C.slate)),
              ]),
            ),
            const Ic('arrowR', size: 18, color: C.emeraldDark),
          ]),
        ),
      );

  Widget _reviews(TravelGroup group) => Column(children: [
        for (final r in group.reviews)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(color: C.surface, borderRadius: BorderRadius.circular(16), border: Border.all(color: C.hairline)),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(children: [
                  Container(width: 32, height: 32, decoration: BoxDecoration(color: hsl(r.name.length * 18.0, 0.4, 0.8), shape: BoxShape.circle), alignment: Alignment.center, child: Text(r.name[0], style: T.d(13, w: FontWeight.w700))),
                  const SizedBox(width: 10),
                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(r.name, style: T.b(13, w: FontWeight.w600)),
                    Text(r.when, style: T.b(11, w: FontWeight.w500, color: C.mist)),
                  ])),
                  Row(mainAxisSize: MainAxisSize.min, children: [for (int i = 0; i < r.stars; i++) const Icon(Icons.star_rounded, size: 12, color: C.saffron)]),
                ]),
                const SizedBox(height: 7),
                Text(r.text, style: T.b(13, color: C.slate, height: 1.5)),
              ]),
            ),
          ),
      ]);

  Widget _joinBar(GroupEvent ev, int left, bool joined, AppController c) => Container(
        padding: const EdgeInsets.fromLTRB(20, 14, 20, 28),
        decoration: const BoxDecoration(
          gradient: LinearGradient(begin: Alignment.bottomCenter, end: Alignment.topCenter, colors: [C.surface, Color(0x00FFFFFF)], stops: [0.72, 1]),
        ),
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(color: C.surface, borderRadius: BorderRadius.circular(20), border: Border.all(color: C.hairline), boxShadow: const [BoxShadow(color: Color(0x1F14201D), blurRadius: 30, offset: Offset(0, 12))]),
          child: Row(children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 12),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
                  Text('from · $left seats left', style: T.b(11, w: FontWeight.w500, color: C.mist)),
                  Text.rich(TextSpan(children: [
                    TextSpan(text: taka(ev.price.budget), style: T.d(20, w: FontWeight.w800, height: 1.05)),
                    TextSpan(text: ' /person', style: T.b(12, w: FontWeight.w500, color: C.slate)),
                  ])),
                ]),
              ),
            ),
            ChatBtn(onTap: () => openChat(context, ChatCtx.event(ev))),
            const SizedBox(width: 12),
            TSButton(
              variant: joined ? BtnVariant.ghost : BtnVariant.primary,
              large: true,
              onTap: () => openJoinSheet(context, ev),
              child: Row(mainAxisSize: MainAxisSize.min, children: [
                Ic(joined ? 'check' : 'users', size: 18, color: joined ? C.emeraldDark : Colors.white),
                const SizedBox(width: 6),
                Text(joined ? 'Joined (${c.joinedCount(ev.id)})' : 'Join trip'),
              ]),
            ),
          ]),
        ),
      );
}

class _PlanTimeline extends StatelessWidget {
  final List<PlanSeg> plan;
  const _PlanTimeline(this.plan);
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      for (int i = 0; i < plan.length; i++)
        IntrinsicHeight(
          child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Column(children: [
              Builder(builder: (_) {
                final m = planMeta[plan[i].type]!;
                return Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(color: m.tint, borderRadius: BorderRadius.circular(13), border: Border.all(color: Color.alphaBlend(m.color.withValues(alpha: 0.3), Colors.white))),
                  child: Ic(m.icon, size: 20, color: m.color),
                );
              }),
              if (i < plan.length - 1) Expanded(child: Container(width: 2, color: C.hairline)),
            ]),
            const SizedBox(width: 13),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(bottom: i < plan.length - 1 ? 16 : 0),
                child: Builder(builder: (_) {
                  final m = planMeta[plan[i].type]!;
                  final s = plan[i];
                  return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Row(children: [
                      Expanded(child: Text(m.label.toUpperCase(), style: T.b(10, w: FontWeight.w700, color: m.color, spacing: 0.6))),
                      Text(s.time, style: T.b(11, w: FontWeight.w600, color: C.mist)),
                    ]),
                    const SizedBox(height: 2),
                    Text(s.title, style: T.d(15, w: FontWeight.w700, spacing: -0.2)),
                    if (s.sub.isNotEmpty) Text(s.sub, style: T.b(12.5, w: FontWeight.w600, color: C.slate)),
                    if (s.meta.isNotEmpty) Padding(padding: const EdgeInsets.only(top: 3), child: Text(s.meta, style: T.b(12, color: C.mist))),
                  ]);
                }),
              ),
            ),
          ]),
        ),
    ]);
  }
}

class _CapacityPanel extends StatelessWidget {
  final GroupEvent ev;
  final int booked;
  const _CapacityPanel({required this.ev, required this.booked});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: C.surface, borderRadius: BorderRadius.circular(20), border: Border.all(color: C.hairline), boxShadow: S.card),
      child: Column(children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text("Who's going", style: T.d(14, w: FontWeight.w700)),
          Text('$booked/${ev.capacity} joined', style: T.d(12, w: FontWeight.w700, color: C.emerald)),
        ]),
        const SizedBox(height: 12),
        SlotBar(booked: booked, capacity: ev.capacity),
        const SizedBox(height: 12),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          GenderSplit(male: ev.male, female: ev.female, large: true),
          Row(mainAxisSize: MainAxisSize.min, children: [
            const Ic('idcard', size: 13, color: C.mist),
            const SizedBox(width: 4),
            Text('${ev.manual} added by host', style: T.b(11, w: FontWeight.w600, color: C.mist)),
          ]),
        ]),
      ]),
    );
  }
}

class _MembersStrip extends StatelessWidget {
  final int booked, male, female;
  const _MembersStrip({required this.booked, required this.male, required this.female});
  @override
  Widget build(BuildContext context) {
    final n = booked < 7 ? booked : 7;
    return Row(children: [
      SizedBox(
        width: n * 24.0 + 10,
        height: 34,
        child: Stack(children: [
          for (int i = 0; i < n; i++)
            Positioned(
              left: i * 24.0,
              child: Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: hsl(((i * 53 + 20) % 360).toDouble(), 0.42, 0.62),
                  shape: BoxShape.circle,
                  border: Border.all(color: C.cloud, width: 2),
                ),
                child: const Ic('user', size: 17, color: Colors.white),
              ),
            ),
        ]),
      ),
      const SizedBox(width: 10),
      Expanded(child: Text('$booked travellers already joined', style: T.b(13, w: FontWeight.w600, color: C.slate))),
    ]);
  }
}

class _InvigilatorCard extends StatelessWidget {
  final GroupEvent ev;
  const _InvigilatorCard(this.ev);
  @override
  Widget build(BuildContext context) {
    final inv = invigilatorFor(ev);
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [Color(0xFFF3FAF7), Color(0xFFEEF7F3)]),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: C.emerald.withValues(alpha: 0.24)),
        boxShadow: S.card,
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: const BoxDecoration(gradient: G.greenGlass),
          child: Row(children: [
            Container(width: 24, height: 24, decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.92), borderRadius: BorderRadius.circular(8)), child: const Ic('compass', size: 15, color: C.emeraldDark)),
            const SizedBox(width: 8),
            Expanded(child: Text('TOUR SHONGI · TRIP MONITOR', style: T.d(11, w: FontWeight.w800, color: Colors.white, spacing: 0.5))),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
              decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(999)),
              child: Row(mainAxisSize: MainAxisSize.min, children: [
                const Icon(Icons.check_rounded, size: 11, color: Colors.white),
                const SizedBox(width: 4),
                Text('Assigned', style: T.b(10, w: FontWeight.w700, color: Colors.white)),
              ]),
            ),
          ]),
        ),
        Padding(
          padding: const EdgeInsets.all(14),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Stack(clipBehavior: Clip.none, children: [
                ClipRRect(borderRadius: BorderRadius.circular(16), child: SizedBox(width: 52, height: 52, child: Photo(src: unsplash(inv.img, 140), hue: 168, radius: 0))),
                Positioned(
                  right: -2,
                  bottom: -2,
                  child: Container(width: 18, height: 18, decoration: BoxDecoration(color: C.info, shape: BoxShape.circle, border: Border.all(color: Colors.white, width: 2)), child: const Ic('shield', size: 9, color: Colors.white)),
                ),
              ]),
              const SizedBox(width: 12),
              Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
                  Text(inv.name, style: T.d(15, w: FontWeight.w700)),
                  Text('Independent trip invigilator', style: T.b(12, w: FontWeight.w600, color: C.emeraldDark)),
                  Text('${inv.code} · ${inv.langs}', style: T.b(11, w: FontWeight.w500, color: C.mist)),
                ]),
              ),
            ]),
            const SizedBox(height: 12),
            Text.rich(TextSpan(children: [
              TextSpan(text: 'A neutral Tour Shongi staff member travels with this group for the ', style: T.b(13, color: C.slate, height: 1.55)),
              TextSpan(text: 'full trip', style: T.b(13, w: FontWeight.w700, color: C.ink, height: 1.55)),
              TextSpan(text: ' — independently monitoring safety, timing and that everything matches what the host promised.', style: T.b(13, color: C.slate, height: 1.55)),
            ])),
            const SizedBox(height: 12),
            Row(children: [
              for (final b in [(ic: 'shield', l: 'Safety oversight'), (ic: 'clock', l: 'On-trip 24/7'), (ic: 'badge', l: '${inv.trips}+ trips')]) ...[
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                    decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.75), borderRadius: BorderRadius.circular(11), border: Border.all(color: C.hairline)),
                    child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      Ic(b.ic, size: 13, color: C.emerald),
                      const SizedBox(width: 5),
                      Flexible(child: Text(b.l, maxLines: 1, overflow: TextOverflow.ellipsis, style: T.b(11, w: FontWeight.w700, color: C.slate))),
                    ]),
                  ),
                ),
                if (b.l != '${inv.trips}+ trips') const SizedBox(width: 8),
              ],
            ]),
          ]),
        ),
      ]),
    );
  }
}

/// Join / book sheet (GroupJoinSheet).
class GroupJoinSheet extends StatefulWidget {
  final GroupEvent ev;
  const GroupJoinSheet({super.key, required this.ev});
  @override
  State<GroupJoinSheet> createState() => _GroupJoinSheetState();
}

class _GroupJoinSheetState extends State<GroupJoinSheet> {
  String tier = 'premium';
  int spots = 1;
  String gender = 'Male';

  @override
  Widget build(BuildContext context) {
    final ev = widget.ev;
    final group = groupById(ev.groupId)!;
    final unit = ev.price.byKey(tier);
    final total = unit * spots;
    final maxH = MediaQuery.of(context).size.height * 0.88;
    return Container(
      constraints: BoxConstraints(maxHeight: maxH),
      decoration: const BoxDecoration(color: C.surface, borderRadius: BorderRadius.vertical(top: Radius.circular(28))),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        const SizedBox(height: 12),
        Container(width: 40, height: 5, decoration: BoxDecoration(color: C.hairline, borderRadius: BorderRadius.circular(99))),
        const SizedBox(height: 16),
        Flexible(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 28),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                ClipRRect(borderRadius: BorderRadius.circular(14), child: SizedBox(width: 56, height: 56, child: Photo(src: unsplash(ev.img, 160), hue: ev.hue, radius: 0))),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
                    Text(ev.title, maxLines: 2, overflow: TextOverflow.ellipsis, style: T.d(18, w: FontWeight.w700, height: 1.15, spacing: -0.3)),
                    Text('${group.name} · ${ev.dates}', style: T.b(12, w: FontWeight.w500, color: C.mist)),
                  ]),
                ),
                Pressable(
                  onTap: () => Navigator.pop(context),
                  child: Container(width: 36, height: 36, decoration: BoxDecoration(color: C.surface, shape: BoxShape.circle, border: Border.all(color: C.hairline)), child: const Ic('x', size: 17, color: C.slate)),
                ),
              ]),
              const SizedBox(height: 18),
              _label('Choose your tier'),
              const SizedBox(height: 8),
              Row(children: [
                for (final t in ['budget', 'premium', 'luxury']) ...[
                  Expanded(child: _tierTile(t, ev)),
                  if (t != 'luxury') const SizedBox(width: 8),
                ],
              ]),
              const SizedBox(height: 18),
              Row(children: [
                Expanded(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
                    _label('Travellers'),
                    Text('How many seats to book', style: T.b(12, w: FontWeight.w500, color: C.mist)),
                  ]),
                ),
                QtyStepper(spots, (v) => setState(() => spots = v), min: 1, max: 8),
              ]),
              const SizedBox(height: 18),
              _label('Your group'),
              const SizedBox(height: 8),
              Row(children: [
                for (final g in ['Male', 'Female', 'Couple']) ...[
                  Expanded(child: _genderTile(g)),
                  if (g != 'Couple') const SizedBox(width: 8),
                ],
              ]),
              const SizedBox(height: 18),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(color: C.cloud, borderRadius: BorderRadius.circular(16), border: Border.all(color: C.hairline)),
                child: Column(children: [
                  _sumRow('${taka(unit)} × $spots traveller${spots > 1 ? 's' : ''}', taka(total)),
                  const SizedBox(height: 6),
                  _sumRow('Booking fee', 'Free', green: true),
                  const Padding(padding: EdgeInsets.symmetric(vertical: 11), child: Divider(height: 1, color: C.hairline)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text('Total', style: T.d(15, w: FontWeight.w700)),
                      Text(taka(total), style: T.d(22, w: FontWeight.w800, color: C.emeraldDark)),
                    ],
                  ),
                ]),
              ),
              const SizedBox(height: 16),
              TSButton(
                full: true,
                large: true,
                onTap: () {
                  AppScope.of(context).confirmJoin(ev.id, spots);
                  Navigator.pop(context);
                  showTripToast(context, 'Reserved $spots seat${spots > 1 ? 's' : ''} on “${ev.title}”');
                },
                child: Row(mainAxisSize: MainAxisSize.min, children: [
                  const Icon(Icons.check_rounded, size: 19, color: Colors.white),
                  const SizedBox(width: 6),
                  Text('Reserve $spots seat${spots > 1 ? 's' : ''}'),
                ]),
              ),
              const SizedBox(height: 10),
              Center(child: Text('Free cancellation up to 48h before departure', style: T.b(11, w: FontWeight.w500, color: C.mist))),
            ]),
          ),
        ),
      ]),
    );
  }

  Widget _label(String t) => Text(t.toUpperCase(), style: T.b(12, w: FontWeight.w700, color: C.slate, spacing: 0.5));

  Widget _tierTile(String key, GroupEvent ev) {
    final t = tiersForKey(key);
    final on = tier == key;
    return Pressable(
      onTap: () => setState(() => tier = key),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 12),
        decoration: BoxDecoration(
          color: on ? Color.alphaBlend(t.color.withValues(alpha: 0.10), Colors.white) : C.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: on ? t.color : C.hairline, width: on ? 1.5 : 1),
        ),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Ic(t.icon, size: 19, color: t.color),
          const SizedBox(height: 5),
          Text(t.short, style: T.b(11, w: FontWeight.w700, color: on ? t.color : C.slate)),
          const SizedBox(height: 2),
          Text(taka(ev.price.byKey(key)), style: T.b(11, w: FontWeight.w600), maxLines: 1, overflow: TextOverflow.ellipsis),
        ]),
      ),
    );
  }

  Widget _genderTile(String g) {
    final on = gender == g;
    final ic = g == 'Male' ? 'genderM' : (g == 'Female' ? 'genderF' : 'heart');
    return Pressable(
      onTap: () => setState(() => gender = g),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 11),
        decoration: BoxDecoration(
          color: on ? C.emeraldTint : C.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: on ? C.emerald : C.hairline, width: on ? 1.5 : 1),
        ),
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Ic(ic, size: 16, color: on ? C.emeraldDark : C.slate),
          const SizedBox(width: 6),
          Text(g, style: T.d(12, w: FontWeight.w700, color: on ? C.emeraldDark : C.slate)),
        ]),
      ),
    );
  }

  Widget _sumRow(String l, String v, {bool green = false}) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(l, style: T.b(13, color: C.slate)),
          Text(v, style: T.b(13, w: FontWeight.w600, color: green ? C.success : C.slate)),
        ],
      );
}

Tier tiersForKey(String key) => tiers.firstWhere((t) => t.key == key);
