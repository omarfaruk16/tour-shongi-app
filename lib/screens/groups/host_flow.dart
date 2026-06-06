import 'package:flutter/material.dart';
import '../../core/theme.dart';
import '../../core/icons.dart';
import '../../data/content.dart' show user;
import '../../data/groups.dart';
import '../../nav.dart';
import '../../widgets/photo.dart';
import '../../widgets/ui.dart';
import '../../widgets/group_bits.dart';

/// Host flow controller: register → dashboard → create event → manage members.
class GroupHostFlow extends StatefulWidget {
  const GroupHostFlow({super.key});
  @override
  State<GroupHostFlow> createState() => _GroupHostFlowState();
}

class _HostEvent {
  final String id, title, dates, img;
  final int hue, capacity, booked, manual;
  final bool draft;
  _HostEvent(this.id, this.title, this.dates, this.img, this.hue, this.capacity, this.booked, this.manual) : draft = false;
}

class _GroupHostFlowState extends State<GroupHostFlow> {
  String step = 'register';
  String orgName = '', leadName = '', focus = 'Adventure Group';
  List<_HostEvent> events = [];
  _HostEvent? active;

  void _toast(String m) => comingSoonToast(context, m);

  @override
  Widget build(BuildContext context) {
    switch (step) {
      case 'dashboard':
        return _Dashboard(
          org: orgName,
          lead: leadName,
          focus: focus,
          events: events,
          onBack: () => Navigator.pop(context),
          onPreview: () => openGroupProfile(context, travelGroups[0]),
          onCreate: () => setState(() => step = 'create'),
          onManage: (e) => setState(() {
            active = e;
            step = 'members';
          }),
        );
      case 'create':
        return _CreateEvent(
          onBack: () => setState(() => step = 'dashboard'),
          onPublish: (title, dates, capacity) {
            setState(() {
              events.insert(0, _HostEvent('mine-${events.length + 1}', title, dates.isEmpty ? 'TBD' : dates, '1530789253388-582c481c54b0', 168, capacity, 0, 0));
              step = 'dashboard';
            });
            _toast('Event published 🎉');
          },
        );
      case 'members':
        return _Members(ev: active!, onBack: () => setState(() => step = 'dashboard'));
      default:
        return _Register(
          onBack: () => Navigator.pop(context),
          onDone: (org, lead, f) {
            setState(() {
              orgName = org;
              leadName = lead;
              focus = f;
              events = [_HostEvent('mine-1', 'Sajek Valley Cloud Chase', '12–14 Jun 2026', groupEvents[0].img, 158, 50, 32, 6)];
              step = 'dashboard';
            });
            _toast('Group registered — verification in progress');
          },
        );
    }
  }
}

void comingSoonToast(BuildContext context, String m) {
  ScaffoldMessenger.of(context)
    ..clearSnackBars()
    ..showSnackBar(SnackBar(behavior: SnackBarBehavior.floating, backgroundColor: C.ink, margin: const EdgeInsets.fromLTRB(20, 0, 20, 24), content: Text(m, style: T.b(13, w: FontWeight.w600, color: Colors.white))));
}

class _HostScaffold extends StatelessWidget {
  final String title;
  final String? sub;
  final VoidCallback onBack;
  final Widget? right;
  final List<Widget> children;
  const _HostScaffold({required this.title, this.sub, required this.onBack, this.right, required this.children});
  @override
  Widget build(BuildContext context) {
    final topPad = MediaQuery.of(context).padding.top;
    return Scaffold(
      backgroundColor: C.cloud,
      body: Column(children: [
        Container(
          padding: EdgeInsets.fromLTRB(14, topPad + 8, 14, 16),
          decoration: const BoxDecoration(gradient: G.greenGlass, boxShadow: [BoxShadow(color: Color(0x2E0B5A4A), blurRadius: 20, offset: Offset(0, 6))]),
          child: Row(children: [
            GestureDetector(onTap: onBack, child: Container(width: 40, height: 40, decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.2), shape: BoxShape.circle), child: const Ic('chevL', size: 22, color: Colors.white))),
            const SizedBox(width: 10),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
              Text(title, style: T.d(20, w: FontWeight.w800, color: Colors.white, spacing: -0.3)),
              if (sub != null) Text(sub!, style: T.b(12, w: FontWeight.w500, color: Colors.white.withValues(alpha: 0.85))),
            ])),
            ?right,
          ]),
        ),
        Expanded(child: ListView(padding: const EdgeInsets.fromLTRB(20, 20, 20, 40), children: children)),
      ]),
    );
  }
}

