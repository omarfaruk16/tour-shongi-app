import 'package:flutter/material.dart';
import '../../core/theme.dart';
import '../../core/icons.dart';
import '../../data/models.dart';
import '../../data/content.dart';
import '../../nav.dart';
import '../../widgets/photo.dart';
import '../../widgets/ui.dart';
import '../../widgets/anim.dart';

const _meta = <String, ({String title, String sub})>{
  'bookings': (title: 'My bookings', sub: 'Your trips, past & upcoming'),
  'wallet': (title: 'Wallet & rewards', sub: 'Balance, points & history'),
  'offers': (title: 'Offers & coupons', sub: 'Deals you can use today'),
  'host': (title: 'Become a host', sub: 'List your stay or activity'),
  'postreel': (title: 'Post a reel', sub: 'Share a moment with travellers'),
  'details': (title: 'Personal details', sub: 'Manage your information'),
  'privacy': (title: 'Privacy & security', sub: 'Control your account safety'),
  'notif': (title: 'Notifications', sub: 'Choose what reaches you'),
  'help': (title: 'Help & support', sub: 'We’re here around the clock'),
  'settings': (title: 'Settings', sub: 'App & account preferences'),
};

class ProfileDetailScreen extends StatelessWidget {
  final String route;
  final VoidCallback? onLogout;
  final void Function(Listing)? onOpen;
  const ProfileDetailScreen({super.key, required this.route, this.onLogout, this.onOpen});

  @override
  Widget build(BuildContext context) {
    final m = _meta[route] ?? (title: 'Details', sub: '');
    final topPad = MediaQuery.of(context).padding.top;
    final children = _content(context);
    return Scaffold(
      backgroundColor: C.cloud,
      body: Column(children: [
        Container(
          padding: EdgeInsets.fromLTRB(14, topPad + 8, 14, 16),
          decoration: const BoxDecoration(gradient: G.greenGlass, boxShadow: [BoxShadow(color: Color(0x2E0B5A4A), blurRadius: 20, offset: Offset(0, 6))]),
          child: Row(children: [
            GestureDetector(onTap: () => Navigator.pop(context), child: Container(width: 40, height: 40, decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.2), shape: BoxShape.circle), child: const Ic('chevL', size: 22, color: Colors.white))),
            const SizedBox(width: 10),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
              Text(m.title, style: T.d(20, w: FontWeight.w800, color: Colors.white, spacing: -0.3)),
              if (m.sub.isNotEmpty) Text(m.sub, style: T.b(12, w: FontWeight.w500, color: Colors.white.withValues(alpha: 0.85))),
            ])),
          ]),
        ),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
            children: [
              for (int i = 0; i < children.length; i++)
                Padding(padding: const EdgeInsets.only(bottom: 18), child: StaggerIn(index: i, child: children[i])),
            ],
          ),
        ),
      ]),
    );
  }

  List<Widget> _content(BuildContext context) {
    switch (route) {
      case 'bookings':
        return [const _Bookings()];
      case 'wallet':
        return _wallet();
      case 'offers':
        return [const _Offers()];
      case 'host':
        return _host();
      case 'postreel':
        return [const _PostReel()];
      case 'details':
        return _details();
      case 'privacy':
        return [const _Privacy()];
      case 'notif':
        return [const _Notif()];
      case 'help':
        return [const _Help()];
      case 'settings':
        return [_Settings(onLogout: onLogout)];
      default:
        return [Text('Coming soon', style: T.b(14, color: C.slate))];
    }
  }

  List<Widget> _wallet() => const [_Wallet()];

  List<Widget> _host() => [
        ClipRRect(
          borderRadius: BorderRadius.circular(22),
          child: SizedBox(
            height: 178,
            child: Stack(fit: StackFit.expand, children: [
              Image.network(unsplash('1564013799919-ab600027ffc6', 700), fit: BoxFit.cover, errorBuilder: (_, _, _) => Container(color: C.emeraldDark)),
              const DecoratedBox(decoration: BoxDecoration(gradient: G.greenGlass)),
              Positioned(left: 18, right: 18, bottom: 16, child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
                Text('Share your corner of Bangladesh', style: T.d(24, w: FontWeight.w800, color: Colors.white, height: 1.1, spacing: -0.4)),
                const SizedBox(height: 5),
                Text('Hosts earn an average of ৳42,000 / month', style: T.b(13, w: FontWeight.w500, color: Colors.white.withValues(alpha: 0.92))),
              ])),
            ]),
          ),
        ),
        for (final b in const [(ic: 'wallet', t: 'Earn on your terms', d: 'Set your own prices and availability across all three tiers.'), (ic: 'shield', t: 'Protected payouts', d: 'Guaranteed payouts within 24h of guest check-in, every time.'), (ic: 'headset', t: 'Host support 24/7', d: 'A dedicated team in Dhaka, plus damage cover up to ৳5,00,000.')])
          _benefit(b.ic, b.t, b.d),
        TSButton(full: true, large: true, onTap: () {}, child: const Row(mainAxisSize: MainAxisSize.min, children: [Ic('compass', size: 19, color: Colors.white), SizedBox(width: 8), Text('Start hosting')])),
      ];

  Widget _benefit(String ic, String t, String d) => Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(color: C.surface, borderRadius: BorderRadius.circular(18), border: Border.all(color: C.hairline), boxShadow: S.card),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(width: 42, height: 42, decoration: BoxDecoration(color: C.emeraldTint, borderRadius: BorderRadius.circular(13)), child: Ic(ic, size: 21, color: C.emeraldDark)),
          const SizedBox(width: 13),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
            Text(t, style: T.d(14.5, w: FontWeight.w700)),
            Text(d, style: T.b(12.5, w: FontWeight.w500, color: C.slate, height: 1.45)),
          ])),
        ]),
      );

  List<Widget> _details() {
    final fields = [
      (ic: 'user', l: 'Full name', v: user.name),
      (ic: 'mail', l: 'Email', v: user.email),
      (ic: 'phone', l: 'Phone', v: '+880 1712 345678'),
      (ic: 'cal', l: 'Date of birth', v: '14 Aug 1996'),
      (ic: 'pin', l: 'Address', v: 'Gulshan 2, Dhaka 1212'),
      (ic: 'globe', l: 'Nationality', v: 'Bangladeshi'),
    ];
    return [
      Column(children: [
        Stack(children: [
          Container(width: 86, height: 86, decoration: BoxDecoration(color: hsl(user.hue.toDouble(), 0.45, 0.58), shape: BoxShape.circle), alignment: Alignment.center, child: Text(user.initials, style: T.d(30, w: FontWeight.w800, color: Colors.white))),
          Positioned(bottom: 0, right: 0, child: Container(width: 30, height: 30, decoration: BoxDecoration(color: C.emerald, shape: BoxShape.circle, border: Border.all(color: C.cloud, width: 3)), child: const Ic('camera', size: 14, color: Colors.white))),
        ]),
        const SizedBox(height: 8),
        Text('Change photo', style: T.b(13, w: FontWeight.w600, color: C.emerald)),
      ]),
      _PDCard(children: [
        for (int i = 0; i < fields.length; i++)
          _PDRow(icon: fields[i].ic, label: fields[i].l, value: fields[i].v, last: i == fields.length - 1, trailing: const Ic('edit', size: 16, color: C.mist)),
      ]),
      TSButton(full: true, large: true, onTap: () {}, child: const Row(mainAxisSize: MainAxisSize.min, children: [Icon(Icons.check_rounded, size: 19, color: Colors.white), SizedBox(width: 8), Text('Save changes')])),
    ];
  }
}

