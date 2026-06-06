import 'package:flutter/material.dart';
import '../core/theme.dart';
import '../core/icons.dart';
import '../data/models.dart';
import '../data/content.dart';
import '../data/groups.dart';
import '../app_state.dart';
import '../nav.dart';
import '../widgets/cards.dart';
import '../widgets/ui.dart';
import '../widgets/anim.dart';
import '../widgets/group_bits.dart';

/// Destination landing page — everything going to one place.
class DestinationScreen extends StatefulWidget {
  final Destination dest;
  const DestinationScreen({super.key, required this.dest});
  @override
  State<DestinationScreen> createState() => _DestinationScreenState();
}

class _DestinationScreenState extends State<DestinationScreen> {
  String tab = 'all';
  @override
  Widget build(BuildContext context) {
    final d = widget.dest;
    final c = AppScope.of(context);
    final topPad = MediaQuery.of(context).padding.top;
    final stays = catalogHotels.where((i) => atDest(i.location, d)).toList();
    final acts = catalogActivities.where((i) => atDest(i.location, d)).toList();
    final groups = groupEvents.where((e) => atDest(e.location, d)).toList();
    final tabs = [
      (k: 'all', l: 'All', n: stays.length + acts.length + groups.length),
      (k: 'stays', l: 'Stays', n: stays.length),
      (k: 'acts', l: 'Activities', n: acts.length),
      (k: 'groups', l: 'Tour groups', n: groups.length),
    ];
    bool show(String k) => tab == 'all' || tab == k;

    return Scaffold(
      backgroundColor: C.cloud,
      body: AnimatedBuilder(
        animation: c,
        builder: (context, _) => ListView(
          padding: const EdgeInsets.only(bottom: 40),
          children: [
            SizedBox(
              height: 220 + topPad,
              child: Stack(fit: StackFit.expand, children: [
                Image.network(unsplash(d.img, 900), fit: BoxFit.cover, errorBuilder: (_, _, _) => Container(color: hsl(d.hue.toDouble(), 0.4, 0.4))),
                const DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Color(0x5714201D), Color(0x3314201D), Color(0xD114201D)], stops: [0, 0.45, 1]),
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
                      decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.18), borderRadius: BorderRadius.circular(999)),
                      child: Row(mainAxisSize: MainAxisSize.min, children: [const Ic('pin', size: 13, color: Colors.white), const SizedBox(width: 6), Text(d.tag, style: T.d(11, w: FontWeight.w700, color: Colors.white))]),
                    ),
                  ]),
                ),
                Positioned(
                  left: 20,
                  right: 20,
                  bottom: 18,
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
                    Text(d.name, style: T.d(28, w: FontWeight.w800, color: Colors.white, spacing: -0.5)),
                    Text(d.bn, style: T.bn(14, color: Colors.white.withValues(alpha: 0.92))),
                    const SizedBox(height: 10),
                    Wrap(spacing: 14, runSpacing: 6, children: [
                      _heroStat('bed', '${stays.length} stays'),
                      _heroStat('compass', '${acts.length} activities'),
                      _heroStat('users', '${groups.length} tour groups'),
                    ]),
                  ]),
                ),
              ]),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 38,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                children: [for (final t in tabs) Padding(padding: const EdgeInsets.only(right: 8), child: TSChip('${t.l} ${t.n}', active: tab == t.k, onTap: () => setState(() => tab = t.k)))],
              ),
            ),
            if (show('stays') && stays.isNotEmpty) _section('Stays', stays.length, [
              for (int i = 0; i < stays.length; i++)
                Padding(padding: const EdgeInsets.fromLTRB(20, 0, 20, 12), child: StaggerIn(index: i, child: CompactCard(stays[i], onOpen: () => openDetail(context, stays[i]), fav: c.isFav(stays[i].id), onFav: () => c.toggleFav(stays[i].id)))),
            ]),
            if (show('acts') && acts.isNotEmpty) _section('Things to do', acts.length, [
              for (int i = 0; i < acts.length; i++)
                Padding(padding: const EdgeInsets.fromLTRB(20, 0, 20, 12), child: StaggerIn(index: i, child: CompactCard(acts[i], onOpen: () => openDetail(context, acts[i]), fav: c.isFav(acts[i].id), onFav: () => c.toggleFav(acts[i].id)))),
            ]),
            if (show('groups') && groups.isNotEmpty) _section('Tour groups', groups.length, [
              for (int i = 0; i < groups.length; i++)
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
                  child: StaggerIn(
                    index: i,
                    child: GroupEventCardWide(
                      ev: groups[i],
                      booked: groups[i].booked + c.joinedCount(groups[i].id),
                      onOpen: () => openGroupEvent(context, groups[i]),
                      onChat: () => openChat(context, ChatCtx.event(groups[i])),
                      onHost: (g) => openGroupProfile(context, g),
                    ),
                  ),
                ),
            ]),
          ],
        ),
      ),
    );
  }

  Widget _heroStat(String icon, String text) => Row(mainAxisSize: MainAxisSize.min, children: [Ic(icon, size: 14, color: Colors.white), const SizedBox(width: 5), Text(text, style: T.b(12, w: FontWeight.w600, color: Colors.white))]);

  Widget _section(String title, int count, List<Widget> children) => Padding(
        padding: const EdgeInsets.only(top: 22),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 13),
            child: Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
              Expanded(child: Text(title, style: T.d(18, w: FontWeight.w700, spacing: -0.3))),
              Text('$count', style: T.b(13, w: FontWeight.w500, color: C.mist)),
            ]),
          ),
          ...children,
        ]),
      );
}

