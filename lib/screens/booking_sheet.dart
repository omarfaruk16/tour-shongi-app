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
import '../widgets/calendar.dart';

/// Half-screen booking sheet (BookingSheet) — pick tier, dates, rooms/persons, add-ons.
class BookingSheet extends StatefulWidget {
  final HotelOption opt;
  final String optKind; // Stay | Activity
  final Listing listing;
  final String initialTier;
  const BookingSheet({super.key, required this.opt, required this.optKind, required this.listing, this.initialTier = 'premium'});
  @override
  State<BookingSheet> createState() => _BookingSheetState();
}

class _BookingSheetState extends State<BookingSheet> {
  late String tier = widget.initialTier;
  int guests = 2;
  DateTime? dFrom, dTo;
  final Set<String> picked = {};

  bool get isStay => widget.optKind == 'Stay';

  @override
  void initState() {
    super.initState();
    final start = addDays(startOfDay(DateTime.now()), 3);
    dFrom = start;
    dTo = isStay ? addDays(start, 2) : null;
  }

  @override
  Widget build(BuildContext context) {
    final opt = widget.opt;
    final unit = opt.price.byKey(tier);
    final nights = isStay ? (nightsBetween(dFrom, dTo) < 1 ? 1 : nightsBetween(dFrom, dTo)) : 1;
    final addonList = addons.take(3).toList();
    final addonTotal = addonList.where((a) => picked.contains(a.id)).fold<int>(0, (s, a) => s + a.price);
    final base = isStay ? unit * nights * guests : unit * guests;
    final total = base + addonTotal;
    final maxH = MediaQuery.of(context).size.height * 0.86;

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
          const SizedBox(height: 14),
          Flexible(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 76,
                        height: 76,
                        child: Photo(src: unsplash(opt.img, 240), hue: widget.listing.hue, height: 76, radius: 16),
                      ),
                      const SizedBox(width: 13),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('${widget.optKind} · ${widget.listing.name}'.toUpperCase(),
                                style: T.b(10, w: FontWeight.w600, color: isStay ? C.info : C.emerald, spacing: 0.6)),
                            const SizedBox(height: 2),
                            Text(opt.name, style: T.d(19, w: FontWeight.w800, height: 1.15, spacing: -0.4)),
                            const SizedBox(height: 5),
                            Text(opt.desc, style: T.b(12.5, w: FontWeight.w400, color: C.slate, height: 1.45)),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  _label('Package tier'),
                  const SizedBox(height: 9),
                  TierSelector(value: tier, onChange: (v) => setState(() => tier = v), prices: opt.price),
                  const SizedBox(height: 20),
                  _label(isStay ? 'When is your stay' : 'Pick a date'),
                  const SizedBox(height: 9),
                  DateRangeField(
                    from: dFrom,
                    to: dTo,
                    single: !isStay,
                    onChange: (f, t) => setState(() {
                      dFrom = f;
                      dTo = t;
                    }),
                  ),
                  const SizedBox(height: 18),
                  _label(isStay ? 'How many rooms' : 'How many persons'),
                  const SizedBox(height: 9),
                  PersonsRow(
                    value: guests,
                    onChange: (v) => setState(() => guests = v),
                    min: 1,
                    max: 12,
                    icon: isStay ? 'bed' : 'users',
                    label: isStay ? 'Rooms' : 'Travellers',
                    sub: isStay ? 'Rooms for this stay' : 'Joining this activity',
                  ),
                  const SizedBox(height: 18),
                  Row(
                    children: [
                      _label('Frequently added'),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
                        decoration: BoxDecoration(color: C.cloud, borderRadius: BorderRadius.circular(999)),
                        child: Text('Optional', style: T.b(11, w: FontWeight.w600, color: C.mist)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  for (final a in addonList) ...[
                    _addonRow(a),
                    const SizedBox(height: 8),
                  ],
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Row(
                      children: [
                        const Ic('plus', size: 17, color: C.emerald),
                        const SizedBox(width: 8),
                        Text('Add a special request', style: T.b(13, w: FontWeight.w600, color: C.emeraldDark)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(20, 12, 20, 26 + MediaQuery.of(context).padding.bottom),
            decoration: const BoxDecoration(
              border: Border(top: BorderSide(color: C.hairline)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      RollingNumber(total, style: T.d(22, w: FontWeight.w800, height: 1.1)),
                      Text(
                        isStay
                            ? '${taka(unit)}/person × ${nights}n × $guests'
                            : '${taka(unit)}/person × $guests',
                        style: T.b(11, w: FontWeight.w500, color: C.mist),
                      ),
                    ],
                  ),
                ),
                TSButton(
                  large: true,
                  onTap: () => _add(unit, total, addonTotal, addonList, nights),
                  child: const Row(mainAxisSize: MainAxisSize.min, children: [
                    Icon(Icons.add_rounded, size: 18, color: Colors.white),
                    SizedBox(width: 6),
                    Text('Add to Trip'),
                  ]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _add(int unit, int total, int addonTotal, List<Addon> addonList, int nights) {
    final c = AppScope.of(context);
    c.addToTrip(TripItem(
      uid: '${widget.opt.id}-${DateTime.now().microsecondsSinceEpoch}',
      listingId: widget.listing.id,
      listingName: widget.listing.name,
      kind: widget.listing.kind,
      location: widget.listing.location,
      img: widget.opt.img,
      optionId: widget.opt.id,
      optionName: widget.opt.name,
      optKind: widget.optKind,
      tier: tier,
      isStay: isStay,
      unit: unit,
      addonTotal: addonTotal,
      nights: isStay ? nights : 1,
      guests: guests,
      total: total,
      dateFrom: dFrom != null ? fmtShort(dFrom) : null,
      dateTo: dTo != null ? fmtShort(dTo) : null,
      addons: [
        for (final a in addonList.where((a) => picked.contains(a.id)))
          (id: a.id, name: a.name, price: a.price),
      ],
    ));
    Navigator.of(context).pop();
    showTripToast(context, 'Added “${widget.opt.name}” to your trip');
  }

  Widget _label(String t) =>
      Text(t.toUpperCase(), style: T.b(12, w: FontWeight.w700, color: C.slate, spacing: 0.5));

  Widget _addonRow(Addon a) {
    final on = picked.contains(a.id);
    return GestureDetector(
      onTap: () => setState(() => on ? picked.remove(a.id) : picked.add(a.id)),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: on ? C.emeraldTint : C.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: on ? C.emerald : C.hairline, width: on ? 1.5 : 1),
        ),
        child: Row(
          children: [
            SizedBox(width: 40, height: 40, child: Photo(src: unsplash(a.img, 120), hue: 150, height: 40, radius: 10)),
            const SizedBox(width: 11),
            Expanded(child: Text(a.name, style: T.b(13, w: FontWeight.w600))),
            Text('+${taka(a.price)}', style: T.b(12.5, w: FontWeight.w700, color: C.emeraldDark)),
            const SizedBox(width: 10),
            Container(
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                color: on ? C.emerald : Colors.transparent,
                borderRadius: BorderRadius.circular(7),
                border: on ? null : Border.all(color: C.hairline, width: 2),
              ),
              child: on ? const Icon(Icons.check_rounded, size: 14, color: Colors.white) : null,
            ),
          ],
        ),
      ),
    );
  }
}