// ── Shared bits ──
class _PDCard extends StatelessWidget {
  final List<Widget> children;
  const _PDCard({required this.children});
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: C.surface, borderRadius: BorderRadius.circular(18), border: Border.all(color: C.hairline), boxShadow: S.card),
      clipBehavior: Clip.antiAlias,
      child: Column(children: children),
    );
  }
}

class _PDRow extends StatelessWidget {
  final String? icon;
  final String label;
  final String? value;
  final Widget? trailing;
  final VoidCallback? onTap;
  final bool last, danger;
  const _PDRow({this.icon, required this.label, this.value, this.trailing, this.onTap, this.last = false}) : danger = false;
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(children: [
            if (icon != null) ...[
              Container(width: 38, height: 38, decoration: BoxDecoration(color: danger ? Color.alphaBlend(C.error.withValues(alpha: 0.1), Colors.white) : C.emeraldTint, borderRadius: BorderRadius.circular(12)), child: Ic(icon!, size: 19, color: danger ? C.error : C.emeraldDark)),
              const SizedBox(width: 13),
            ],
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
              Text(label, style: T.b(14, w: FontWeight.w600, color: danger ? C.error : C.ink)),
              if (value != null) Text(value!, style: T.b(12.5, w: FontWeight.w500, color: C.mist)),
            ])),
            trailing ?? (onTap != null ? const Ic('chevR', size: 17, color: C.mist) : const SizedBox.shrink()),
          ]),
        ),
      ),
      if (!last) Padding(padding: EdgeInsets.only(left: icon != null ? 65 : 14), child: const Divider(height: 1, color: C.hairline)),
    ]);
  }
}

class _PDSwitch extends StatelessWidget {
  final bool on;
  final VoidCallback onToggle;
  const _PDSwitch(this.on, this.onToggle);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onToggle,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        width: 46,
        height: 28,
        decoration: BoxDecoration(gradient: on ? G.emerald : null, color: on ? null : C.hairline, borderRadius: BorderRadius.circular(999)),
        child: AnimatedAlign(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOutBack,
          alignment: on ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(margin: const EdgeInsets.all(3), width: 22, height: 22, decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle, boxShadow: [BoxShadow(color: Color(0x4014201D), blurRadius: 6, offset: Offset(0, 2))])),
        ),
      ),
    );
  }
}

Widget _pdLabel(String t) => Padding(padding: const EdgeInsets.only(left: 2, bottom: 10), child: Text(t.toUpperCase(), style: T.b(12, w: FontWeight.w700, color: C.mist, spacing: 0.6)));

// ── Bookings ──
class _Bookings extends StatefulWidget {
  const _Bookings();
  @override
  State<_Bookings> createState() => _BookingsState();
}

class _BookingsState extends State<_Bookings> {
  String seg = 'upcoming';
  @override
  Widget build(BuildContext context) {
    final upcoming = [
      (item: hotels[0], dates: '12–15 Jun 2026', nights: 3, status: 'Confirmed', code: 'TS-9F2K', guests: 2),
      (item: activities[0], dates: '14 Jun 2026', nights: 0, status: 'Confirmed', code: 'TS-3A7P', guests: 2),
    ];
    final past = [
      (item: hotels[3], dates: '2–4 Mar 2026', nights: 2, status: 'Completed', code: 'TS-7K1B', guests: 2),
      (item: activities[2], dates: '18 Jan 2026', nights: 0, status: 'Completed', code: 'TS-5D9X', guests: 4),
    ];
    final list = seg == 'upcoming' ? upcoming : past;
    return Column(children: [
      Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(color: C.emeraldTint, borderRadius: BorderRadius.circular(16)),
        child: Row(children: [_seg('upcoming', 'Upcoming', upcoming.length), _seg('past', 'Past', past.length)]),
      ),
      const SizedBox(height: 14),
      for (final b in list)
        Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: _PDCard(children: [
            Padding(
              padding: const EdgeInsets.all(12),
              child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                SizedBox(width: 88, height: 88, child: Photo(src: unsplash(b.item.img, 280), hue: b.item.hue, height: 88, radius: 14)),
                const SizedBox(width: 12),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
                  Row(children: [
                    Expanded(child: Text(b.item.isActivity ? 'ACTIVITY' : 'STAY', style: T.b(10, w: FontWeight.w600, color: b.item.isActivity ? C.emerald : C.info, spacing: 0.6))),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
                      decoration: BoxDecoration(color: b.status == 'Completed' ? C.cloud : Color.alphaBlend(C.success.withValues(alpha: 0.12), Colors.white), borderRadius: BorderRadius.circular(999)),
                      child: Row(mainAxisSize: MainAxisSize.min, children: [Container(width: 6, height: 6, decoration: BoxDecoration(color: b.status == 'Completed' ? C.mist : C.success, shape: BoxShape.circle)), const SizedBox(width: 5), Text(b.status, style: T.b(10, w: FontWeight.w700, color: b.status == 'Completed' ? C.slate : C.success))]),
                    ),
                  ]),
                  const SizedBox(height: 4),
                  Text(b.item.name, maxLines: 1, overflow: TextOverflow.ellipsis, style: T.d(15, w: FontWeight.w700, height: 1.2, spacing: -0.2)),
                  const SizedBox(height: 5),
                  Row(children: [const Ic('cal', size: 13, color: C.emerald), const SizedBox(width: 5), Text(b.dates, style: T.b(12, w: FontWeight.w500, color: C.slate))]),
                  const SizedBox(height: 3),
                  Row(children: [const Ic('users', size: 13, color: C.mist), const SizedBox(width: 5), Text('${b.guests} guests${b.nights > 0 ? ' · ${b.nights} nights' : ''}', style: T.b(12, w: FontWeight.w500, color: C.mist))]),
                  Text('#${b.code}', style: T.b(11, w: FontWeight.w500, color: C.mist)),
                ])),
              ]),
            ),
            const Divider(height: 1, color: C.hairline),
            Row(children: [
              for (final a in (b.status == 'Completed' ? const [(ic: 'receipt', l: 'Receipt'), (ic: 'star', l: 'Review')] : const [(ic: 'map', l: 'Directions'), (ic: 'headset', l: 'Manage')]))
                Expanded(
                  child: InkWell(
                    onTap: () => _openBkSheet(context, a.l, item: b.item, code: b.code, dates: b.dates, guests: b.guests, nights: b.nights),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(border: a.l == 'Review' || a.l == 'Manage' ? const Border(left: BorderSide(color: C.hairline)) : null),
                      child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [Ic(a.ic, size: 16, color: C.emerald), const SizedBox(width: 7), Text(a.l, style: T.d(13, w: FontWeight.w700, color: C.emeraldDark))]),
                    ),
                  ),
                ),
            ]),
          ]),
        ),
    ]);
  }

  Widget _seg(String v, String label, int n) {
    final on = seg == v;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => seg = v),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(color: on ? C.surface : Colors.transparent, borderRadius: BorderRadius.circular(12), boxShadow: on ? S.card : null),
          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [Text(label, style: T.d(13, w: FontWeight.w700, color: on ? C.emeraldDark : C.slate)), const SizedBox(width: 6), Text('$n', style: T.b(11, w: FontWeight.w700, color: on ? C.emerald : C.mist))]),
        ),
      ),
    );
  }
}