Widget _label(String t) => Padding(padding: const EdgeInsets.only(left: 2, bottom: 8, top: 4), child: Text(t.toUpperCase(), style: T.b(12, w: FontWeight.w700, color: C.slate, spacing: 0.4)));

class _Field extends StatelessWidget {
  final String label, hint, icon;
  final TextEditingController controller;
  final String? helper;
  const _Field(this.label, this.hint, this.icon, this.controller, {this.helper});
  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Padding(padding: const EdgeInsets.only(left: 2, bottom: 7), child: Text(label.toUpperCase(), style: T.b(12, w: FontWeight.w700, color: C.slate, spacing: 0.4))),
      TextField(
        controller: controller,
        style: T.b(14, w: FontWeight.w500),
        decoration: InputDecoration(
          isDense: true,
          hintText: hint,
          hintStyle: T.b(14, w: FontWeight.w500, color: C.mist),
          prefixIcon: Padding(padding: const EdgeInsets.only(left: 12, right: 8), child: Ic(icon, size: 18, color: C.emerald)),
          prefixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
          filled: true,
          fillColor: C.surface,
          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(R.input), borderSide: const BorderSide(color: C.hairline)),
          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(R.input), borderSide: const BorderSide(color: C.emerald, width: 1.5)),
        ),
      ),
      if (helper != null) Padding(padding: const EdgeInsets.only(left: 2, top: 5), child: Text(helper!, style: T.b(11, w: FontWeight.w500, color: C.mist))),
    ]);
  }
}

class _Register extends StatefulWidget {
  final VoidCallback onBack;
  final void Function(String org, String lead, String focus) onDone;
  const _Register({required this.onBack, required this.onDone});
  @override
  State<_Register> createState() => _RegisterState();
}

class _RegisterState extends State<_Register> {
  final org = TextEditingController();
  final lead = TextEditingController(text: user.name);
  final phone = TextEditingController(text: '+880 ');
  final nid = TextEditingController();
  final email = TextEditingController(text: user.email);
  final address = TextEditingController();
  final tagline = TextEditingController();
  String focus = 'Adventure Group';
  static const _types = ['Adventure Group', 'Family & Beach', 'Wildlife Expedition', 'Relaxation', 'Island & Beach', 'Pilgrimage'];

  bool get ready => org.text.isNotEmpty && phone.text.trim().length > 6 && nid.text.isNotEmpty && email.text.isNotEmpty;

