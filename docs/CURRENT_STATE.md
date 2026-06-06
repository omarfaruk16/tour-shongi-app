# CURRENT_STATE.md — Tour Shongi (Flutter app)

> Snapshot of where the project stands. Pairs with PROJECT_MEMORY.md.
> Project path: **`~/Desktop/tour_shongi_app/`**.

---

## Headline

The **frontend prototype is feature-complete**: every screen from the React/JSX prototype
(`Tour Shongi App (offline).html`, the latest delivery) has been ported to Flutter and verified.

- `flutter analyze` → **No issues found** (clean).
- `flutter test` → **18/18 widget tests pass** (each screen pumped at phone size; zero overflows).
- `flutter build web --release` → **builds successfully** (`build/web` artifact present).
- Runs on **Chrome** and **macOS**. (Android not set up — see Known issues.)

### Progress percentage

| Scope | % | Notes |
|---|---|---|
| **Prototype → Flutter UI port** (the actual job so far) | **~100%** | All screens & flows present and matching the latest prototype |
| **As a shippable product (MVP)** | **~35%** | UI done, but **no backend / auth / payments / persistence** |
| **As a production app** | **~15%** | No real data, security, store assets, Android build, or services |

> Interpret the percentages by context: *the UI clone is essentially finished*; *the product behind
> it barely exists* because everything is mocked/local.

---

## What is fully completed ✅

**Foundation**
- Theme system (`C/R/S/G/T` tokens), `buildTheme()`, money/image/HSL helpers.
- Icon mapping layer (`Ic` widget + `kIconMap`).
- Global state (`AppController` + `AppScope`): favourites, trip cart, group-joins, price breakdown.
- Navigation helper layer (`lib/nav.dart`) with all push/sheet helpers + `ChatCtx` + toasts.
- Static data layer: `models.dart`, `content.dart`, `groups.dart` (full seed catalog).
- Animation widgets: `Pressable`, `StaggerIn`, `GrowBar`, plus `RollingNumber`, `TierSelector` slide, typing dots, parallax heroes.

**Screens / flows (all done)**
- **Auth**: Login + Register (Traveller/Tour-Group toggle), guest entry, two-line social buttons, logout.
- **Home**: location header, offers carousel, USP band, **4-column experience grid**, Hotels/Recommended/Activities rails, Groups-on-home section, destinations rail, "all results" feed with sort/offers/rating filters.
- **Explore**: search, find-on-map card, category chips, destinations, full list.
- **Category list** ("Hotels & Resorts" / "Activities") with filters.
- **Detail** (hotel & activity): parallax hero, **tier chooser** (Budget/Premium/Luxury, prices update), bookable options, **15-day price trend**, amenities / itinerary+gear, reels strip, gallery, reviews + rating bars, map snippet, sticky book bar.
- **Booking sheet**: tier selector, **date-range calendar** (check-in/out, nights) + single-date for activities, **Rooms/Travellers** stepper, add-ons → adds a `TripItem` to the cart.
- **Trip cart**: items, suggestions, **price breakdown** (service fee, tax, discount), sticky checkout.
- **Checkout → Confirmation**: payment method pick, **e-voucher with QR** (custom painter).
- **Reels**: vertical pager, reel cards, full-screen viewer, deep-link to listing, **"Visited" badge + "Book again"** CTA for visited places.
- **Map**: pan/zoom vector `CustomPaint` map with price pins and peek cards.
- **Filter sheet**: where / dates / tier / category / guests / rooms.
- **Destination pages** (`DestinationScreen`): hero + All/Stays/Activities/Tour-groups tabs, location-matched listings.
- **Collection pages** (`CollectionScreen`): **Eco-parks** & **Hidden Gems** curated sets.
- **Chat**: animated bubbles, typing indicator, quick replies; contexts for listing host, group host, group event, and **Tour Shongi Support**.
- **Groups & Hajj subsystem**: browse (`GroupsScreen`/`HajjScreen`), **event detail** (capacity bar, gender split, plan timeline, includes, **trip invigilator** card), **join sheet** (live seat updates), **group/agency public profile**, **host flow** (register → dashboard → create event → manage members).
- **Account**: profile header, **redesigned wallet** (balance + eye toggle, points→Platinum bar, quick actions, rewards strip, transactions), payment methods, menu; **Saved** screen.
- **Account sub-pages** (`ProfileDetailScreen` router): bookings, wallet, offers, host, post-reel, personal details, privacy & security (incl. **change-password sheet** w/ strength meter), notifications, help (live chat → support), settings.
- **Booking action sheets**: Receipt (itemised + VAT), Review (rate + post), Directions (transport modes), Manage (message host / reschedule / cancel).

