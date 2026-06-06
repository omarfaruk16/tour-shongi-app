import 'package:flutter/painting.dart' show Color;
import 'models.dart';

const categories = ['Beach', 'Hill', 'City', 'Family', 'Island', 'Tea Estate', 'Luxury'];

const destinations = <Destination>[
  Destination('coxs', "Cox's Bazar", 'কক্সবাজার', 'Beach', 28, 14, "Cox's Bazar", 198,
      '1507525428034-b723cf961d3e'),
  Destination('sajek', 'Sajek Valley', 'সাজেক', 'Hill', 12, 9, 'Sajek Valley', 150,
      '1470071459604-3b5ec3a7fe05'),
  Destination('sundar', 'Sundarbans', 'সুন্দরবন', 'Island', 6, 11, 'Sundarbans', 130,
      '1441974231531-c6227db76b6e'),
  Destination('sylhet', 'Sreemangal', 'শ্রীমঙ্গল', 'Tea Estate', 9, 7, 'Sreemangal', 95,
      '1501785888041-af3ef285b470'),
  Destination('bandar', 'Bandarban', 'বান্দরবান', 'Hill', 10, 12, 'Bandarban', 165,
      '1506905925346-21bda4d32df4'),
];

const hotels = <Listing>[
  Listing(
    id: 'sayeman', kind: 'hotel', name: 'Sayeman Beach Resort', bn: 'সায়মন বিচ রিসোর্ট',
    location: "Cox's Bazar", rating: 4.8, reviews: 1284, cat: 'Beach',
    base: Base(7500, 12500, 24000), discount: 20, ph: 'Beachfront resort', hue: 196,
    img: '1540541338287-41700207dee6',
    blurb:
        'A landmark beachfront retreat on the world’s longest sea beach, with an infinity pool that melts into the Bay of Bengal, three dining venues and a full-service spa.',
    amenities: ['wifi', 'pool', 'food', 'spa', 'parking', 'ac', 'beach', 'gym'], gallery: 5,
  ),
  Listing(
    id: 'mermaid', kind: 'hotel', name: 'Mermaid Eco Resort', bn: 'মারমেইড ইকো রিসোর্ট',
    location: "Cox's Bazar", rating: 4.7, reviews: 932, cat: 'Beach',
    base: Base(6800, 11200, 19800), discount: 0, ph: 'Bamboo eco-cabanas', hue: 150,
    img: '1520250497591-112f2f40a3f4',
    blurb:
        'Barefoot-luxury eco cabanas built from bamboo and driftwood, tucked into a coconut grove a few steps from a quiet stretch of beach.',
    amenities: ['wifi', 'food', 'spa', 'beach', 'yoga', 'parking'], gallery: 5,
  ),
  Listing(
    id: 'sajek-cloud', kind: 'hotel', name: 'Cloud Valley Resort', bn: 'ক্লাউড ভ্যালি রিসোর্ট',
    location: 'Sajek Valley', rating: 4.6, reviews: 564, cat: 'Hill',
    base: Base(5200, 8800, 15500), discount: 15, ph: 'Hilltop cottages', hue: 158,
    img: '1464822759023-fed622ff2c3b',
    blurb:
        'Wake above a sea of clouds in timber cottages perched on the highest ridge of Sajek, with panoramic sunrise decks and bonfire evenings.',
    amenities: ['wifi', 'food', 'bonfire', 'parking', 'viewpoint'], gallery: 4,
  ),
  Listing(
    id: 'tea-bungalow', kind: 'hotel', name: 'Grand Tea Bungalow', bn: 'গ্র্যান্ড টি বাংলো',
    location: 'Sreemangal', rating: 4.9, reviews: 411, cat: 'Tea Estate',
    base: Base(6200, 9900, 18200), discount: 0, ph: 'Colonial bungalow', hue: 95,
    img: '1518002171953-a080ee817e1f',
    blurb:
        'A restored colonial planter’s bungalow set inside a working tea estate — verandah breakfasts, guided garden walks and absolute quiet.',
    amenities: ['wifi', 'food', 'spa', 'parking', 'garden', 'ac'], gallery: 5,
  ),
];