  @override
  Widget build(BuildContext context) {
    return _HostScaffold(
      title: 'Register your group',
      sub: 'Step 1 of 2 · About your group',
      onBack: widget.onBack,
      children: [
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(gradient: const LinearGradient(colors: [C.emeraldTint, Color(0xFFEEF7F3)]), borderRadius: BorderRadius.circular(18), border: Border.all(color: C.emerald.withValues(alpha: 0.22))),
          child: Row(children: [
            Container(width: 42, height: 42, decoration: BoxDecoration(gradient: G.emerald, borderRadius: BorderRadius.circular(13)), child: const Ic('flag', size: 21, color: Colors.white)),
            const SizedBox(width: 12),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
              Text('Become a travel group host', style: T.d(14, w: FontWeight.w700, color: C.emeraldDark)),
              Text('Register once, then publish unlimited group tours and manage your travellers.', style: T.b(12, w: FontWeight.w500, color: C.slate, height: 1.45)),
            ])),
          ]),
        ),
        const SizedBox(height: 18),
        _label('Group details'),
        _Field('Group / organisation name', 'e.g. Wander BD', 'users', org), const SizedBox(height: 14),
        _Field('Lead organiser', 'Full name', 'user', lead),
        const SizedBox(height: 18),
        _label('Verification & contact'),
        _Field('Phone number', '+880 1XXX XXXXXX', 'phone', phone), const SizedBox(height: 14),
        _Field('National ID (NID) no.', '10 / 13 / 17-digit NID', 'idcard', nid, helper: 'Used to verify you — never shown publicly.'), const SizedBox(height: 14),
        _Field('Email address', 'you@group.com', 'mail', email), const SizedBox(height: 14),
        _Field('Address', 'Street, area, city', 'pin', address),
        const SizedBox(height: 18),
        _label('What you mostly host'),
        Wrap(spacing: 8, runSpacing: 8, children: [for (final t in _types) TSChip(t, active: focus == t, onTap: () => setState(() => focus = t))]),
        const SizedBox(height: 18),
        _label('Public profile'),
        _Field('Tagline', 'One line about your tours', 'sparkle', tagline),
        const SizedBox(height: 14),
        _uploadBox('Upload NID / passport', 'Front & back · JPG or PDF', 'idcard'),
        const SizedBox(height: 20),
        AnimatedOpacity(
          opacity: ready ? 1 : 0.5,
          duration: const Duration(milliseconds: 200),
          child: TSButton(
            full: true,
            large: true,
            onTap: () => ready ? widget.onDone(org.text, lead.text, focus) : null,
            child: const Row(mainAxisSize: MainAxisSize.min, children: [Ic('arrowR', size: 19, color: Colors.white), SizedBox(width: 8), Text('Continue')]),
          ),
        ),
        if (!ready) Padding(padding: const EdgeInsets.only(top: 8), child: Center(child: Text('Fill name, phone, NID and email to continue', style: T.b(11, w: FontWeight.w500, color: C.mist)))),
      ],
    );
  }
}

Widget _uploadBox(String title, String sub, String icon) => Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(color: C.surface, borderRadius: BorderRadius.circular(16), border: Border.all(color: C.emerald.withValues(alpha: 0.45), width: 1.5)),
      child: Row(children: [
        Container(width: 40, height: 40, decoration: BoxDecoration(color: C.emeraldTint, borderRadius: BorderRadius.circular(12)), child: Ic(icon, size: 20, color: C.emeraldDark)),
        const SizedBox(width: 12),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
          Text(title, style: T.d(13, w: FontWeight.w700)),
          Text(sub, style: T.b(11, w: FontWeight.w500, color: C.mist)),
        ])),
        const Ic('plus', size: 20, color: C.emerald),
      ]),
    );

