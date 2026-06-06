import 'package:flutter/material.dart';
import '../core/theme.dart';
import '../core/icons.dart';
import '../data/models.dart';
import '../data/content.dart';
import '../app_state.dart';
import '../nav.dart';
import '../widgets/cards.dart';
import '../widgets/chrome.dart';

/// "Hotels & Resorts" / "Activities" full list (CategoryListScreen).
class CategoryScreen extends StatefulWidget {
  final String type; // hotel | activity
  const CategoryScreen({super.key, required this.type});
  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  String cat = 'All';
  String sort = 'recommended';
  bool onlyOffers = false;
  bool topRated = false;

  bool get isAct => widget.type == 'activity';

  @override
  Widget build(BuildContext context) {
    final c = AppScope.of(context);
    final all = isAct ? catalogActivities : catalogHotels;
    final cats = ['All', ...categories.where((cc) => all.any((i) => i.cat == cc))];
    var list = cat == 'All' ? List<Listing>.from(all) : all.where((i) => i.cat == cat).toList();
    if (onlyOffers) list = list.where((i) => i.discount > 0).toList();
    if (topRated) list = list.where((i) => i.rating >= 4.0).toList();
    if (sort == 'price') list.sort((a, b) => a.base.budget - b.base.budget);
    if (sort == 'rating') list.sort((a, b) => b.rating.compareTo(a.rating));
    final topPad = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: C.cloud,
      body: AnimatedBuilder(
        animation: c,
        builder: (context, _) => Column(
          children: [
            Container(
              padding: EdgeInsets.only(top: topPad + 8),
              decoration: const BoxDecoration(
                color: C.cloud,
                border: Border(bottom: BorderSide(color: C.hairline)),
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                    child: Row(children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(color: C.surface, shape: BoxShape.circle, border: Border.all(color: C.hairline)),
                          child: const Ic('chevL', size: 22, color: C.ink),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(isAct ? 'Activities' : 'Hotels & Resorts', style: T.d(22, w: FontWeight.w800, spacing: -0.4)),
                            Text(
                                '${list.length} ${isAct ? 'activities' : 'stays'}${cat != 'All' ? ' · $cat' : ' across Bangladesh'}',
                                style: T.b(12, w: FontWeight.w500, color: C.mist)),
                          ],
                        ),
                      ),
                    ]),
                  ),
                  ChipRow(items: cats, value: cat, onChange: (v) => setState(() => cat = v)),
                  const SizedBox(height: 12),
                  _filterBar(),
                  const SizedBox(height: 12),
                ],
              ),
            ),
            Expanded(
              child: list.isEmpty
                  ? Center(child: Text('No ${isAct ? 'activities' : 'stays'} match these filters.',
                      style: T.b(14, w: FontWeight.w500, color: C.mist)))
                  : ListView.separated(
                      padding: const EdgeInsets.fromLTRB(20, 16, 20, 30),
                      itemCount: list.length,
                      separatorBuilder: (_, _) => const SizedBox(height: 12),
                      itemBuilder: (_, i) => CompactCard(list[i],
                          onOpen: () => openDetail(context, list[i]), fav: c.isFav(list[i].id), onFav: () => c.toggleFav(list[i].id)),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _filterBar() {
    return SizedBox(
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
              decoration: BoxDecoration(color: C.surface, shape: BoxShape.circle, border: Border.all(color: C.hairline, width: 1.5)),
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