const activities = <Listing>[
  Listing(
    id: 'paraglide', kind: 'activity', name: 'Sunrise Paragliding', bn: 'প্যারাগ্লাইডিং',
    location: 'Bandarban', rating: 4.9, reviews: 327, cat: 'Hill',
    duration: '3 hrs', intensity: 'Moderate',
    base: Base(4500, 7200, 12000), discount: 0, ph: 'Tandem paraglider', hue: 168,
    img: '1521336575822-6da63fb45455',
    blurb:
        'Launch from a ridge at first light and ride the morning thermals on a certified tandem flight over Bandarban’s folded green hills.',
    steps: [
      DayStep('Briefing & gear-up', '20 min', 'Meet your pilot, harness fitting and a full safety walkthrough.'),
      DayStep('Ridge ascent', '40 min', 'Short 4x4 ride to the launch ridge as the valley wakes up.'),
      DayStep('The flight', '15–20 min', 'Tandem launch and a soaring glide over hills and streams.'),
      DayStep('Landing & photos', '30 min', 'Soft landing in the valley, GoPro footage handed over.'),
    ],
    gear: [
      Gear('Harness + wing', 'Provided'),
      Gear('Helmet & comms', 'Provided'),
      Gear('Trail shoes', 'Bring'),
      Gear('Windbreaker', 'Bring'),
    ],
  ),
  Listing(
    id: 'scuba', kind: 'activity', name: 'Reef Scuba Discovery', bn: 'স্কুবা ডাইভিং',
    location: 'Saint Martin', rating: 4.7, reviews: 218, cat: 'Beach',
    duration: '4 hrs', intensity: 'Easy',
    base: Base(5500, 8500, 14500), discount: 10, ph: 'Diver over a reef', hue: 200,
    img: '1544551763-46a013bb70d5',
    blurb:
        'A guided discovery dive over Bangladesh’s only coral island — no experience needed, with a one-to-one instructor in clear shallow water.',
    steps: [
      DayStep('Pool skills', '45 min', 'Master breathing and clearing in calm shallows.'),
      DayStep('Boat to reef', '25 min', 'Short ride to the protected reef shelf.'),
      DayStep('Guided dive', '40 min', 'Descend to 6m with your instructor among the coral.'),
      DayStep('Surface & log', '30 min', 'Warm up on deck and log your first dive.'),
    ],
    gear: [
      Gear('Full scuba kit', 'Provided'),
      Gear('Wetsuit', 'Provided'),
      Gear('Swimwear', 'Bring'),
      Gear('Towel', 'Bring'),
    ],
  ),
  Listing(
    id: 'cruise', kind: 'activity', name: 'Mangrove Boat Safari', bn: 'বোট সাফারি',
    location: 'Sundarbans', rating: 4.8, reviews: 503, cat: 'Island',
    duration: 'Full day', intensity: 'Easy',
    base: Base(6500, 10500, 17500), discount: 0, ph: 'Boat in mangrove channel', hue: 132,
    img: '1559827260-dc66d52bef19',
    blurb:
        'A full-day country-boat safari deep into the Sundarbans channels with a naturalist guide, watch-towers and a riverside lunch.',
    steps: [
      DayStep('Dock & permits', '30 min', 'Board your boat and meet the forest-department guide.'),
      DayStep('Channel cruise', '2 hrs', 'Glide narrow creeks watching for deer and kingfishers.'),
      DayStep('Watch-tower walk', '1 hr', 'Boardwalk to a canopy tower over the mangroves.'),
      DayStep('Riverside lunch', '1 hr', 'Fresh Bengali lunch served on deck.'),
    ],
    gear: [
      Gear('Binoculars', 'Provided'),
      Gear('Life vest', 'Provided'),
      Gear('Sun hat', 'Bring'),
      Gear('Insect repellent', 'Bring'),
    ],
  ),
];

