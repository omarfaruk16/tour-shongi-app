import 'package:flutter/material.dart';
import '../core/theme.dart';
import '../core/icons.dart';
import '../data/content.dart';
import '../app_state.dart';
import '../nav.dart';
import '../widgets/cards.dart';
import '../widgets/chrome.dart';
import '../widgets/ui.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});
  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  String cat = 'Beach';
  @override
  Widget build(BuildContext context) {
    final c = AppScope.of(context);
    final topPad = MediaQuery.of(context).padding.top;
    final results = [...hotels, ...activities];
    return AnimatedBuilder(
      animation: c,
      builder: (context, _) {
        return ListView(
          padding: EdgeInsets.only(top: topPad + 16, bottom: 120),
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Explore', style: T.d(26, w: FontWeight.w800, spacing: -0.5)),
                  Text('Stays & activities across Bangladesh', style: T.b(13, w: FontWeight.w500, color: C.mist)),
                ],
              ),
            ),
            TSSearchBar(onFilter: () => openFilter(context), placeholder: 'Search destinations, stays, activities…'),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: GestureDetector(
                onTap: () => openMap(context),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(colors: [C.emeraldTint, Color(0xFFEEF7F3)]),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: C.emerald.withValues(alpha: 0.22)),
                  ),
                  child: Row(children: [
                    Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(gradient: G.emerald, borderRadius: BorderRadius.circular(13)),
                      child: const Ic('map', size: 22, color: Colors.white),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('Find via map', style: T.d(15, w: FontWeight.w700, color: C.emeraldDark, spacing: -0.2)),
                          Text('See every stay & activity around you', style: T.b(12, w: FontWeight.w500, color: C.slate)),
                        ],
                      ),
                    ),
                    const Ic('arrowR', size: 18, color: C.emeraldDark),
                  ]),
                ),
              ),
            ),
            const SizedBox(height: 14),
            ChipRow(items: categories, value: cat, onChange: (v) => setState(() => cat = v)),
            const SizedBox(height: 18),
            const SectionHeader('Top destinations'),
            SizedBox(
              height: 190,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: destinations.length,
                separatorBuilder: (_, _) => const SizedBox(width: 12),
                itemBuilder: (_, i) => DestinationCard(destinations[i], onOpen: () => openDest(context, destinations[i])),
              ),
            ),
            const SizedBox(height: 26),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 14),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(child: Text('$cat results', style: T.d(20, w: FontWeight.w700, spacing: -0.3))),
                  Text('${results.length} places', style: T.b(13, w: FontWeight.w500, color: C.mist)),
                ],
              ),
            ),
            for (final it in results)
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
                child: CompactCard(it, onOpen: () => openDetail(context, it), fav: c.isFav(it.id), onFav: () => c.toggleFav(it.id)),
              ),
          ],
        );
      },
    );
  }
}
