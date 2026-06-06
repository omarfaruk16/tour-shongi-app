# PROJECT_MEMORY.md — Tour Shongi (Flutter app)

> Long-lived reference for the project. Read this first. It assumes **zero prior knowledge**.

---

## 1. Project vision

**Tour Shongi** ("ভ্রমণ সঙ্গী" = "travel companion") is a **Bangladesh travel super-app**.
It lets travellers discover and book **stays (hotels/resorts)** and **activities/experiences**
across Bangladesh, each offered in **three facility tiers — Budget, Premium, Luxury** —
plus a full **Travel-with-a-Group** subsystem (hosted group tours and **Hajj/Umrah** packages),
a **Reels** (short-video) feed, an in-app **wallet & rewards**, **host/agency** tools, and **chat**.

The look is a **warm, editorial, green-branded** mobile UI (emerald + saffron accents, Bangla
sub-labels throughout).

### Origin / source of truth
This Flutter app is a **faithful port of an interactive HTML/React prototype** produced in Claude
Design ("Claude AI Design"). The prototype was delivered as **offline HTML bundles** whose React/JSX
source modules are embedded (base64) inside the HTML. The Flutter code recreates those screens
pixel-for-intent. There were two mobile-app prototype deliveries folded into this app:
1. `Tour Shongi (offline).html` — the original **mobile app** prototype (this repo).
2. `Tour Shongi App (offline).html` — an **updated** mobile app prototype (changes folded in).

**The prototype JSX is the spec.** When new prototype HTML arrives, decode its embedded source and
match the Flutter UI to it (see §"How to read a prototype HTML" below).

---

## 2. Business goals

- Single app to **discover + book** every kind of Bangladesh trip (stays, activities, group tours, Hajj/Umrah).
- **Three-tier pricing** on everything (Budget / Premium / Luxury) as the core differentiator.
- **Trust & safety**: verified hosts, a neutral **Tour Shongi "trip invigilator"** that travels with each group, in-app chat & payments.
- **Social discovery** via Reels that deep-link to bookable listings.
- **Two-sided**: travellers book; **hosts/agencies** register, publish tours, and manage members.
- Local payment rails (**bKash, Nagad, card**) and a points/wallet loyalty loop.

> ⚠️ These are the *product* goals expressed by the prototype UI. **None of the backend, payments,
> auth, or persistence is real yet** — this repository is **frontend-only** (see CURRENT_STATE.md).

---

## 3. Current architecture

**Type:** Pure-frontend Flutter app. **No backend, no database, no network API of our own.**
All content is **hard-coded static Dart data**. The only network calls are:
- **Unsplash** images (`https://images.unsplash.com/photo-<id>?...`) loaded via `Image.network`.
- **Google Fonts** (downloaded at runtime by the `google_fonts` package; falls back offline).

**App shape:** a single-`MaterialApp` app. Global mutable state lives in **one `ChangeNotifier`**
(`AppController`) exposed through an **`InheritedNotifier` (`AppScope`)**. Navigation between
full-screen pages uses the standard Flutter **`Navigator` stack** (`MaterialPageRoute` /
`PageRouteBuilder`); sheets use **`showModalBottomSheet`**.

### Navigation model
- `AuthGate` (StatefulWidget, boolean `authed`) shows **AuthScreen** until "logged in", then **MainShell**.
- `MainShell` holds an **`IndexedStack`** of **4 tab screens** — `HomeScreen`, `ExploreScreen`,
  `ReelsScreen`, `AccountScreen` — plus a **floating `BottomNav`** with **5 buttons**:
  Home · Explore · **Reels (center)** · **Trip** · Account.
  - Home/Explore/Reels/Account switch the IndexedStack index.
  - **Trip** is **not** a stack tab — tapping it **pushes** `TripScreen` as a route (so it can hide the nav and show a close button). The Trip button shows a **badge** = number of items in the cart.
- Everything else (detail, booking sheet, map, category list, filter sheet, reel viewer, all of the
  groups/Hajj subsystem, chat, destination/collection pages, account sub-pages) is **pushed/shown on demand** via helpers in `lib/nav.dart`.