// Extended catalog ("See all" lists) built from the base items (matches _variant).
final extraHotels = <Listing>[
  hotels[0].variant(id: 'longbeach', name: 'Long Beach Hotel', bn: 'লং বিচ হোটেল', location: "Cox's Bazar", cat: 'Beach', rating: 4.6, reviews: 1042, discount: 10, hue: 200, img: '1505228395891-9a51e7e86bf6', base: const Base(6900, 10800, 20500)),
  hotels[0].variant(id: 'seapearl', name: 'Royal Tulip Sea Pearl', bn: 'সী পার্ল', location: "Cox's Bazar", cat: 'Luxury', rating: 4.9, reviews: 870, discount: 0, hue: 210, img: '1571003123894-1f0594d2b5d9', base: const Base(14500, 22000, 38000)),
  hotels[1].variant(id: 'bluemarine', name: 'Blue Marine Resort', bn: 'ব্লু মেরিন', location: 'Saint Martin', cat: 'Island', rating: 4.5, reviews: 388, discount: 12, hue: 196, img: '1544551763-46a013bb70d5', base: const Base(5800, 9200, 16500)),
  hotels[1].variant(id: 'kuakata-bay', name: 'Family Bay Resort', bn: 'ফ্যামিলি বে', location: 'Kuakata', cat: 'Family', rating: 4.4, reviews: 296, discount: 0, hue: 188, img: '1520250497591-112f2f40a3f4', base: const Base(5200, 8400, 14800)),
  hotels[2].variant(id: 'sajek-resort', name: 'Sajek Resort', bn: 'সাজেক রিসোর্ট', location: 'Sajek Valley', cat: 'Hill', rating: 4.7, reviews: 612, discount: 8, hue: 158, img: '1506905925346-21bda4d32df4', base: const Base(6400, 10200, 17800)),
  hotels[2].variant(id: 'rangamati-lake', name: 'Rangamati Lake Resort', bn: 'রাঙ্গামাটি লেক', location: 'Rangamati', cat: 'Hill', rating: 4.5, reviews: 421, discount: 0, hue: 168, img: '1470071459604-3b5ec3a7fe05', base: const Base(5600, 9000, 15200)),
  hotels[3].variant(id: 'nazimgarh', name: 'Nazimgarh Wilderness', bn: 'নাজিমগড়', location: 'Sylhet', cat: 'Tea Estate', rating: 4.8, reviews: 358, discount: 0, hue: 110, img: '1501785888041-af3ef285b470', base: const Base(8200, 12600, 21000)),
  hotels[0].variant(id: 'sonargaon', name: 'Pan Pacific Sonargaon', bn: 'সোনারগাঁও', location: 'Dhaka', cat: 'City', rating: 4.7, reviews: 1560, discount: 15, hue: 220, img: '1566073771259-6a8506099945', base: const Base(9800, 15500, 28000)),
  hotels[3].variant(id: 'radisson-ctg', name: 'Radisson Blu Chattogram', bn: 'রেডিসন ব্লু', location: 'Chattogram', cat: 'City', rating: 4.8, reviews: 1188, discount: 0, hue: 224, img: '1551882547-ff40c63fe5fa', base: const Base(10500, 16800, 30000)),
];

