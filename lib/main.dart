import 'package:flutter/material.dart';
import 'core/theme.dart';
import 'core/icons.dart';
import 'app_state.dart';
import 'data/content.dart';
import 'screens/auth_screen.dart';
import 'screens/home_screen.dart';
import 'screens/explore_screen.dart';
import 'screens/reels_screen.dart';
import 'screens/account_screen.dart';
import 'screens/trip_screen.dart';

void main() {
  hotelsAndActivities = [...hotels, ...activities, ...extraHotels, ...extraActivities];
  runApp(const TourShongiApp());
}

class TourShongiApp extends StatefulWidget {
  const TourShongiApp({super.key});
  @override
  State<TourShongiApp> createState() => _TourShongiAppState();
}

class _TourShongiAppState extends State<TourShongiApp> {
  final controller = AppController();

  @override
  Widget build(BuildContext context) {
    return AppScope(
      controller: controller,
      child: MaterialApp(
        title: 'Tour Shongi',
        debugShowCheckedModeBanner: false,
        theme: buildTheme(),
        home: const AuthGate(),
      ),
    );
  }
}

/// Login/Register → app.
class AuthGate extends StatefulWidget {
  const AuthGate({super.key});
  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  bool authed = false;

  @override
  Widget build(BuildContext context) {
    if (!authed) {
      return AuthScreen(onEnter: () => setState(() => authed = true));
    }
    return MainShell(onLogout: () => setState(() => authed = false));
  }
}

/// Bottom-nav tab shell: Home · Explore · Reels · Trip · Account.
class MainShell extends StatefulWidget {
  final VoidCallback onLogout;
  const MainShell({super.key, required this.onLogout});
  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int tab = 0; // 0 home, 1 explore, 2 reels, 3 account

  void _onNav(String id) {
    switch (id) {
      case 'home':
        setState(() => tab = 0);
        break;
      case 'explore':
        setState(() => tab = 1);
        break;
      case 'reels':
        setState(() => tab = 2);
        break;
      case 'account':
        setState(() => tab = 3);
        break;
      case 'trip':
        Navigator.of(context).push(MaterialPageRoute(builder: (_) => const TripScreen()));
        break;
    }
  }

  String get _activeId => ['home', 'explore', 'reels', 'account'][tab];

  @override
  Widget build(BuildContext context) {
    final reels = tab == 2;
    return Scaffold(
      backgroundColor: reels ? Colors.black : C.cloud,
      body: Stack(
        children: [
          IndexedStack(
            index: tab,
            children: [
              HomeScreen(onTab: _onNav),
              const ExploreScreen(),
              const ReelsScreen(),
              AccountScreen(onLogout: widget.onLogout, onTab: _onNav),
            ],
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: BottomNav(active: _activeId, onNav: _onNav),
          ),
        ],
      ),
    );
  }
}

/// Floating bottom navigation bar (BottomNav).
class BottomNav extends StatelessWidget {
  final String active;
  final void Function(String) onNav;
  const BottomNav({super.key, required this.active, required this.onNav});

  @override
  Widget build(BuildContext context) {
    final c = AppScope.of(context);
    final items = [
      (id: 'home', icon: 'home', label: 'Home', center: false, badge: 0),
      (id: 'explore', icon: 'compass', label: 'Explore', center: false, badge: 0),
      (id: 'reels', icon: 'play', label: 'Reels', center: true, badge: 0),
      (id: 'trip', icon: 'bag', label: 'Trip', center: false, badge: c.trip.length),
      (id: 'account', icon: 'user', label: 'Account', center: false, badge: 0),
    ];
    return Container(
      padding: const EdgeInsets.only(top: 10, bottom: 22),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          colors: [C.surface, Color(0x00FFFFFF)],
          stops: [0.62, 1],
        ),
      ),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
        decoration: BoxDecoration(
          color: C.surface,
          borderRadius: BorderRadius.circular(26),
          border: Border.all(color: C.hairline),
          boxShadow: const [BoxShadow(color: Color(0x1A14201D), blurRadius: 30, offset: Offset(0, 10))],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            for (final it in items)
              Expanded(
                child: _NavItem(
                  icon: it.icon,
                  label: it.label,
                  on: active == it.id,
                  center: it.center,
                  badge: it.badge,
                  onTap: () => onNav(it.id),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final String icon, label;
  final bool on, center;
  final int badge;
  final VoidCallback onTap;
  const _NavItem({
    required this.icon,
    required this.label,
    required this.on,
    required this.center,
    required this.badge,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (center)
            Container(
              width: 46,
              height: 38,
              decoration: BoxDecoration(
                gradient: on ? G.emerald : null,
                color: on ? null : C.ink,
                borderRadius: BorderRadius.circular(14),
                boxShadow: on ? S.greenBtn : null,
              ),
              child: const Icon(Icons.play_arrow_rounded, size: 20, color: Colors.white),
            )
          else
            SizedBox(
              height: 28,
              child: Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.center,
                children: [
                  Ic(icon, size: 23, color: on ? C.emerald : C.mist),
                  if (badge > 0)
                    Positioned(
                      top: -6,
                      right: 4,
                      child: Container(
                        constraints: const BoxConstraints(minWidth: 16),
                        height: 16,
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        decoration: BoxDecoration(
                          color: C.saffron,
                          borderRadius: BorderRadius.circular(999),
                          border: Border.all(color: C.surface, width: 1.5),
                        ),
                        alignment: Alignment.center,
                        child: Text('$badge',
                            style: T.b(10, w: FontWeight.w700, color: Colors.white)),
                      ),
                    ),
                ],
              ),
            ),
          const SizedBox(height: 4),
          Text(label,
              style: T.b(10, w: on ? FontWeight.w700 : FontWeight.w500, color: on ? C.emerald : C.mist)),
        ],
      ),
    );
  }
}