// ── Booking action sheets ──
void _openBkSheet(BuildContext context, String label, {required Listing item, required String code, required String dates, required int guests, required int nights}) {
  Widget body;
  switch (label) {
    case 'Receipt':
      body = _ReceiptSheet(item: item, code: code, dates: dates, guests: guests, nights: nights);
      break;
    case 'Review':
      body = _ReviewSheet(item: item);
      break;
    case 'Directions':
      body = _DirectionsSheet(item: item);
      break;
    default:
      body = _ManageSheet(item: item, code: code);
  }
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    barrierColor: const Color(0x7314201D),
    builder: (_) => body,
  );
}

class _BkSheet extends StatelessWidget {
  final String icon, title;
  final String? sub;
  final Color iconBg, iconCol;
  final List<Widget> children;
  const _BkSheet({required this.icon, required this.title, this.sub, this.iconBg = C.emeraldTint, this.iconCol = C.emeraldDark, required this.children});
  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.9),
      decoration: const BoxDecoration(color: C.surface, borderRadius: BorderRadius.vertical(top: Radius.circular(28))),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        const SizedBox(height: 12),
        Container(width: 40, height: 5, decoration: BoxDecoration(color: C.hairline, borderRadius: BorderRadius.circular(99))),
        const SizedBox(height: 16),
        Flexible(
          child: SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(20, 0, 20, 28 + MediaQuery.of(context).padding.bottom),
            child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
              Row(children: [
                Container(width: 44, height: 44, decoration: BoxDecoration(color: iconBg, borderRadius: BorderRadius.circular(13)), child: Ic(icon, size: 22, color: iconCol)),
                const SizedBox(width: 11),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
                  Text(title, style: T.d(18, w: FontWeight.w800)),
                  if (sub != null) Text(sub!, style: T.b(12, w: FontWeight.w500, color: C.mist)),
                ])),
                GestureDetector(onTap: () => Navigator.pop(context), child: Container(width: 34, height: 34, decoration: BoxDecoration(color: C.surface, shape: BoxShape.circle, border: Border.all(color: C.hairline)), child: const Ic('x', size: 16, color: C.slate))),
              ]),
              const SizedBox(height: 18),
              ...children,
            ]),
          ),
        ),
      ]),
    );
  }
}

class _ReceiptSheet extends StatelessWidget {
  final Listing item;
  final String code, dates;
  final int guests, nights;
  const _ReceiptSheet({required this.item, required this.code, required this.dates, required this.guests, required this.nights});
  @override
  Widget build(BuildContext context) {
    final unit = item.base.premium;
    final sub = unit * (nights < 1 ? 1 : nights) * guests;
    final vat = (sub * 0.05).round();
    final total = sub + vat;
    Widget line(String l, String v, {bool bold = false}) => Padding(
          padding: EdgeInsets.only(top: bold ? 12 : 5, bottom: bold ? 0 : 5),
          child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text(l, style: bold ? T.d(15, w: FontWeight.w800) : T.b(13, w: FontWeight.w500, color: C.slate)),
            Text(v, style: bold ? T.d(15, w: FontWeight.w800, color: C.emeraldDark) : T.b(13, w: FontWeight.w600)),
          ]),
        );
    return _BkSheet(icon: 'receipt', title: 'Receipt', sub: 'Booking #$code', children: [
      Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: C.cloud, borderRadius: BorderRadius.circular(18), border: Border.all(color: C.hairline)),
        child: Column(children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Row(children: [
              Container(width: 30, height: 30, decoration: BoxDecoration(color: C.emerald, borderRadius: BorderRadius.circular(8)), child: const Ic('compass', size: 17, color: Colors.white)),
              const SizedBox(width: 8),
              Text('Tour Shongi', style: T.d(15, w: FontWeight.w800)),
              const Spacer(),
              Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4), decoration: BoxDecoration(color: Color.alphaBlend(C.success.withValues(alpha: 0.12), Colors.white), borderRadius: BorderRadius.circular(999)), child: Text('Paid', style: T.b(11, w: FontWeight.w600, color: C.success))),
            ]),
          ),
          const Divider(height: 1, color: C.hairline),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(item.name, style: T.d(14, w: FontWeight.w700)),
              Text('$dates · $guests guests${nights > 0 ? ' · $nights nights' : ''}', style: T.b(12, w: FontWeight.w500, color: C.mist)),
            ]),
          ),
          const Divider(height: 1, color: C.hairline),
          line('${taka(unit)} × ${nights < 1 ? 1 : nights}${nights > 0 ? 'n' : ' ticket'} × $guests', taka(sub)),
          line('VAT (5%)', taka(vat)),
          line('Total paid', taka(total), bold: true),
        ]),
      ),
      const SizedBox(height: 16),
      Row(children: [
        Expanded(child: TSButton(variant: BtnVariant.ghost, full: true, onTap: () => Navigator.pop(context), child: const Row(mainAxisSize: MainAxisSize.min, children: [Ic('mail', size: 18, color: C.emeraldDark), SizedBox(width: 6), Text('Email')]))),
        const SizedBox(width: 10),
        Expanded(child: TSButton(full: true, onTap: () => Navigator.pop(context), child: const Row(mainAxisSize: MainAxisSize.min, children: [Ic('receipt', size: 18, color: Colors.white), SizedBox(width: 6), Text('Download PDF')]))),
      ]),
    ]);
  }
}

class _ReviewSheet extends StatefulWidget {
  final Listing item;
  const _ReviewSheet({required this.item});
  @override
  State<_ReviewSheet> createState() => _ReviewSheetState();
}

