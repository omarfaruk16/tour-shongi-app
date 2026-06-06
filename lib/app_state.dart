import 'package:flutter/widgets.dart';
import 'data/models.dart';

/// One line item in the trip cart (built by the booking sheet).
class TripItem {
  final String uid, listingId, listingName, kind, location, img;
  final String optionId, optionName, optKind; // optKind: Stay | Activity
  final String tier;
  final bool isStay;
  final int unit, addonTotal, nights;
  int guests;
  int total;
  final String? dateFrom, dateTo;
  final List<({String id, String name, int price})> addons;
  TripItem({
    required this.uid,
    required this.listingId,
    required this.listingName,
    required this.kind,
    required this.location,
    required this.img,
    required this.optionId,
    required this.optionName,
    required this.optKind,
    required this.tier,
    required this.isStay,
    required this.unit,
    required this.addonTotal,
    required this.nights,
    required this.guests,
    required this.total,
    this.dateFrom,
    this.dateTo,
    required this.addons,
  });
}

class Breakdown {
  final int subtotal, serviceFee, tax, discount, total;
  const Breakdown(this.subtotal, this.serviceFee, this.tax, this.discount, this.total);
}

/// priceBreakdown(items) from trip.jsx.
Breakdown priceBreakdown(List<TripItem> items) {
  final subtotal = items.fold<int>(0, (s, it) => s + it.total);
  final serviceFee = items.isNotEmpty ? (subtotal * 0.04).round() : 0;
  final tax = items.isNotEmpty ? (subtotal * 0.05).round() : 0;
  final discount = subtotal > 20000 ? 1500 : 0;
  return Breakdown(subtotal, serviceFee, tax, discount, subtotal + serviceFee + tax - discount);
}

/// Global app state: favourites + trip cart (shared across routes).
class AppController extends ChangeNotifier {
  final Set<String> favs = {'mermaid', 'paraglide'};
  final List<TripItem> trip = [];
  String tripName = 'My Bangladesh Trip';

  /// eventId → extra seats this user has reserved.
  final Map<String, int> groupJoins = {};
  int joinedCount(String eventId) => groupJoins[eventId] ?? 0;
  void confirmJoin(String eventId, int spots) {
    groupJoins[eventId] = (groupJoins[eventId] ?? 0) + spots;
    notifyListeners();
  }

  bool isFav(String id) => favs.contains(id);
  void toggleFav(String id) {
    favs.contains(id) ? favs.remove(id) : favs.add(id);
    notifyListeners();
  }

  int get tripTotal => priceBreakdown(trip).total;

  void addToTrip(TripItem item) {
    trip.add(item);
    notifyListeners();
  }

  void removeFromTrip(String uid) {
    trip.removeWhere((i) => i.uid == uid);
    notifyListeners();
  }

  void setGuests(String uid, int g) {
    final it = trip.firstWhere((i) => i.uid == uid);
    final base = it.isStay ? it.unit * it.nights * g : it.unit * g;
    it.guests = g;
    it.total = base + it.addonTotal;
    notifyListeners();
  }

  void setTripName(String n) {
    tripName = n;
    notifyListeners();
  }

  void clearTrip() {
    trip.clear();
    notifyListeners();
  }

  List<Listing> savedListings() {
    final all = [...hotelsAndActivities];
    return all.where((l) => favs.contains(l.id)).toList();
  }
}

// Avoid importing content here for the saved list — injected lazily.
List<Listing> hotelsAndActivities = const [];

/// InheritedNotifier exposing [AppController].
class AppScope extends InheritedNotifier<AppController> {
  const AppScope({super.key, required AppController controller, required super.child})
      : super(notifier: controller);

  static AppController of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<AppScope>();
    assert(scope != null, 'AppScope not found in context');
    return scope!.notifier!;
  }
}
