import 'package:flutter/material.dart';
import '../core/theme.dart';
import '../core/icons.dart';
import '../data/models.dart';
import '../data/content.dart';
import '../app_state.dart';
import '../nav.dart';
import '../widgets/photo.dart';
import '../widgets/ui.dart';
import '../widgets/booking_bits.dart';

class DetailScreen extends StatefulWidget {
  final Listing item;
  const DetailScreen({super.key, required this.item});
  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  final _scroll = ScrollController();
  double _y = 0;
  int _pickDate = 0;

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
    final item = widget.item;
    final c = AppScope.of(context);
    final isAct = item.isActivity;
    final days = buildPriceTable(item.base.budget, item.id.length + 3);
    final topPad = MediaQuery.of(context).padding.top;
    final scrolled = _y > 250;

    return Scaffold(
      backgroundColor: C.cloud,
      body: Stack(
        children: [
          // parallax hero
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Transform.translate(
              offset: Offset(0, (-_y * 0.4).clamp(-200.0, 0.0)),
              child: SizedBox(
                height: 420,
                child: Photo(src: unsplash(item.img, 1000), hue: item.hue, height: 420, radius: 0, scrim: true),
              ),
            ),
          ),
          // content
          SingleChildScrollView(
            controller: _scroll,
            child: Column(
              children: [
                const SizedBox(height: 332),
                Container(
                  decoration: const BoxDecoration(
                    color: C.cloud,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
                  ),
                  padding: const EdgeInsets.only(top: 22, bottom: 150),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: isAct ? _activityBody(item, days) : _hotelBody(item, days),
                  ),
                ),
              ],
            ),
          ),
          // top bar
          Container(
            padding: EdgeInsets.fromLTRB(18, topPad + 8, 18, 12),
            decoration: BoxDecoration(
              color: scrolled ? Colors.white.withValues(alpha: 0.9) : Colors.transparent,
              border: scrolled ? const Border(bottom: BorderSide(color: C.hairline)) : null,
            ),
            child: Row(
              children: [
                _glassBtn('chevL', () => Navigator.of(context).pop()),
                const Spacer(),
                _glassBtn('share', () {}),
                const SizedBox(width: 10),
                _glassBtn(c.isFav(item.id) ? 'heart' : 'heart', () => c.toggleFav(item.id),
                    color: c.isFav(item.id) ? C.error : C.ink),
              ],
            ),
          ),
          // sticky bar
          Positioned(left: 0, right: 0, bottom: 0, child: _stickyBar(item, isAct, c)),
        ],
      ),
    );
  }

  Widget _glassBtn(String icon, VoidCallback onTap, {Color color = C.ink}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.9),
          shape: BoxShape.circle,
          boxShadow: const [BoxShadow(color: Color(0x2914201D), blurRadius: 10, offset: Offset(0, 2))],
        ),
        child: Ic(icon, size: 19, color: color),
      ),
    );
  }

  // ── Hotel body ──
  List<Widget> _hotelBody(Listing item, List<PriceDay> days) {
    final opts = optionsFor(item.id);
    return [
      _block(Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(item.name, style: T.d(24, w: FontWeight.w800, height: 1.15, spacing: -0.5)),
                    Text(item.bn, style: T.bn(13, color: C.mist)),
                  ],
                ),
              ),
              if (item.discount > 0) Ribbon(item.discount),
            ],
          ),
          const SizedBox(height: 10),
          Wrap(spacing: 14, runSpacing: 6, crossAxisAlignment: WrapCrossAlignment.center, children: [
            Stars(item.rating, reviews: item.reviews),
            _locLine(item.location),
          ]),
        ],
      )),
      _section('About this stay', _blurb(item.blurb)),
      _block(Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle('Add to your trip'),
          const SizedBox(height: 4),
          Text('Pick rooms and on-site activities — each adds to your trip.',
              style: T.b(12.5, w: FontWeight.w400, color: C.mist)),
          const SizedBox(height: 14),
          _OptionsSection(listing: item, stays: opts.stays, acts: opts.acts),
        ],
      )),
      const SizedBox(height: 26),
      _block(_sectionTitle('15-day price trend')),
      const SizedBox(height: 12),
      PriceTable(days: days, selected: _pickDate, onPick: (v) => setState(() => _pickDate = v)),
      const SizedBox(height: 26),
      _section('Facilities', _Amenities(item.amenities)),
      ..._reelsAndGallery(item),
      _section('Reviews', _Reviews(item.rating, item.reviews)),
      _section('Location', _MapSnippet(item.location, item.hue)),
    ];
  }

  // ── Activity body ──
  List<Widget> _activityBody(Listing item, List<PriceDay> days) {
    return [
      _block(Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(item.name, style: T.d(24, w: FontWeight.w800, height: 1.15, spacing: -0.5)),
          const SizedBox(height: 10),
          Wrap(spacing: 12, runSpacing: 6, crossAxisAlignment: WrapCrossAlignment.center, children: [
            Stars(item.rating, reviews: item.reviews),
            _locLine(item.location),
          ]),
          const SizedBox(height: 14),
          Row(children: [
            Expanded(child: _metaTile('clock', item.duration ?? '')),
            const SizedBox(width: 10),
            Expanded(child: _metaTile('gauge', item.intensity ?? '')),
          ]),
        ],
      )),
      _section('The experience', _blurb(item.blurb)),
      const SizedBox(height: 26),
      _block(_sectionTitle('15-day price trend')),
      const SizedBox(height: 12),
      PriceTable(days: days, selected: _pickDate, onPick: (v) => setState(() => _pickDate = v)),
      const SizedBox(height: 26),
      _section('How the day flows', _Timeline(item.steps)),
      _section('What to bring', _GearList(item.gear)),
      ..._reelsAndGallery(item),
      _section('Reviews', _Reviews(item.rating, item.reviews)),
      _section('Meeting point', _MapSnippet(item.location, item.hue)),
    ];
  }

  List<Widget> _reelsAndGallery(Listing item) {
    final rl = reelsFor(item.id);
    return [
      if (rl.isNotEmpty) ...[
        const SizedBox(height: 26),
        _block(_sectionTitle(item.isActivity ? 'Reels of this activity' : 'Reels at this place')),
        const SizedBox(height: 12),
        SizedBox(
          height: 176,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: rl.length,
            separatorBuilder: (_, _) => const SizedBox(width: 12),
            itemBuilder: (_, i) => _ReelThumb(rl[i]),
          ),
        ),
      ],
      _section('Gallery', _Gallery(item)),
    ];
  }

  Widget _block(Widget child) => Padding(padding: const EdgeInsets.symmetric(horizontal: 20), child: child);

  Widget _section(String title, Widget child) => Padding(
        padding: const EdgeInsets.fromLTRB(20, 26, 20, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [_sectionTitle(title), const SizedBox(height: 12), child],
        ),
      );

  Widget _sectionTitle(String t) => Text(t, style: T.d(18, w: FontWeight.w700, spacing: -0.3));

  Widget _blurb(String text) => Text.rich(TextSpan(children: [
        TextSpan(text: '$text ', style: T.b(14, w: FontWeight.w400, color: C.slate, height: 1.65)),
        TextSpan(text: 'Read more', style: T.b(14, w: FontWeight.w600, color: C.emerald)),
      ]));

  Widget _locLine(String loc) => Row(mainAxisSize: MainAxisSize.min, children: [
        const Ic('pin', size: 15, color: C.emerald),
        const SizedBox(width: 4),
        Text(loc, style: T.b(13, w: FontWeight.w500, color: C.slate)),
      ]);

  Widget _metaTile(String icon, String label) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 11),
        decoration: BoxDecoration(
          color: C.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: C.hairline),
        ),
        child: Row(children: [
          Ic(icon, size: 19, color: C.emeraldDark),
          const SizedBox(width: 9),
          Text(label, style: T.b(13, w: FontWeight.w600)),
        ]),
      );

  Widget _stickyBar(Listing item, bool isAct, AppController c) {
    return Container(
      padding: EdgeInsets.fromLTRB(20, 14, 20, 28 + MediaQuery.of(context).padding.bottom * 0),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          colors: [C.surface, Color(0x00FFFFFF)],
          stops: [0.72, 1],
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (c.trip.isNotEmpty)
            GestureDetector(
              onTap: () => openTrip(context),
              child: Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
                decoration: BoxDecoration(color: C.emeraldTint, borderRadius: BorderRadius.circular(13)),
                child: Row(children: [
                  const Ic('bag', size: 16, color: C.emeraldDark),
                  const SizedBox(width: 7),
                  Expanded(
                    child: Text('${c.trip.length} in your trip · ${taka(c.tripTotal)}',
                        style: T.d(12.5, w: FontWeight.w700, color: C.emeraldDark)),
                  ),
                  Text('View', style: T.d(12.5, w: FontWeight.w700, color: C.emeraldDark)),
                  const Ic('arrowR', size: 14, color: C.emeraldDark),
                ]),
              ),
            ),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: C.surface,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: C.hairline),
              boxShadow: const [BoxShadow(color: Color(0x1F14201D), blurRadius: 30, offset: Offset(0, 12))],
            ),
            child: Row(children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('from', style: T.b(11, w: FontWeight.w500, color: C.mist)),
                      Text.rich(TextSpan(children: [
                        TextSpan(text: taka(item.base.budget), style: T.d(20, w: FontWeight.w800, height: 1.05)),
                        TextSpan(text: ' /person', style: T.b(12, w: FontWeight.w500, color: C.slate)),
                      ])),
                    ],
                  ),
                ),
              ),
              TSButton(
                large: true,
                onTap: () {
                  if (isAct) {
                    openBooking(
                        context,
                        HotelOption(item.id, item.name, item.blurb, item.img, item.base,
                            discount: item.discount, duration: item.duration),
                        'Activity',
                        item);
                  } else {
                    openTrip(context);
                  }
                },
                child: Row(mainAxisSize: MainAxisSize.min, children: [
                  Ic(isAct ? 'plus' : 'bag', size: 18, color: Colors.white),
                  const SizedBox(width: 6),
                  Text(isAct ? 'Add to Trip' : 'View Trip'),
                ]),
              ),
            ]),
          ),
        ],
      ),
    );
  }
}

