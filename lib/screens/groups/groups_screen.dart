import 'package:flutter/material.dart';
import '../../core/theme.dart';
import '../../core/icons.dart';
import '../../data/groups.dart';
import '../../app_state.dart';
import '../../nav.dart';
import '../../widgets/photo.dart';
import '../../widgets/ui.dart';
import '../../widgets/anim.dart';
import '../../widgets/group_bits.dart';

class GroupsScreen extends StatefulWidget {
  const GroupsScreen({super.key});
  @override
  State<GroupsScreen> createState() => _GroupsScreenState();
}

class _GroupsScreenState extends State<GroupsScreen> {
  String type = 'All';
  bool sortFew = false;
  static const _types = ['All', 'Adventure Group', 'Family & Beach', 'Wildlife Expedition', 'Relaxation', 'Island & Beach'];

  @override
  Widget build(BuildContext context) {
    final c = AppScope.of(context);
    final topPad = MediaQuery.of(context).padding.top;
    return Scaffold(
      backgroundColor: C.cloud,
      body: AnimatedBuilder(
        animation: c,
        builder: (context, _) {
          int booked(GroupEvent e) => e.booked + c.joinedCount(e.id);
          var list = type == 'All' ? List<GroupEvent>.from(groupEvents) : groupEvents.where((e) => e.tourType == type).toList();
          if (sortFew) {
            list.sort((a, b) => (a.capacity - booked(a)) - (b.capacity - booked(b)));
          }
          return ListView(
            padding: const EdgeInsets.only(bottom: 40),
            children: [
              // hero
              SizedBox(
                height: 196 + topPad,
                child: Stack(fit: StackFit.expand, children: [
                  Image.network(unsplash('1530789253388-582c481c54b0', 800), fit: BoxFit.cover,
                      errorBuilder: (_, _, _) => Container(color: C.emeraldDark)),
                  const DecoratedBox(decoration: BoxDecoration(gradient: G.greenGlass)),
                  Positioned(
                    top: topPad + 8,
                    left: 16,
                    right: 16,
                    child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                      _glassBack(context),
                      Pressable(
                        onTap: () => openHostFlow(context),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
                          decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.92), borderRadius: BorderRadius.circular(999)),
                          child: Row(mainAxisSize: MainAxisSize.min, children: [
                            const Ic('flag', size: 15, color: C.emeraldDark),
                            const SizedBox(width: 6),
                            Text('Host a group', style: T.d(12, w: FontWeight.w700, color: C.emeraldDark)),
                          ]),
                        ),
                      ),
                    ]),
                  ),
                  Positioned(
                    left: 20,
                    right: 20,
                    bottom: 18,
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
                      Text('Travel with a Group', style: T.d(26, w: FontWeight.w800, color: Colors.white, spacing: -0.5)),
                      const SizedBox(height: 5),
                      Text('${groupEvents.length} hosted tours · join one or bring your friends',
                          style: T.b(13, w: FontWeight.w500, color: Colors.white.withValues(alpha: 0.92))),
                    ]),
                  ),
                ]),
              ),
              const SizedBox(height: 20),
              const SectionHeader('Trusted travel groups', sub: 'Verified hosts with a track record'),
              SizedBox(
                height: 116,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: travelGroups.length,
                  separatorBuilder: (_, _) => const SizedBox(width: 12),
                  itemBuilder: (_, i) => _HostCard(travelGroups[i], wide: false),
                ),
              ),
              const SizedBox(height: 24),
              // filters
              SizedBox(
                height: 40,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  children: [
                    Pressable(
                      onTap: () => setState(() => sortFew = !sortFew),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
                        decoration: BoxDecoration(
                          color: sortFew ? const Color(0x1FE8A33D) : C.surface,
                          borderRadius: BorderRadius.circular(999),
                          border: Border.all(color: sortFew ? C.saffron : C.hairline, width: 1.5),
                        ),
                        child: Row(mainAxisSize: MainAxisSize.min, children: [
                          Ic('trendD', size: 15, color: sortFew ? C.saffronDark : C.slate),
                          const SizedBox(width: 6),
                          Text('Filling fast', style: T.d(13, w: FontWeight.w700, color: sortFew ? C.saffronDark : C.ink)),
                        ]),
                      ),
                    ),
                    const SizedBox(width: 8),
                    for (final t in _types) ...[
                      TSChip(t, active: type == t, onTap: () => setState(() => type = t)),
                      const SizedBox(width: 8),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 14),
                child: Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
                  Expanded(child: Text(type == 'All' ? 'All group tours' : type, style: T.d(18, w: FontWeight.w700, spacing: -0.3))),
                  Text('${list.length} trips', style: T.b(13, w: FontWeight.w500, color: C.mist)),
                ]),
              ),
              for (int i = 0; i < list.length; i++)
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
                  child: StaggerIn(
                    index: i,
                    child: GroupEventCardWide(
                      ev: list[i],
                      booked: booked(list[i]),
                      onOpen: () => openGroupEvent(context, list[i]),
                      onChat: () => openChat(context, ChatCtx.event(list[i])),
                      onHost: (g) => openGroupProfile(context, g),
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}

class HajjScreen extends StatefulWidget {
  const HajjScreen({super.key});
  @override
  State<HajjScreen> createState() => _HajjScreenState();
}

class _HajjScreenState extends State<HajjScreen> {
  String type = 'All';
  static const _types = ['All', 'Umrah', 'Hajj'];

  @override
  Widget build(BuildContext context) {
    final c = AppScope.of(context);
    final topPad = MediaQuery.of(context).padding.top;
    final list = type == 'All' ? hajjEvents : hajjEvents.where((e) => e.tourType == type).toList();
    return Scaffold(
      backgroundColor: C.cloud,
      body: AnimatedBuilder(
        animation: c,
        builder: (context, _) => ListView(
          padding: const EdgeInsets.only(bottom: 40),
          children: [
            SizedBox(
              height: 212 + topPad,
              child: Stack(fit: StackFit.expand, children: [
                Image.network(unsplash('1565330770968-0240c0046ce3', 800), fit: BoxFit.cover,
                    errorBuilder: (_, _, _) => Container(color: C.emeraldDeep)),
                const DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Color(0x9E07362C), Color(0xDB062821), Color(0xF2051A15)],
                      stops: [0, 0.7, 1],
                    ),
                  ),
                ),
                Positioned(
                  top: topPad + 8,
                  left: 16,
                  right: 16,
                  child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    _glassBack(context),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 7),
                      decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.16), borderRadius: BorderRadius.circular(999)),
                      child: Row(mainAxisSize: MainAxisSize.min, children: [
                        const Ic('shield', size: 14, color: Colors.white),
                        const SizedBox(width: 6),
                        Text('Verified agencies', style: T.d(11, w: FontWeight.w700, color: Colors.white)),
                      ]),
                    ),
                  ]),
                ),
                Positioned(
                  left: 20,
                  right: 20,
                  bottom: 18,
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
                    Text('Hajj & Umrah', style: T.d(27, w: FontWeight.w800, color: Colors.white, spacing: -0.5)),
                    const SizedBox(height: 5),
                    Text('${hajjEvents.length} approved packages · guided kafelas from Bangladesh',
                        style: T.b(13, w: FontWeight.w500, color: Colors.white.withValues(alpha: 0.94))),
                  ]),
                ),
              ]),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(children: [
                for (final a in const [(ic: 'shield', t: 'Govt. approved'), (ic: 'idcard', t: 'Visa support'), (ic: 'compass', t: 'Muallim guide')]) ...[
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 11, horizontal: 6),
                      decoration: BoxDecoration(color: C.surface, borderRadius: BorderRadius.circular(14), border: Border.all(color: C.hairline), boxShadow: S.card),
                      child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                        Ic(a.ic, size: 15, color: C.emerald),
                        const SizedBox(width: 6),
                        Flexible(child: Text(a.t, maxLines: 1, overflow: TextOverflow.ellipsis, style: T.d(11.5, w: FontWeight.w700))),
                      ]),
                    ),
                  ),
                  if (a.t != 'Muallim guide') const SizedBox(width: 8),
                ],
              ]),
            ),
            const SizedBox(height: 22),
            const SectionHeader('Approved agencies', sub: 'Govt-licensed Hajj & Umrah operators'),
            SizedBox(
              height: 116,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: hajjGroups.length,
                separatorBuilder: (_, _) => const SizedBox(width: 12),
                itemBuilder: (_, i) => _HostCard(hajjGroups[i], wide: true),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              height: 40,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                children: [
                  for (final t in _types) ...[
                    TSChip(t, active: type == t, onTap: () => setState(() => type = t)),
                    const SizedBox(width: 8),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 14),
              child: Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
                Expanded(child: Text(type == 'All' ? 'All packages' : '$type packages', style: T.d(18, w: FontWeight.w700, spacing: -0.3))),
                Text('${list.length} trips', style: T.b(13, w: FontWeight.w500, color: C.mist)),
              ]),
            ),
            for (int i = 0; i < list.length; i++)
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
                child: StaggerIn(
                  index: i,
                  child: GroupEventCardWide(
                    ev: list[i],
                    booked: list[i].booked + c.joinedCount(list[i].id),
                    onOpen: () => openGroupEvent(context, list[i]),
                    onChat: () => openChat(context, ChatCtx.event(list[i])),
                    onHost: (g) => openGroupProfile(context, g),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

Widget _glassBack(BuildContext context) => Pressable(
      onTap: () => Navigator.of(context).pop(),
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.22), shape: BoxShape.circle),
        child: const Ic('chevL', size: 22, color: Colors.white),
      ),
    );

