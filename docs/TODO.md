# TODO.md — Tour Shongi (Flutter app)

> Remaining work, in priority order. The **UI port is done**; almost everything below is about turning
> the prototype into a real product (backend, persistence, services, store readiness).
> Project path: `~/Desktop/tour_shongi_app/`.

---

## Priority 0 — Environment / build unblockers (do first)

- [ ] **Install Android SDK** via Android Studio SDK Manager; run `flutter doctor --android-licenses`; confirm `flutter doctor` is green for Android.
- [ ] Put Flutter on PATH (or document the `export PATH="$HOME/flutter/bin:$PATH"` prefix in README).
- [ ] Verify a debug build runs on an Android emulator/device and on macOS.
- [ ] (Optional) Fix Xcode/CocoaPods if iOS is a target.

## Priority 1 — Make the prototype "real" (MVP backbone)

- [ ] **Decide backend strategy** (Firebase vs. custom REST/Node vs. Supabase). This unlocks everything below.
- [ ] **Real authentication**: email/password + phone OTP + Google sign-in; replace the `AuthGate` boolean; add token/session storage, logout, password reset. (Register screen already collects org/NID/etc. for host accounts.)
- [ ] **Persistence**: pick local store (Hive/Isar/sqflite or Firestore offline) for favourites, trip cart, group joins, and (later) auth session. Replace in-memory `AppController` fields with a repository layer.
- [ ] **Data layer / API**: stand up endpoints mirroring `lib/data/` shapes (listings, options, destinations, collections, offers, reels, groups, group-events, hajj, bookings, wallet, chat). Introduce a repository/service abstraction so screens stop importing static `content.dart`/`groups.dart` directly. Add `--dart-define` API base URL.
- [ ] **Booking → server**: turn checkout into a real `POST /bookings`; return a booking id/voucher; list under My Bookings from the server.
- [ ] **Wire stub buttons**: audit every `comingSoon`/no-op action (share, host dashboard actions, post-reel submit, redeem points, etc.) and either implement or hide.

## Priority 2 — Core product features

- [ ] **Payments**: integrate bKash/Nagad/card gateway; replace mock payment-method UI; handle success/failure/refund.
- [ ] **Search & filters that actually filter** (currently decorative). Back with server query params or local filtering.
- [ ] **Real chat**: websocket/Firestore messaging for listing host, group host, and Tour Shongi Support; presence, unread counts, push.
- [ ] **Real map**: swap the vector `CustomPaint` for Google Maps/Mapbox with real coordinates and clustered price pins.
- [ ] **Calendar availability/pricing**: make selected dates affect availability and price (seasonal/weekend), not just display strings.
- [ ] **Reels media**: real short-video playback + upload pipeline (post-reel flow).

## Priority 3 — Production hardening

- [ ] **Localization**: extract Bangla/English strings to `intl`/`.arb`; add a language switch.
- [ ] **Image caching** (`cached_network_image`) + asset/CDN strategy; consider bundling key images for offline.
- [ ] **Error/empty/loading states** for every networked screen (shimmers, retry, offline banner).
- [ ] **Accessibility**: semantics labels, contrast, dynamic text scaling, large-tap targets.
- [ ] **Analytics + crash reporting** (e.g. Firebase Analytics/Crashlytics or Sentry).
- [ ] **Push notifications** (booking updates, group reminders, chat).
- [ ] **App identity**: custom app icon, splash screen, adaptive icons, package id, signing config.
- [ ] **Store readiness**: Play/App-Store listings, screenshots, privacy policy, content rating, ToS.
- [ ] **Security**: secure token storage, input validation, NID/KYC handling for hosts, rate limiting on backend.
- [ ] **Testing**: expand beyond overflow smoke tests — unit tests for repositories/pricing, integration tests for the booking and join flows, golden tests for key widgets.
- [ ] **CI/CD**: pipeline for analyze + test + build (web/Android), and release automation.

---

## MVP task list (minimum to ship a usable booking app)

1. Android SDK + green `flutter doctor`.
2. Backend chosen + listings/destinations/collections/reels served from it.
3. Real auth (email/phone) + session persistence.
4. Persist favourites + trip cart.
5. Real booking submission + My Bookings from server.
6. One real payment method (bKash **or** card).
7. Search/filter actually filters.
8. App icon + splash + Android signed build.
9. Basic error/loading/empty states.
10. Privacy policy + store listing for a closed beta.

## Production task list (beyond MVP)

- All Priority 2 + Priority 3 items: payments (all methods), real chat, real maps, reels video, localization, image caching, accessibility, analytics/crash, push, full test suite, CI/CD, security/KYC, iOS build, and full store launch assets.

---

## Nice-to-haves / polish backlog

- [ ] Persist & restore last-selected tier per listing.
- [ ] Wishlist/Saved sync across devices.
- [ ] Host analytics dashboard (real numbers).
- [ ] Referral / loyalty mechanics behind the wallet points.
- [ ] Dark mode (theme tokens already centralized — feasible).
- [ ] Re-introduce the prototype "Tweaks" variants as real user settings if desired (layout/mood).