// ── Options (rooms / activities) inside a hotel ──
class _OptionsSection extends StatefulWidget {
  final Listing listing;
  final List<HotelOption> stays, acts;
  const _OptionsSection({required this.listing, required this.stays, required this.acts});
  @override
  State<_OptionsSection> createState() => _OptionsSectionState();
}

class _OptionsSectionState extends State<_OptionsSection> {
  String tab = 'stays';
  String selTier = 'budget';
  @override
  Widget build(BuildContext context) {
    final list = tab == 'stays' ? widget.stays : widget.acts;
    final kind = tab == 'stays' ? 'Stay' : 'Activity';
    int tierRange(String k) {
      final ps = list.map((o) => o.price.byKey(k)).where((p) => p > 0);
      return ps.isEmpty ? 0 : ps.reduce((a, b) => a < b ? a : b);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(children: [
          _tab('stays', 'Stays', widget.stays.length),
          const SizedBox(width: 8),
          _tab('acts', 'Activities', widget.acts.length),
        ]),
        const SizedBox(height: 14),
        // tier chooser — every room comes in all three tiers
        Row(children: [
          const Ic('layers', size: 14, color: C.mist),
          const SizedBox(width: 7),
          Text('Choose your comfort level — prices update', style: T.b(11.5, w: FontWeight.w600, color: C.slate)),
        ]),
        const SizedBox(height: 9),
        Row(children: [
          for (final t in tiers) ...[
            Expanded(child: _tierTile(t, tierRange(t.key))),
            if (t != tiers.last) const SizedBox(width: 8),
          ],
        ]),
        const SizedBox(height: 6),
        for (int i = 0; i < list.length; i++) ...[
          _OptionRow(opt: list[i], kind: kind, tier: selTier, onAdd: () => openBooking(context, list[i], kind, widget.listing, initialTier: selTier)),
          if (i < list.length - 1) const Divider(height: 1, color: C.hairline),
        ],
      ],
    );
  }

  Widget _tierTile(Tier t, int from) {
    final on = selTier == t.key;
    final accent = t.gradient ? C.saffronDark : t.color;
    return GestureDetector(
      onTap: () => setState(() => selTier = t.key),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 11),
        decoration: BoxDecoration(
          color: on ? Color.alphaBlend(accent.withValues(alpha: 0.09), Colors.white) : C.surface,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: on ? accent : C.hairline, width: on ? 1.5 : 1),
          boxShadow: on ? [BoxShadow(color: accent.withValues(alpha: 0.22), blurRadius: 16, offset: const Offset(0, 6))] : null,
        ),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Ic(t.icon, size: 18, color: accent),
          const SizedBox(height: 4),
          Text(t.short, style: T.d(12, w: on ? FontWeight.w800 : FontWeight.w700, color: on ? accent : C.slate)),
          const SizedBox(height: 2),
          Text('from ${taka(from)}', maxLines: 1, overflow: TextOverflow.ellipsis, style: T.b(10, w: FontWeight.w600, color: C.mist)),
        ]),
      ),
    );
  }

  Widget _tab(String k, String label, int n) {
    final on = tab == k;
    return GestureDetector(
      onTap: () => setState(() => tab = k),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
        decoration: BoxDecoration(
          color: on ? C.emeraldTint : C.surface,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: on ? C.emerald : C.hairline, width: on ? 1.5 : 1),
        ),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          Text(label, style: T.d(13.5, w: FontWeight.w700, color: on ? C.emeraldDark : C.slate)),
          const SizedBox(width: 6),
          Text('$n', style: T.b(11, w: FontWeight.w600, color: (on ? C.emeraldDark : C.slate).withValues(alpha: 0.7))),
        ]),
      ),
    );
  }
}

