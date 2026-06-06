# NEXT_SESSION_PROMPT.md

> Copy everything in the box below into a **brand-new Claude Code session** to continue work.
> It assumes the next session has **zero** prior knowledge of this project.

---

```
You are continuing development of "Tour Shongi" — a Bangladesh travel super-app built in Flutter.
This is a handover; you have NO prior memory of it. Before doing anything, read the handover docs.

## Step 0 — Read these first (in order)
1. ~/Desktop/tour_shongi_app/docs/PROJECT_MEMORY.md   (vision, architecture, tech stack, folder map, theme, conventions)
2. ~/Desktop/tour_shongi_app/docs/CURRENT_STATE.md    (what's done / partial / not started, known issues)
3. ~/Desktop/tour_shongi_app/docs/SESSION_SUMMARY.md  (what the last session changed)
4. ~/Desktop/tour_shongi_app/docs/TODO.md             (prioritized remaining work)
Then skim lib/main.dart, lib/app_state.dart, lib/nav.dart, lib/core/theme.dart, and lib/data/ to ground yourself.

## Project location & nature
- Project: ~/Desktop/tour_shongi_app  (the MOBILE APP — the only project; work here)
- It is a PURE-FRONTEND Flutter app: NO backend, NO database, NO real auth/payments. All content is
  static Dart data in lib/data/ (content.dart, groups.dart, models.dart). Images come from Unsplash via
  Image.network; fonts via the google_fonts package. State is an in-memory ChangeNotifier (AppController)
  exposed through an InheritedNotifier (AppScope) — it resets on relaunch.
- The app is a faithful Flutter port of a React/JSX prototype delivered as offline-export HTML. The
  prototype JSX is the design spec. The UI port is ~100% complete and verified.

## Critical environment facts (THIS MACHINE)
- Flutter SDK 3.44.1 / Dart 3.12.1 is at ~/flutter/bin but NOT on PATH. Prefix every command:
      export PATH="$HOME/flutter/bin:$PATH"
  e.g.  export PATH="$HOME/flutter/bin:$PATH"; cd ~/Desktop/tour_shongi_app && flutter analyze
- macOS TCC PRIVACY: the Bash/shell tool CANNOT read ~/Downloads ("Operation not permitted").
  ~/Desktop and the home dir work fine. If the user gives you a new file in Downloads, ask them to
  move it to ~/Desktop first.
- Android SDK is NOT installed (flutter doctor: "Unable to locate Android SDK"). web + macOS targets
  work today. Run on web:  export PATH="$HOME/flutter/bin:$PATH"; cd ~/Desktop/tour_shongi_app && flutter run -d chrome
- cd inside a compound Bash command can trip a permission prompt; prefer absolute paths.

## Health check before you start changing things
Run and confirm all green:
    export PATH="$HOME/flutter/bin:$PATH"; cd ~/Desktop/tour_shongi_app && flutter pub get && flutter analyze && flutter test
Expected: "No issues found!" and "All tests passed!" (18 tests). flutter build web --release also works.

## Conventions you MUST follow (details in docs/PROJECT_MEMORY.md §13)
- Use theme tokens only: colors C.*, radii R.*, shadows S.*, gradients G.*; text via T.d()/T.b()/T.bn().
- Money via taka(), images via unsplash(id,width), icons via the Ic('name', ...) widget (names in
  lib/core/icons.dart kIconMap — add a mapping if a name is missing).
- Navigate ONLY through helpers in lib/nav.dart (openDetail, openBooking(initialTier), openMap,
  openCategory, openFilter, openTrip, openReelViewer, openGroups, openHajj, openGroupEvent,
  openGroupProfile, openHostFlow, openChat(ChatCtx...), openDest, openCollection, openProfileRoute,
  openJoinSheet, plus showTripToast/comingSoon). Don't call Navigator ad-hoc from screens.
- Read global state via AppScope.of(context); wrap screen bodies in AnimatedBuilder(animation: controller).
- Sheets = showModalBottomSheet(isScrollControlled: true, backgroundColor: transparent); the sheet caps
  its own height (~0.86–0.9 * screen) with a drag handle.
- AVOID Material name collisions — custom widgets are prefixed (TSButton, TSChip, TSSearchBar,
  QtyStepper; the data model is DayStep not Step).
- Every NEW full screen must be added to test/screens_test.dart (pump at phone size 1170x2532 @ DPR 3 =
  390x844 logical; the test fails on RenderFlex overflow). Keep flutter analyze clean; run dart fix --apply.

## If the user hands you an updated prototype HTML (how to read it)
The offline HTML embeds the JSX source. To recover it:
- Move the .html to ~/Desktop (Downloads is blocked).
- It has <script type="__bundler/template"> (a JSON-encoded HTML string listing module load order via
  <script type="text/babel" src="UUID">) and <script type="__bundler/manifest"> (JSON mapping
  UUID -> {mime, compressed, data} where data is base64 of the source; inflate gzip/deflate if compressed).
- Write a small Python script to decode each module to a .jsx file, DIFF against the current build to
  find the deltas, and port only the changed/new screens to Flutter. Ignore tweaks-panel.jsx (a design tool).

## Your task this session
<<< THE USER WILL TELL YOU WHAT TO DO. >>>
If they don't specify, propose the next steps from docs/TODO.md, starting at Priority 0 (install Android
SDK) and Priority 1 (choose a backend, add real auth + persistence + a data/repository layer). Confirm
the direction with the user before large architectural changes, since introducing a backend/state-
management/persistence layer will reshape how screens get their data (today they import static lib/data/
files directly).

## Definition of done for any change
- flutter analyze => No issues found
- flutter test    => All tests passed (add/adjust tests for new screens/logic)
- flutter build web --release succeeds
- Update docs/CURRENT_STATE.md, docs/SESSION_SUMMARY.md, and docs/TODO.md to reflect your work.
```

---

## Quick reference card (for the human pasting this)

- **Run it:** `export PATH="$HOME/flutter/bin:$PATH"; cd ~/Desktop/tour_shongi_app && flutter run -d chrome`
- **Try the flows:** Login → *Continue as guest* → Home (tap Eco-parks / a destination) → open a hotel →
  pick a tier → **+** a room → calendar + travellers → add → **Trip** → checkout → confirm (QR).
  Reels tab (Visited badge), Travel-with-a-Group → Join, Account → Wallet / My bookings / Help live chat.