class _ReviewSheetState extends State<_ReviewSheet> {
  int stars = 5;
  bool done = false;
  @override
  Widget build(BuildContext context) {
    if (done) {
      return _BkSheet(icon: 'star', title: 'Thank you!', sub: 'Your review is live', iconBg: Color.alphaBlend(C.saffron.withValues(alpha: 0.16), Colors.white), iconCol: C.saffronDark, children: [
        Column(children: [
          Container(width: 60, height: 60, decoration: BoxDecoration(color: Color.alphaBlend(C.success.withValues(alpha: 0.14), Colors.white), shape: BoxShape.circle), child: const Icon(Icons.check_rounded, size: 30, color: C.success)),
          const SizedBox(height: 14),
          Text('Thanks for helping other travellers choose well.', textAlign: TextAlign.center, style: T.b(13, w: FontWeight.w500, color: C.slate)),
        ]),
      ]);
    }
    const labels = ['', 'Poor', 'Fair', 'Good', 'Great', 'Excellent'];
    return _BkSheet(icon: 'star', title: 'Write a review', sub: widget.item.name, iconBg: Color.alphaBlend(C.saffron.withValues(alpha: 0.16), Colors.white), iconCol: C.saffronDark, children: [
      Center(
        child: Column(children: [
          Row(mainAxisSize: MainAxisSize.min, children: [
            for (int i = 1; i <= 5; i++)
              GestureDetector(
                onTap: () => setState(() => stars = i),
                child: Padding(padding: const EdgeInsets.all(2), child: Icon(i <= stars ? Icons.star_rounded : Icons.star_border_rounded, size: 36, color: C.saffron)),
              ),
          ]),
          const SizedBox(height: 6),
          Text(labels[stars], style: T.d(13, w: FontWeight.w700, color: C.slate)),
        ]),
      ),
      const SizedBox(height: 16),
      Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(color: C.cloud, borderRadius: BorderRadius.circular(16), border: Border.all(color: C.hairline)),
        child: TextField(maxLines: 4, style: T.b(14, w: FontWeight.w500), decoration: InputDecoration(border: InputBorder.none, isDense: true, hintText: 'Share details of your experience…', hintStyle: T.b(14, w: FontWeight.w500, color: C.mist))),
      ),
      const SizedBox(height: 16),
      TSButton(full: true, large: true, onTap: () => setState(() => done = true), child: const Row(mainAxisSize: MainAxisSize.min, children: [Ic('send', size: 18, color: Colors.white), SizedBox(width: 6), Text('Post review')])),
    ]);
  }
}

class _DirectionsSheet extends StatelessWidget {
  final Listing item;
  const _DirectionsSheet({required this.item});
  @override
  Widget build(BuildContext context) {
    return _BkSheet(icon: 'map', title: 'Directions', sub: item.location, iconBg: Color.alphaBlend(C.info.withValues(alpha: 0.14), Colors.white), iconCol: C.info, children: [
      Container(
        height: 150,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(18), border: Border.all(color: C.hairline), gradient: const LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [Color(0xFFDBE7E2), Color(0xFFCFE0DB)])),
        child: const Center(child: Ic('pin', size: 30, color: C.emeraldDark)),
      ),
      const SizedBox(height: 14),
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(color: C.cloud, borderRadius: BorderRadius.circular(14), border: Border.all(color: C.hairline)),
        child: Row(children: [
          const Ic('pin', size: 18, color: C.emerald),
          const SizedBox(width: 9),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
            Text(item.name, style: T.d(13.5, w: FontWeight.w700)),
            Text('${item.location} · ~285 km from Dhaka', style: T.b(12, w: FontWeight.w500, color: C.mist)),
          ])),
        ]),
      ),
      const SizedBox(height: 14),
      Row(children: [
        for (final m in const [(ic: 'compass', l: 'Drive', t: '4h 30m'), (ic: 'users', l: 'Bus', t: '6h 10m'), (ic: 'send', l: 'Flight', t: '1h 05m')]) ...[
          Expanded(child: Container(
            padding: const EdgeInsets.symmetric(vertical: 11, horizontal: 6),
            decoration: BoxDecoration(color: C.surface, borderRadius: BorderRadius.circular(13), border: Border.all(color: C.hairline)),
            child: Column(children: [Ic(m.ic, size: 18, color: C.emeraldDark), const SizedBox(height: 4), Text(m.l, style: T.d(12, w: FontWeight.w700)), Text(m.t, style: T.b(11, w: FontWeight.w500, color: C.mist))]),
          )),
          if (m.l != 'Flight') const SizedBox(width: 8),
        ],
      ]),
      const SizedBox(height: 16),
      TSButton(full: true, large: true, onTap: () => Navigator.pop(context), child: const Row(mainAxisSize: MainAxisSize.min, children: [Ic('map', size: 18, color: Colors.white), SizedBox(width: 6), Text('Open in Maps')])),
    ]);
  }
}

class _ManageSheet extends StatelessWidget {
  final Listing item;
  final String code;
  const _ManageSheet({required this.item, required this.code});
  @override
  Widget build(BuildContext context) {
    final actions = [
      (ic: 'comment', l: 'Message host', d: 'Chat about your booking', col: C.emerald, chat: true),
      (ic: 'cal', l: 'Reschedule dates', d: 'Change your check-in', col: C.info, chat: false),
      (ic: 'bookmark', l: 'Add to calendar', d: 'Get a reminder', col: C.saffronDark, chat: false),
    ];
    return _BkSheet(icon: 'headset', title: 'Manage booking', sub: '#$code · ${item.name}', children: [
      for (final a in actions)
        Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Pressable(
            onTap: () {
              Navigator.pop(context);
              if (a.chat) openChat(context, ChatCtx.listing(item));
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
              decoration: BoxDecoration(color: C.surface, borderRadius: BorderRadius.circular(16), border: Border.all(color: C.hairline), boxShadow: S.card),
              child: Row(children: [
                Container(width: 40, height: 40, decoration: BoxDecoration(color: Color.alphaBlend(a.col.withValues(alpha: 0.14), Colors.white), borderRadius: BorderRadius.circular(12)), child: Ic(a.ic, size: 20, color: a.col)),
                const SizedBox(width: 13),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
                  Text(a.l, style: T.d(14, w: FontWeight.w700)),
                  Text(a.d, style: T.b(12, w: FontWeight.w500, color: C.mist)),
                ])),
                const Ic('chevR', size: 17, color: C.mist),
              ]),
            ),
          ),
        ),
      Pressable(
        onTap: () => Navigator.pop(context),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 13),
          decoration: BoxDecoration(color: Color.alphaBlend(C.error.withValues(alpha: 0.07), Colors.white), borderRadius: BorderRadius.circular(16), border: Border.all(color: C.error.withValues(alpha: 0.35), width: 1.5)),
          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [const Ic('x', size: 18, color: C.error), const SizedBox(width: 9), Text('Cancel booking', style: T.d(14, w: FontWeight.w700, color: C.error))]),
        ),
      ),
    ]);
  }
}

// ── Wallet (redesigned) ──
class _Wallet extends StatefulWidget {
  const _Wallet();
  @override
  State<_Wallet> createState() => _WalletState();
}