final extraActivities = <Listing>[
  activities[1].variant(id: 'snorkel', name: 'Reef Snorkeling', bn: 'স্নরকেলিং', location: 'Saint Martin', cat: 'Beach', rating: 4.6, reviews: 274, discount: 0, hue: 196, img: '1559827260-dc66d52bef19', duration: '3 hrs', intensity: 'Easy', base: const Base(3200, 5200, 8500)),
  activities[0].variant(id: 'nafakhum', name: 'Nafakhum Waterfall Trek', bn: 'নাফাখুম ট্রেক', location: 'Bandarban', cat: 'Hill', rating: 4.8, reviews: 196, discount: 0, hue: 150, img: '1441974231531-c6227db76b6e', duration: 'Full day', intensity: 'Hard', base: const Base(5000, 7800, 12500)),
  activities[1].variant(id: 'kayak', name: 'Sea Kayaking', bn: 'কায়াকিং', location: "Cox's Bazar", cat: 'Beach', rating: 4.5, reviews: 142, discount: 15, hue: 200, img: '1544551763-46a013bb70d5', duration: '2 hrs', intensity: 'Moderate', base: const Base(2800, 4500, 7200)),
  activities[2].variant(id: 'lawachara', name: 'Lawachara Forest Walk', bn: 'লাউয়াছড়া', location: 'Sreemangal', cat: 'Family', rating: 4.7, reviews: 231, discount: 0, hue: 110, img: '1501785888041-af3ef285b470', duration: 'Half day', intensity: 'Easy', base: const Base(2400, 3900, 6500)),
  activities[0].variant(id: 'atv-sajek', name: 'ATV Hill Ride', bn: 'এটিভি রাইড', location: 'Sajek Valley', cat: 'Hill', rating: 4.6, reviews: 158, discount: 10, hue: 158, img: '1464822759023-fed622ff2c3b', duration: '1.5 hrs', intensity: 'Moderate', base: const Base(3500, 5600, 9000)),
  activities[2].variant(id: 'bonfire-bbq', name: 'Bonfire & BBQ Night', bn: 'বনফায়ার বিবিকিউ', location: 'Sajek Valley', cat: 'Family', rating: 4.8, reviews: 312, discount: 0, hue: 35, img: '1469474968028-56623f02e42e', duration: 'Evening', intensity: 'Easy', base: const Base(1800, 2900, 4800)),
  activities[2].variant(id: 'canopy-walk', name: 'Sundarbans Canopy Walk', bn: 'ক্যানোপি ওয়াক', location: 'Sundarbans', cat: 'Island', rating: 4.7, reviews: 188, discount: 0, hue: 132, img: '1504280390367-361c6d9f38f4', duration: 'Half day', intensity: 'Easy', base: const Base(4200, 6800, 11000)),
  activities[1].variant(id: 'surf-lesson', name: 'Surfing Lesson', bn: 'সার্ফিং', location: "Cox's Bazar", cat: 'Beach', rating: 4.5, reviews: 124, discount: 0, hue: 204, img: '1473496169904-658ba7c44d8a', duration: '2 hrs', intensity: 'Moderate', base: const Base(3000, 4800, 7800)),
];

List<Listing> get catalogHotels => [...hotels, ...extraHotels];
List<Listing> get catalogActivities => [...activities, ...extraActivities];

final Map<String, Listing> _index = {
  for (final l in [...hotels, ...activities, ...extraHotels, ...extraActivities]) l.id: l
};
Listing? listingById(String id) => _index[id];

const offers = <Offer>[
  Offer('o1', 'Monsoon Escape', 30, 'Hill resorts · book by Jun 15', 35, '1469474968028-56623f02e42e'),
  Offer('o2', "Cox's Long Weekend", 22, 'Beachfront stays, 2 nights free brunch', 195, '1505228395891-9a51e7e86bf6'),
  Offer('o3', 'First Trip on Us', 15, 'New travellers — any activity', 150, '1473496169904-658ba7c44d8a'),
];

// twemoji codepoints → unicode emoji
const experiences = <Experience>[
  Experience('domestic', 'Domestic', '📍', Color(0xFFFCEDED)),
  Experience('intl', 'International', '🌏', Color(0xFFE8F1EC)),
  Experience('hotels', 'Hotel / Resort', '🏝️', Color(0xFFFCF3E2)),
  Experience('activity', 'Activities', '🪂', Color(0xFFE7F1EE)),
  Experience('hajj', 'Hajj / Umrah', '🕋', Color(0xFFFBF1E0)),
  Experience('tour', 'Tour Group', '🚌', Color(0xFFFBEDE6)),
  Experience('ecopark', 'Eco-parks', '🌳', Color(0xFFE6F2E8)),
  Experience('hidden', 'Hidden Gems', '💎', Color(0xFFEFEAF7)),
];

/// Places the traveller has already visited (completed trips) — surfaced on reels.
const visited = <String>['sayeman', 'cruise', 'paraglide'];

/// Curated collections (Eco-parks, Hidden Gems).
class Collection {
  final String title, bn, tag, img, blurb;
  final List<String> hotels, acts;
  const Collection(this.title, this.bn, this.tag, this.img, this.blurb, this.hotels, this.acts);
}

