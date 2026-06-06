# Tour Shongi — Flutter mobile app

A Flutter port of the **Tour Shongi — Travel Prototype** (`Tour Shongi (offline).html`),
the interactive Bangladesh travel app. Full-screen mobile app (the device is the
phone, so the web prototype's phone-frame chrome is dropped). Frontend only — all
hotels, activities, reels, offers and pricing are bundled static data ported from
the prototype's `data.jsx`.

> This is the **app**, distinct from the marketing-site port in `../tour_shongi_flutter`.

## Run it

```bash
cd tour_shongi_app
flutter pub get
flutter run            # device/emulator
flutter run -d chrome  # browser
```
First run needs internet (Unsplash photos + Google Fonts). Offline, images show a
striped placeholder and fonts fall back — layout is unaffected.

## Status — fully built ✅

The whole prototype is ported and verified: `flutter analyze` → **No issues found**,
**16 widget tests pass** (full-tree, zero overflows), `flutter build web --release` → **succeeds**.
Animations throughout (press-scale buttons, staggered entrances, animated seat bars,
sliding tier selector, typing indicator, parallax heroes, animated toggles & accordions).

## Core app

- **Auth** — login & register (traveller / tour-group), "continue as guest".
- **5-tab shell** with the floating bottom nav: **Home · Explore · Reels · Trip · Account**.
- **Home** — location header + search, auto-rotating offers carousel, USP band, the
  6 *type of experience* tiles, Hotels/Recommended/Activities rails with category chips,
  top-destinations rail, and the "All results" feed with sort / offers / rating filters.
- **Explore** — search, find-via-map card, category chips, destinations, results list.
- **Category list** ("Hotels & Resorts" / "Activities") with category + sort/offers/rating filters.
- **Detail** (hotel & activity) — parallax hero, 3-tier pricing, rooms/on-site options,
  15-day price-trend strip, amenities (stays) or itinerary + gear (activities),
  tagged reels, gallery, reviews, map snippet, sticky book bar.
- **Booking sheet** — tier selector, nights/guests steppers, add-ons → adds to the trip cart.
- **Trip cart → Checkout → Confirmation** — line items with live totals, fee/tax/discount
  breakdown, payment methods, and an e-voucher with QR.
- **Reels** — vertical snap feed with like/save/follow + a single-reel viewer; reel CTAs
  deep-link to the matching listing.
- **Map** — pan/zoom stylised vector map with price pins + a bottom place carousel.
- **Account** — profile, wallet card, payment methods, grouped settings menu, **Saved** trips.
- **Filter sheet** — destination, dates, tier, category, guests/rooms.

State (favourites + trip cart) is shared app-wide via an `AppController` / `AppScope`.

## Travel Groups, Hajj & extras

- **Travel with a Group** — home section + full browse screen with trusted-host strip,
  "filling fast" + type filters, and seats-left bars.
- **Hajj & Umrah** — approved-agency browse with assurance band.
- **Group event detail** — parallax hero, day-by-day journey/stay/activity plan, capacity &
  gender split, suitable-for, a Tour Shongi **trip-invigilator** card, what's-included, travel
  buddies, host reviews, and a sticky **Join** bar → tier/seats/group join sheet (updates seats live).
- **Host / agency public profile** — cover, badges, stats, bio, upcoming/completed history, reviews.
- **Become a host flow** — register → dashboard → create event (with plan builder) → manage members.
- **Chat** — animated message thread with quick replies, typing indicator and auto host replies.
- **Account sub-screens** — My bookings, Wallet (with transactions), Offers (copyable coupons),
  Become a host, Post a reel, Personal details, Privacy & security, Notifications, Help, Settings.

## Structure

```
lib/
  main.dart              App entry, auth gate, tab shell + bottom nav
  app_state.dart         AppController (favs + trip cart) + AppScope + priceBreakdown
  nav.dart               Navigation helpers (open detail/booking/map/…) + toasts
  core/                  theme.dart (tokens), icons.dart (named icon set)
  data/                  models.dart, content.dart (all listings/reels/options/…)
  widgets/               photo, ui atoms, cards, chrome, booking_bits, trip_bits
  screens/               auth, home, explore, category, detail, booking_sheet,
                         trip, checkout, reels, account, map, filter_sheet
```

## Verified

`flutter analyze` → **No issues found**. `flutter test` (full-tree smoke test) → **passing**,
no layout overflows. `flutter build web --release` → **succeeds**.
Built with Flutter 3.44 / Dart 3.12.
