import 'package:flutter/material.dart';
import '../core/theme.dart';
import '../core/icons.dart';
import '../data/models.dart';
import '../app_state.dart';
import 'photo.dart';
import 'ui.dart';

String tierShort(String key) => tiers.firstWhere((t) => t.key == key).short;

/// Browse → Trip → Checkout indicator (TripSteps).
class TripSteps extends StatelessWidget {
  final int active;
  const TripSteps(this.active, {super.key});
  @override
  Widget build(BuildContext context) {
    const labels = ['Browse', 'Trip', 'Checkout'];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6),
      child: Row(
        children: [
          for (int i = 0; i < labels.length; i++) ...[
            Column(mainAxisSize: MainAxisSize.min, children: [
              Container(
                width: 26,
                height: 26,
                decoration: BoxDecoration(
                  color: i <= active ? C.emerald : C.hairline,
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: i < active
                    ? const Icon(Icons.check_rounded, size: 14, color: Colors.white)
                    : Text('${i + 1}', style: T.d(12, w: FontWeight.w700, color: Colors.white)),
              ),
              const SizedBox(height: 5),
              Text(labels[i],
                  style: T.b(11, w: i == active ? FontWeight.w700 : FontWeight.w500, color: i == active ? C.ink : C.mist)),
            ]),
            if (i < labels.length - 1)
              Expanded(
                child: Container(
                  height: 2,
                  margin: const EdgeInsets.only(left: 6, right: 6, bottom: 18),
                  color: i < active ? C.emerald : C.hairline,
                ),
              ),
          ],
        ],
      ),
    );
  }
}

/// Subtotal / fees / taxes / total rows (BreakdownRows).
class BreakdownRows extends StatelessWidget {
  final Breakdown b;
  final bool showTotal;
  const BreakdownRows(this.b, {super.key, this.showTotal = false});
  @override
  Widget build(BuildContext context) {
    Widget row(String l, int v, {bool neg = false}) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(l, style: T.b(13, w: FontWeight.w500, color: neg ? C.success : C.slate)),
              Text('${neg ? '− ' : ''}${taka(v)}',
                  style: T.b(13, w: FontWeight.w600, color: neg ? C.success : C.ink)),
            ],
          ),
        );
    return Column(
      children: [
        row('Subtotal', b.subtotal),
        row('Service fee', b.serviceFee),
        row('Taxes', b.tax),
        if (b.discount > 0) row('Gold member discount', b.discount, neg: true),
        if (showTotal) ...[
          const Divider(height: 16, color: C.hairline),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text('Total', style: T.d(16, w: FontWeight.w700)),
              Text(taka(b.total), style: T.d(20, w: FontWeight.w800)),
            ],
          ),
        ],
      ],
    );
  }
}

/// One trip line item (TripItemCard).
class TripItemCard extends StatelessWidget {
  final TripItem it;
  final VoidCallback onRemove;
  final ValueChanged<int> onGuests;
  const TripItemCard(this.it, {super.key, required this.onRemove, required this.onGuests});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: C.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: C.hairline),
        boxShadow: S.card,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 76, height: 84, child: Photo(src: unsplash(it.img, 240), hue: 150, height: 84, radius: 13)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(children: [
                  Expanded(
                    child: Text(it.optKind.toUpperCase(),
                        style: T.b(10, w: FontWeight.w600, color: it.optKind == 'Activity' ? C.emerald : C.info, spacing: 0.5)),
                  ),
                  GestureDetector(onTap: onRemove, child: const Ic('trash', size: 17, color: C.mist)),
                ]),
                Text(it.optionName, maxLines: 1, overflow: TextOverflow.ellipsis, style: T.d(14.5, w: FontWeight.w700, height: 1.2, spacing: -0.2)),
                Text(it.listingName, maxLines: 1, overflow: TextOverflow.ellipsis, style: T.b(11.5, w: FontWeight.w500, color: C.mist)),
                const SizedBox(height: 7),
                Row(children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(color: C.emeraldTint, borderRadius: BorderRadius.circular(999)),
                    child: Text(tierShort(it.tier), style: T.b(11, w: FontWeight.w600, color: C.emeraldDark)),
                  ),
                  if (it.nights > 1) ...[
                    const SizedBox(width: 6),
                    Text('${it.nights} nights', style: T.b(11, w: FontWeight.w600, color: C.slate)),
                  ],
                  const Spacer(),
                  Text(taka(it.total), style: T.b(15, w: FontWeight.w700)),
                ]),
                const SizedBox(height: 8),
                Row(children: [
                  Text('Guests', style: T.b(11, w: FontWeight.w500, color: C.mist)),
                  const Spacer(),
                  QtyStepper(it.guests, onGuests, min: 1, max: 12),
                ]),
                if (it.addons.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 7),
                    child: Text('+ ${it.addons.map((a) => a.name).join(', ')}',
                        style: T.b(11, w: FontWeight.w500, color: C.slate)),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