const collections = <String, Collection>{
  'ecopark': Collection('Eco-parks', 'ইকো-পার্ক', 'Nature & wildlife', '1501785888041-af3ef285b470',
      'Protected forests, wetlands and wildlife reserves — slow travel close to nature.',
      ['nazimgarh', 'rangamati-lake', 'kuakata-bay'], ['lawachara', 'canopy-walk', 'nafakhum', 'cruise']),
  'hidden': Collection('Hidden Gems', 'হিডেন জেম', 'Off the beaten path', '1470071459604-3b5ec3a7fe05',
      'Quiet, lesser-known spots loved by locals — before the crowds find them.',
      ['sajek-resort', 'bluemarine', 'rangamati-lake'], ['nafakhum', 'snorkel', 'bonfire-bbq', 'atv-sajek']),
};

/// Destination → location-name aliases for matching listings.
const destAlias = <String, List<String>>{
  'coxs': ['cox'],
  'sajek': ['sajek'],
  'sundar': ['sundarban'],
  'sylhet': ['sreemangal', 'srimangal', 'sylhet', 'lawachara'],
  'bandar': ['bandarban', 'nafakhum'],
};

bool atDest(String loc, Destination d) {
  final l = loc.toLowerCase();
  final keys = destAlias[d.id] ?? [d.name.toLowerCase()];
  return keys.any((k) => l.contains(k));
}

const reviews = <Review>[
  Review('Tasnia R.', '2 weeks ago', 5, 'Genuinely the smoothest booking I’ve done. The sea-view room was exactly as pictured.'),
  Review('Imran H.', '1 month ago', 5, 'Staff went out of their way for our family. Pool and breakfast were the highlights.'),
  Review('Naila K.', '1 month ago', 4, 'Beautiful property, slightly busy on the weekend but worth it for the location.'),
];

const ratingBars = <({int s, int p})>[
  (s: 5, p: 78), (s: 4, p: 16), (s: 3, p: 4), (s: 2, p: 1), (s: 1, p: 1),
];

const amenityLabels = <String, String>{
  'wifi': 'Free Wi-Fi', 'pool': 'Infinity pool', 'food': 'Restaurant', 'spa': 'Spa & wellness',
  'parking': 'Free parking', 'ac': 'Air conditioning', 'beach': 'Private beach', 'gym': 'Fitness center',
  'yoga': 'Yoga deck', 'bonfire': 'Bonfire nights', 'viewpoint': 'Sunrise deck', 'garden': 'Garden walks',
};

