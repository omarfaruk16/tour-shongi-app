import 'dart:async';
import 'package:flutter/material.dart';
import '../core/theme.dart';
import '../core/icons.dart';
import '../data/models.dart';
import '../data/content.dart';
import '../data/groups.dart';
import '../app_state.dart';
import '../nav.dart';
import '../widgets/cards.dart';
import '../widgets/chrome.dart';
import '../widgets/ui.dart';
import '../widgets/group_bits.dart';

class HomeScreen extends StatelessWidget {
  final void Function(String) onTab;
  const HomeScreen({super.key, required this.onTab});

  void _onExp(BuildContext context, String id) {
    switch (id) {
      case 'hotels':
        openCategory(context, 'hotel');
        break;
      case 'activity':
        openCategory(context, 'activity');
        break;
      case 'tour':
        openGroups(context);
        break;
      case 'hajj':
        openHajj(context);
        break;
      case 'ecopark':
      case 'hidden':
        openCollection(context, id);
        break;
      default:
        openFilter(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = AppScope.of(context);
    final topPad = MediaQuery.of(context).padding.top;
    return AnimatedBuilder(
      animation: c,
      builder: (context, _) {
        return ListView(
          padding: EdgeInsets.only(top: topPad + 12, bottom: 120),
          children: [
            LocationHeader(onBell: () {}, onSearch: () => openFilter(context)),
            const SizedBox(height: 16),
            TSSearchBar(onFilter: () => openFilter(context)),
            const SizedBox(height: 30),
            const _OfferCarousel(),
            const SizedBox(height: 30),
            _UspBand(onTap: () => openMap(context)),
            const SizedBox(height: 30),
            const SectionHeader('Type of experience'),
            _ExperienceRow(onPick: (id) => _onExp(context, id)),
            const SizedBox(height: 30),
            _CardSection(
              title: 'Hotels & Resorts',
              sub: 'Stays across every tier',
              items: hotels,
              onSeeAll: () => openCategory(context, 'hotel'),
            ),
            const SizedBox(height: 30),
            _GroupsHomeSection(joined: c.groupJoins),
            const SizedBox(height: 30),
            _CardSection(
              title: 'Recommended for you',
              sub: 'Based on your saved trips',
              items: [hotels[3], activities[0], hotels[1]],
            ),
            const SizedBox(height: 30),
            _CardSection(
              title: 'Activities',
              sub: 'Things to do nearby',
              items: activities,
              onSeeAll: () => openCategory(context, 'activity'),
            ),
            const SizedBox(height: 30),
            const SectionHeader('Top destinations'),
            SizedBox(
              height: 190,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: destinations.length,
                separatorBuilder: (_, _) => const SizedBox(width: 12),
                itemBuilder: (_, i) =>
                    DestinationCard(destinations[i], onOpen: () => openDest(context, destinations[i])),
              ),
            ),
            const SizedBox(height: 30),
            const _AllResultsFeed(),
          ],
        );
      },
    );
  }
}

/// A titled horizontal rail of listing cards + chip row.
class _CardSection extends StatefulWidget {
  final String title;
  final String? sub;
  final List<Listing> items;
  final VoidCallback? onSeeAll;
  const _CardSection({required this.title, this.sub, required this.items, this.onSeeAll});
  @override
  State<_CardSection> createState() => _CardSectionState();
}

class _CardSectionState extends State<_CardSection> {
  String cat = 'Beach';
  bool get hasChips => widget.onSeeAll != null;
  @override
  Widget build(BuildContext context) {
    final c = AppScope.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(widget.title, sub: widget.sub, onAction: widget.onSeeAll),
        if (hasChips) ...[
          ChipRow(items: categories, value: cat, onChange: (v) => setState(() => cat = v)),
          const SizedBox(height: 14),
        ],
        SizedBox(
          height: 280,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: widget.items.length,
            separatorBuilder: (_, _) => const SizedBox(width: 14),
            itemBuilder: (_, i) {
              final it = widget.items[i];
              return Align(
                alignment: Alignment.topCenter,
                child: ListingCard(it,
                    onOpen: () => openDetail(context, it),
                    fav: c.isFav(it.id),
                    onFav: () => c.toggleFav(it.id)),
              );
            },
          ),
        ),
      ],
    );
  }
}

/// Auto-rotating offer carousel (OfferCarousel).
class _OfferCarousel extends StatefulWidget {
  const _OfferCarousel();
  @override
  State<_OfferCarousel> createState() => _OfferCarouselState();
}