class _Dashboard extends StatelessWidget {
  final String org, lead, focus;
  final List<_HostEvent> events;
  final VoidCallback onBack, onPreview, onCreate;
  final void Function(_HostEvent) onManage;
  const _Dashboard({required this.org, required this.lead, required this.focus, required this.events, required this.onBack, required this.onPreview, required this.onCreate, required this.onManage});
  @override
  Widget build(BuildContext context) {
    final totalSeats = events.fold<int>(0, (s, e) => s + e.capacity);
    final totalBooked = events.fold<int>(0, (s, e) => s + e.booked);
    return _HostScaffold(
      title: org.isEmpty ? 'Your group' : org,
      sub: 'Host dashboard',
      onBack: onBack,
      right: GestureDetector(
        onTap: onPreview,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.92), borderRadius: BorderRadius.circular(999)),
          child: Row(mainAxisSize: MainAxisSize.min, children: [const Ic('eye', size: 14, color: C.emeraldDark), const SizedBox(width: 5), Text('Preview', style: T.d(11, w: FontWeight.w700, color: C.emeraldDark))]),
        ),
      ),
      children: [
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(color: C.surface, borderRadius: BorderRadius.circular(18), border: Border.all(color: C.hairline), boxShadow: S.card),
          child: Row(children: [
            Container(width: 52, height: 52, decoration: BoxDecoration(gradient: G.emerald, borderRadius: BorderRadius.circular(15)), alignment: Alignment.center, child: Text((org.isEmpty ? 'G' : org)[0], style: T.d(20, w: FontWeight.w800, color: Colors.white))),
            const SizedBox(width: 13),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
              Text(org, style: T.d(16, w: FontWeight.w700)),
              Text('$lead · $focus', style: T.b(12, w: FontWeight.w500, color: C.mist)),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(color: const Color(0x24E8A33D), borderRadius: BorderRadius.circular(999)),
                child: Row(mainAxisSize: MainAxisSize.min, children: [const Ic('clock', size: 12, color: C.saffronDark), const SizedBox(width: 5), Text('Verification pending', style: T.b(11, w: FontWeight.w700, color: C.saffronDark))]),
              ),
            ])),
          ]),
        ),
        const SizedBox(height: 18),
        Row(children: [
          for (final s in [(n: events.length, l: 'Live tours'), (n: totalBooked, l: 'Travellers'), (n: totalSeats - totalBooked, l: 'Seats open')]) ...[
            Expanded(child: Container(
              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
              decoration: BoxDecoration(color: C.surface, borderRadius: BorderRadius.circular(16), border: Border.all(color: C.hairline), boxShadow: S.card),
              child: Column(children: [Text('${s.n}', style: T.d(22, w: FontWeight.w800, color: C.emeraldDark)), Text(s.l, style: T.b(11, w: FontWeight.w500, color: C.mist))]),
            )),
            if (s.l != 'Seats open') const SizedBox(width: 10),
          ],
        ]),
        const SizedBox(height: 18),
        TSButton(full: true, large: true, onTap: onCreate, child: const Row(mainAxisSize: MainAxisSize.min, children: [Ic('plus', size: 19, color: Colors.white), SizedBox(width: 8), Text('Create a travel event')])),
        const SizedBox(height: 18),
        _label('Your events'),
        for (final ev in events)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(color: C.surface, borderRadius: BorderRadius.circular(R.card), border: Border.all(color: C.hairline), boxShadow: S.card),
              child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                SizedBox(width: 80, height: 94, child: Photo(src: unsplash(ev.img, 240), hue: ev.hue, height: 94, radius: 14)),
                const SizedBox(width: 12),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
                  Row(children: [
                    Expanded(child: Text(ev.title, maxLines: 1, overflow: TextOverflow.ellipsis, style: T.d(15, w: FontWeight.w700, height: 1.2, spacing: -0.2))),
                    Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3), decoration: BoxDecoration(color: Color.alphaBlend(C.success.withValues(alpha: 0.12), Colors.white), borderRadius: BorderRadius.circular(999)), child: Text('Live', style: T.b(10, w: FontWeight.w700, color: C.success))),
                  ]),
                  const SizedBox(height: 4),
                  Row(children: [const Ic('cal', size: 12, color: C.emerald), const SizedBox(width: 4), Text(ev.dates, style: T.b(12, w: FontWeight.w500, color: C.slate))]),
                  const SizedBox(height: 8),
                  SlotBar(booked: ev.booked, capacity: ev.capacity),
                  const SizedBox(height: 9),
                  GestureDetector(
                    onTap: () => onManage(ev),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                      decoration: BoxDecoration(color: C.emeraldTint, borderRadius: BorderRadius.circular(10)),
                      child: Row(mainAxisSize: MainAxisSize.min, children: [const Ic('users', size: 14, color: C.emeraldDark), const SizedBox(width: 6), Text('Manage members', style: T.d(12, w: FontWeight.w700, color: C.emeraldDark))]),
                    ),
                  ),
                ])),
              ]),
            ),
          ),
      ],
    );
  }
}

class _CreateEvent extends StatefulWidget {
  final VoidCallback onBack;
  final void Function(String title, String dates, int capacity) onPublish;
  const _CreateEvent({required this.onBack, required this.onPublish});
  @override
  State<_CreateEvent> createState() => _CreateEventState();
}

class _CreateEventState extends State<_CreateEvent> {
  final title = TextEditingController();
  final location = TextEditingController();
  final dates = TextEditingController();
  final budget = TextEditingController();
  int capacity = 40;
  String type = 'Adventure Group';
  final Set<String> suit = {'Friends', 'Solo'};
  final List<String> plan = ['journey', 'stay'];
  static const _types = ['Adventure Group', 'Family & Beach', 'Wildlife Expedition', 'Relaxation', 'Island & Beach'];