const reels = <Reel>[
  Reel(id: 'r1', owner: 'Sayeman Beach Resort', kind: 'Resort', handle: '@sayeman', verified: true, hue: 196, caption: 'Golden hour from the infinity pool 🌅 Book a Premium sea-view suite this weekend.', music: 'Original audio · Sayeman', likes: 4820, comments: 213, shares: 96, linkId: 'sayeman', cta: 'Book this stay', tag: 'Stay', img: '1540541338287-41700207dee6'),
  Reel(id: 'r2', owner: 'Bandarban Paragliding', kind: 'Activity host', handle: '@flybandarban', verified: true, hue: 168, caption: 'POV: you launch into the clouds at sunrise 🪂 Tandem flights every morning.', music: 'Trending · Uplift', likes: 9120, comments: 540, shares: 312, linkId: 'paraglide', cta: 'Book this flight', tag: 'Activity', img: '1521336575822-6da63fb45455'),
  Reel(id: 'r3', owner: 'Cloud Valley Resort', kind: 'Resort', handle: '@cloudvalley', verified: false, hue: 158, caption: 'Waking up above the clouds in Sajek hits different ☁️ Cottages from ৳5,200.', music: 'Original audio · Cloud Valley', likes: 3110, comments: 128, shares: 64, linkId: 'sajek-cloud', cta: 'See cottages', tag: 'Stay', img: '1464822759023-fed622ff2c3b'),
  Reel(id: 'r4', owner: 'Sundarbans Safari Co.', kind: 'Activity host', handle: '@wildsundarban', verified: true, hue: 132, caption: 'Spotted on today’s safari 🐅 Full-day boat trips with a naturalist guide.', music: 'Trending · Wild Calm', likes: 7640, comments: 401, shares: 188, linkId: 'cruise', cta: 'Book a safari', tag: 'Activity', img: '1441974231531-c6227db76b6e'),
  Reel(id: 'r5', owner: 'Nusrat travels', kind: 'Traveler', handle: '@nusrat.j', verified: false, hue: 196, caption: 'Best weekend ever at Sayeman 💙 The sea-view suite is unreal. Tag your travel buddy!', music: 'Trending · Summer Days', likes: 2240, comments: 96, shares: 41, linkId: 'sayeman', cta: 'See this stay', tag: 'Stay', img: '1571896349842-33c89424de2d'),
  Reel(id: 'r6', owner: 'Rakib explores', kind: 'Traveler', handle: '@rakib.dives', verified: false, hue: 200, caption: 'First dive at Saint Martin and I’m hooked 🐠 Visibility was incredible today.', music: 'Original audio · Rakib', likes: 5180, comments: 230, shares: 120, linkId: 'scuba', cta: 'Try this dive', tag: 'Activity', img: '1544551763-46a013bb70d5'),
  Reel(id: 'r7', owner: 'Maliha K.', kind: 'Traveler', handle: '@maliha.k', verified: false, hue: 95, caption: 'Tea-estate mornings hit different ☕🌿 Verandah breakfast at the Grand Tea Bungalow.', music: 'Trending · Morning Light', likes: 3320, comments: 142, shares: 73, linkId: 'tea-bungalow', cta: 'See this stay', tag: 'Stay', img: '1518002171953-a080ee817e1f'),
  Reel(id: 'r8', owner: 'Cloud Valley Resort', kind: 'Resort', handle: '@cloudvalley', verified: false, hue: 158, caption: 'Bonfire nights above the clouds 🔥 Limited cottages for the long weekend.', music: 'Original audio · Cloud Valley', likes: 4010, comments: 188, shares: 95, linkId: 'sajek-cloud', cta: 'See cottages', tag: 'Stay', img: '1469474968028-56623f02e42e'),
];

List<Reel> reelsFor(String linkId) => reels.where((r) => r.linkId == linkId).toList();