class _WalletState extends State<_Wallet> {
  bool hidden = false;
  static const balance = 1240;
  static const points = 3260;
  static const nextTier = 5000;

  @override
  Widget build(BuildContext context) {
    final progress = (points / nextTier).clamp(0.0, 1.0);
    final tx = const [
      (l: 'Trip booking · Sayeman', d: 'Today · 2:14 PM', a: -2400, type: 'spend'),
      (l: 'Cashback reward', d: 'Yesterday', a: 240, type: 'earn'),
      (l: 'Top-up · bKash', d: '28 May', a: 3000, type: 'topup'),
      (l: 'Referral bonus · Imran', d: '24 May', a: 500, type: 'earn'),
      (l: 'Paragliding booking', d: '20 May', a: -1800, type: 'spend'),
    ];
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      // hero balance card
      Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: const LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [Color(0xFF0E7C66), Color(0xFF0A5A4A), Color(0xFF08453A)], stops: [0, 0.7, 1]),
          borderRadius: BorderRadius.circular(24),
          boxShadow: const [BoxShadow(color: Color(0x570E7C66), blurRadius: 36, offset: Offset(0, 16))],
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
                Text('Wallet balance', style: T.b(12, w: FontWeight.w500, color: Colors.white70)),
                const SizedBox(height: 3),
                Row(children: [
                  Text(hidden ? '৳ •••••' : taka(balance), style: T.d(32, w: FontWeight.w800, color: Colors.white, spacing: -0.5)),
                  const SizedBox(width: 10),
                  GestureDetector(
                    onTap: () => setState(() => hidden = !hidden),
                    child: Container(width: 28, height: 28, decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.16), shape: BoxShape.circle), child: const Ic('eye', size: 15, color: Colors.white)),
                  ),
                ]),
              ]),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(999)),
              child: Row(mainAxisSize: MainAxisSize.min, children: [
                const Icon(Icons.workspace_premium_rounded, size: 14, color: C.saffron),
                const SizedBox(width: 5),
                Text(user.tier, style: T.b(11, w: FontWeight.w700, color: Colors.white)),
              ]),
            ),
          ]),
          const SizedBox(height: 18),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
            decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(16)),
            child: Column(children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Row(children: [const Icon(Icons.auto_awesome_rounded, size: 15, color: C.saffron), const SizedBox(width: 6), Text('${thou(points)} points', style: T.d(13, w: FontWeight.w700, color: Colors.white))]),
                Text('${thou(nextTier - points)} to Platinum', style: T.b(11, w: FontWeight.w500, color: Colors.white70)),
              ]),
              const SizedBox(height: 9),
              ClipRRect(
                borderRadius: BorderRadius.circular(99),
                child: LinearProgressIndicator(value: progress, minHeight: 6, backgroundColor: Colors.white.withValues(alpha: 0.22), valueColor: const AlwaysStoppedAnimation(C.saffron)),
              ),
            ]),
          ),
        ]),
      ),
      const SizedBox(height: 18),
      // quick actions (4)
      Row(children: [
        for (final a in const [(ic: 'plusCircle', l: 'Top up'), (ic: 'send', l: 'Send'), (ic: 'gift', l: 'Redeem'), (ic: 'receipt', l: 'History')]) ...[
          Expanded(child: Container(
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 6),
            decoration: BoxDecoration(color: C.surface, borderRadius: BorderRadius.circular(16), border: Border.all(color: C.hairline), boxShadow: S.card),
            child: Column(children: [Container(width: 40, height: 40, decoration: const BoxDecoration(color: C.emeraldTint, shape: BoxShape.circle), child: Ic(a.ic, size: 19, color: C.emeraldDark)), const SizedBox(height: 7), Text(a.l, style: T.d(11, w: FontWeight.w700))]),
          )),
          if (a.l != 'History') const SizedBox(width: 9),
        ],
      ]),
      const SizedBox(height: 18),
      // rewards strip
      Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [Color.alphaBlend(C.saffron.withValues(alpha: 0.16), Colors.white), Color.alphaBlend(C.saffron.withValues(alpha: 0.07), Colors.white)]),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: Color.alphaBlend(C.saffron.withValues(alpha: 0.26), Colors.white)),
        ),
        child: Row(children: [
          Container(width: 44, height: 44, decoration: BoxDecoration(color: C.surface, borderRadius: BorderRadius.circular(13), boxShadow: S.card), child: const Ic('gift', size: 22, color: C.saffronDark)),
          const SizedBox(width: 12),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
            Text('Redeem ৳3,260 in points', style: T.d(13.5, w: FontWeight.w700)),
            Text('100 points = ৳100 off any booking', style: T.b(12, w: FontWeight.w500, color: C.slate)),
          ])),
          Container(padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8), decoration: BoxDecoration(color: C.saffronDark, borderRadius: BorderRadius.circular(10)), child: Text('Redeem', style: T.d(12, w: FontWeight.w700, color: Colors.white))),
        ]),
      ),
      const SizedBox(height: 18),
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        _pdLabel('Recent transactions'),
        Padding(padding: const EdgeInsets.only(bottom: 10), child: Text('See all', style: T.b(12, w: FontWeight.w600, color: C.emerald))),
      ]),
      _PDCard(children: [
        for (int i = 0; i < tx.length; i++)
          () {
            final earn = tx[i].a > 0;
            final ic = tx[i].type == 'topup' ? 'plusCircle' : (earn ? 'sparkle' : 'bag');
            final col = tx[i].type == 'topup' ? C.info : (earn ? C.success : C.slate);
            return Column(children: [
              Padding(
                padding: const EdgeInsets.all(14),
                child: Row(children: [
                  Container(width: 38, height: 38, decoration: BoxDecoration(color: Color.alphaBlend(col.withValues(alpha: 0.13), Colors.white), borderRadius: BorderRadius.circular(11)), child: Ic(ic, size: 18, color: col)),
                  const SizedBox(width: 12),
                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
                    Text(tx[i].l, style: T.b(13.5, w: FontWeight.w600)),
                    Text(tx[i].d, style: T.b(11.5, w: FontWeight.w500, color: C.mist)),
                  ])),
                  Text('${earn ? '+' : '−'}${taka(tx[i].a.abs())}', style: T.b(14, w: FontWeight.w800, color: earn ? C.success : C.ink)),
                ]),
              ),
              if (i < tx.length - 1) const Padding(padding: EdgeInsets.only(left: 64), child: Divider(height: 1, color: C.hairline)),
            ]);
          }(),
      ]),
    ]);
  }
}

// ── Offers ──
class _Offers extends StatefulWidget {
  const _Offers();
  @override
  State<_Offers> createState() => _OffersState();
}