**Quality gates**
- Per-screen overflow tests in `test/screens_test.dart` + an auth→shell smoke test in `widget_test.dart`.

---

## What is partially completed 🟡

- **Interactivity depth**: many secondary buttons are **cosmetic stubs** — they show a "coming soon"
  snackbar/toast or simply do nothing (e.g. share, some host-dashboard actions, "post reel" submit,
  social-login buttons, store/redeem buttons). The *primary* flows (browse → detail → book → cart →
  checkout → confirm; join a group; chat) are wired end-to-end against local state.
- **Persistence**: state changes (favourites, cart, joins, registered host events) work **within a
  session** but are **not saved** — relaunch/hot-restart resets them.
- **Search**: search bars are present and styled but **don't filter** results (decorative).
- **Calendar**: fully functional range picking, but selected dates are stored as display strings on the
  `TripItem`; they don't drive availability/pricing logic (prices are static per tier).

---

## What is not started ❌

- **Any backend** — no server, API, or cloud.
- **Real authentication** — login is a boolean gate; no accounts, tokens, sessions, password reset.
- **Database / persistence** — no local DB (Hive/Isar/sqflite) and no remote DB.
- **Payments** — bKash/Nagad/card are UI only; no SDK or gateway.
- **Real maps** — the map is a hand-drawn vector illustration, not Google/Mapbox.
- **Real chat** — chat is canned local messages; no websocket/messaging backend.
- **Media/Reels backend** — reels are static Unsplash stills with play chrome, not real video.
- **Push notifications, analytics, crash reporting.**
- **Localization framework** — Bangla strings are hard-coded inline (no `intl`/`.arb`); no language switch.
- **Android build** — Android SDK not installed; no signed APK/AAB; app icons/splash not customised.
- **iOS build** — Xcode/CocoaPods incomplete.
- **Store assets** — no Play/App-Store listing, screenshots, privacy policy, etc.
- **Accessibility pass** — no semantics/contrast/large-text audit.

---

## Working features (try these)

1. Launch → Login → **Continue as guest**.
2. Home → tap **Eco-parks** / **Hidden Gems** → Collection pages.
3. Home → tap a **destination card** → Destination page with tabs.
4. Open a hotel → pick a **tier** → **+** a room → **calendar** + Rooms/Travellers → add → **Trip** tab → **Review & checkout → Confirm** (QR voucher).
5. **Reels** tab → scroll; visited places show the green **Visited** / "Book again".
6. **Travel with a Group** → open an event → **Join trip** (seat bar updates) → **Chat with host**.
7. Account → **Wallet** (eye toggle), **My bookings** (Receipt/Review/Directions/Manage), **Help → Live chat** (support), **Privacy → Change password**.

---

## Known issues

1. **Android SDK missing** — `flutter doctor` reports "Unable to locate Android SDK". Can't build APK until the SDK + licenses are installed.
2. **Offline degradation** — without internet, Unsplash images fall back to coloured `Photo` placeholders and Google Fonts fall back to the platform font (layout still fine).
3. **No persistence** — see above; expected for a prototype.
4. **Icons are approximations** — mapped to nearest Material icons; a few may not perfectly match the prototype's bespoke SVGs.
5. **macOS TCC** — the shell cannot read `~/Downloads`; new prototype files must be moved to `~/Desktop`.
6. **Flutter not on PATH** — must `export PATH="$HOME/flutter/bin:$PATH"` each shell.

---

## Temporary solutions / workarounds in place

- **Mock auth**: `AuthGate` boolean instead of a real auth provider.
- **Static seed data** in `lib/data/` stands in for API responses; the file shapes intentionally mirror a future REST schema (see PROJECT_MEMORY §6).
- **In-memory `ChangeNotifier`** instead of a persisted store.
- **Stub actions** emit a `comingSoon`/toast snackbar rather than failing silently.
- **`Photo` placeholder** (hue-striped) guarantees layout even when images fail.
- **Overflow tests** at a fixed 390×844 logical phone size substitute for a device-farm/manual QA pass.
- **`Tweaks` panel omitted**: only the default design variant is built (documented decision, not a bug).
