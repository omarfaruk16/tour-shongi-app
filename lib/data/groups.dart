import 'package:flutter/painting.dart';
import '../core/theme.dart';
import 'models.dart';

class GHost {
  final String name, phone, nid, email, address;
  const GHost(this.name, this.phone, this.nid, this.email, this.address);
}

class PastTrip {
  final String title, location, dates, img;
  final int travellers, hue;
  final double rating;
  const PastTrip(this.title, this.location, this.dates, this.travellers, this.rating, this.hue, this.img);
}

class TravelGroup {
  final String id, kind, name, bn, handle, badge, img, tagline, bio, founded;
  final bool verified;
  final int hue, reviewCount;
  final double rating;
  final List<({int n, String l})> stats;
  final GHost host;
  final List<Review> reviews;
  final List<PastTrip> past;
  const TravelGroup({
    required this.id,
    required this.kind,
    required this.name,
    required this.bn,
    required this.handle,
    required this.verified,
    required this.badge,
    required this.hue,
    required this.img,
    required this.rating,
    required this.reviewCount,
    required this.founded,
    required this.tagline,
    required this.bio,
    required this.stats,
    required this.host,
    required this.reviews,
    this.past = const [],
  });
}

class PlanSeg {
  final String type, title, sub, time, meta;
  const PlanSeg(this.type, this.title, this.sub, this.time, this.meta);
}

class GroupEvent {
  final String id, groupId, title, bn, location, img, dates, departs, tourType, blurb;
  final int hue, days, nights, discount, capacity, booked, male, female, manual, reviews;
  final double rating;
  final Base price;
  final List<String> suitableFor, includes;
  final List<PlanSeg> plan;
  const GroupEvent({
    required this.id,
    required this.groupId,
    required this.title,
    required this.bn,
    required this.location,
    required this.hue,
    required this.img,
    required this.dates,
    required this.days,
    required this.nights,
    required this.departs,
    required this.price,
    required this.discount,
    required this.capacity,
    required this.booked,
    required this.male,
    required this.female,
    required this.manual,
    required this.tourType,
    required this.rating,
    required this.reviews,
    required this.suitableFor,
    required this.blurb,
    required this.plan,
    required this.includes,
  });
}

class Invigilator {
  final String name, img, since, code, langs;
  final int trips;
  const Invigilator(this.name, this.img, this.since, this.trips, this.code, this.langs);
}

class ChatMsg {
  final String from, text, time; // from: host | me
  const ChatMsg(this.from, this.text, this.time);
}

class ChatThread {
  final String name, sub;
  final int hue;
  final String? img;
  final bool verified;
  final List<ChatMsg> msgs;
  const ChatThread(this.name, this.sub, this.hue, this.img, this.verified, this.msgs);
}

const suitableMeta = <String, ({String icon, int hue})>{
  'Students': (icon: 'badge', hue: 158),
  'Friends': (icon: 'users', hue: 168),
  'Solo': (icon: 'user', hue: 196),
  'Family': (icon: 'users', hue: 35),
  'Couples': (icon: 'heart', hue: 330),
  'Kids': (icon: 'sparkle', hue: 45),
  'Men': (icon: 'genderM', hue: 210),
  'Women': (icon: 'genderF', hue: 330),
  'Photographers': (icon: 'camera', hue: 260),
  'First-timers': (icon: 'sparkle', hue: 45),
  'Elderly': (icon: 'user', hue: 25),
  'Families': (icon: 'users', hue: 35),
};

const planMeta = <String, ({String icon, String label, Color color, Color tint})>{
  'journey': (icon: 'route', label: 'Journey', color: C.info, tint: Color(0x1F3B82C4)),
  'stay': (icon: 'bed', label: 'Stay', color: C.emerald, tint: C.emeraldTint),
  'activity': (icon: 'compass', label: 'Activity', color: C.saffronDark, tint: Color(0x29E8A33D)),
};