class _OffersState extends State<_Offers> {
  String copied = '';
  @override
  Widget build(BuildContext context) {
    final coupons = const [
      (code: 'MONSOON30', title: 'Monsoon Escape', sub: '30% off hill resorts · book by Jun 15', hue: 158, off: 30),
      (code: 'COXWEEKEND', title: "Cox's Long Weekend", sub: '22% off + free brunch, 2 nights', hue: 195, off: 22),
      (code: 'FIRSTTRIP', title: 'First Trip on Us', sub: '15% off any activity for new travellers', hue: 35, off: 15),
      (code: 'GOLD500', title: 'Gold member bonus', sub: '৳500 off bookings above ৳10,000', hue: 130, off: -1),
    ];
    return Column(children: [
      for (final c in coupons)
        Padding(
          padding: const EdgeInsets.only(bottom: 14),
          child: Container(
            decoration: BoxDecoration(color: C.surface, borderRadius: BorderRadius.circular(20), border: Border.all(color: C.hairline), boxShadow: S.card),
            clipBehavior: Clip.antiAlias,
            child: IntrinsicHeight(
              child: Row(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                Container(
                  width: 78,
                  decoration: BoxDecoration(gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [hsl(c.hue.toDouble(), 0.52, 0.42), hsl(c.hue + 12.0, 0.60, 0.32)])),
                  alignment: Alignment.center,
                  child: c.off > 0
                      ? Column(mainAxisAlignment: MainAxisAlignment.center, children: [Text('${c.off}%', style: T.d(24, w: FontWeight.w800, color: Colors.white, height: 1)), Text('OFF', style: T.d(10, w: FontWeight.w700, color: Colors.white))])
                      : const Ic('gift', size: 30, color: Colors.white),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
                      Text(c.title, style: T.d(15, w: FontWeight.w700, spacing: -0.2)),
                      const SizedBox(height: 3),
                      Text(c.sub, style: T.b(12, w: FontWeight.w500, color: C.slate, height: 1.4)),
                      const SizedBox(height: 10),
                      Row(children: [
                        Flexible(child: Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5), decoration: BoxDecoration(color: C.emeraldTint, borderRadius: BorderRadius.circular(8), border: Border.all(color: C.emerald.withValues(alpha: 0.4))), child: Text(c.code, maxLines: 1, overflow: TextOverflow.ellipsis, style: T.d(12, w: FontWeight.w700, color: C.emeraldDark, spacing: 0.5)))),
                        const SizedBox(width: 8),
                        GestureDetector(
                          onTap: () {
                            setState(() => copied = c.code);
                            Future.delayed(const Duration(milliseconds: 1600), () { if (mounted) setState(() => copied = ''); });
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                            decoration: BoxDecoration(color: copied == c.code ? C.success : C.emerald, borderRadius: BorderRadius.circular(10)),
                            child: Row(mainAxisSize: MainAxisSize.min, children: copied == c.code ? [const Icon(Icons.check_rounded, size: 14, color: Colors.white), const SizedBox(width: 5), Text('Copied', style: T.d(12, w: FontWeight.w700, color: Colors.white))] : [Text('Copy code', style: T.d(12, w: FontWeight.w700, color: Colors.white))]),
                          ),
                        ),
                      ]),
                    ]),
                  ),
                ),
              ]),
            ),
          ),
        ),
    ]);
  }
}

// ── Post a reel ──
class _PostReel extends StatefulWidget {
  const _PostReel();
  @override
  State<_PostReel> createState() => _PostReelState();
}

class _PostReelState extends State<_PostReel> {
  String linked = hotels[0].id;
  @override
  Widget build(BuildContext context) {
    final all = [...hotels, ...activities];
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      AspectRatio(
        aspectRatio: 9 / 11,
        child: Container(
          decoration: BoxDecoration(color: hsl(158, 0.24, 0.90), borderRadius: BorderRadius.circular(22), border: Border.all(color: C.emerald.withValues(alpha: 0.45), width: 1.5)),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Container(width: 70, height: 70, decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.7), shape: BoxShape.circle, boxShadow: S.card), child: const Ic('camera', size: 32, color: C.emeraldDark)),
            const SizedBox(height: 12),
            Text('Upload a video', style: T.d(15, w: FontWeight.w700, color: C.emeraldDark)),
            Text('Vertical · up to 60 seconds', style: T.b(12, w: FontWeight.w500, color: C.slate)),
          ]),
        ),
      ),
      const SizedBox(height: 18),
      _pdLabel('Caption'),
      Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(color: C.surface, borderRadius: BorderRadius.circular(16), border: Border.all(color: C.hairline), boxShadow: S.card),
        child: TextField(maxLines: 3, style: T.b(14, w: FontWeight.w500), decoration: InputDecoration(border: InputBorder.none, isDense: true, hintText: 'Tell travellers what makes this special…', hintStyle: T.b(14, w: FontWeight.w500, color: C.mist))),
      ),
      const SizedBox(height: 18),
      _pdLabel('Link a stay or activity'),
      SizedBox(
        height: 110,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: all.length,
          separatorBuilder: (_, _) => const SizedBox(width: 10),
          itemBuilder: (_, i) {
            final it = all[i];
            final on = linked == it.id;
            return GestureDetector(
              onTap: () => setState(() => linked = it.id),
              child: Container(
                width: 130,
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(14), border: Border.all(color: on ? C.emerald : C.hairline, width: on ? 2 : 1)),
                clipBehavior: Clip.antiAlias,
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  SizedBox(height: 60, child: Photo(src: unsplash(it.img, 280), hue: it.hue, radius: 0)),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 7),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
                      Text(it.name, maxLines: 1, overflow: TextOverflow.ellipsis, style: T.d(11.5, w: FontWeight.w700)),
                      Text(on ? '✓ Linked' : 'Tap to link', style: T.b(10, w: FontWeight.w500, color: on ? C.emerald : C.mist)),
                    ]),
                  ),
                ]),
              ),
            );
          },
        ),
      ),
      const SizedBox(height: 18),
      TSButton(full: true, large: true, onTap: () {}, child: const Row(mainAxisSize: MainAxisSize.min, children: [Ic('sparkle', size: 18, color: Colors.white), SizedBox(width: 8), Text('Post reel')])),
    ]);
  }
}

// ── Privacy ──
class _Privacy extends StatefulWidget {
  const _Privacy();
  @override
  State<_Privacy> createState() => _PrivacyState();
}

class _PrivacyState extends State<_Privacy> {
  final t = {'face': true, 'twofa': false, 'loc': true, 'ads': false};
  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      _pdLabel('Sign-in'),
      _PDCard(children: [
        _PDRow(icon: 'lock', label: 'Change password', value: 'Last changed 3 months ago', onTap: () => _openChangePassword(context)),
        _PDRow(icon: 'eye', label: 'Face ID unlock', value: 'Use biometrics to open the app', last: true, trailing: _PDSwitch(t['face']!, () => setState(() => t['face'] = !t['face']!))),
      ]),
      const SizedBox(height: 18),
      _pdLabel('Security'),
      _PDCard(children: [
        _PDRow(icon: 'shield', label: 'Two-factor authentication', value: t['twofa']! ? 'On · SMS to +880 1712…' : 'Add an extra layer', trailing: _PDSwitch(t['twofa']!, () => setState(() => t['twofa'] = !t['twofa']!))),
        _PDRow(icon: 'pin', label: 'Location services', value: 'Used to show nearby stays', trailing: _PDSwitch(t['loc']!, () => setState(() => t['loc'] = !t['loc']!))),
        _PDRow(icon: 'tag', label: 'Personalised ads', value: 'Tailor offers to you', last: true, trailing: _PDSwitch(t['ads']!, () => setState(() => t['ads'] = !t['ads']!))),
      ]),
    ]);
  }
}

