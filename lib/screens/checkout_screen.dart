import 'dart:math';
import 'package:flutter/material.dart';
import '../core/theme.dart';
import '../core/icons.dart';
import '../data/content.dart';
import '../app_state.dart';
import '../nav.dart';
import '../widgets/photo.dart';
import '../widgets/ui.dart';
import '../widgets/trip_bits.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});
  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  String pay = 'bKash';

  @override
  Widget build(BuildContext context) {
    final c = AppScope.of(context);
    final items = c.trip;
    final b = priceBreakdown(items);
    final topPad = MediaQuery.of(context).padding.top;
    final totalGuests = items.fold<int>(1, (m, it) => it.guests > m ? it.guests : m);

    return Scaffold(
      backgroundColor: C.cloud,
      body: Stack(
        children: [
          ListView(
            padding: EdgeInsets.only(top: topPad + 16, bottom: 150),
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: PushHeader('Checkout', sub: c.tripName),
              ),
              const Padding(padding: EdgeInsets.fromLTRB(20, 22, 20, 18), child: TripSteps(2)),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: C.surface,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: C.hairline),
                        boxShadow: S.card,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(children: [
                            Expanded(child: Text(c.tripName, style: T.d(16, w: FontWeight.w700))),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(color: C.emeraldTint, borderRadius: BorderRadius.circular(999)),
                              child: Text('${items.length} items', style: T.b(11, w: FontWeight.w600, color: C.emeraldDark)),
                            ),
                          ]),
                          const SizedBox(height: 12),
                          Row(children: [
                            _chip('cal', '30 May – 2 Jun'),
                            const SizedBox(width: 16),
                            _chip('users', '$totalGuests travellers'),
                          ]),
                        ],
                      ),
                    ),
                    const SizedBox(height: 18),
                    _mini('Your items'),
                    for (final it in items)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Row(children: [
                          SizedBox(width: 48, height: 48, child: Photo(src: unsplash(it.img, 140), hue: 150, height: 48, radius: 11)),
                          const SizedBox(width: 11),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(it.optionName, maxLines: 1, overflow: TextOverflow.ellipsis, style: T.b(13.5, w: FontWeight.w600)),
                                Text('${tierShort(it.tier)} · ${it.nights > 1 ? '${it.nights}n · ' : ''}${it.guests} guests',
                                    style: T.b(11, w: FontWeight.w500, color: C.mist)),
                              ],
                            ),
                          ),
                          Text(taka(it.total), style: T.b(13.5, w: FontWeight.w700)),
                        ]),
                      ),
                    const SizedBox(height: 12),
                    _mini('Traveller details'),
                    _field('user', user.name),
                    _field('mail', user.email),
                    _field('headset', '+880 1712 345678'),
                    const SizedBox(height: 22),
                    _mini('Payment method'),
                    for (final m in const [
                      (brand: 'bKash', last: '•••• 4821', hue: 330),
                      (brand: 'Nagad', last: '•••• 7733', hue: 24),
                      (brand: 'Card', last: 'Visa •••• 5560', hue: 220),
                    ])
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: _PayMethod(
                          brand: m.brand,
                          last: m.last,
                          hue: m.hue,
                          active: pay == m.brand,
                          onTap: () => setState(() => pay = m.brand),
                        ),
                      ),
                    const SizedBox(height: 12),
                    Row(children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                          decoration: BoxDecoration(
                            color: C.cloud,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: C.hairline),
                          ),
                          child: Row(children: [
                            const Ic('tag', size: 17, color: C.saffronDark),
                            const SizedBox(width: 10),
                            Text('Promo code', style: T.b(13, w: FontWeight.w600, color: C.mist)),
                          ]),
                        ),
                      ),
                      const SizedBox(width: 10),
                      TSButton(variant: BtnVariant.ghost, onTap: () {}, child: const Text('Apply')),
                    ]),
                    const SizedBox(height: 22),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: C.surface,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: C.hairline),
                        boxShadow: S.card,
                      ),
                      child: BreakdownRows(b, showTotal: true),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.fromLTRB(20, 14, 20, 28),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [C.surface, Color(0x00FFFFFF)],
                  stops: [0.72, 1],
                ),
              ),
              child: TSButton(
                full: true,
                large: true,
                onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => ConfirmationScreen(pay: pay))),
                child: Row(mainAxisSize: MainAxisSize.min, children: [
                  const Ic('shield', size: 19, color: Colors.white),
                  const SizedBox(width: 8),
                  Text('Confirm & pay ${taka(b.total)}'),
                ]),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _chip(String icon, String text) => Row(mainAxisSize: MainAxisSize.min, children: [
        Ic(icon, size: 15, color: C.emerald),
        const SizedBox(width: 6),
        Text(text, style: T.b(12.5, w: FontWeight.w500, color: C.slate)),
      ]);

  Widget _mini(String t) => Padding(
        padding: const EdgeInsets.only(bottom: 11),
        child: Text(t.toUpperCase(), style: T.b(12, w: FontWeight.w700, color: C.slate, spacing: 0.5)),
      );

  Widget _field(String icon, String value) => Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
        decoration: BoxDecoration(
          color: C.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: C.hairline),
        ),
        child: Row(children: [
          Ic(icon, size: 18, color: C.emerald),
          const SizedBox(width: 11),
          Expanded(child: Text(value, style: T.b(13.5, w: FontWeight.w600))),
          const Ic('edit', size: 15, color: C.mist),
        ]),
      );
}