const travelGroups = <TravelGroup>[
  TravelGroup(
    id: 'wanderbd', kind: 'group', name: 'Wander BD', bn: 'ওয়ান্ডার বিডি', handle: '@wanderbd',
    verified: true, badge: 'Top Host', hue: 168, img: '1521336575822-6da63fb45455',
    rating: 4.9, reviewCount: 312, founded: '2021',
    tagline: 'Adventure group tours across the hills & coast of Bangladesh',
    bio: 'A community of 12 trip leaders running small-group adventures — paragliding, treks and offbeat valleys. Every trip is led by a certified guide and a local fixer.',
    stats: [(n: 84, l: 'Trips hosted'), (n: 1900, l: 'Travellers'), (n: 24, l: 'Destinations')],
    host: GHost('Tanvir Ahmed', '+880 1711 204050', '19912694xxxxxx', 'hello@wanderbd.co', 'Road 11, Banani, Dhaka 1213'),
    reviews: [
      Review('Sadia P.', '1 week ago', 5, 'Wander BD made my first solo group trip feel completely safe. The leads are pros.'),
      Review('Rifat H.', '3 weeks ago', 5, 'Sajek convoy, bonfire, sunrise trek — every minute was planned yet never rushed.'),
      Review('Mou T.', '1 month ago', 4, 'Great value and a fun crowd. Bus was a little late but the team kept us updated.'),
    ],
  ),
  TravelGroup(
    id: 'bandhu', kind: 'group', name: 'Bandhu Tours', bn: 'বন্ধু ট্যুরস', handle: '@bandhutours',
    verified: true, badge: 'Family Friendly', hue: 35, img: '1505228395891-9a51e7e86bf6',
    rating: 4.8, reviewCount: 248, founded: '2019',
    tagline: 'Relaxed beach & family group holidays, done the easy way',
    bio: 'Family-run since 2019. We handle the buses, hotels and meals so you just show up. Kid-friendly itineraries and women-led support on every trip.',
    stats: [(n: 132, l: 'Trips hosted'), (n: 3400, l: 'Travellers'), (n: 18, l: 'Destinations')],
    host: GHost('Nasrin Akter', '+880 1819 663300', '19872641xxxxxx', 'care@bandhutours.com', 'Mehedibag, Chattogram 4000'),
    reviews: [
      Review('Imran & family', '5 days ago', 5, 'Took my parents and two kids. Everything from pickup to dinner was sorted.'),
      Review('Lamia K.', '2 weeks ago', 5, 'As a woman travelling with friends I felt looked after the whole way.'),
      Review('Sajib R.', '1 month ago', 4, 'Smooth Cox’s trip. Hotel was a step above what I expected for the price.'),
    ],
  ),
  TravelGroup(
    id: 'hilltrek', kind: 'group', name: 'Hill Trekkers Club', bn: 'হিল ট্রেকার্স', handle: '@hilltrekkers',
    verified: false, badge: 'Rising Host', hue: 150, img: '1441974231531-c6227db76b6e',
    rating: 4.7, reviewCount: 96, founded: '2022',
    tagline: 'Serious treks & wildlife expeditions for the outdoorsy',
    bio: 'A trekking collective for people who like it rugged — multi-day forest expeditions, wildlife safaris and summit pushes with experienced mountain leaders.',
    stats: [(n: 41, l: 'Trips hosted'), (n: 720, l: 'Travellers'), (n: 12, l: 'Destinations')],
    host: GHost('Arnob Chowdhury', '+880 1521 778899', '19952218xxxxxx', 'trek@hilltrekkers.club', 'Zakir Hossain Rd, Khulshi, Chattogram'),
    reviews: [
      Review('Fahim A.', '1 week ago', 5, 'The Sundarbans expedition was the real deal. Naturalist guide knew everything.'),
      Review('Tisha N.', '1 month ago', 4, 'Challenging but unforgettable. Come fit and you’ll love it.'),
    ],
  ),
];