class _OfferCarouselState extends State<_OfferCarousel> {
  final _controller = PageController(viewportFraction: 0.84);
  int _i = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(milliseconds: 4200), (_) {
      if (!_controller.hasClients) return;
      _i = (_i + 1) % offers.length;
      _controller.animateToPage(_i, duration: const Duration(milliseconds: 550), curve: Curves.easeOut);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      SizedBox(
        height: 150,
        child: PageView.builder(
          controller: _controller,
          onPageChanged: (i) => setState(() => _i = i),
          itemCount: offers.length,
          itemBuilder: (_, i) {
            final o = offers[i];
            return Padding(
              padding: EdgeInsets.only(left: i == 0 ? 20 : 6, right: 6),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(22),
                child: Stack(fit: StackFit.expand, children: [
                  Image.network(unsplash(o.img, 600), fit: BoxFit.cover,
                      errorBuilder: (_, _, _) => const SizedBox.shrink()),
                  DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          hsl(o.hue.toDouble(), 0.62, 0.48).withValues(alpha: 0.86),
                          hsl(o.hue + 18.0, 0.70, 0.36).withValues(alpha: 0.92),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.baseline,
                                textBaseline: TextBaseline.alphabetic,
                                children: [
                                  Text('${o.off}%', style: T.d(34, w: FontWeight.w800, color: Colors.white, height: 1)),
                                  const SizedBox(width: 4),
                                  Text('OFF', style: T.d(15, w: FontWeight.w700, color: Colors.white70)),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(o.title, maxLines: 1, overflow: TextOverflow.ellipsis, style: T.d(17, w: FontWeight.w700, color: Colors.white)),
                              Text(o.sub, maxLines: 1, overflow: TextOverflow.ellipsis, style: T.b(12, w: FontWeight.w500, color: Colors.white70)),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Row(mainAxisSize: MainAxisSize.min, children: [
                            Text('Grab offer', style: T.d(13, w: FontWeight.w700, color: Colors.white)),
                            const SizedBox(width: 6),
                            const Icon(Icons.arrow_forward_rounded, size: 15, color: Colors.white),
                          ]),
                        ),
                      ],
                    ),
                  ),
                ]),
              ),
            );
          },
        ),
      ),
      const SizedBox(height: 12),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          for (int k = 0; k < offers.length; k++)
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.symmetric(horizontal: 3),
              width: k == _i ? 20 : 6,
              height: 6,
              decoration: BoxDecoration(
                color: k == _i ? C.emerald : C.hairline,
                borderRadius: BorderRadius.circular(99),
              ),
            ),
        ],
      ),
    ]);
  }
}

class _UspBand extends StatelessWidget {
  final VoidCallback onTap;
  const _UspBand({required this.onTap});
  @override
  Widget build(BuildContext context) {
    const items = [(i: 'shield', t: 'Price-match'), (i: 'headset', t: '24/7 support'), (i: 'check', t: 'Verified stays')];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            gradient: const LinearGradient(colors: [C.emeraldTint, Color(0xFFF3F9F6)]),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: C.emerald.withValues(alpha: 0.22)),
          ),
          child: Row(children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(children: [
                    const Ic('map', size: 16, color: C.emeraldDark),
                    const SizedBox(width: 6),
                    Flexible(
                      child: Text('Find the advantages with Tour Shongi',
                          maxLines: 1, overflow: TextOverflow.ellipsis,
                          style: T.d(14, w: FontWeight.w700, color: C.emeraldDark)),
                    ),
                  ]),
                  const SizedBox(height: 8),
                  Wrap(spacing: 14, runSpacing: 4, children: [
                    for (final it in items)
                      Row(mainAxisSize: MainAxisSize.min, children: [
                        Ic(it.i, size: 14, color: C.emerald),
                        const SizedBox(width: 5),
                        Text(it.t, style: T.b(11, w: FontWeight.w500, color: C.slate)),
                      ]),
                  ]),
                ],
              ),
            ),
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(gradient: G.emerald, shape: BoxShape.circle),
              child: const Icon(Icons.arrow_forward_rounded, size: 16, color: Colors.white),
            ),
          ]),
        ),
      ),
    );
  }
}

class _ExperienceRow extends StatelessWidget {
  final void Function(String) onPick;
  const _ExperienceRow({required this.onPick});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: GridView.count(
        crossAxisCount: 4,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        children: [for (final e in experiences) ExperienceTile(e, onTap: () => onPick(e.id))],
      ),
    );
  }
}

