import 'package:flutter/material.dart';
import 'core/theme.dart';
import 'core/icons.dart';
import 'data/models.dart';
import 'data/groups.dart';
import 'screens/detail_screen.dart';
import 'screens/booking_sheet.dart';
import 'screens/map_screen.dart';
import 'screens/category_screen.dart';
import 'screens/filter_sheet.dart';
import 'screens/reels_screen.dart';
import 'screens/trip_screen.dart';
import 'screens/chat_screen.dart';
import 'screens/destination_screen.dart';
import 'screens/groups/groups_screen.dart';
import 'screens/groups/group_detail.dart';
import 'screens/groups/group_profile.dart';
import 'screens/groups/host_flow.dart';
import 'screens/account/profile_detail.dart';

/// A chat target: Tour Shongi support, a group event, a host group, or a listing.
class ChatCtx {
  final GroupEvent? event;
  final TravelGroup? group;
  final Listing? listing;
  final bool support;
  const ChatCtx.event(this.event) : group = null, listing = null, support = false;
  const ChatCtx.group(this.group) : event = null, listing = null, support = false;
  const ChatCtx.listing(this.listing) : event = null, group = null, support = false;
  const ChatCtx.support() : event = null, group = null, listing = null, support = true;
}

/// Open a listing's detail page.
void openDetail(BuildContext context, Listing item) {
  Navigator.of(context).push(MaterialPageRoute(builder: (_) => DetailScreen(item: item)));
}

void openGroups(BuildContext context) {
  Navigator.of(context).push(MaterialPageRoute(builder: (_) => const GroupsScreen()));
}

void openHajj(BuildContext context) {
  Navigator.of(context).push(MaterialPageRoute(builder: (_) => const HajjScreen()));
}

void openDest(BuildContext context, Destination d) {
  Navigator.of(context).push(MaterialPageRoute(builder: (_) => DestinationScreen(dest: d)));
}

void openCollection(BuildContext context, String kind) {
  Navigator.of(context).push(MaterialPageRoute(builder: (_) => CollectionScreen(kind: kind)));
}

void openGroupEvent(BuildContext context, GroupEvent ev) {
  Navigator.of(context).push(MaterialPageRoute(builder: (_) => GroupEventDetailScreen(event: ev)));
}

void openGroupProfile(BuildContext context, TravelGroup group) {
  Navigator.of(context).push(MaterialPageRoute(builder: (_) => TravelGroupProfileScreen(group: group)));
}

void openHostFlow(BuildContext context) {
  Navigator.of(context).push(MaterialPageRoute(builder: (_) => const GroupHostFlow()));
}

void openChat(BuildContext context, ChatCtx ctx) {
  Navigator.of(context).push(PageRouteBuilder(
    transitionDuration: const Duration(milliseconds: 280),
    pageBuilder: (_, _, _) => ChatScreen(ctx: ctx),
    transitionsBuilder: (_, anim, _, child) => SlideTransition(
      position: Tween(begin: const Offset(0.18, 0), end: Offset.zero)
          .animate(CurvedAnimation(parent: anim, curve: Curves.easeOutCubic)),
      child: FadeTransition(opacity: anim, child: child),
    ),
  ));
}

void openProfileRoute(BuildContext context, String route, {VoidCallback? onLogout, void Function(Listing)? onOpen}) {
  Navigator.of(context).push(MaterialPageRoute(
      builder: (_) => ProfileDetailScreen(route: route, onLogout: onLogout, onOpen: onOpen)));
}

void openJoinSheet(BuildContext context, GroupEvent ev) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    barrierColor: const Color(0x6B14201D),
    builder: (_) => GroupJoinSheet(ev: ev),
  );
}

/// Open the booking bottom-sheet for an option of a listing.
void openBooking(BuildContext context, HotelOption opt, String optKind, Listing listing, {String initialTier = 'premium'}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    barrierColor: const Color(0x7314201D),
    builder: (_) => BookingSheet(opt: opt, optKind: optKind, listing: listing, initialTier: initialTier),
  );
}

void openFilter(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    barrierColor: const Color(0x6614201D),
    builder: (_) => const FilterSheet(),
  );
}

void openMap(BuildContext context) {
  Navigator.of(context).push(MaterialPageRoute(builder: (_) => const MapScreen()));
}

void openCategory(BuildContext context, String type) {
  Navigator.of(context).push(MaterialPageRoute(builder: (_) => CategoryScreen(type: type)));
}

void openTrip(BuildContext context) {
  Navigator.of(context).push(MaterialPageRoute(builder: (_) => const TripScreen()));
}

void openReelViewer(BuildContext context, Reel reel) {
  Navigator.of(context).push(PageRouteBuilder(
    opaque: false,
    transitionDuration: const Duration(milliseconds: 220),
    pageBuilder: (_, _, _) => ReelViewer(reel: reel),
    transitionsBuilder: (_, anim, _, child) => FadeTransition(opacity: anim, child: child),
  ));
}

/// "Added … to your trip" floating toast.
void showTripToast(BuildContext context, String message) {
  final messenger = ScaffoldMessenger.of(context);
  messenger.clearSnackBars();
  messenger.showSnackBar(SnackBar(
    behavior: SnackBarBehavior.floating,
    backgroundColor: C.ink,
    elevation: 8,
    margin: const EdgeInsets.fromLTRB(20, 0, 20, 96),
    duration: const Duration(milliseconds: 2400),
    content: Row(
      children: [
        Container(
          width: 28,
          height: 28,
          decoration: const BoxDecoration(color: C.success, shape: BoxShape.circle),
          child: const Icon(Icons.check_rounded, size: 18, color: Colors.white),
        ),
        const SizedBox(width: 11),
        Expanded(child: Text(message, style: T.b(13.5, w: FontWeight.w600, color: Colors.white))),
      ],
    ),
  ));
}

/// Generic "coming soon" toast (used for placeholder routes / groups in phase 2).
void comingSoon(BuildContext context, String what) {
  final messenger = ScaffoldMessenger.of(context);
  messenger.clearSnackBars();
  messenger.showSnackBar(SnackBar(
    behavior: SnackBarBehavior.floating,
    backgroundColor: C.ink,
    margin: const EdgeInsets.fromLTRB(20, 0, 20, 96),
    content: Text('$what — coming soon', style: T.b(13, w: FontWeight.w600, color: Colors.white)),
  ));
}

/// Header used at the top of pushed screens (back chevron + title).
class PushHeader extends StatelessWidget {
  final String title;
  final String? sub;
  final String closeIcon;
  final VoidCallback? onClose;
  const PushHeader(this.title, {super.key, this.sub, this.closeIcon = 'chevL', this.onClose});
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: onClose ?? () => Navigator.of(context).maybePop(),
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: C.surface,
              shape: BoxShape.circle,
              border: Border.all(color: C.hairline),
            ),
            child: Ic(closeIcon, size: 20, color: C.ink),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(title, style: T.d(22, w: FontWeight.w800, spacing: -0.4)),
              if (sub != null) Text(sub!, style: T.b(12, w: FontWeight.w500, color: C.mist)),
            ],
          ),
        ),
      ],
    );
  }
}