const hotelOptions = <String, ({List<HotelOption> stays, List<HotelOption> acts})>{
  'sayeman': (
    stays: [
      HotelOption('sy-deluxe', 'Garden-View Deluxe', 'King room over the gardens · breakfast included', '1566073771259-6a8506099945', Base(7500, 10500, 14000), discount: 20),
      HotelOption('sy-sea', 'Sea-View Suite', 'Private balcony facing the Bay of Bengal', '1571896349842-33c89424de2d', Base(12500, 16500, 24000), discount: 20),
      HotelOption('sy-villa', 'Private Pool Villa', 'Plunge pool, butler service, 2 bedrooms', '1582719508461-905c673771fd', Base(22000, 28000, 38000)),
    ],
    acts: [
      HotelOption('sy-spa', 'Sunset Spa Ritual', '90-min couples massage on the beach', '1540541338287-41700207dee6', Base(3500, 5200, 7800), duration: '90 min'),
      HotelOption('sy-cruise', 'Bay Sunset Cruise', 'Catamaran cruise with snacks & music', '1505228395891-9a51e7e86bf6', Base(2800, 4200, 6500), discount: 10, duration: '2 hrs'),
    ],
  ),
  'mermaid': (
    stays: [
      HotelOption('mm-cabana', 'Bamboo Cabana', 'Eco cabana steps from the beach', '1520250497591-112f2f40a3f4', Base(6800, 9200, 13500)),
      HotelOption('mm-villa', 'Driftwood Villa', 'Open-air villa with outdoor shower', '1582719508461-905c673771fd', Base(11200, 15000, 19800)),
    ],
    acts: [
      HotelOption('mm-yoga', 'Sunrise Beach Yoga', 'Guided 60-min flow on the sand', '1506905925346-21bda4d32df4', Base(1500, 2400, 3600), duration: '60 min'),
      HotelOption('mm-surf', 'Beginner Surf Lesson', 'Board, instructor & photos included', '1473496169904-658ba7c44d8a', Base(3200, 4800, 7000), discount: 15, duration: '2 hrs'),
    ],
  ),
  'sajek-cloud': (
    stays: [
      HotelOption('sj-cottage', 'Ridge Cottage', 'Timber cottage with sunrise deck', '1464822759023-fed622ff2c3b', Base(5200, 7400, 10500), discount: 15),
      HotelOption('sj-suite', 'Cloud Suite', 'Floor-to-ceiling glass over the valley', '1469474968028-56623f02e42e', Base(8800, 11500, 15500), discount: 15),
    ],
    acts: [
      HotelOption('sj-bonfire', 'Bonfire & BBQ Night', 'Live music, BBQ dinner under the stars', '1470071459604-3b5ec3a7fe05', Base(1800, 2800, 4200), duration: 'Evening'),
      HotelOption('sj-trek', 'Konglak Hill Trek', 'Guided sunrise trek to the peak', '1506905925346-21bda4d32df4', Base(2200, 3400, 5000), duration: '3 hrs'),
    ],
  ),
  'tea-bungalow': (
    stays: [
      HotelOption('tb-room', 'Planter’s Room', 'Colonial room with verandah', '1518002171953-a080ee817e1f', Base(6200, 8400, 11000)),
      HotelOption('tb-suite', 'Estate Suite', 'Four-poster bed, garden access', '1571896349842-33c89424de2d', Base(9900, 13000, 18200)),
    ],
    acts: [
      HotelOption('tb-walk', 'Guided Tea-Garden Walk', 'Plucking, tasting & factory tour', '1501785888041-af3ef285b470', Base(1600, 2600, 3800), duration: '2 hrs'),
      HotelOption('tb-bird', 'Lawachara Birding', 'Naturalist-led rainforest walk', '1441974231531-c6227db76b6e', Base(2400, 3600, 5400), discount: 10, duration: 'Half day'),
    ],
  ),
};

({List<HotelOption> stays, List<HotelOption> acts}) optionsFor(String id) =>
    hotelOptions[id] ?? (stays: const [], acts: const []);

const addons = <Addon>[
  Addon('ad-airport', 'Airport pickup', 1200, '1518684079-3c830dcef090'),
  Addon('ad-breakfast', 'Daily breakfast', 600, '1566552881560-0be862a7c445'),
  Addon('ad-dinner', 'Candle-light dinner', 1800, '1539635278303-d4002c07eae3'),
  Addon('ad-guide', 'Private guide', 2200, '1518709268805-4e9042af9f23'),
];

const user = AppUser('Arefin Rahman', '@arefin', 'arefin.r@gmail.com', 'AR', 198, 'Gold member',
    2480, '2024', [(n: 12, l: 'Trips'), (n: 38, l: 'Reviews'), (n: 5, l: 'Cities')]);

const accountGroups = <AccountGroup>[
  AccountGroup('Travel', [
    AccountItem('bookmark', 'My bookings', '2 upcoming', 'bookings'),
    AccountItem('heart', 'Saved trips', '', 'saved'),
    AccountItem('wallet', 'Wallet & rewards', '৳1,240', 'wallet'),
    AccountItem('tag', 'Offers & coupons', '3 new', 'offers'),
  ]),
  AccountGroup('Hosting', [
    AccountItem('users', 'Host a travel group', 'New', 'grouphost'),
    AccountItem('compass', 'Become a host', '', 'host'),
    AccountItem('sparkle', 'Post a reel', '', 'postreel'),
  ]),
  AccountGroup('Settings', [
    AccountItem('user', 'Personal details', '', 'details'),
    AccountItem('shield', 'Privacy & security', '', 'privacy'),
    AccountItem('bell', 'Notifications', 'On', 'notif'),
    AccountItem('headset', 'Help & support', '', 'help'),
  ]),
];

const paymentMethods = <PaymentMethod>[
  PaymentMethod('bKash', '•••• 4821', true, 330),
  PaymentMethod('Visa', '•••• 5560', false, 220),
];