class _HostCard extends StatelessWidget {
  final TravelGroup g;
  final bool wide;
  const _HostCard(this.g, {required this.wide});
  @override
  Widget build(BuildContext context) {
    return Pressable(
      onTap: () => openGroupProfile(context, g),
      scale: 0.97,
      child: Container(
        width: wide ? 188 : 158,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(color: C.surface, borderRadius: BorderRadius.circular(20), border: Border.all(color: C.hairline), boxShadow: S.card),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
          Row(children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(wide ? 13 : 999),
              child: SizedBox(width: wide ? 44 : 40, height: wide ? 44 : 40, child: Photo(src: unsplash(g.img, 120), hue: g.hue, radius: 0)),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
                Row(children: [
                  Flexible(child: Text(g.name, maxLines: 1, overflow: TextOverflow.ellipsis, style: T.d(13, w: FontWeight.w700))),
                  if (g.verified) ...[const SizedBox(width: 4), const Icon(Icons.check_rounded, size: 11, color: C.info)],
                ]),
                Text('${eventsByGroup(g.id).length} ${g.kind == 'hajj' ? 'packages' : 'tours'}',
                    style: T.b(11, w: FontWeight.w500, color: C.mist)),
              ]),
            ),
          ]),
          const SizedBox(height: 10),
          Row(children: [
            Stars(g.rating, size: 12),
            const SizedBox(width: 8),
            Flexible(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(color: const Color(0x24E8A33D), borderRadius: BorderRadius.circular(999)),
                child: Row(mainAxisSize: MainAxisSize.min, children: [
                  const Ic('badge', size: 12, color: C.saffronDark),
                  const SizedBox(width: 3),
                  Flexible(child: Text(g.badge, maxLines: 1, overflow: TextOverflow.ellipsis, style: T.b(10, w: FontWeight.w700, color: C.saffronDark))),
                ]),
              ),
            ),
          ]),
        ]),
      ),
    );
  }
}
