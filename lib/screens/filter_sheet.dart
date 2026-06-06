import 'package:flutter/material.dart';
import '../core/theme.dart';
import '../core/icons.dart';
import '../data/models.dart';
import '../data/content.dart';
import '../widgets/ui.dart';

class FilterSheet extends StatefulWidget {
  const FilterSheet({super.key});
  @override
  State<FilterSheet> createState() => _FilterSheetState();
}

class _FilterSheetState extends State<FilterSheet> {
  String tier = 'premium';
  int people = 2;
  int rooms = 1;
  String cat = 'Beach';

  @override
  Widget build(BuildContext context) {
    final maxH = MediaQuery.of(context).size.height * 0.82;
    return Container(
      constraints: BoxConstraints(maxHeight: maxH),
      decoration: const BoxDecoration(
        color: C.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 12),
          Container(width: 40, height: 5, decoration: BoxDecoration(color: C.hairline, borderRadius: BorderRadius.circular(99))),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(children: [
              Text('Filters', style: T.d(22, w: FontWeight.w700, spacing: -0.3)),
              const Spacer(),
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(color: C.surface, shape: BoxShape.circle, border: Border.all(color: C.hairline)),
                  child: const Ic('x', size: 17, color: C.slate),
                ),
              ),
            ]),
          ),
          Flexible(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 4, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _label('Where to'),
                  _field('pin', "Cox's Bazar, Bangladesh"),
                  _label('Dates'),
                  Row(children: [
                    Expanded(child: _field('cal', '30 May')),
                    const SizedBox(width: 10),
                    Expanded(child: _field('cal', '2 Jun')),
                  ]),
                  _label('Facility tier'),
                  Row(children: [
                    for (final t in tiers) ...[
                      Expanded(child: _tierTile(t)),
                      if (t != tiers.last) const SizedBox(width: 8),
                    ],
                  ]),
                  _label('Category'),
                  SizedBox(
                    height: 38,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: categories.length,
                      separatorBuilder: (_, _) => const SizedBox(width: 8),
                      itemBuilder: (_, i) => TSChip(categories[i], active: cat == categories[i], onTap: () => setState(() => cat = categories[i])),
                    ),
                  ),
                  const SizedBox(height: 18),
                  Row(children: [
                    Expanded(child: _label('Guests', inline: true)),
                    QtyStepper(people, (v) => setState(() => people = v)),
                  ]),
                  const Divider(height: 28, color: C.hairline),
                  Row(children: [
                    Expanded(child: _label('Rooms', inline: true)),
                    QtyStepper(rooms, (v) => setState(() => rooms = v)),
                  ]),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(20, 0, 20, 20 + MediaQuery.of(context).padding.bottom),
            child: Row(children: [
              Expanded(
                child: TSButton(
                  variant: BtnVariant.outline,
                  large: true,
                  full: true,
                  onTap: () => setState(() {
                    tier = 'premium';
                    people = 2;
                    rooms = 1;
                    cat = 'Beach';
                  }),
                  child: const Text('Reset'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TSButton(
                  large: true,
                  full: true,
                  onTap: () => Navigator.pop(context),
                  child: const Row(mainAxisSize: MainAxisSize.min, children: [
                    Ic('search', size: 18, color: Colors.white),
                    SizedBox(width: 8),
                    Text('Search'),
                  ]),
                ),
              ),
            ]),
          ),
        ],
      ),
    );
  }

  Widget _label(String t, {bool inline = false}) => Padding(
        padding: EdgeInsets.only(top: inline ? 0 : 18, bottom: inline ? 0 : 8),
        child: Text(t.toUpperCase(), style: T.b(12, w: FontWeight.w600, color: C.slate, spacing: 0.4)),
      );

  Widget _field(String icon, String value) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
        decoration: BoxDecoration(
          color: C.cloud,
          borderRadius: BorderRadius.circular(R.input),
          border: Border.all(color: C.hairline),
        ),
        child: Row(children: [
          Ic(icon, size: 18, color: C.emerald),
          const SizedBox(width: 10),
          Text(value, style: T.b(14, w: FontWeight.w600)),
        ]),
      );

  Widget _tierTile(Tier t) {
    final on = tier == t.key;
    return GestureDetector(
      onTap: () => setState(() => tier = t.key),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 11),
        decoration: BoxDecoration(
          color: on ? Color.alphaBlend(t.color.withValues(alpha: 0.10), Colors.white) : C.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: on ? t.color : C.hairline, width: on ? 1.5 : 1),
        ),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Ic(t.icon, size: 19, color: t.color),
          const SizedBox(height: 5),
          Text(t.short, style: T.b(11, w: FontWeight.w600, color: on ? t.color : C.slate)),
        ]),
      ),
    );
  }
}
