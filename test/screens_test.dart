// Pumps every Phase-2 screen at a phone size to catch layout overflows.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:tour_shongi_app/core/theme.dart';
import 'package:tour_shongi_app/app_state.dart';
import 'package:tour_shongi_app/nav.dart';
import 'package:tour_shongi_app/data/content.dart';
import 'package:tour_shongi_app/data/groups.dart';
import 'package:tour_shongi_app/screens/groups/groups_screen.dart';
import 'package:tour_shongi_app/screens/groups/group_detail.dart';
import 'package:tour_shongi_app/screens/groups/group_profile.dart';
import 'package:tour_shongi_app/screens/groups/host_flow.dart';
import 'package:tour_shongi_app/screens/chat_screen.dart';
import 'package:tour_shongi_app/screens/destination_screen.dart';
import 'package:tour_shongi_app/screens/booking_sheet.dart';
import 'package:tour_shongi_app/screens/account/profile_detail.dart';
import 'package:tour_shongi_app/data/models.dart';

Widget _wrap(Widget child) => AppScope(
      controller: AppController(),
      child: MaterialApp(theme: buildTheme(), home: child),
    );

void main() {
  setUpAll(() {
    hotelsAndActivities = [...hotels, ...activities, ...extraHotels, ...extraActivities];
  });

  Future<void> phone(WidgetTester tester, Widget child) async {
    tester.view.physicalSize = const Size(1170, 2532);
    tester.view.devicePixelRatio = 3.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(_wrap(child));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 700));
  }

  testWidgets('Groups + Hajj browse', (t) async {
    await phone(t, const GroupsScreen());
    expect(find.text('Travel with a Group'), findsWidgets);
    await phone(t, const HajjScreen());
    expect(find.text('Hajj & Umrah'), findsWidgets);
  });

  testWidgets('Group event detail + Hajj event detail', (t) async {
    await phone(t, GroupEventDetailScreen(event: groupEvents.first));
    await phone(t, GroupEventDetailScreen(event: hajjEvents.first));
  });

  testWidgets('Group profile (travel + hajj)', (t) async {
    await phone(t, TravelGroupProfileScreen(group: travelGroups.first));
    await phone(t, TravelGroupProfileScreen(group: hajjGroups.first));
  });

  testWidgets('Chat screen', (t) async {
    await phone(t, ChatScreen(ctx: ChatCtx.event(groupEvents.first)));
    await phone(t, const ChatScreen(ctx: ChatCtx.support()));
  });

  testWidgets('Destination + Collection screens', (t) async {
    await phone(t, DestinationScreen(dest: destinations.first));
    await phone(t, const CollectionScreen(kind: 'ecopark'));
    await phone(t, const CollectionScreen(kind: 'hidden'));
  });

  Future<void> openSheet(WidgetTester t, Widget sheet) async {
    await phone(
      t,
      Scaffold(
        body: Builder(
          builder: (ctx) => Center(
            child: ElevatedButton(
              onPressed: () => showModalBottomSheet(context: ctx, isScrollControlled: true, builder: (_) => sheet),
              child: const Text('open'),
            ),
          ),
        ),
      ),
    );
    await t.tap(find.text('open'));
    await t.pump();
    await t.pump(const Duration(milliseconds: 400));
  }

  testWidgets('Booking sheet (stay + activity) with calendar', (t) async {
    final stay = hotelOptions['sayeman']!.stays.first;
    await openSheet(t, BookingSheet(opt: stay, optKind: 'Stay', listing: hotels.first));
    final act = HotelOption(activities.first.id, activities.first.name, activities.first.blurb, activities.first.img, activities.first.base);
    await openSheet(t, BookingSheet(opt: act, optKind: 'Activity', listing: activities.first));
  });

  testWidgets('Host flow (register step)', (t) async {
    await phone(t, const GroupHostFlow());
  });

  for (final route in ['bookings', 'wallet', 'offers', 'host', 'postreel', 'details', 'privacy', 'notif', 'help', 'settings']) {
    testWidgets('Account route: $route', (t) async {
      await phone(t, ProfileDetailScreen(route: route, onLogout: () {}, onOpen: (_) {}));
    });
  }
}
