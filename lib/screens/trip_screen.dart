import 'package:flutter/material.dart';
import '../core/theme.dart';
import '../core/icons.dart';
import '../data/content.dart';
import '../app_state.dart';
import '../nav.dart';
import '../widgets/photo.dart';
import '../widgets/ui.dart';
import '../widgets/trip_bits.dart';
import 'detail_screen.dart';
import 'checkout_screen.dart';

class TripScreen extends StatelessWidget {
  const TripScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final c = AppScope.of(context);
    return AnimatedBuilder(
      animation: c,
      builder: (context, _) {
        final items = c.trip;
        final topPad = MediaQuery.of(context).padding.top;
        if (items.isEmpty) {
          return Scaffold(
            backgroundColor: C.cloud,
            body: ListView(
              padding: EdgeInsets.only(top: topPad + 16),
              children: [
                PushHeader('Your Trip', sub: 'Tour Shongi', closeIcon: 'x').p(),
                const Padding(padding: EdgeInsets.fromLTRB(20, 24, 20, 0), child: TripSteps(1)),
                Padding(
                  padding: const EdgeInsets.fromLTRB(40, 70, 40, 0),
                  child: Column(children: [
                    Container(
                      width: 78,
                      height: 78,
                      decoration: BoxDecoration(color: C.emeraldTint, borderRadius: BorderRadius.circular(24)),
                      child: const Ic('bag', size: 36, color: C.emeraldDark),
                    ),
                    const SizedBox(height: 18),
                    Text('Your trip is empty', style: T.d(19, w: FontWeight.w700)),
                    const SizedBox(height: 8),
                    Text('Add stays and activities to build your trip package.',
                        textAlign: TextAlign.center, style: T.b(14, w: FontWeight.w400, color: C.slate, height: 1.5)),
                    const SizedBox(height: 20),
                    TSButton(
                      large: true,
                      onTap: () => Navigator.of(context).pop(),
                      child: const Row(mainAxisSize: MainAxisSize.min, children: [
                        Ic('compass', size: 18, color: Colors.white),
                        SizedBox(width: 8),
                        Text('Browse stays & activities'),
                      ]),
                    ),
                  ]),
                ),
              ],
            ),
          );
        }

        final b = priceBreakdown(items);
        final suggestions = [...hotels, ...activities]
            .where((x) => !items.any((it) => it.listingId == x.id))
            .take(4)
            .toList();

        return Scaffold(
          backgroundColor: C.cloud,
          body: Stack(
            children: [
              ListView(
                padding: EdgeInsets.only(top: topPad + 16, bottom: 150),
                children: [
                  PushHeader('Your Trip', sub: '${items.length} item${items.length > 1 ? 's' : ''} · Tour Shongi', closeIcon: 'x').p(),
                  const Padding(padding: EdgeInsets.fromLTRB(20, 22, 20, 18), child: TripSteps(1)),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                      decoration: BoxDecoration(
                        color: C.surface,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: C.hairline),
                        boxShadow: S.card,
                      ),
                      child: Row(children: [
                        const Ic('bag', size: 19, color: C.emeraldDark),
                        const SizedBox(width: 10),
                        Expanded(child: Text(c.tripName, style: T.d(15, w: FontWeight.w700))),
                        const Ic('edit', size: 16, color: C.mist),
                      ]),
                    ),
                  ),
                  for (final it in items)
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
                      child: TripItemCard(it,
                          onRemove: () => c.removeFromTrip(it.uid), onGuests: (g) => c.setGuests(it.uid, g)),
                    ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
                        decoration: BoxDecoration(
                          color: C.surface,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: C.hairline, width: 1.5, style: BorderStyle.solid),
                        ),
                        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                          const Ic('plus', size: 17, color: C.emerald),
                          const SizedBox(width: 8),
                          Text('Add more to your trip', style: T.d(13.5, w: FontWeight.w700, color: C.emeraldDark)),
                        ]),
                      ),
                    ),
                  ),
                  if (suggestions.isNotEmpty) ...[
                    const SizedBox(height: 26),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Popular with your trip', style: T.d(17, w: FontWeight.w700)),
                          Text('Other travellers added these too', style: T.b(12, w: FontWeight.w500, color: C.mist)),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 168,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        itemCount: suggestions.length,
                        separatorBuilder: (_, _) => const SizedBox(width: 12),
                        itemBuilder: (_, i) {
                          final s = suggestions[i];
                          return GestureDetector(
                            onTap: () => Navigator.of(context).push(
                                MaterialPageRoute(builder: (_) => DetailScreen(item: s))),
                            child: SizedBox(
                              width: 150,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Stack(children: [
                                    Photo(src: unsplash(s.img, 320), hue: s.hue, height: 104, radius: 16),
                                    Positioned(
                                      right: 8,
                                      bottom: 8,
                                      child: Container(
                                        width: 30,
                                        height: 30,
                                        decoration: const BoxDecoration(color: C.surface, shape: BoxShape.circle),
                                        child: const Icon(Icons.add_rounded, size: 17, color: C.emerald),
                                      ),
                                    ),
                                  ]),
                                  const SizedBox(height: 7),
                                  Text(s.name, maxLines: 1, overflow: TextOverflow.ellipsis, style: T.d(13, w: FontWeight.w700, height: 1.2)),
                                  Text('from ${taka(s.base.budget)}', style: T.b(12, w: FontWeight.w600, color: C.emeraldDark)),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 26, 20, 0),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: C.surface,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: C.hairline),
                        boxShadow: S.card,
                      ),
                      child: BreakdownRows(b),
                    ),
                  ),
                ],
              ),
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: _BottomBar(
                  total: b.total,
                  sub: 'incl. fees & taxes',
                  label: 'Review & checkout',
                  onTap: () => Navigator.of(context)
                      .push(MaterialPageRoute(builder: (_) => const CheckoutScreen())),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

/// Sticky bottom bar with total + CTA (shared by Trip).
class _BottomBar extends StatelessWidget {
  final int total;
  final String sub, label;
  final VoidCallback onTap;
  const _BottomBar({required this.total, required this.sub, required this.label, required this.onTap});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 28),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          colors: [C.surface, Color(0x00FFFFFF)],
          stops: [0.72, 1],
        ),
      ),
      child: Container(
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
                  Text(taka(total), style: T.d(20, w: FontWeight.w800, height: 1.1)),
                  Text(sub, style: T.b(11, w: FontWeight.w500, color: C.slate)),
                ],
              ),
            ),
          ),
          TSButton(
            large: true,
            onTap: onTap,
            child: Row(mainAxisSize: MainAxisSize.min, children: [
              Text(label),
              const SizedBox(width: 6),
              const Icon(Icons.arrow_forward_rounded, size: 18, color: Colors.white),
            ]),
          ),
        ]),
      ),
    );
  }
}

extension _Pad on PushHeader {
  Widget p() => Padding(padding: const EdgeInsets.symmetric(horizontal: 20), child: this);
}