const groupEvents = <GroupEvent>[
  GroupEvent(
    id: 'gev-sajek', groupId: 'wanderbd', title: 'Sajek Valley Cloud Chase', bn: 'সাজেক ভ্যালি ক্লাউড চেজ',
    location: 'Sajek Valley', hue: 158, img: '1464822759023-fed622ff2c3b',
    dates: '12–14 Jun 2026', days: 3, nights: 2, departs: 'Dhaka',
    price: Base(6900, 9800, 14500), discount: 12, capacity: 50, booked: 32, male: 20, female: 12, manual: 6,
    tourType: 'Adventure Group', rating: 4.9, reviews: 86,
    suitableFor: ['Students', 'Friends', 'Solo', 'Men', 'Women'],
    blurb: 'Chase a sea of clouds from the highest ridge of Sajek on this 3-day small-group adventure — night coach in, jeep convoy up, bonfire nights and a sunrise trek to Konglak peak.',
    plan: [
      PlanSeg('journey', 'Dhaka → Khagrachari', 'AC Night Coach', 'Day 1 · 10:00 PM', 'Reserved seats · ~7h overnight'),
      PlanSeg('journey', 'Khagrachari → Sajek', 'Chander Gari (Jeep convoy)', 'Day 1 · 9:00 AM', 'Scenic 3h army-escorted convoy'),
      PlanSeg('stay', 'Meghpunji Resort', 'Twin-share hill cottage', 'Day 1–2', '2 nights · sunrise-facing deck'),
      PlanSeg('activity', 'Konglak Hill sunrise trek', 'Guided hike', 'Day 2 · 5:00 AM', '~3h · easy-moderate'),
      PlanSeg('activity', 'Bonfire, BBQ & live music', 'Evening social', 'Day 2 · 7:30 PM', 'Included dinner under the stars'),
      PlanSeg('journey', 'Sajek → Dhaka', 'AC Night Coach', 'Day 3 · 8:00 PM', 'Return overnight · arrive Day 4 AM'),
    ],
    includes: ['Round-trip AC coach', '2 nights twin cottage', '5 meals + BBQ', 'Jeep convoy & permits', 'Trip lead + local guide'],
  ),
  GroupEvent(
    id: 'gev-sundar', groupId: 'hilltrek', title: 'Sundarbans Wildlife Expedition', bn: 'সুন্দরবন অভিযান',
    location: 'Sundarbans', hue: 132, img: '1441974231531-c6227db76b6e',
    dates: '20–23 Jun 2026', days: 4, nights: 3, departs: 'Khulna',
    price: Base(12500, 17500, 24000), discount: 0, capacity: 30, booked: 26, male: 15, female: 11, manual: 4,
    tourType: 'Wildlife Expedition', rating: 4.8, reviews: 54,
    suitableFor: ['Friends', 'Solo', 'Photographers', 'Men', 'Women'],
    blurb: 'A 4-day live-aboard expedition deep into the mangrove channels with a forest-department naturalist — watch-towers, narrow creeks, and a real chance of spotting deer, crocs and, if you’re lucky, a tiger track.',
    plan: [
      PlanSeg('journey', 'Khulna → Mongla jetty', 'Private coach', 'Day 1 · 7:00 AM', 'Board the live-aboard boat'),
      PlanSeg('stay', 'M.V. Bonbibi (live-aboard)', 'Cabin, twin-share', 'Day 1–3', '3 nights on the river'),
      PlanSeg('activity', 'Karamjal channel cruise', 'Naturalist-led', 'Day 2 · all day', 'Deer, kingfishers, watch-tower'),
      PlanSeg('activity', 'Kotka canopy walk', 'Forest trek', 'Day 3 · AM', 'Boardwalk + tower lookout'),
      PlanSeg('journey', 'Mongla → Khulna', 'Private coach', 'Day 4 · 4:00 PM', 'Return transfer'),
    ],
    includes: ['3 nights live-aboard cabin', 'All meals on board', 'Forest permits & escort', 'Naturalist guide', 'Country-boat safaris'],
  ),
  GroupEvent(
    id: 'gev-cox', groupId: 'bandhu', title: "Cox's Bazar Long Weekend", bn: 'কক্সবাজার লং উইকেন্ড',
    location: "Cox's Bazar", hue: 196, img: '1540541338287-41700207dee6',
    dates: '5–7 Jul 2026', days: 3, nights: 2, departs: 'Dhaka',
    price: Base(7900, 11500, 18000), discount: 15, capacity: 60, booked: 24, male: 13, female: 11, manual: 8,
    tourType: 'Family & Beach', rating: 4.8, reviews: 112,
    suitableFor: ['Family', 'Couples', 'Kids', 'Men', 'Women'],
    blurb: 'An easy, all-sorted beach weekend for families and friends — beachfront resort, sunset catamaran, and plenty of free time to just be by the sea. Kid-friendly and women-led support throughout.',
    plan: [
      PlanSeg('journey', 'Dhaka → Cox’s Bazar', 'AC Night Coach', 'Day 1 · 11:00 PM', 'Reserved family seating'),
      PlanSeg('stay', 'Sayeman Beach Resort', 'Sea-view family room', 'Day 1–2', '2 nights · breakfast included'),
      PlanSeg('activity', 'Sunset catamaran cruise', 'Group sail', 'Day 2 · 5:00 PM', 'Snacks & music on board'),
      PlanSeg('activity', 'Beach free time + Inani trip', 'Optional jeep', 'Day 3 · AM', 'Visit Inani & Himchari'),
      PlanSeg('journey', 'Cox’s Bazar → Dhaka', 'AC Night Coach', 'Day 3 · 9:00 PM', 'Return overnight'),
    ],
    includes: ['Round-trip AC coach', '2 nights sea-view room', 'Daily breakfast', 'Catamaran cruise', 'Family trip host'],
  ),
  GroupEvent(
    id: 'gev-bandar', groupId: 'wanderbd', title: 'Bandarban Trek & Paraglide', bn: 'বান্দরবান ট্রেক',
    location: 'Bandarban', hue: 168, img: '1506905925346-21bda4d32df4',
    dates: '18–21 Jul 2026', days: 4, nights: 3, departs: 'Dhaka',
    price: Base(9500, 13800, 19500), discount: 0, capacity: 24, booked: 18, male: 12, female: 6, manual: 3,
    tourType: 'Adventure Group', rating: 4.9, reviews: 41,
    suitableFor: ['Students', 'Solo', 'Friends', 'Men', 'Women'],
    blurb: 'Four days in Bandarban’s folded green hills — Nilgiri summit, Nafakhum waterfall trek, and a certified tandem paraglide over the ridges at first light. For travellers who like a sweat with their views.',
    plan: [
      PlanSeg('journey', 'Dhaka → Bandarban', 'AC Night Coach', 'Day 1 · 10:30 PM', 'Overnight to the hills'),
      PlanSeg('stay', 'Hillside Eco Lodge', 'Dorm + twin options', 'Day 1–3', '3 nights · ridge views'),
      PlanSeg('activity', 'Sunrise tandem paraglide', 'Certified pilot', 'Day 2 · 6:00 AM', '15–20 min flight + GoPro'),
      PlanSeg('activity', 'Nafakhum waterfall trek', 'Full-day hike', 'Day 3 · all day', 'Boat + trail · moderate'),
      PlanSeg('journey', 'Bandarban → Dhaka', 'AC Night Coach', 'Day 4 · 8:00 PM', 'Return overnight'),
    ],
    includes: ['Round-trip AC coach', '3 nights eco lodge', 'Tandem paraglide flight', 'Guided treks & permits', '2 trip leads'],
  ),
  GroupEvent(
    id: 'gev-stmartin', groupId: 'bandhu', title: 'Saint Martin Island Hop', bn: 'সেন্ট মার্টিন',
    location: 'Saint Martin', hue: 200, img: '1544551763-46a013bb70d5',
    dates: '2–4 Aug 2026', days: 3, nights: 2, departs: 'Dhaka',
    price: Base(8800, 12500, 17500), discount: 10, capacity: 50, booked: 41, male: 22, female: 19, manual: 7,
    tourType: 'Island & Beach', rating: 4.7, reviews: 88,
    suitableFor: ['Friends', 'Couples', 'Solo', 'Men', 'Women'],
    blurb: 'Bangladesh’s only coral island, three ways — beach cycling, a discovery snorkel over the reef, and a slow Chera Dwip sunset. Crystal water, fresh seafood, zero rush.',
    plan: [
      PlanSeg('journey', 'Dhaka → Teknaf', 'AC Night Coach', 'Day 1 · 10:00 PM', 'Overnight to the coast'),
      PlanSeg('journey', 'Teknaf → Saint Martin', 'Ferry', 'Day 2 · 9:00 AM', 'Bay of Bengal crossing'),
      PlanSeg('stay', 'Blue Marine Resort', 'Beachfront cottage', 'Day 2', '1 night · steps from the reef'),
      PlanSeg('activity', 'Reef snorkel + Chera Dwip', 'Guided + boat', 'Day 2–3', 'Coral, cycling & sunset'),
      PlanSeg('journey', 'Return to Dhaka', 'Ferry + AC coach', 'Day 3 · PM', 'Arrive Day 4 AM'),
    ],
    includes: ['Round-trip coach + ferry', '1 night beachfront stay', 'Snorkel gear & guide', 'Chera Dwip boat trip', 'Trip host'],
  ),
  GroupEvent(
    id: 'gev-tea', groupId: 'hilltrek', title: 'Sreemangal Tea Trails', bn: 'শ্রীমঙ্গল চা বাগান',
    location: 'Sreemangal', hue: 95, img: '1501785888041-af3ef285b470',
    dates: '9–10 Aug 2026', days: 2, nights: 1, departs: 'Dhaka',
    price: Base(5500, 8200, 12000), discount: 0, capacity: 40, booked: 14, male: 5, female: 9, manual: 2,
    tourType: 'Relaxation', rating: 4.7, reviews: 33,
    suitableFor: ['Couples', 'Women', 'Family', 'Solo', 'Men'],
    blurb: 'A gentle weekend among the tea gardens — seven-layer tea, a Lawachara rainforest walk and a verandah breakfast at a colonial estate bungalow. The slow trip.',
    plan: [
      PlanSeg('journey', 'Dhaka → Sreemangal', 'Intercity train', 'Day 1 · 6:40 AM', 'Scenic AC chair coach'),
      PlanSeg('stay', 'Grand Tea Bungalow', 'Planter’s room', 'Day 1', '1 night inside a tea estate'),
      PlanSeg('activity', 'Tea-garden walk & tasting', 'Guided', 'Day 1 · PM', 'Plucking, factory & 7-layer tea'),
      PlanSeg('activity', 'Lawachara rainforest walk', 'Naturalist-led', 'Day 2 · AM', 'Birds & gibbons · easy'),
      PlanSeg('journey', 'Sreemangal → Dhaka', 'Intercity train', 'Day 2 · 4:00 PM', 'Evening return'),
    ],
    includes: ['Round-trip train', '1 night estate bungalow', 'Breakfast + tea tasting', 'Guided forest & garden walks', 'Trip host'],
  ),
];