class _OptionRow extends StatelessWidget {
  final HotelOption opt;
  final String kind;
  final String tier;
  final VoidCallback onAdd;
  const _OptionRow({required this.opt, required this.kind, required this.tier, required this.onAdd});
  @override
  Widget build(BuildContext context) {
    final t = tiers.firstWhere((x) => x.key == tier, orElse: () => tiers.first);
    final accent = t.gradient ? C.saffronDark : t.color;
    final orig = opt.price.byKey(tier);
    final disc = opt.discount > 0 ? ((orig * (1 - opt.discount / 100)) / 50).round() * 50 : null;
    return GestureDetector(
      onTap: onAdd,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(children: [
          SizedBox(width: 64, height: 64, child: Photo(src: unsplash(opt.img, 200), hue: 160, height: 64, radius: 14)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(children: [
                  Flexible(child: Text(opt.name, maxLines: 1, overflow: TextOverflow.ellipsis, style: T.d(14.5, w: FontWeight.w700, spacing: -0.2))),
                  const SizedBox(width: 7),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                    decoration: BoxDecoration(
                      gradient: t.gradient ? G.gold : null,
                      color: t.gradient ? null : Color.alphaBlend(t.color.withValues(alpha: 0.14), Colors.white),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Row(mainAxisSize: MainAxisSize.min, children: [
                      Ic(t.icon, size: 10, color: t.gradient ? Colors.white : accent),
                      const SizedBox(width: 3),
                      Text(t.short.toUpperCase(), style: T.b(9, w: FontWeight.w700, color: t.gradient ? Colors.white : accent, spacing: 0.4)),
                    ]),
                  ),
                ]),
                const SizedBox(height: 2),
                Row(children: [
                  Text(taka(disc ?? orig), style: T.b(13.5, w: FontWeight.w700, color: accent)),
                  if (disc != null) ...[
                    const SizedBox(width: 6),
                    Text(taka(orig), style: T.b(12, w: FontWeight.w500, color: C.mist).copyWith(decoration: TextDecoration.lineThrough)),
                  ],
                  Text(' · ${kind == 'Stay' ? 'per night' : (opt.duration ?? 'per person')}', style: T.b(11, w: FontWeight.w500, color: C.mist)),
                ]),
                const SizedBox(height: 3),
                Text(opt.desc, maxLines: 1, overflow: TextOverflow.ellipsis, style: T.b(12, w: FontWeight.w400, color: C.slate)),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: C.surface,
              shape: BoxShape.circle,
              border: Border.all(color: accent, width: 1.5),
            ),
            child: Icon(Icons.add_rounded, size: 20, color: accent),
          ),
        ]),
      ),
    );
  }
}