// ── Notifications ──
class _Notif extends StatefulWidget {
  const _Notif();
  @override
  State<_Notif> createState() => _NotifState();
}

class _NotifState extends State<_Notif> {
  final st = <String, bool>{};
  final groups = const [
    (title: 'Trips', items: [(ic: 'bookmark', l: 'Booking updates', v: 'reminders', on: true), (ic: 'cal', l: 'Trip reminders', v: '24h before check-in', on: true), (ic: 'receipt', l: 'Payment receipts', v: '', on: true)]),
    (title: 'Discover', items: [(ic: 'tag', l: 'Offers & coupons', v: 'New deals near you', on: true), (ic: 'sparkle', l: 'New reels from hosts', v: '', on: false), (ic: 'compass', l: 'Destination ideas', v: 'Weekly inspiration', on: false)]),
    (title: 'Channels', items: [(ic: 'bell', l: 'Push notifications', v: '', on: true), (ic: 'mail', l: 'Email', v: '', on: true), (ic: 'phone', l: 'SMS', v: '', on: false)]),
  ];
  @override
  void initState() {
    super.initState();
    for (final g in groups) {
      for (final it in g.items) {
        st[it.l] = it.on;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      for (final g in groups) ...[
        _pdLabel(g.title),
        _PDCard(children: [
          for (int i = 0; i < g.items.length; i++)
            _PDRow(icon: g.items[i].ic, label: g.items[i].l, value: g.items[i].v.isEmpty ? null : g.items[i].v, last: i == g.items.length - 1, trailing: _PDSwitch(st[g.items[i].l] ?? false, () => setState(() => st[g.items[i].l] = !(st[g.items[i].l] ?? false)))),
        ]),
        const SizedBox(height: 18),
      ],
    ]);
  }
}

// ── Help ──
class _Help extends StatefulWidget {
  const _Help();
  @override
  State<_Help> createState() => _HelpState();
}

class _HelpState extends State<_Help> {
  int open = 0;
  @override
  Widget build(BuildContext context) {
    final faqs = const [
      (q: 'How do I change or cancel a booking?', a: 'Open My bookings, choose the trip and tap Manage. Free cancellation applies up to 48 hours before check-in on most stays.'),
      (q: 'When am I charged for a trip?', a: 'A 20% deposit reserves your trip for 30 minutes. The balance is charged 24 hours before check-in, or instantly for activities.'),
      (q: 'What are facility tiers?', a: 'Every stay and activity comes in Budget, Premium and Luxury — same place, different room class, inclusions and service level.'),
      (q: 'How do wallet points work?', a: 'You earn 2% back on every booking as points. 100 points = ৳100 and can be applied at checkout.'),
    ];
    final contacts = const [(ic: 'comment', l: 'Live chat', d: 'Replies in ~2 min', col: C.emerald), (ic: 'phone', l: 'Call us', d: '16247 · 24/7', col: C.info), (ic: 'mail', l: 'Email', d: 'help@tourshongi.com', col: C.saffronDark)];
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(color: C.surface, borderRadius: BorderRadius.circular(14), border: Border.all(color: C.hairline), boxShadow: S.card),
        child: Row(children: [const Ic('search', size: 19, color: C.mist), const SizedBox(width: 10), Text('Search help articles…', style: T.b(14, w: FontWeight.w500, color: C.mist))]),
      ),
      const SizedBox(height: 18),
      _pdLabel('Get in touch'),
      Row(children: [
        for (final c in contacts) ...[
          Expanded(child: GestureDetector(
            onTap: c.l == 'Live chat' ? () => openChat(context, const ChatCtx.support()) : null,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 8),
              decoration: BoxDecoration(color: C.surface, borderRadius: BorderRadius.circular(16), border: Border.all(color: C.hairline), boxShadow: S.card),
              child: Column(children: [
                Container(width: 42, height: 42, decoration: BoxDecoration(color: Color.alphaBlend(c.col.withValues(alpha: 0.14), Colors.white), shape: BoxShape.circle), child: Ic(c.ic, size: 20, color: c.col)),
                const SizedBox(height: 8),
                Text(c.l, style: T.d(12, w: FontWeight.w700)),
                Text(c.d, textAlign: TextAlign.center, style: T.b(10, w: FontWeight.w500, color: C.mist, height: 1.3)),
              ]),
            ),
          )),
          if (c.l != 'Email') const SizedBox(width: 10),
        ],
      ]),
      const SizedBox(height: 18),
      _pdLabel('Popular questions'),
      for (int i = 0; i < faqs.length; i++)
        Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Container(
            decoration: BoxDecoration(color: C.surface, borderRadius: BorderRadius.circular(16), border: Border.all(color: C.hairline), boxShadow: S.card),
            clipBehavior: Clip.antiAlias,
            child: Column(children: [
              InkWell(
                onTap: () => setState(() => open = open == i ? -1 : i),
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Row(children: [
                    Expanded(child: Text(faqs[i].q, style: T.d(13.5, w: FontWeight.w700, height: 1.3))),
                    AnimatedRotation(turns: open == i ? 0.5 : 0, duration: const Duration(milliseconds: 250), child: const Ic('chevD', size: 18, color: C.emerald)),
                  ]),
                ),
              ),
              AnimatedCrossFade(
                firstChild: const SizedBox(width: double.infinity),
                secondChild: Padding(padding: const EdgeInsets.fromLTRB(14, 0, 14, 14), child: SizedBox(width: double.infinity, child: Text(faqs[i].a, style: T.b(13, color: C.slate, height: 1.55)))),
                crossFadeState: open == i ? CrossFadeState.showSecond : CrossFadeState.showFirst,
                duration: const Duration(milliseconds: 250),
              ),
            ]),
          ),
        ),
    ]);
  }
}

// ── Settings ──
class _Settings extends StatefulWidget {
  final VoidCallback? onLogout;
  const _Settings({this.onLogout});
  @override
  State<_Settings> createState() => _SettingsState();
}