const hajjGroups = <TravelGroup>[
  TravelGroup(
    id: 'almadina', kind: 'hajj', name: 'Al-Madina Travels', bn: 'আল-মদিনা ট্রাভেলস', handle: '@almadinahajj',
    verified: true, badge: 'Govt. Approved', hue: 41, img: '1565330770968-0240c0046ce3',
    rating: 4.9, reviewCount: 540, founded: '2008',
    tagline: 'Government-approved Hajj & Umrah journeys since 2008',
    bio: 'A Ministry of Religious Affairs licensed agency (Hajj Licence #1142). We run guided Hajj and Umrah kafelas with experienced Muallims, 3–5 star hotels close to the Haram, full Saudi e-visa support and a Bangla-speaking team on the ground in Makkah & Madinah.',
    stats: [(n: 160, l: 'Kafelas guided'), (n: 8400, l: 'Pilgrims'), (n: 17, l: 'Years')],
    host: GHost('Mawlana Abdul Karim', '+880 1711 990011', '19852214xxxxxx', 'hajj@almadina.com.bd', 'Naya Paltan, Dhaka 1000'),
    past: [
      PastTrip('Hajj 2025 — Premium Kafela', 'Makkah · Madinah', 'Jun 2025', 120, 4.9, 41, '1554794470-42d3cd193ecc'),
      PastTrip('Ramadan Umrah 2025', 'Makkah', 'Mar 2025', 64, 4.9, 158, '1577295605163-132e25c3c914'),
      PastTrip('Winter Umrah 2024', 'Madinah', 'Dec 2024', 48, 4.8, 41, '1565330770968-0240c0046ce3'),
    ],
    reviews: [
      Review('Abdul M.', '2 weeks ago', 5, 'My parents went for Hajj with Al-Madina. Hotel was 5 minutes from the Haram and the Muallim guided every ritual patiently.'),
      Review('Sumaiya R.', '1 month ago', 5, 'Visa, flights and ziyarah were all handled. As a woman traveller I felt fully looked after.'),
      Review('Kamrul H.', '2 months ago', 4, 'Very organised Umrah. Food was good Bengali cuisine. Only the return flight was delayed a bit.'),
    ],
  ),
  TravelGroup(
    id: 'baitullah', kind: 'hajj', name: 'Baitullah Kafela', bn: 'বায়তুল্লাহ কাফেলা', handle: '@baitullahkafela',
    verified: true, badge: 'Hajj Agency', hue: 150, img: '1577295605163-132e25c3c914',
    rating: 4.8, reviewCount: 286, founded: '2013',
    tagline: 'Comfort Umrah & Hajj kafelas — a scholar guide on every trip',
    bio: 'A boutique kafela operator focused on small, comfortable groups. Every trip travels with a Hafez/scholar guide, hotels within walking distance of the Haram, and women-led support for sisters travelling in the group.',
    stats: [(n: 92, l: 'Kafelas'), (n: 5200, l: 'Pilgrims'), (n: 12, l: 'Years')],
    host: GHost('Hafez Tariqul Islam', '+880 1819 442200', '19902236xxxxxx', 'info@baitullahkafela.com', 'Mouchak, Dhaka 1217'),
    past: [
      PastTrip('Family Umrah 2025', 'Makkah · Madinah', 'Apr 2025', 36, 4.8, 41, '1565330770968-0240c0046ce3'),
      PastTrip('Hajj 2024 Kafela', 'Makkah', 'Jun 2024', 54, 4.7, 150, '1554794470-42d3cd193ecc'),
    ],
    reviews: [
      Review('Nasir U.', '3 weeks ago', 5, 'Small group, so the guide had time for everyone. Hotel in Madinah was right by Bab-e-Salam.'),
      Review('Farhana A.', '1 month ago', 5, 'Took my whole family including my elderly mother. Wheelchair help was arranged at every step.'),
    ],
  ),
];