  bool get ready => title.text.isNotEmpty && location.text.isNotEmpty && dates.text.isNotEmpty && budget.text.isNotEmpty;

  @override
  Widget build(BuildContext context) {
    return _HostScaffold(
      title: 'Create travel event',
      sub: 'Build your group tour',
      onBack: widget.onBack,
      children: [
        _uploadBox('Add a cover photo', 'Landscape · shown on the event card', 'camera'),
        const SizedBox(height: 18),
        _Field('Event title', 'e.g. Sajek Valley Cloud Chase', 'flag', title),
        const SizedBox(height: 14),
        Row(children: [
          Expanded(child: _Field('Destination', 'Sajek Valley', 'pin', location)),
          const SizedBox(width: 10),
          Expanded(child: _Field('Departs from', 'Dhaka', 'bus', TextEditingController(text: 'Dhaka'))),
        ]),
        const SizedBox(height: 14),
        _Field('Dates', 'e.g. 12–14 Jun 2026', 'cal', dates),
        const SizedBox(height: 18),
        _label('Tour type'),
        Wrap(spacing: 8, runSpacing: 8, children: [for (final t in _types) TSChip(t, active: type == t, onTap: () => setState(() => type = t))]),
        const SizedBox(height: 18),
        _label('Suitable for'),
        Wrap(spacing: 8, runSpacing: 8, children: [
          for (final s in suitableMeta.keys)
            GestureDetector(
              onTap: () => setState(() => suit.contains(s) ? suit.remove(s) : suit.add(s)),
              child: Builder(builder: (_) {
                final m = suitableMeta[s]!;
                final on = suit.contains(s);
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                  decoration: BoxDecoration(
                    color: on ? hsl(m.hue.toDouble(), 0.45, 0.96) : C.surface,
                    borderRadius: BorderRadius.circular(999),
                    border: Border.all(color: on ? hsl(m.hue.toDouble(), 0.50, 0.50) : C.hairline, width: on ? 1.5 : 1),
                  ),
                  child: Row(mainAxisSize: MainAxisSize.min, children: [
                    Ic(m.icon, size: 13, color: hsl(m.hue.toDouble(), 0.50, 0.45)),
                    const SizedBox(width: 5),
                    Text(s, style: T.b(12, w: FontWeight.w600, color: on ? C.ink : C.slate)),
                    if (on) ...[const SizedBox(width: 5), Icon(Icons.check_rounded, size: 12, color: hsl(m.hue.toDouble(), 0.50, 0.40))],
                  ]),
                );
              }),
            ),
        ]),
        const SizedBox(height: 18),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(color: C.surface, borderRadius: BorderRadius.circular(16), border: Border.all(color: C.hairline), boxShadow: S.card),
          child: Row(children: [
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [Text('Total capacity', style: T.d(14, w: FontWeight.w700)), Text('Max travellers on this tour', style: T.b(12, w: FontWeight.w500, color: C.mist))])),
            QtyStepper(capacity, (v) => setState(() => capacity = v), min: 4, max: 120),
          ]),
        ),
        const SizedBox(height: 18),
        _label('Price per person (budget tier)'),
        _Field('Budget price', '৳', 'wallet', budget),
        const SizedBox(height: 18),
        _label('Travel plan'),
        for (int i = 0; i < plan.length; i++) _planRow(i),
        const SizedBox(height: 12),
        Row(children: [
          for (final e in planMeta.entries) ...[
            Expanded(
              child: GestureDetector(
                onTap: () => setState(() => plan.add(e.key)),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 11, horizontal: 6),
                  decoration: BoxDecoration(color: e.value.tint, borderRadius: BorderRadius.circular(12), border: Border.all(color: Color.alphaBlend(e.value.color.withValues(alpha: 0.4), Colors.white))),
                  child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [Ic('plus', size: 15, color: e.value.color), const SizedBox(width: 5), Text(e.value.label, style: T.d(12, w: FontWeight.w700, color: e.value.color))]),
                ),
              ),
            ),
            if (e.key != 'activity') const SizedBox(width: 8),
          ],
        ]),
        const SizedBox(height: 20),
        AnimatedOpacity(
          opacity: ready ? 1 : 0.5,
          duration: const Duration(milliseconds: 200),
          child: TSButton(
            full: true,
            large: true,
            onTap: () => ready ? widget.onPublish(title.text, dates.text, capacity) : null,
            child: const Row(mainAxisSize: MainAxisSize.min, children: [Icon(Icons.check_rounded, size: 19, color: Colors.white), SizedBox(width: 8), Text('Publish event')]),
          ),
        ),
        if (!ready) Padding(padding: const EdgeInsets.only(top: 8), child: Center(child: Text('Add a title, destination, dates and a budget price', style: T.b(11, w: FontWeight.w500, color: C.mist)))),
      ],
    );
  }

  Widget _planRow(int i) {
    final m = planMeta[plan[i]]!;
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: C.surface, borderRadius: BorderRadius.circular(16), border: Border.all(color: C.hairline), boxShadow: S.card),
      child: Row(children: [
        Container(width: 32, height: 32, decoration: BoxDecoration(color: m.tint, borderRadius: BorderRadius.circular(10)), child: Ic(m.icon, size: 17, color: m.color)),
        const SizedBox(width: 9),
        Expanded(child: Text('${m.label} · Day ${(i ~/ 2) + 1}', style: T.d(13, w: FontWeight.w700, color: m.color))),
        GestureDetector(
          onTap: () => setState(() => plan.removeAt(i)),
          child: Container(width: 28, height: 28, decoration: BoxDecoration(color: Color.alphaBlend(C.error.withValues(alpha: 0.09), Colors.white), shape: BoxShape.circle), child: const Ic('trash', size: 15, color: C.error)),
        ),
      ]),
    );
  }
}