class _Amenities extends StatelessWidget {
  final List<String> list;
  const _Amenities(this.list);
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, c) {
      final w = (c.maxWidth - 12) / 2;
      return Wrap(
        spacing: 12,
        runSpacing: 12,
        children: [
          for (final a in list.take(6))
            SizedBox(
              width: w,
              child: Row(children: [
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(color: C.emeraldTint, borderRadius: BorderRadius.circular(12)),
                  child: Ic(a, size: 19, color: C.emeraldDark),
                ),
                const SizedBox(width: 10),
                Expanded(child: Text(amenityLabels[a] ?? a, style: T.b(13, w: FontWeight.w500))),
              ]),
            ),
        ],
      );
    });
  }
}

class _Timeline extends StatelessWidget {
  final List<DayStep> steps;
  const _Timeline(this.steps);
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (int i = 0; i < steps.length; i++)
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(children: [
                  Container(
                    width: 30,
                    height: 30,
                    decoration: const BoxDecoration(color: C.emerald, shape: BoxShape.circle),
                    alignment: Alignment.center,
                    child: Text('${i + 1}', style: T.d(13, w: FontWeight.w700, color: Colors.white)),
                  ),
                  if (i < steps.length - 1) Expanded(child: Container(width: 2, color: C.hairline)),
                ]),
                const SizedBox(width: 14),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(bottom: i < steps.length - 1 ? 18 : 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(children: [
                          Expanded(child: Text(steps[i].t, style: T.d(14, w: FontWeight.w700))),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(color: C.emeraldTint, borderRadius: BorderRadius.circular(999)),
                            child: Text(steps[i].time, style: T.b(11, w: FontWeight.w600, color: C.emerald)),
                          ),
                        ]),
                        const SizedBox(height: 4),
                        Text(steps[i].d, style: T.b(13, w: FontWeight.w400, color: C.slate, height: 1.5)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

class _GearList extends StatelessWidget {
  final List<Gear> gear;
  const _GearList(this.gear);
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (final g in gear) ...[
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: C.surface,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: C.hairline),
            ),
            child: Row(children: [
              Ic(g.tag == 'Provided' ? 'check' : 'tag', size: 17,
                  color: g.tag == 'Provided' ? C.success : C.saffronDark),
              const SizedBox(width: 10),
              Expanded(child: Text(g.n, style: T.b(13, w: FontWeight.w600))),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: (g.tag == 'Provided' ? C.success : C.saffron).withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(g.tag, style: T.b(11, w: FontWeight.w600, color: g.tag == 'Provided' ? C.success : C.saffronDark)),
              ),
            ]),
          ),
          const SizedBox(height: 8),
        ],
      ],
    );
  }
}