class _PayMethod extends StatelessWidget {
  final String brand, last;
  final int hue;
  final bool active;
  final VoidCallback onTap;
  const _PayMethod({required this.brand, required this.last, required this.hue, required this.active, required this.onTap});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
        decoration: BoxDecoration(
          color: active ? C.emeraldTint : C.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: active ? C.emerald : C.hairline, width: active ? 1.5 : 1),
        ),
        child: Row(children: [
          Container(
            width: 42,
            height: 30,
            decoration: BoxDecoration(color: hsl(hue.toDouble(), 0.6, 0.48), borderRadius: BorderRadius.circular(7)),
            alignment: Alignment.center,
            child: Text(brand[0], style: T.d(11, w: FontWeight.w800, color: Colors.white)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(brand, style: T.b(13.5, w: FontWeight.w600)),
                Text(last, style: T.b(12, w: FontWeight.w500, color: C.mist)),
              ],
            ),
          ),
          Container(
            width: 22,
            height: 22,
            decoration: BoxDecoration(
              color: active ? C.emerald : Colors.transparent,
              shape: BoxShape.circle,
              border: active ? null : Border.all(color: C.hairline, width: 2),
            ),
            child: active ? const Icon(Icons.check_rounded, size: 14, color: Colors.white) : null,
          ),
        ]),
      ),
    );
  }
}

class ConfirmationScreen extends StatelessWidget {
  final String pay;
  const ConfirmationScreen({super.key, required this.pay});
  @override
  Widget build(BuildContext context) {
    final c = AppScope.of(context);
    final items = List.of(c.trip);
    final b = priceBreakdown(items);
    final ref = 'TS${Random().nextInt(900000) + 100000}';
    return Scaffold(
      backgroundColor: C.cloud,
      body: Stack(
        children: [
          ListView(
            padding: const EdgeInsets.fromLTRB(20, 90, 20, 140),
            children: [
              Column(children: [
                Container(
                  width: 84,
                  height: 84,
                  decoration: BoxDecoration(
                    color: C.success,
                    shape: BoxShape.circle,
                    boxShadow: const [BoxShadow(color: Color(0x592E9E6B), blurRadius: 30, offset: Offset(0, 14))],
                  ),
                  child: const Icon(Icons.check_rounded, size: 44, color: Colors.white),
                ),
                const SizedBox(height: 18),
                Text('Trip booked!', style: T.d(24, w: FontWeight.w800, spacing: -0.4)),
                const SizedBox(height: 8),
                Text.rich(
                  TextSpan(children: [
                    TextSpan(text: 'Paid with $pay · Booking ', style: T.b(14, w: FontWeight.w400, color: C.slate)),
                    TextSpan(text: ref, style: T.b(14, w: FontWeight.w700, color: C.ink)),
                  ]),
                  textAlign: TextAlign.center,
                ),
              ]),
              const SizedBox(height: 26),
              Container(
                decoration: BoxDecoration(
                  color: C.surface,
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(color: C.hairline),
                  boxShadow: S.card,
                ),
                clipBehavior: Clip.antiAlias,
                child: Column(children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
                    decoration: const BoxDecoration(gradient: G.emerald),
                    child: Row(children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('E-voucher', style: T.b(11, w: FontWeight.w500, color: Colors.white70)),
                            Text(c.tripName, style: T.d(17, w: FontWeight.w700, color: Colors.white)),
                          ],
                        ),
                      ),
                      const Ic('receipt', size: 28, color: Colors.white),
                    ]),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(18),
                    child: Column(children: [
                      for (final it in items)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 7),
                          child: Row(children: [
                            Expanded(
                              child: Text.rich(TextSpan(children: [
                                TextSpan(text: it.optionName, style: T.b(13, w: FontWeight.w600)),
                                TextSpan(text: ' · ${tierShort(it.tier)}', style: T.b(13, w: FontWeight.w500, color: C.mist)),
                              ])),
                            ),
                            Text(taka(it.total), style: T.b(13, w: FontWeight.w600)),
                          ]),
                        ),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: Divider(height: 1, color: C.hairline),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          Text('Total paid', style: T.d(15, w: FontWeight.w700)),
                          Text(taka(b.total), style: T.d(19, w: FontWeight.w800, color: C.emeraldDark)),
                        ],
                      ),
                      const SizedBox(height: 16),
                      CustomPaint(size: const Size(96, 96), painter: _QrPainter()),
                      const SizedBox(height: 8),
                      Text('Show this QR at check-in', style: T.b(11, w: FontWeight.w500, color: C.mist)),
                    ]),
                  ),
                ]),
              ),
            ],
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.fromLTRB(20, 14, 20, 28),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [C.cloud, Color(0x00F4F7F6)],
                  stops: [0.72, 1],
                ),
              ),
              child: TSButton(
                full: true,
                large: true,
                onTap: () {
                  c.clearTrip();
                  Navigator.of(context).popUntil((r) => r.isFirst);
                },
                child: const Text('View my trips'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Faux QR block.
class _QrPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final border = Paint()
      ..color = C.ink
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4;
    final cell = size.width / 6;
    final fill = Paint()..color = C.ink;
    final rng = Random(42);
    for (int y = 0; y < 6; y++) {
      for (int x = 0; x < 6; x++) {
        if (rng.nextBool()) {
          canvas.drawRect(Rect.fromLTWH(x * cell, y * cell, cell, cell), fill);
        }
      }
    }
    canvas.drawRRect(
        RRect.fromRectAndRadius(Offset.zero & size, const Radius.circular(12)), border);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