class _Members extends StatefulWidget {
  final _HostEvent ev;
  final VoidCallback onBack;
  const _Members({required this.ev, required this.onBack});
  @override
  State<_Members> createState() => _MembersState();
}

class _MembersState extends State<_Members> {
  late int appCount = widget.ev.booked - widget.ev.manual;
  late List<({String name, String gender})> members = List.generate(widget.ev.manual, (i) {
    const names = ['Rafiq Hasan', 'Sumi Akter', 'Jamal Uddin', 'Nadia R.', 'Karim S.', 'Farzana K.', 'Hasib A.', 'Mitu P.'];
    return (name: names[i % 8], gender: i % 3 == 1 ? 'Female' : 'Male');
  });
  final name = TextEditingController();
  String gender = 'Male';

  int get booked => appCount + members.length;
  int get left => (widget.ev.capacity - booked).clamp(0, widget.ev.capacity);

  @override
  Widget build(BuildContext context) {
    final male = members.where((m) => m.gender == 'Male').length;
    final female = members.length - male;
    return _HostScaffold(
      title: 'Manage members',
      sub: widget.ev.title,
      onBack: widget.onBack,
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(color: C.surface, borderRadius: BorderRadius.circular(20), border: Border.all(color: C.hairline), boxShadow: S.card),
          child: Column(children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text('$booked of ${widget.ev.capacity} seats', style: T.d(13, w: FontWeight.w700)), Text('$left open', style: T.d(13, w: FontWeight.w700, color: C.emerald))]),
            const SizedBox(height: 12),
            SlotBar(booked: booked, capacity: widget.ev.capacity),
            const SizedBox(height: 12),
            Row(children: [
              _legend(C.emerald, '$appCount via app'),
              const SizedBox(width: 14),
              _legend(C.saffron, '${members.length} added by you'),
            ]),
          ]),
        ),
        const SizedBox(height: 18),
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(color: C.surface, borderRadius: BorderRadius.circular(18), border: Border.all(color: C.hairline), boxShadow: S.card),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Add a member manually', style: T.d(13, w: FontWeight.w700)),
            const SizedBox(height: 10),
            TextField(
              controller: name,
              style: T.b(14, w: FontWeight.w500),
              decoration: InputDecoration(isDense: true, hintText: 'Member name', hintStyle: T.b(14, w: FontWeight.w500, color: C.mist), filled: true, fillColor: C.cloud, contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12), enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(R.input), borderSide: const BorderSide(color: C.hairline)), focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(R.input), borderSide: const BorderSide(color: C.emerald, width: 1.5))),
            ),
            const SizedBox(height: 10),
            Row(children: [
              for (final g in ['Male', 'Female']) ...[
                Expanded(child: GestureDetector(
                  onTap: () => setState(() => gender = g),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(color: gender == g ? C.emeraldTint : C.surface, borderRadius: BorderRadius.circular(12), border: Border.all(color: gender == g ? C.emerald : C.hairline, width: gender == g ? 1.5 : 1)),
                    child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [Ic(g == 'Male' ? 'genderM' : 'genderF', size: 16, color: gender == g ? C.emeraldDark : C.slate), const SizedBox(width: 6), Text(g, style: T.d(12, w: FontWeight.w700, color: gender == g ? C.emeraldDark : C.slate))]),
                  ),
                )),
                if (g == 'Male') const SizedBox(width: 8),
              ],
            ]),
            const SizedBox(height: 12),
            TSButton(
              full: true,
              variant: left > 0 ? BtnVariant.primary : BtnVariant.ghost,
              onTap: () {
                if (name.text.trim().isEmpty || left <= 0) return;
                setState(() {
                  members.add((name: name.text.trim(), gender: gender));
                  name.clear();
                });
              },
              child: Row(mainAxisSize: MainAxisSize.min, children: [
                Ic('plus', size: 18, color: left > 0 ? Colors.white : C.emeraldDark),
                const SizedBox(width: 6),
                Text(left > 0 ? 'Add to trip' : 'Trip is full'),
              ]),
            ),
          ]),
        ),
        const SizedBox(height: 18),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [_label('Members you added'), GenderSplit(male: male, female: female)]),
        Container(
          decoration: BoxDecoration(color: C.surface, borderRadius: BorderRadius.circular(18), border: Border.all(color: C.hairline), boxShadow: S.card),
          clipBehavior: Clip.antiAlias,
          child: members.isEmpty
              ? Padding(padding: const EdgeInsets.all(24), child: Center(child: Text('No manual members yet.', style: T.b(13, w: FontWeight.w500, color: C.mist))))
              : Column(children: [
                  for (int i = 0; i < members.length; i++)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                      decoration: BoxDecoration(border: i > 0 ? const Border(top: BorderSide(color: C.hairline)) : null),
                      child: Row(children: [
                        Container(width: 36, height: 36, decoration: BoxDecoration(color: hsl(members[i].gender == 'Female' ? 330 : 210, 0.45, 0.64), shape: BoxShape.circle), alignment: Alignment.center, child: Text(members[i].name[0], style: T.d(13, w: FontWeight.w700, color: Colors.white))),
                        const SizedBox(width: 11),
                        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
                          Text(members[i].name, style: T.b(13.5, w: FontWeight.w600)),
                          Row(children: [Ic(members[i].gender == 'Female' ? 'genderF' : 'genderM', size: 12, color: C.mist), const SizedBox(width: 4), Text('${members[i].gender} · Added by host', style: T.b(11, w: FontWeight.w500, color: C.mist))]),
                        ])),
                        GestureDetector(onTap: () => setState(() => members.removeAt(i)), child: Container(width: 30, height: 30, decoration: BoxDecoration(color: Color.alphaBlend(C.error.withValues(alpha: 0.09), Colors.white), shape: BoxShape.circle), child: const Ic('trash', size: 15, color: C.error))),
                      ]),
                    ),
                ]),
        ),
      ],
    );
  }

  Widget _legend(Color c, String t) => Row(mainAxisSize: MainAxisSize.min, children: [Container(width: 8, height: 8, decoration: BoxDecoration(color: c, shape: BoxShape.circle)), const SizedBox(width: 5), Text(t, style: T.b(12, w: FontWeight.w600, color: C.slate))]);
}