### Global state (`lib/app_state.dart`)
`AppController extends ChangeNotifier`:
- `Set<String> favs` — favourited listing ids (seeded with `{'mermaid','paraglide'}`).
- `List<TripItem> trip` — the cart; `tripName` (default "My Bangladesh Trip").
- `Map<String,int> groupJoins` — eventId → extra seats this user reserved.
- Methods: `toggleFav`, `addToTrip`, `removeFromTrip`, `setGuests`, `setTripName`, `clearTrip`,
  `confirmJoin`, `joinedCount`, `savedListings`, getter `tripTotal`.
- `priceBreakdown(items)` (top-level) → `Breakdown(subtotal, serviceFee 4%, tax 5%, discount, total)`;
  `discount = 1500` if subtotal > 20000.
- `AppScope.of(context)` returns the controller; screens wrap their body in `AnimatedBuilder(animation: c, …)` to rebuild on changes.
- `hotelsAndActivities` (top-level list) is injected in `main()` to avoid a data import cycle.

> **State is in-memory only.** Hot restart / app relaunch resets favs, cart, and joins.

---

## 4. Tech stack

| Layer | Choice |
|---|---|
| Language / SDK | **Dart 3.12.1**, **Flutter 3.44.1 (stable)** |
| UI | Flutter Material 3 (`useMaterial3: true`), but components are **custom-built** to match the prototype (we rarely use stock Material widgets directly) |
| Fonts | `google_fonts` ^6.2.1 — Plus Jakarta Sans (display), Inter (body), Hind Siliguri (Bangla) |
| Icons | Built-in **Material Icons**, mapped from the prototype's named SVG icon set (see `lib/core/icons.dart`); also `cupertino_icons` ^1.0.8 (transitive) |
| Images | `Image.network` to Unsplash (no caching package) |
| State mgmt | Plain `ChangeNotifier` + `InheritedNotifier` (no Provider/Riverpod/Bloc) |
| Lints | `flutter_lints` ^6.0.0 (analyze is **clean**) |
| Tests | `flutter_test` — 2 files, **18 widget tests** (smoke + per-screen overflow checks) |

**No** Firebase, no REST/GraphQL client, no local DB, no codegen, no routing package, no DI framework.

### Toolchain notes (important for the next session)
- The Flutter SDK is installed at **`~/flutter/bin`** but is **NOT on the shell PATH**. Prefix commands:
  `export PATH="$HOME/flutter/bin:$PATH"` (then `flutter analyze`, `flutter test`, `flutter run`, etc.).
- **macOS / Chrome / web** targets work. **Android SDK is NOT installed** (`flutter doctor` shows
  "Unable to locate Android SDK"; no `~/Library/Android/sdk`). To ship an APK the next session must
  install SDK components via Android Studio's SDK Manager and run `flutter doctor --android-licenses`.
- **Xcode is incomplete** (no CocoaPods) — iOS device builds not set up; macOS/web are the easy targets.
- Run on web: `~/flutter/bin/flutter run -d chrome` (used port 8088 last time).

### ⚠️ macOS file-access gotcha (will bite you)
The shell/Bash tool **cannot read `~/Downloads`** (macOS TCC privacy block) — `ls/cp/unzip` there
return "Operation not permitted". **`~/Desktop` and the home dir work fine.** When the user drops a
new prototype HTML in Downloads, **ask them to move it to `~/Desktop`** first.

---

## 5. Folder structure

Project root: **`~/Desktop/tour_shongi_app/`** (a normal `flutter create` project).

