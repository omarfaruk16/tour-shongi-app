import 'package:flutter/material.dart';
import '../core/theme.dart';
import '../data/models.dart';
import 'photo.dart';
import 'ui.dart';

/// Hotel or activity card used in home/explore rails (HotelCard / ActivityCard).
class ListingCard extends StatelessWidget {
  final Listing item;
  final VoidCallback onOpen;
  final bool fav;
  final VoidCallback onFav;
  final double width;
  const ListingCard(this.item,
      {super.key, required this.onOpen, required this.fav, required this.onFav, this.width = 264});

  @override
  Widget build(BuildContext context) {
    final act = item.isActivity;
    return GestureDetector(
      onTap: onOpen,
      child: Container(
        width: width,
        decoration: BoxDecoration(
          color: C.surface,
          borderRadius: BorderRadius.circular(R.card),
          boxShadow: S.card,
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(8),
              child: Photo(
                src: unsplash(item.img, 600),
                hue: item.hue,
                height: 150,
                scrim: true,
                child: Stack(
                  children: [
                    Positioned(
                      top: 12,
                      left: 12,
                      child: act
                          ? _IntensityPill(item.intensity ?? '')
                          : (item.discount > 0 ? Ribbon(item.discount) : const TierPill(small: true)),
                    ),
                    Positioned(top: 12, right: 12, child: FavHeart(active: fav, onToggle: onFav)),
                    Positioned(
                      left: 14,
                      bottom: 12,
                      child: Row(
                        children: [
                          const Icon(Icons.place_outlined, size: 14, color: Colors.white),
                          const SizedBox(width: 4),
                          Text(item.location, style: T.b(12, w: FontWeight.w600, color: Colors.white)),
                          if (act) ...[
                            const SizedBox(width: 8),
                            const Icon(Icons.schedule_rounded, size: 13, color: Colors.white),
                            const SizedBox(width: 4),
                            Text(item.duration ?? '',
                                style: T.b(12, w: FontWeight.w600, color: Colors.white)),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 4, 14, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(item.name,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: T.d(16, w: FontWeight.w700, height: 1.25, spacing: -0.2)),
                      ),
                      const SizedBox(width: 8),
                      Padding(
                        padding: const EdgeInsets.only(top: 2),
                        child: Stars(item.rating),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(child: _PriceFrom(item.base.budget)),
                      Container(
                        width: 34,
                        height: 34,
                        decoration: const BoxDecoration(color: C.emeraldTint, shape: BoxShape.circle),
                        child: const Icon(Icons.arrow_forward_rounded, size: 17, color: C.emeraldDark),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _IntensityPill extends StatelessWidget {
  final String text;
  const _IntensityPill(this.text);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.82),
        borderRadius: BorderRadius.circular(999),
        boxShadow: const [BoxShadow(color: Color(0x1F14201D), blurRadius: 8, offset: Offset(0, 2))],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.speed_rounded, size: 13, color: C.emerald),
          const SizedBox(width: 5),
          Text(text, style: T.b(11, w: FontWeight.w600, color: C.ink)),
        ],
      ),
    );
  }
}

class _PriceFrom extends StatelessWidget {
  final int amount;
  const _PriceFrom(this.amount);
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('from', style: T.b(11, w: FontWeight.w500, color: C.mist)),
        Text.rich(TextSpan(children: [
          TextSpan(text: taka(amount), style: T.b(18, w: FontWeight.w700, color: C.ink)),
          TextSpan(text: ' /person', style: T.b(12, w: FontWeight.w500, color: C.slate)),
        ])),
      ],
    );
  }
}

/// Horizontal compact list card (CompactCard).
class CompactCard extends StatelessWidget {
  final Listing item;
  final VoidCallback onOpen;
  final bool fav;
  final VoidCallback onFav;
  const CompactCard(this.item,
      {super.key, required this.onOpen, required this.fav, required this.onFav});
  @override
  Widget build(BuildContext context) {
    final act = item.isActivity;
    return GestureDetector(
      onTap: onOpen,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: C.surface,
          borderRadius: BorderRadius.circular(R.card),
          boxShadow: S.card,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 104,
              height: 104,
              child: Stack(
                children: [
                  Photo(src: unsplash(item.img, 320), hue: item.hue, height: 104, radius: 16),
                  if (item.discount > 0)
                    Positioned(
                      top: 6,
                      left: 6,
                      child: Transform.scale(
                        scale: 0.82,
                        alignment: Alignment.topLeft,
                        child: Ribbon(item.discount),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(right: 4),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(act ? 'ACTIVITY' : 'STAY',
                              style: T.b(10,
                                  w: FontWeight.w600,
                                  color: act ? C.emerald : C.info,
                                  spacing: 0.6)),
                        ),
                        FavHeart(active: fav, onToggle: onFav, size: 30),
                      ],
                    ),
                    const SizedBox(height: 3),
                    Text(item.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: T.d(15, w: FontWeight.w700, height: 1.2, spacing: -0.2)),
                    const SizedBox(height: 5),
                    Stars(item.rating, size: 12, reviews: item.reviews),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        const Icon(Icons.place_outlined, size: 13, color: C.mist),
                        const SizedBox(width: 4),
                        Flexible(
                          child: Text(
                            act ? '${item.location} · ${item.duration}' : item.location,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: T.b(12, w: FontWeight.w500, color: C.mist),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 7),
                    Text.rich(TextSpan(children: [
                      TextSpan(text: 'from ${taka(item.base.budget)}',
                          style: T.b(15, w: FontWeight.w700, color: C.ink)),
                      TextSpan(text: ' /person', style: T.b(11, w: FontWeight.w500, color: C.slate)),
                    ])),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Destination tile (DestinationCard).
class DestinationCard extends StatelessWidget {
  final Destination d;
  final VoidCallback onOpen;
  const DestinationCard(this.d, {super.key, required this.onOpen});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onOpen,
      child: SizedBox(
        width: 150,
        child: Photo(
          src: unsplash(d.img, 400),
          hue: d.hue,
          height: 190,
          radius: 20,
          scrim: true,
          child: Positioned(
            left: 13,
            right: 13,
            bottom: 12,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(d.name, style: T.d(16, w: FontWeight.w700, color: Colors.white, spacing: -0.2)),
                Text(d.bn, style: T.bn(11, color: Colors.white.withValues(alpha: 0.85))),
                const SizedBox(height: 4),
                Text('${d.resorts} stays · ${d.activities} activities',
                    style: T.b(11, w: FontWeight.w500, color: Colors.white.withValues(alpha: 0.9))),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Experience tile (ExperienceTile) — emoji + label on a soft tinted square.
class ExperienceTile extends StatelessWidget {
  final Experience e;
  final VoidCallback onTap;
  const ExperienceTile(this.e, {super.key, required this.onTap});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AspectRatio(
        aspectRatio: 1,
        child: Container(
          padding: const EdgeInsets.fromLTRB(10, 14, 10, 12),
          decoration: BoxDecoration(
            color: e.bg,
            borderRadius: BorderRadius.circular(22),
            boxShadow: const [BoxShadow(color: Color(0x0F14201D), blurRadius: 16, offset: Offset(0, 6))],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(child: Center(child: Text(e.emoji, style: const TextStyle(fontSize: 38)))),
              Text(e.label,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  style: T.b(12.5, w: FontWeight.w600, color: C.ink, height: 1.15)),
            ],
          ),
        ),
      ),
    );
  }
}