/// Curated collection (Eco-parks / Hidden Gems).
class CollectionScreen extends StatefulWidget {
  final String kind;
  const CollectionScreen({super.key, required this.kind});
  @override
  State<CollectionScreen> createState() => _CollectionScreenState();
}

class _CollectionScreenState extends State<CollectionScreen> {
  String tab = 'all';
  @override
  Widget build(BuildContext context) {
    final col = collections[widget.kind]!;
    final c = AppScope.of(context);
    final topPad = MediaQuery.of(context).padding.top;
    final stays = col.hotels.map(listingById).whereType<Listing>().toList();
    final acts = col.acts.map(listingById).whereType<Listing>().toList();
    final tabs = [
      (k: 'all', l: 'All', n: stays.length + acts.length),
      (k: 'stays', l: 'Stays', n: stays.length),
      (k: 'acts', l: 'Activities', n: acts.length),
    ];
    bool show(String k) => tab == 'all' || tab == k;

    return Scaffold(
      backgroundColor: C.cloud,
      body: AnimatedBuilder(
        animation: c,
        builder: (context, _) => ListView(
          padding: const EdgeInsets.only(bottom: 120),
          children: [
            SizedBox(
              height: 200 + topPad,
              child: Stack(fit: StackFit.expand, children: [
                Image.network(unsplash(col.img, 900), fit: BoxFit.cover, errorBuilder: (_, _, _) => Container(color: C.emeraldDark)),
                const DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Color(0x5214201D), Color(0x2E14201D), Color(0xD614201D)], stops: [0, 0.45, 1]),
                  ),
                ),
                Positioned(top: topPad + 8, left: 16, child: _glassBack(context)),
                Positioned(
                  left: 20,
                  right: 20,
                  bottom: 18,
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
                    Container(
                      margin: const EdgeInsets.only(bottom: 9),
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.18), borderRadius: BorderRadius.circular(999)),
                      child: Row(mainAxisSize: MainAxisSize.min, children: [const Ic('sparkle', size: 13, color: Colors.white), const SizedBox(width: 6), Text(col.tag, style: T.d(11, w: FontWeight.w700, color: Colors.white))]),
                    ),
                    Text(col.title, style: T.d(28, w: FontWeight.w800, color: Colors.white, spacing: -0.5)),
                    const SizedBox(height: 5),
                    Text(col.blurb, style: T.b(13, w: FontWeight.w500, color: Colors.white.withValues(alpha: 0.94), height: 1.4)),
                  ]),
                ),
              ]),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 38,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                children: [for (final t in tabs) Padding(padding: const EdgeInsets.only(right: 8), child: TSChip('${t.l} ${t.n}', active: tab == t.k, onTap: () => setState(() => tab = t.k)))],
              ),
            ),
            if (show('stays') && stays.isNotEmpty) ...[
              const Padding(padding: EdgeInsets.fromLTRB(20, 20, 20, 12), child: _H('Stays & lodges')),
              for (int i = 0; i < stays.length; i++)
                Padding(padding: const EdgeInsets.fromLTRB(20, 0, 20, 12), child: StaggerIn(index: i, child: CompactCard(stays[i], onOpen: () => openDetail(context, stays[i]), fav: c.isFav(stays[i].id), onFav: () => c.toggleFav(stays[i].id)))),
            ],
            if (show('acts') && acts.isNotEmpty) ...[
              const Padding(padding: EdgeInsets.fromLTRB(20, 22, 20, 12), child: _H('Things to do')),
              for (int i = 0; i < acts.length; i++)
                Padding(padding: const EdgeInsets.fromLTRB(20, 0, 20, 12), child: StaggerIn(index: i, child: CompactCard(acts[i], onOpen: () => openDetail(context, acts[i]), fav: c.isFav(acts[i].id), onFav: () => c.toggleFav(acts[i].id)))),
            ],
          ],
        ),
      ),
    );
  }
}

class _H extends StatelessWidget {
  final String text;
  const _H(this.text);
  @override
  Widget build(BuildContext context) => Text(text, style: T.d(18, w: FontWeight.w700, spacing: -0.3));
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