```
tour_shongi_app/
  pubspec.yaml            deps: google_fonts, cupertino_icons; dev: flutter_test, flutter_lints
  README.md               human-readable overview + run instructions
  docs/                   ← THIS handover package
  build/web/              last release web build artifact
  android/ ios/ web/ macos/  platform scaffolding (android SDK not installed)
  test/
    widget_test.dart      auth→shell smoke test
    screens_test.dart     pumps every screen at phone size to catch overflows (18 cases total)
  lib/
    main.dart             entry, AuthGate, MainShell, BottomNav
    app_state.dart        AppController, AppScope, TripItem, Breakdown, priceBreakdown
    nav.dart              navigation helpers + ChatCtx + PushHeader + toasts
    core/
      theme.dart          C (colors), R (radii), S (shadows), G (gradients), T (text styles),
                          buildTheme(), taka(), thou(), unsplash(), hsl()
      icons.dart          name→IconData map + `Ic` widget (kIconMap), amenity icon map
    data/
      models.dart         Base, Tier, Listing, Step→"DayStep", Gear, Destination, Offer,
                          Experience, Review, Reel, HotelOption, Addon, PriceDay, AppUser,
                          AccountItem, AccountGroup, PaymentMethod, buildPriceTable()
      content.dart        hotels, activities, extraHotels, extraActivities, catalogHotels/Activities,
                          listingById(), destinations, offers, experiences, visited, collections,
                          destAlias, atDest(), reviews, ratingBars, amenityLabels, reels, reelsFor(),
                          hotelOptions, optionsFor(), addons, user, accountGroups, paymentMethods,
                          categories, Collection class
      groups.dart         travelGroups, groupEvents, hajjGroups, hajjEvents, suitableMeta, planMeta,
                          invigilators, chatThreads + models (TravelGroup, GroupEvent, PlanSeg,
                          GHost, PastTrip, Invigilator, ChatMsg, ChatThread) + helpers
                          (groupById, eventsByGroup, invigilatorFor, chatFor)
    widgets/
      photo.dart          Photo  (hue-striped placeholder + network image + optional scrim)
      ui.dart             Stars, TierPill, Ribbon, FavHeart, TSChip, TSButton (BtnVariant),
                          SectionHeader, QtyStepper, IconBtn
      cards.dart          ListingCard, CompactCard, DestinationCard, ExperienceTile
      chrome.dart         LocationHeader, TSSearchBar, ChipRow
      booking_bits.dart   RollingNumber, TierSelector (segmented/compact), PriceTable (15-day strip)
      trip_bits.dart      TripSteps, BreakdownRows, TripItemCard, tierShort()
      group_bits.dart     SlotBar, GenderSplit, HostChip, ChatBtn, SuitChips,
                          GroupEventCardTall, GroupEventCardWide
      calendar.dart       DateRangeField, PersonsRow, RangeCalendar, MonthGrid + date helpers
                          (startOfDay, addDays, nightsBetween, fmtShort)
      anim.dart           Pressable (tap-scale), StaggerIn (entrance), GrowBar (animated bar)
    screens/
      auth_screen.dart        Login + Register (toggle), "continue as guest"
      home_screen.dart        Home: header, offers carousel, USP band, experience grid (4-col),
                              Hotels/Recommended/Activities rails, Groups home section,
                              destinations rail, "All results" feed with sort/offers/rating
      explore_screen.dart     Explore: search, find-via-map card, category chips, destinations, list
      category_screen.dart    "Hotels & Resorts" / "Activities" full list w/ category + filters
      detail_screen.dart      Hotel & Activity detail (parallax hero, tier chooser, options,
                              price-trend, amenities/itinerary+gear, reels strip, gallery, reviews,
                              map snippet, sticky book bar) + _OptionsSection + _OptionRow
      booking_sheet.dart      BookingSheet: tier selector, DateRangeField, PersonsRow, add-ons → cart
      trip_screen.dart        Trip cart (items, suggestions, breakdown, sticky checkout bar)
      checkout_screen.dart    CheckoutScreen + ConfirmationScreen (e-voucher + QR painter)
      reels_screen.dart       ReelsScreen (vertical pager) + ReelCard + ReelViewer; "Visited" badge
      account_screen.dart     AccountScreen (profile, wallet, payments, menu) + SavedScreen
      map_screen.dart         MapScreen: pan/zoom CustomPaint vector map + price pins + peek cards
      filter_sheet.dart       FilterSheet (where/dates/tier/category/guests/rooms)
      chat_screen.dart        ChatScreen (animated bubbles, typing dots, quick replies) + support
      destination_screen.dart DestinationScreen + CollectionScreen (Eco-parks / Hidden Gems)
      groups/
        groups_screen.dart    GroupsScreen + HajjScreen (browse)
        group_detail.dart     GroupEventDetailScreen + GroupJoinSheet (+ invigilator/capacity/plan)
        group_profile.dart    TravelGroupProfileScreen (host/agency public profile)
        host_flow.dart        GroupHostFlow (register → dashboard → create event → manage members)
      account/
        profile_detail.dart   ProfileDetailScreen router + all account sub-pages
                              (bookings, wallet, offers, host, postreel, details, privacy, notif,
                               help, settings) + booking action sheets (receipt/review/directions/
                               manage) + change-password sheet
```