const hajjEvents = <GroupEvent>[
  GroupEvent(
    id: 'hev-umrah10', groupId: 'almadina', title: 'Umrah Premium — 10 Days', bn: 'উমরাহ প্রিমিয়াম',
    location: 'Makkah · Madinah', hue: 41, img: '1565330770968-0240c0046ce3',
    dates: '5–14 Sep 2026', days: 10, nights: 9, departs: 'Dhaka',
    price: Base(185000, 235000, 320000), discount: 0, capacity: 40, booked: 28, male: 16, female: 12, manual: 5,
    tourType: 'Umrah', rating: 4.9, reviews: 64,
    suitableFor: ['Family', 'Couples', 'First-timers', 'Women', 'Men'],
    blurb: 'A comfortable 10-day Umrah with 5-star hotels a short walk from both Harams, a Bangla-speaking Muallim for every ritual, and guided ziyarah in Makkah and Madinah. Visa, flights and transfers fully arranged.',
    plan: [
      PlanSeg('journey', 'Dhaka → Jeddah', 'Biman / Saudia direct flight', 'Day 1', 'Group check-in · ~6h flight'),
      PlanSeg('journey', 'Jeddah → Makkah', 'AC coach transfer', 'Day 1', 'Ihram from the airport · ~1.5h'),
      PlanSeg('stay', 'Swissôtel Al Maqam, Makkah', 'Twin / quad rooms', 'Day 1–6', '5 nights · steps from Masjid al-Haram'),
      PlanSeg('activity', 'Umrah rituals — Tawaf & Sa’i', 'Muallim-guided', 'Day 2', 'Ihram, Tawaf, Sa’i, halq'),
      PlanSeg('activity', 'Makkah ziyarah', 'Guided tour', 'Day 4', 'Mina, Arafat, Jabal al-Nour, Hira'),
      PlanSeg('journey', 'Makkah → Madinah', 'Haramain high-speed train', 'Day 6', '~2.5h · reserved seats'),
      PlanSeg('stay', 'Anwar Al Madinah Mövenpick', 'Twin / quad rooms', 'Day 6–9', '3 nights · facing Masjid an-Nabawi'),
      PlanSeg('activity', 'Riyadul Jannah & Madinah ziyarah', 'Guided', 'Day 7', 'Quba, Uhud, the Prophet’s ﷺ Rawdah'),
      PlanSeg('journey', 'Madinah → Jeddah → Dhaka', 'Coach + return flight', 'Day 10', 'Return overnight'),
    ],
    includes: ['Return air tickets', 'Saudi Umrah e-visa', '5★ hotels near both Harams', 'All AC transfers + Haramain train', 'Daily breakfast & dinner', 'Experienced Muallim guide', 'Guided ziyarah tours', 'Zamzam water (5L)'],
  ),
  GroupEvent(
    id: 'hev-hajj', groupId: 'almadina', title: 'Hajj 2027 — Premium Package', bn: 'হজ্জ প্রিমিয়াম প্যাকেজ',
    location: 'Makkah · Mina · Madinah', hue: 38, img: '1554794470-42d3cd193ecc',
    dates: '18 May–22 Jun 2027', days: 36, nights: 35, departs: 'Dhaka',
    price: Base(720000, 920000, 1250000), discount: 0, capacity: 120, booked: 86, male: 47, female: 39, manual: 14,
    tourType: 'Hajj', rating: 4.9, reviews: 38,
    suitableFor: ['Family', 'Couples', 'Elderly', 'Women', 'Men'],
    blurb: 'A complete guided Hajj with non-shifting 5-star hotels near the Haram, air-conditioned Mina tents in the closest zone, full Muallim and medical support, and an experienced team that has led Bangladeshi pilgrims for 17 years.',
    plan: [
      PlanSeg('journey', 'Dhaka → Jeddah / Madinah', 'Group flight', 'Day 1', 'Hajj flight · group check-in'),
      PlanSeg('stay', 'Madinah — 8 nights', 'Hotel near Masjid an-Nabawi', 'Day 1–9', '40 days Hajj · Madinah first'),
      PlanSeg('stay', 'Makkah — non-shifting hotel', 'Near Masjid al-Haram', 'Day 9–30', 'Same hotel throughout · no shifting'),
      PlanSeg('activity', 'The days of Hajj', 'Mina · Arafat · Muzdalifah', '8–13 Dhul-Hijjah', 'AC tents in Mina (Zone closest) + full guidance'),
      PlanSeg('activity', 'Tawaf al-Ziyarah & Jamarat', 'Muallim-guided', '10–12 Dhul-Hijjah', 'Stoning, Tawaf, Sa’i, qurbani arranged'),
      PlanSeg('journey', 'Return to Dhaka', 'Group flight', 'Day 36', 'After completing Hajj'),
    ],
    includes: ['Return Hajj air tickets', 'Hajj visa & Mofa', 'Non-shifting 5★ Makkah hotel', 'AC Mina tents (closest zone)', 'All meals (Bengali cuisine)', 'Qurbani / dam included', 'Muallim + medical team', 'Trained Bangla guides'],
  ),
  GroupEvent(
    id: 'hev-umrah-eco', groupId: 'baitullah', title: 'Umrah Economy — 14 Days', bn: 'উমরাহ ইকোনমি',
    location: 'Makkah · Madinah', hue: 150, img: '1577295605163-132e25c3c914',
    dates: '2–15 Oct 2026', days: 14, nights: 13, departs: 'Dhaka',
    price: Base(135000, 168000, 210000), discount: 8, capacity: 45, booked: 19, male: 10, female: 9, manual: 3,
    tourType: 'Umrah', rating: 4.7, reviews: 41,
    suitableFor: ['Students', 'First-timers', 'Family', 'Women', 'Men'],
    blurb: 'A value 14-day Umrah for first-timers and students — clean 3-star hotels within walking distance of the Haram, a scholar guide on the trip, and a relaxed schedule with plenty of ibadah time. Visa and flights included.',
    plan: [
      PlanSeg('journey', 'Dhaka → Jeddah', 'Connecting flight', 'Day 1', 'Ihram en route'),
      PlanSeg('journey', 'Jeddah → Makkah', 'AC coach', 'Day 1', '~1.5h transfer'),
      PlanSeg('stay', '3★ hotel, Makkah', 'Quad sharing', 'Day 1–8', '7 nights · ~700m to the Haram'),
      PlanSeg('activity', 'Umrah — Tawaf & Sa’i', 'Scholar-guided', 'Day 2', 'Full ritual walkthrough'),
      PlanSeg('activity', 'Makkah ziyarah', 'Group tour', 'Day 4', 'Historic sites of Makkah'),
      PlanSeg('journey', 'Makkah → Madinah', 'AC coach', 'Day 8', '~5h scenic transfer'),
      PlanSeg('stay', '3★ hotel, Madinah', 'Quad sharing', 'Day 8–13', '5 nights · near the Haram'),
      PlanSeg('activity', 'Madinah ziyarah', 'Guided', 'Day 10', 'Quba, Uhud, Masjid Qiblatain'),
      PlanSeg('journey', 'Madinah → Dhaka', 'Return flight', 'Day 14', 'Via Jeddah'),
    ],
    includes: ['Return air tickets', 'Saudi Umrah e-visa', '3★ hotels near both Harams', 'All ground transfers', 'Daily breakfast', 'Scholar guide', 'Ziyarah tours', 'Zamzam water'],
  ),
  GroupEvent(
    id: 'hev-umrah-family', groupId: 'baitullah', title: 'Family Umrah Special — 12 Days', bn: 'ফ্যামিলি উমরাহ',
    location: 'Makkah · Madinah', hue: 35, img: '1554794470-42d3cd193ecc',
    dates: '20–31 Dec 2026', days: 12, nights: 11, departs: 'Dhaka',
    price: Base(165000, 205000, 280000), discount: 0, capacity: 30, booked: 12, male: 6, female: 6, manual: 2,
    tourType: 'Umrah', rating: 4.8, reviews: 22,
    suitableFor: ['Families', 'Couples', 'Elderly', 'Women', 'Men'],
    blurb: 'A winter-break Umrah built for families — private family rooms, slower pace, wheelchair and child support, and women-led help for the sisters. Close hotels mean less walking for elders and little ones.',
    plan: [
      PlanSeg('journey', 'Dhaka → Jeddah', 'Direct flight', 'Day 1', 'Family seating arranged'),
      PlanSeg('journey', 'Jeddah → Makkah', 'Private AC coach', 'Day 1', 'Ihram from Jeddah'),
      PlanSeg('stay', '4★ family rooms, Makkah', 'Private family rooms', 'Day 1–7', '6 nights · ~400m to the Haram'),
      PlanSeg('activity', 'Umrah with family support', 'Guided · wheelchair help', 'Day 2', 'Tawaf, Sa’i at a gentle pace'),
      PlanSeg('activity', 'Makkah ziyarah', 'Family coach tour', 'Day 4', 'Kid-friendly schedule'),
      PlanSeg('journey', 'Makkah → Madinah', 'Haramain train', 'Day 7', 'Comfortable ~2.5h'),
      PlanSeg('stay', '4★ family rooms, Madinah', 'Private family rooms', 'Day 7–11', '4 nights · near Masjid an-Nabawi'),
      PlanSeg('activity', 'Madinah ziyarah', 'Guided', 'Day 9', 'Quba, Uhud & the Rawdah'),
      PlanSeg('journey', 'Madinah → Dhaka', 'Return flight', 'Day 12', 'Via Jeddah'),
    ],
    includes: ['Return air tickets', 'Saudi Umrah e-visa', '4★ family rooms near Harams', 'Private transfers + train', 'Breakfast & dinner', 'Wheelchair & child support', 'Women-led group support', 'Guided ziyarah'],
  ),
];

