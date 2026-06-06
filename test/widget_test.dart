// Smoke test: the auth screen builds, and entering the app shows the tabs.
import 'package:flutter_test/flutter_test.dart';

import 'package:tour_shongi_app/main.dart';
import 'package:tour_shongi_app/app_state.dart';
import 'package:tour_shongi_app/data/content.dart';

void main() {
  setUpAll(() {
    hotelsAndActivities = [...hotels, ...activities, ...extraHotels, ...extraActivities];
  });

  testWidgets('Auth → app shell renders', (WidgetTester tester) async {
    await tester.pumpWidget(const TourShongiApp());
    await tester.pump();

    // Login screen
    expect(find.text('Log in'), findsOneWidget);
    expect(find.textContaining('Tour Shongi'), findsWidgets);

    // Enter the app via "Continue as guest" (scroll it into view first).
    final guest = find.text('Continue as guest');
    await tester.ensureVisible(guest);
    await tester.pump();
    await tester.tap(guest, warnIfMissed: false);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    // Bottom-nav labels are present
    expect(find.text('Home'), findsWidgets);
    expect(find.text('Explore'), findsWidgets);
  });
}