---

## 6. Database design

**There is no database.** All data is **compile-time constants** in `lib/data/`. Treat these as the
"schema" the eventual backend should mirror:

### Core entities (see `lib/data/models.dart`)
- **Listing** — a hotel or activity. Fields: `id, kind ('hotel'|'activity'), name, bn, location, cat,
  rating, reviews, base (Base{budget,premium,luxury}), discount, ph, hue, img, blurb, amenities[],
  gallery, duration?, intensity?, steps[] (DayStep), gear[] (Gear)`.
- **Base** — per-tier prices `{budget, premium, luxury}` with `byKey(tier)`.
- **HotelOption** — a bookable room/experience inside a hotel: `id, name, desc, img, price (Base),
  discount, duration?`. Stored in `hotelOptions[hotelId] = (stays:[…], acts:[…])`.
- **Destination** — `id, name, bn, tag, resorts, activities, ph, hue, img`.
- **Collection** — curated set (Eco-parks / Hidden Gems): `title, bn, tag, img, blurb, hotels[ids], acts[ids]`.
- **Offer**, **Experience** (home tiles), **Review**, **RatingBar**, **Reel**, **Addon**, **AppUser**,
  **AccountItem/AccountGroup** (account menu), **PaymentMethod**, **PriceDay** (15-day trend).
- **TripItem** (cart line; in `app_state.dart`): `uid, listingId, listingName, kind, location, img,
  optionId, optionName, optKind ('Stay'|'Activity'), tier, isStay, unit, addonTotal, nights, guests,
  total, dateFrom?, dateTo?, addons[]`.

### Groups subsystem (see `lib/data/groups.dart`)
- **TravelGroup** (host or hajj agency): `id, kind ('group'|'hajj'), name, bn, handle, verified, badge,
  hue, img, rating, reviewCount, founded, tagline, bio, stats[], host (GHost), reviews[], past[] (PastTrip)`.
- **GroupEvent** (a hosted tour / hajj package): `id, groupId, title, bn, location, hue, img, dates,
  days, nights, departs, price (Base), discount, capacity, booked, male, female, manual, tourType,
  rating, reviews, suitableFor[], blurb, plan[] (PlanSeg: type journey|stay|activity, title, sub,
  time, meta), includes[]`.
- **Invigilator** (Tour Shongi staff monitor), **ChatThread / ChatMsg** (canned chat history).

### "Seed data" volume (so the backend team knows the shape)
4 base hotels + 9 extra; 3 base activities + 8 extra; 5 destinations; 8 reels; 3 travel groups;
6 group events; 2 hajj agencies; 4 hajj packages; per-hotel room/activity options; offers, coupons,
add-ons, payment methods, account menu, etc.

---

## 7. API structure

**None.** No API client, no endpoints, no serialization. When a backend is added, the natural REST shape
(mirroring the data above) would be roughly:
- `GET /listings?type=&cat=&dest=&tier=` ; `GET /listings/{id}` ; `GET /listings/{id}/options`
- `GET /destinations` ; `GET /collections/{kind}` ; `GET /offers` ; `GET /reels`
- `GET /groups`, `/groups/{id}`, `/group-events`, `/group-events/{id}` ; `POST /group-events/{id}/join`
- `GET /hajj-packages`
- Trip cart + `POST /bookings` (checkout) ; `GET /me/bookings` ; `GET /me/wallet`
- `POST /auth/login|register` ; chat (websocket).
This section is **aspirational** — nothing is wired.

---

## 8. Authentication flow