class _Reviews extends StatelessWidget {
  final double rating;
  final int count;
  const _Reviews(this.rating, this.count);
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
          Column(children: [
            Text(rating.toString(), style: T.d(38, w: FontWeight.w800, height: 1)),
            const SizedBox(height: 4),
            const Icon(Icons.star_rounded, size: 16, color: C.saffron),
            const SizedBox(height: 3),
            Text('${thou(count)} reviews', style: T.b(11, w: FontWeight.w500, color: C.mist)),
          ]),
          const SizedBox(width: 18),
          Expanded(
            child: Column(
              children: [
                for (final b in ratingBars)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 5),
                    child: Row(children: [
                      SizedBox(width: 10, child: Text('${b.s}', style: T.b(11, w: FontWeight.w600, color: C.slate))),
                      const SizedBox(width: 8),
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(99),
                          child: LinearProgressIndicator(
                            value: b.p / 100,
                            minHeight: 6,
                            backgroundColor: C.hairline,
                            valueColor: const AlwaysStoppedAnimation(C.saffron),
                          ),
                        ),
                      ),
                    ]),
                  ),
              ],
            ),
          ),
        ]),
        const SizedBox(height: 16),
        for (final r in reviews) ...[
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(color: C.cloud, borderRadius: BorderRadius.circular(16)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(color: hsl(r.name.length * 18.0, 0.4, 0.8), shape: BoxShape.circle),
                    alignment: Alignment.center,
                    child: Text(r.name[0], style: T.d(13, w: FontWeight.w700)),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(r.name, style: T.b(13, w: FontWeight.w600)),
                        Text(r.when, style: T.b(11, w: FontWeight.w500, color: C.mist)),
                      ],
                    ),
                  ),
                  Row(mainAxisSize: MainAxisSize.min, children: [
                    for (int i = 0; i < r.stars; i++) const Icon(Icons.star_rounded, size: 12, color: C.saffron),
                  ]),
                ]),
                const SizedBox(height: 7),
                Text(r.text, style: T.b(13, w: FontWeight.w400, color: C.slate, height: 1.5)),
              ],
            ),
          ),
          const SizedBox(height: 12),
        ],
      ],
    );
  }
}