/// "Travel with a Group" home section (GroupsHomeSection).
class _GroupsHomeSection extends StatelessWidget {
  final Map<String, int> joined;
  const _GroupsHomeSection({required this.joined});
  @override
  Widget build(BuildContext context) {
    final events = groupEvents.take(4).toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 14),
          child: Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(children: [
                  Container(width: 26, height: 26, decoration: BoxDecoration(gradient: G.emerald, borderRadius: BorderRadius.circular(8)), child: const Ic('users', size: 16, color: Colors.white)),
                  const SizedBox(width: 7),
                  Text('Travel with a Group', style: T.d(20, w: FontWeight.w700, spacing: -0.3)),
                ]),
                const SizedBox(height: 5),
                Text('Join a hosted tour · meet new people', style: T.b(13, w: FontWeight.w500, color: C.mist)),
              ]),
            ),
            GestureDetector(
              onTap: () => openGroups(context),
              child: Row(mainAxisSize: MainAxisSize.min, children: [
                Text('See all', style: T.b(13, w: FontWeight.w600, color: C.emerald)),
                const SizedBox(width: 3),
                const Icon(Icons.arrow_forward_rounded, size: 15, color: C.emerald),
              ]),
            ),
          ]),
        ),
        SizedBox(
          height: 350,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: events.length,
            separatorBuilder: (_, _) => const SizedBox(width: 14),
            itemBuilder: (_, i) => Align(
              alignment: Alignment.topCenter,
              child: GroupEventCardTall(
                ev: events[i],
                booked: events[i].booked + (joined[events[i].id] ?? 0),
                onOpen: () => openGroupEvent(context, events[i]),
                onChat: () => openChat(context, ChatCtx.event(events[i])),
                onHost: (g) => openGroupProfile(context, g),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// "All results" feed with sort/offers/rating filters (AllResultsFeed).
class _AllResultsFeed extends StatefulWidget {
  const _AllResultsFeed();
  @override
  State<_AllResultsFeed> createState() => _AllResultsFeedState();
}

class _AllResultsFeedState extends State<_AllResultsFeed> {
  String sort = 'recommended';
  bool onlyOffers = false;
  bool topRated = false;

  @override
  Widget build(BuildContext context) {
    final c = AppScope.of(context);
    var feed = <Listing>[];
    final maxN = hotels.length > activities.length ? hotels.length : activities.length;
    for (int i = 0; i < maxN; i++) {
      if (i < hotels.length) feed.add(hotels[i]);
      if (i < activities.length) feed.add(activities[i]);
    }
    if (onlyOffers) feed = feed.where((it) => it.discount > 0).toList();
    if (topRated) feed = feed.where((it) => it.rating >= 4.0).toList();
    if (sort == 'price') feed.sort((a, b) => a.base.budget - b.base.budget);
    if (sort == 'rating') feed.sort((a, b) => b.rating.compareTo(a.rating));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 14),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(child: Text('All results', style: T.d(20, w: FontWeight.w700, spacing: -0.3))),
              Text('${feed.length} places', style: T.b(13, w: FontWeight.w500, color: C.mist)),
            ],
          ),
        ),
        SizedBox(
          height: 46,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            children: [
              GestureDetector(
                onTap: () => openFilter(context),
                child: Container(
                  width: 46,
                  height: 46,
                  decoration: BoxDecoration(
                    color: C.surface,
                    shape: BoxShape.circle,
                    border: Border.all(color: C.hairline, width: 1.5),
                  ),
                  child: const Ic('sliders', size: 20, color: C.ink),
                ),
              ),
              const SizedBox(width: 10),
              _pill('Sort', active: sort != 'recommended', chevron: true, onTap: _sortMenu),
              const SizedBox(width: 10),
              _pill('Offers', active: onlyOffers, onTap: () => setState(() => onlyOffers = !onlyOffers)),
              const SizedBox(width: 10),
              _pill('Ratings 4.0+', active: topRated, star: true, onTap: () => setState(() => topRated = !topRated)),
            ],
          ),
        ),
        const SizedBox(height: 14),
        for (final it in feed)
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
            child: CompactCard(it,
                onOpen: () => openDetail(context, it), fav: c.isFav(it.id), onFav: () => c.toggleFav(it.id)),
          ),
      ],
    );
  }

  Future<void> _sortMenu() async {
    final v = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: C.surface,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (final o in const [('recommended', 'Recommended'), ('price', 'Price: Low to High'), ('rating', 'Top rated')])
              ListTile(
                title: Text(o.$2, style: T.b(14, w: FontWeight.w600)),
                trailing: sort == o.$1 ? const Icon(Icons.check_rounded, color: C.emerald) : null,
                onTap: () => Navigator.pop(context, o.$1),
              ),
          ],
        ),
      ),
    );
    if (v != null) setState(() => sort = v);
  }

  Widget _pill(String label, {bool active = false, bool chevron = false, bool star = false, VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: active ? C.emeraldTint : C.surface,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: active ? C.emerald : C.hairline, width: 1.5),
        ),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          if (star) ...[
            Icon(Icons.star_rounded, size: 16, color: active ? C.emeraldDark : C.saffron),
            const SizedBox(width: 5),
          ],
          Text(label, style: T.d(14, w: FontWeight.w700, color: active ? C.emeraldDark : C.ink)),
          if (chevron) ...[
            const SizedBox(width: 4),
            Ic('chevD', size: 15, color: active ? C.emeraldDark : C.slate),
          ],
        ]),
      ),
    );
  }
}