**Fake / placeholder.** `AuthGate` holds a boolean `authed`.
- `AuthScreen` shows **Login** (email/password are pre-filled display-only text; "Log in",
  "Continue with Gmail/Phone", "Forgot password", **Continue as guest**) and **Register**
  (Traveller / Tour-Group toggle, name/phone/NID/password fields, terms checkbox).
- **Any** of those actions calls `onEnter()` → sets `authed = true` → shows `MainShell`. No validation,
  no token, no real account. The pre-filled login is `arefin.r@gmail.com` / `travel123` (cosmetic).
- **Logout** (Account → Log out, or Settings → Log out) flips `authed` back to false → returns to Login.
- The mock signed-in user is `user` in `content.dart` (Arefin Rahman, Gold member, 2480 pts).

---

## 9. Theme colors (warm-editorial palette) — `lib/core/theme.dart` class `C`

| Token | Hex | Use |
|---|---|---|
| emerald | `#0C8A66` | primary brand |
| emeraldDark | `#07664A` | gradients, dark text-on-tint |
| emeraldDeep | `#053B2C` | deepest green |
| emeraldTint | `#DEF4EA` | chips, soft fills |
| mint | `#6FD3A6` | accents, online dot |
| saffron | `#E8A33D` | secondary accent (stars, ribbons) |
| saffronDark | `#C9821E` | gold gradient end |
| ink | `#14201D` | primary text |
| slate | `#5B6B66` | secondary text |
| mist | `#9AA8A3` | tertiary text/icons |
| cloud | `#F4F7F6` | app background |
| surface | `#FFFFFF` | cards/sheets |
| hairline | `#E7ECEA` | borders/dividers |
| success | `#2E9E6B` · error `#E0524B` · info `#3B82C4` | status |
| tierBudget `#3B82C4` · tierPremium `#0C8A66` · tierLuxA `#E8A33D` · tierLuxB `#C9821E` | tier accents |

- **Radii** (`R`): card 24, image 20, button 16, input 14.
- **Shadows** (`S`): `card`, `sheet`, `float`, `greenBtn`.
- **Gradients** (`G`): `emerald` (140°), `gold`, `greenGlass`, `deep` (radial).
- **Type** (`T`): `T.d(...)` = Plus Jakarta Sans (display/headings), `T.b(...)` = Inter (body),
  `T.bn(...)` = Hind Siliguri (Bangla). Helpers: `taka(n)` → "৳1,240", `thou(n)`, `unsplash(id,w)`,
  `hsl(h,s,l)`.

---

## 10. Important design decisions

1. **No phone-frame chrome.** The web prototype renders inside a 390×844 device mock; the Flutter app
   is the real device, so the status-bar / dynamic-island / home-indicator chrome was dropped.