class _Gallery extends StatelessWidget {
  final Listing item;
  const _Gallery(this.item);
  static const _pool = [
    '1540541338287-41700207dee6', '1571896349842-33c89424de2d', '1566073771259-6a8506099945',
    '1582719508461-905c673771fd', '1520250497591-112f2f40a3f4', '1501785888041-af3ef285b470',
  ];
  @override
  Widget build(BuildContext context) {
    final ids = [item.img, ..._pool.where((x) => x != item.img)].take(5).toList();
    String at(int i) => unsplash(ids[i % ids.length], 400);
    return SizedBox(
      height: 168,
      child: Row(children: [
        Expanded(flex: 2, child: Photo(src: at(0), hue: item.hue, radius: 16)),
        const SizedBox(width: 8),
        Expanded(
          child: Column(children: [
            Expanded(child: Photo(src: at(1), hue: item.hue + 12, radius: 16)),
            const SizedBox(height: 8),
            Expanded(child: Photo(src: at(3), hue: item.hue + 6, radius: 16)),
          ]),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(children: [
            Expanded(child: Photo(src: at(2), hue: item.hue - 10, radius: 16)),
            const SizedBox(height: 8),
            Expanded(
              child: Stack(fit: StackFit.expand, children: [
                Photo(src: at(4), hue: item.hue - 6, radius: 16),
                Container(
                  decoration: BoxDecoration(
                      color: const Color(0x8C14201D), borderRadius: BorderRadius.circular(16)),
                  alignment: Alignment.center,
                  child: Text('+${item.gallery * 3}', style: T.d(15, w: FontWeight.w700, color: Colors.white)),
                ),
              ]),
            ),
          ]),
        ),
      ]),
    );
  }
}

class _MapSnippet extends StatelessWidget {
  final String location;
  final int hue;
  const _MapSnippet(this.location, this.hue);
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 140,
      decoration: BoxDecoration(
        color: hsl(hue.toDouble(), 0.22, 0.90),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: C.hairline),
      ),
      child: Stack(children: [
        Center(
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: C.emerald,
              shape: BoxShape.circle,
              boxShadow: const [BoxShadow(color: Color(0x660E7C66), blurRadius: 16, offset: Offset(0, 6))],
            ),
            child: const Ic('pin', size: 20, color: Colors.white),
          ),
        ),
        Positioned(
          left: 12,
          bottom: 12,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: C.surface,
              borderRadius: BorderRadius.circular(999),
              boxShadow: const [BoxShadow(color: Color(0x1F14201D), blurRadius: 8, offset: Offset(0, 2))],
            ),
            child: Row(mainAxisSize: MainAxisSize.min, children: [
              const Ic('pin', size: 13, color: C.emerald),
              const SizedBox(width: 5),
              Text(location, style: T.b(12, w: FontWeight.w600)),
            ]),
          ),
        ),
      ]),
    );
  }
}

class _ReelThumb extends StatelessWidget {
  final Reel r;
  const _ReelThumb(this.r);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => openReelViewer(context, r),
      child: SizedBox(
        width: 124,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Stack(fit: StackFit.expand, children: [
            Image.network(unsplash(r.img, 300), fit: BoxFit.cover,
                errorBuilder: (_, _, _) => Container(color: C.cloud)),
            const DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [Color(0x9914201D), Color(0x0014201D)],
                  stops: [0, 0.55],
                ),
              ),
            ),
            Positioned(
              top: 8,
              right: 8,
              child: Container(
                width: 26,
                height: 26,
                decoration: BoxDecoration(color: Colors.black.withValues(alpha: 0.4), shape: BoxShape.circle),
                child: const Icon(Icons.play_arrow_rounded, size: 13, color: Colors.white),
              ),
            ),
            Positioned(
              left: 9,
              right: 9,
              bottom: 9,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(r.handle, maxLines: 1, overflow: TextOverflow.ellipsis, style: T.b(11, w: FontWeight.w600, color: Colors.white)),
                  Row(children: [
                    const Icon(Icons.favorite_rounded, size: 11, color: Colors.white),
                    const SizedBox(width: 3),
                    Text('${(r.likes / 1000).toStringAsFixed(1)}k', style: T.b(10, w: FontWeight.w600, color: Colors.white)),
                  ]),
                ],
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