const invigilators = <Invigilator>[
  Invigilator('Mahmud Rahman', '1507003211169-0a1dd7228f2d', '2022', 140, 'TS-INV-04', 'Bangla · English'),
  Invigilator('Tahmina Sultana', '1544005313-94ddf0286df2', '2021', 210, 'TS-INV-02', 'Bangla · English'),
  Invigilator('Rezaul Karim', '1500648767791-00dcc994a43e', '2023', 88, 'TS-INV-09', 'Bangla · English · Hindi'),
  Invigilator('Farhana Islam', '1438761681033-6461ffad8d80', '2020', 265, 'TS-INV-01', 'Bangla · English'),
];

Invigilator invigilatorFor(GroupEvent ev) {
  final key = ev.id.codeUnits.fold<int>(0, (a, c) => a + c);
  return invigilators[key % invigilators.length];
}

TravelGroup? groupById(String id) {
  for (final g in travelGroups) {
    if (g.id == id) return g;
  }
  for (final g in hajjGroups) {
    if (g.id == id) return g;
  }
  return null;
}

List<GroupEvent> eventsByGroup(String id) =>
    [...groupEvents, ...hajjEvents].where((e) => e.groupId == id).toList();

const chatThreads = <String, ChatThread>{
  'gev-sajek': ChatThread('Wander BD', 'Hosts Sajek Valley Cloud Chase', 168, '1521336575822-6da63fb45455', true, [
    ChatMsg('host', 'Assalamu alaikum! Thanks for your interest in the Sajek trip 🌄 Happy to answer anything.', '9:02 AM'),
    ChatMsg('me', 'Hi! Is the bus pickup from Gulshan or only Fakirapool?', '9:05 AM'),
    ChatMsg('host', 'We have a Gulshan-1 pickup at 9:30 PM, then the main counter at Fakirapool. I’ll note Gulshan for you.', '9:06 AM'),
    ChatMsg('me', 'Perfect. And is the Konglak trek hard for a beginner?', '9:08 AM'),
    ChatMsg('host', 'Not at all — about 40 min uphill, we go slow for sunrise. Just bring trainers 👟', '9:09 AM'),
  ]),
  'gev-sundar': ChatThread('Hill Trekkers Club', 'Hosts Sundarbans Expedition', 150, '1441974231531-c6227db76b6e', false, [
    ChatMsg('host', 'Hello! The live-aboard has 14 cabins left. Are you travelling solo or as a group?', 'Yesterday'),
    ChatMsg('me', 'Solo. Is there a single-occupancy option?', 'Yesterday'),
    ChatMsg('host', 'Yes, single supplement is ৳3,500. I can twin-share you with another solo traveller to skip it too.', 'Yesterday'),
  ]),
  'sayeman': ChatThread('Sayeman Beach Resort', 'Resort · replies in ~5 min', 196, '1540541338287-41700207dee6', true, [
    ChatMsg('host', 'Welcome to Sayeman! How can we help with your stay? 🏖️', '10:14 AM'),
    ChatMsg('me', 'Do sea-view suites have a bathtub?', '10:20 AM'),
    ChatMsg('host', 'Yes, all sea-view suites include a tub and a private balcony facing the bay.', '10:21 AM'),
  ]),
  'paraglide': ChatThread('Bandarban Paragliding', 'Activity host · replies fast', 168, '1521336575822-6da63fb45455', true, [
    ChatMsg('host', 'Morning! Flights run 6–9 AM daily, weather permitting 🪂', '8:30 AM'),
    ChatMsg('me', 'What’s the weight limit for tandem?', '8:41 AM'),
    ChatMsg('host', 'Up to 95kg for tandem. We’ll confirm on the day with the pilot.', '8:42 AM'),
  ]),
};

ChatThread chatFor(String id, {required String name, required String sub, required int hue, String? img, bool verified = false}) {
  return chatThreads[id] ??
      ChatThread(name, sub, hue, img, verified, [
        ChatMsg('host', 'Hi! Thanks for reaching out about $name. How can I help? 😊', 'Now'),
      ]);
}