2. **One default "mood".** The prototype has a Tweaks panel with variants (home layout, tier style,
   hero style, warm/bold mood, etc.). We built only the **defaults**: `homeLayout=standard`,
   `tierStyle=segmented`, `heroStyle=fullbleed`, `mood=warm`, `groupsOnHome=true`. The Tweaks panel
   itself (`tweaks-panel.jsx`) is **intentionally not ported** (it's a design-time tool).
3. **Custom widgets over stock Material.** To match the prototype exactly, almost everything is
   hand-built (`TSButton`, `TSChip`, `QtyStepper`, `Photo`, cards…). Material is used for scaffolding,
   `showModalBottomSheet`, `Navigator`, `LinearProgressIndicator`, `TextField`.
4. **Name clashes renamed** to avoid Material collisions: our `Stepper`→**`QtyStepper`**,
   `SearchBar`→**`TSSearchBar`**, data model `Step`→**`DayStep`**. Keep this in mind when adding widgets.
5. **Icons are approximations.** The prototype ships a bespoke SVG icon set; we map each name to the
   nearest Material icon in `lib/core/icons.dart` (`kIconMap`) and render via the `Ic('name', …)` widget.
6. **Animations** are first-class: `Pressable` (tap-scale on buttons/cards), `StaggerIn` (list entrance),
   `GrowBar` (seat/▮ bars), parallax detail heroes, `RollingNumber`, sliding `TierSelector`, typing dots,
   animated toggles & accordions.
7. **Overflow discipline.** Tests pump every screen at a real phone size (390×844) to catch
   `RenderFlex overflowed`. Several real overflows were fixed this way; keep adding screens to
   `test/screens_test.dart`.
8. **`google_fonts` + Unsplash** chosen for fidelity; both degrade gracefully offline (platform font +
   striped `Photo` placeholder). No assets are bundled.

---

## 11. Environment variables

**None.** No `.env`, no `--dart-define`, no secrets, no config files. Nothing to set up to run —
`flutter pub get` then run. (If a backend is added later, introduce `--dart-define` for the API base URL.)

---

## 12. Third-party services

- **Unsplash** (images, unauthenticated hot-link URLs) — runtime image source.
- **Google Fonts** (via `google_fonts` package) — runtime font download.
- **Twemoji codepoints** were used in the prototype for experience-tile emoji; in Flutter we just use
  native emoji glyphs in `Text`.
- That's it. No analytics, crash reporting, payments, maps SDK, auth provider, or push.

---

## 13. Coding conventions

- **Theme tokens only** — never hard-code colours/sizes; use `C.*`, `R.*`, `S.*`, `G.*`, and `T.d/T.b/T.bn`.
- **Money** via `taka()`, big numbers via `thou()`, images via `unsplash(id, width)`.
- **Icons** via `Ic('name', size:, color:)` (string names from `kIconMap`), or `Icons.*` directly for
  one-offs. If a needed icon name is missing, add it to `kIconMap`.
- **Screens** read global state with `AppScope.of(context)` and wrap their tree in
  `AnimatedBuilder(animation: controller, …)` so favourites / cart / joins update live.
- **Navigation**: don't call `Navigator` ad-hoc from screens — use the helpers in `lib/nav.dart`
  (`openDetail`, `openBooking`, `openMap`, `openCategory`, `openFilter`, `openTrip`, `openReelViewer`,
  `openGroups`, `openHajj`, `openGroupEvent`, `openGroupProfile`, `openHostFlow`, `openChat`,
  `openDest`, `openCollection`, `openProfileRoute`, `openJoinSheet`, plus `showTripToast` / `comingSoon`).
- **Sheets** = `showModalBottomSheet(isScrollControlled: true, backgroundColor: transparent)`; the sheet
  widget caps its own height (`maxHeight: screen*0.86–0.9`) with a drag handle.
- **New full screens** must be added to `test/screens_test.dart` (pump at phone size; assert no overflow).
- **Avoid Material name collisions** (see decision #4); prefix custom widgets `TS…`/`Qty…` when a stock
  Material widget shares the name.
- **Lints must stay clean**: run `flutter analyze` (target: "No issues found") and `dart fix --apply`
  before finishing. Prefer `withValues(alpha:)` over deprecated `withOpacity`.
- **Records & typedefs** are used heavily for small inline data (e.g. `(ic: 'x', l: 'Label')`).
- **`const`** wherever possible (lints enforce `prefer_const_*`).

---

## How to read a prototype HTML (for future updates)

The offline-export HTML embeds the React/JSX source. To recover it:
1. Ask the user to move the file from `~/Downloads` to **`~/Desktop`** (Bash can't read Downloads).
2. The HTML contains three special script blocks:
   - `<script type="__bundler/template">` — a **JSON-encoded string** of the real HTML; inside it the
     module load order appears as `<script type="text/babel" src="<UUID>">` references.
   - `<script type="__bundler/manifest">` — a **big JSON** mapping each `UUID → {mime, compressed, data}`.
     For JS modules, `data` is **base64** of the source (`compressed` flag = gzip/deflate if true).
   - `<script type="__bundler/ext_resources">` — small list (e.g. the logo).
3. Parse with Python: load the template JSON → get ordered babel UUIDs → for each, base64-decode (and
   inflate if compressed) the manifest entry → write `*.jsx`. (A working script was used this session;
   the modules map to files like `home.jsx`, `detail.jsx`, `groups.jsx`, etc., with a `// filename`
   header comment on line 1.)
4. **Diff** the new modules against the previous prototype to find exactly what changed, then port only
   the deltas. Ignore `tweaks-panel.jsx` (design tool).