class _SettingsState extends State<_Settings> {
  final t = {'dark': false, 'sound': true, 'haptics': true, 'auto': true};
  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      _pdLabel('Preferences'),
      _PDCard(children: [
        _PDRow(icon: 'globe', label: 'Language', value: 'English (UK)', onTap: () {}),
        _PDRow(icon: 'wallet', label: 'Currency', value: 'BDT · ৳ Bangladeshi Taka', onTap: () {}),
        _PDRow(icon: 'moon', label: 'Dark appearance', value: 'Match a darker mood', last: true, trailing: _PDSwitch(t['dark']!, () => setState(() => t['dark'] = !t['dark']!))),
      ]),
      const SizedBox(height: 18),
      _pdLabel('App'),
      _PDCard(children: [
        _PDRow(icon: 'volume', label: 'Sound effects', trailing: _PDSwitch(t['sound']!, () => setState(() => t['sound'] = !t['sound']!))),
        _PDRow(icon: 'play', label: 'Haptic feedback', trailing: _PDSwitch(t['haptics']!, () => setState(() => t['haptics'] = !t['haptics']!))),
        _PDRow(icon: 'camera', label: 'Autoplay reels', value: 'On mobile data too', last: true, trailing: _PDSwitch(t['auto']!, () => setState(() => t['auto'] = !t['auto']!))),
      ]),
      const SizedBox(height: 18),
      _pdLabel('About'),
      _PDCard(children: [
        _PDRow(icon: 'info', label: 'Terms of service', onTap: () {}),
        _PDRow(icon: 'shield', label: 'Privacy policy', onTap: () {}),
        _PDRow(icon: 'star', label: 'Rate Tour Shongi', value: 'v1.0.0', last: true, onTap: () {}),
      ]),
      const SizedBox(height: 18),
      GestureDetector(
        onTap: widget.onLogout,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(color: Color.alphaBlend(C.error.withValues(alpha: 0.07), Colors.white), borderRadius: BorderRadius.circular(16), border: Border.all(color: C.error.withValues(alpha: 0.35), width: 1.5)),
          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [const Ic('logout', size: 19, color: C.error), const SizedBox(width: 9), Text('Log out', style: T.d(15, w: FontWeight.w700, color: C.error))]),
        ),
      ),
    ]);
  }
}

// ── Change password sheet ──
void _openChangePassword(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    barrierColor: const Color(0x7314201D),
    builder: (_) => const _ChangePasswordSheet(),
  );
}

class _ChangePasswordSheet extends StatefulWidget {
  const _ChangePasswordSheet();
  @override
  State<_ChangePasswordSheet> createState() => _ChangePasswordSheetState();
}

class _ChangePasswordSheetState extends State<_ChangePasswordSheet> {
  final cur = TextEditingController();
  final nw = TextEditingController();
  final cf = TextEditingController();
  bool done = false;

  int get strength => nw.text.length >= 12 ? 2 : (nw.text.length >= 8 ? 1 : (nw.text.isNotEmpty ? 0 : -1));
  bool get valid => cur.text.length >= 4 && nw.text.length >= 8 && nw.text == cf.text;

  @override
  Widget build(BuildContext context) {
    const sLabels = ['Weak', 'Good', 'Strong'];
    const sCols = [C.error, C.saffronDark, C.success];
    final sCol = strength >= 0 ? sCols[strength] : C.hairline;
    return Container(
      decoration: const BoxDecoration(color: C.surface, borderRadius: BorderRadius.vertical(top: Radius.circular(28))),
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        const SizedBox(height: 12),
        Container(width: 40, height: 5, decoration: BoxDecoration(color: C.hairline, borderRadius: BorderRadius.circular(99))),
        const SizedBox(height: 16),
        Padding(
          padding: EdgeInsets.fromLTRB(20, 0, 20, 28 + MediaQuery.of(context).padding.bottom),
          child: done
              ? Column(children: [
                  Container(width: 64, height: 64, decoration: BoxDecoration(color: Color.alphaBlend(C.success.withValues(alpha: 0.14), Colors.white), shape: BoxShape.circle), child: const Icon(Icons.check_rounded, size: 32, color: C.success)),
                  const SizedBox(height: 16),
                  Text('Password updated', style: T.d(19, w: FontWeight.w800)),
                  const SizedBox(height: 6),
                  Text('Your new password is now active on this account.', textAlign: TextAlign.center, style: T.b(13, w: FontWeight.w500, color: C.slate)),
                  const SizedBox(height: 20),
                ])
              : Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                  Row(children: [
                    Container(width: 44, height: 44, decoration: BoxDecoration(color: C.emeraldTint, borderRadius: BorderRadius.circular(13)), child: const Ic('lock', size: 22, color: C.emeraldDark)),
                    const SizedBox(width: 11),
                    Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
                      Text('Change password', style: T.d(18, w: FontWeight.w800)),
                      Text('Use 8+ characters with a number', style: T.b(12, w: FontWeight.w500, color: C.mist)),
                    ])),
                  ]),
                  const SizedBox(height: 18),
                  _pwField('Current password', cur, 'Enter current password'),
                  const SizedBox(height: 14),
                  _pwField('New password', nw, 'Create a new password'),
                  if (strength >= 0)
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Row(children: [
                        Expanded(child: Row(children: [for (int i = 0; i < 3; i++) Expanded(child: Container(height: 4, margin: EdgeInsets.only(right: i < 2 ? 4 : 0), decoration: BoxDecoration(color: i <= strength ? sCol : C.hairline, borderRadius: BorderRadius.circular(99))))])),
                        const SizedBox(width: 8),
                        Text(sLabels[strength], style: T.b(11, w: FontWeight.w700, color: sCol)),
                      ]),
                    ),
                  const SizedBox(height: 14),
                  _pwField('Confirm new password', cf, 'Re-enter new password'),
                  const SizedBox(height: 18),
                  AnimatedOpacity(
                    opacity: valid ? 1 : 0.5,
                    duration: const Duration(milliseconds: 200),
                    child: TSButton(full: true, large: true, onTap: () {
                      if (!valid) return;
                      final nav = Navigator.of(context);
                      setState(() => done = true);
                      Future.delayed(const Duration(milliseconds: 1300), () { if (mounted) nav.pop(); });
                    }, child: const Text('Update password')),
                  ),
                ]),
        ),
      ]),
    );
  }

  Widget _pwField(String label, TextEditingController ctrl, String hint) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Padding(padding: const EdgeInsets.only(bottom: 7), child: Text(label, style: T.b(12, w: FontWeight.w700, color: C.slate))),
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
        decoration: BoxDecoration(color: C.cloud, borderRadius: BorderRadius.circular(14), border: Border.all(color: C.hairline)),
        child: Row(children: [
          const Ic('lock', size: 17, color: C.mist),
          const SizedBox(width: 8),
          Expanded(child: TextField(controller: ctrl, obscureText: true, onChanged: (_) => setState(() {}), style: T.b(14, w: FontWeight.w500), decoration: InputDecoration(border: InputBorder.none, isDense: true, hintText: hint, hintStyle: T.b(14, w: FontWeight.w500, color: C.mist)))),
        ]),
      ),
    ]);
  }
}
