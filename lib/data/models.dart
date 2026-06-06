import 'package:flutter/material.dart';
import '../core/theme.dart';

/// Per-tier base prices (BDT).
class Base {
  final int budget, premium, luxury;
  const Base(this.budget, this.premium, this.luxury);
  int byKey(String k) => k == 'luxury' ? luxury : (k == 'premium' ? premium : budget);
}

class Tier {
  final String key, label, short;
  final Color color;
  final String icon;
  final bool gradient;
  const Tier(this.key, this.label, this.short, this.color, this.icon, {this.gradient = false});
}

const tiers = <Tier>[
  Tier('budget', 'Budget Friendly', 'Budget', C.tierBudget, 'wallet'),
  Tier('premium', 'Premium', 'Premium', C.tierPremium, 'diamond'),
  Tier('luxury', 'Luxury', 'Luxury', C.tierLuxA, 'crown', gradient: true),
];

class DayStep {
  final String t, time, d;
  const DayStep(this.t, this.time, this.d);
}

class Gear {
  final String n, tag; // tag: Provided | Bring
  const Gear(this.n, this.tag);
}

/// A hotel/resort or activity listing.
class Listing {
  final String id, kind, name, bn, location, cat, ph, img, blurb;
  final double rating;
  final int reviews, discount, hue, gallery;
  final Base base;
  final List<String> amenities;
  final String? duration, intensity;
  final List<DayStep> steps;
  final List<Gear> gear;
  const Listing({
    required this.id,
    required this.kind,
    required this.name,
    required this.bn,
    required this.location,
    required this.rating,
    required this.reviews,
    required this.cat,
    required this.base,
    this.discount = 0,
    required this.ph,
    required this.hue,
    required this.img,
    required this.blurb,
    this.amenities = const [],
    this.gallery = 4,
    this.duration,
    this.intensity,
    this.steps = const [],
    this.gear = const [],
  });

  bool get isActivity => kind == 'activity';

  /// Clone with overrides (mirrors `_variant` in data.jsx).
  Listing variant({
    required String id,
    String? name,
    String? bn,
    String? location,
    String? cat,
    double? rating,
    int? reviews,
    int? discount,
    int? hue,
    String? img,
    Base? base,
    String? duration,
    String? intensity,
  }) =>
      Listing(
        id: id,
        kind: kind,
        name: name ?? this.name,
        bn: bn ?? this.bn,
        location: location ?? this.location,
        rating: rating ?? this.rating,
        reviews: reviews ?? this.reviews,
        cat: cat ?? this.cat,
        base: base ?? this.base,
        discount: discount ?? this.discount,
        ph: ph,
        hue: hue ?? this.hue,
        img: img ?? this.img,
        blurb: blurb,
        amenities: amenities,
        gallery: gallery,
        duration: duration ?? this.duration,
        intensity: intensity ?? this.intensity,
        steps: steps,
        gear: gear,
      );
}

class Destination {
  final String id, name, bn, tag, ph, img;
  final int resorts, activities, hue;
  const Destination(this.id, this.name, this.bn, this.tag, this.resorts, this.activities,
      this.ph, this.hue, this.img);
}

class Offer {
  final String id, title, sub, img;
  final int off, hue;
  const Offer(this.id, this.title, this.off, this.sub, this.hue, this.img);
}

class Experience {
  final String id, label, emoji;
  final Color bg;
  const Experience(this.id, this.label, this.emoji, this.bg);
}

class Review {
  final String name, when, text;
  final int stars;
  const Review(this.name, this.when, this.stars, this.text);
}

class Reel {
  final String id, owner, kind, handle, caption, music, linkId, cta, tag, img;
  final bool verified;
  final int hue, likes, comments, shares;
  const Reel({
    required this.id,
    required this.owner,
    required this.kind,
    required this.handle,
    required this.verified,
    required this.hue,
    required this.caption,
    required this.music,
    required this.likes,
    required this.comments,
    required this.shares,
    required this.linkId,
    required this.cta,
    required this.tag,
    required this.img,
  });
}

/// A bookable room/experience inside a hotel.
class HotelOption {
  final String id, name, desc, img;
  final Base price;
  final int discount;
  final String? duration;
  const HotelOption(this.id, this.name, this.desc, this.img, this.price,
      {this.discount = 0, this.duration});
}

class Addon {
  final String id, name, img;
  final int price;
  const Addon(this.id, this.name, this.price, this.img);
}

class PriceDay {
  final int offset;
  final bool isToday;
  final String label, month;
  final int dayNum, price, delta;
  final String trend; // today|up|down|flat
  const PriceDay(this.offset, this.isToday, this.label, this.dayNum, this.month, this.price,
      this.delta, this.trend);
}

/// 15-day price strip (buildPriceTable: 7 past · today · 7 future).
List<PriceDay> buildPriceTable(int base, [int seed = 1]) {
  final today = DateTime(2026, 5, 30);
  var rng = seed * 9301 + 49297;
  double rand() {
    rng = (rng * 9301 + 49297) % 233280;
    return rng / 233280;
  }

  final raw = <({DateTime d, int price})>[];
  for (var i = -7; i <= 7; i++) {
    final d = today.add(Duration(days: i));
    final wobble = (rand() - 0.42) * 0.26;
    final weekend = (d.weekday == DateTime.friday || d.weekday == DateTime.saturday) ? 0.12 : 0.0;
    final price = ((base * (1 + wobble + weekend)) / 50).round() * 50;
    raw.add((d: d, price: price));
  }
  final todayPrice = raw[7].price;
  const wk = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
  const mo = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
  return [
    for (var i = 0; i < raw.length; i++)
      () {
        final r = raw[i];
        final offset = i - 7;
        final isToday = offset == 0;
        final delta = r.price - todayPrice;
        final trend = isToday
            ? 'today'
            : (r.price < todayPrice ? 'down' : (r.price > todayPrice ? 'up' : 'flat'));
        return PriceDay(offset, isToday, wk[r.d.weekday - 1], r.d.day, mo[r.d.month - 1],
            r.price, delta, trend);
      }(),
  ];
}

class AppUser {
  final String name, handle, email, initials, tier, since;
  final int points, hue;
  final List<({int n, String l})> stats;
  const AppUser(this.name, this.handle, this.email, this.initials, this.hue, this.tier,
      this.points, this.since, this.stats);
}

class AccountItem {
  final String icon, label, meta, to;
  const AccountItem(this.icon, this.label, this.meta, this.to);
}

class AccountGroup {
  final String title;
  final List<AccountItem> items;
  const AccountGroup(this.title, this.items);
}

class PaymentMethod {
  final String brand, last;
  final bool primary;
  final int hue;
  const PaymentMethod(this.brand, this.last, this.primary, this.hue);
}
