import 'dart:math';
import 'package:flutter/material.dart';
import '../core/theme.dart';
import '../core/icons.dart';
import '../data/groups.dart';
import '../nav.dart';
import '../widgets/photo.dart';
import '../widgets/anim.dart';

const _hostReplies = [
  'Great question! Let me check and confirm that for you shortly. 😊',
  'Yes, that works — I’ll note it on your booking.',
  'Absolutely. Most travellers ask the same — you’re all set.',
  'We can arrange that. I’ll send the details over here.',
  'Happy to help! Anything else you’d like to know before you join?',
];

ChatThread _resolve(ChatCtx ctx) {
  if (ctx.support) {
    return chatFor('support', name: 'Tour Shongi Support', sub: 'Live chat · replies in ~2 min', hue: 158, verified: true);
  }
  if (ctx.event != null) {
    final ev = ctx.event!;
    final g = groupById(ev.groupId)!;
    return chatFor(ev.id, name: g.name, sub: 'Hosts ${ev.title}', hue: g.hue, img: g.img, verified: g.verified);
  }
  if (ctx.group != null) {
    final g = ctx.group!;
    return chatFor('grp:${g.id}', name: g.name, sub: g.tagline, hue: g.hue, img: g.img, verified: g.verified);
  }
  final l = ctx.listing!;
  return chatFor(l.id,
      name: l.name,
      sub: l.isActivity ? 'Activity host · replies fast' : 'Resort · replies in ~5 min',
      hue: l.hue,
      img: l.img,
      verified: true);
}

class ChatScreen extends StatefulWidget {
  final ChatCtx ctx;
  const ChatScreen({super.key, required this.ctx});
  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late final ChatThread thread = _resolve(widget.ctx);
  late final List<ChatMsg> msgs = List.of(thread.msgs);
  final _scroll = ScrollController();
  final _input = TextEditingController();
  bool typing = false;
  static const _quicks = ['Is pickup from Gulshan?', 'Any seats left?', 'What’s the refund policy?', 'Can I pay in instalments?'];

  void _scrollDown() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scroll.hasClients) _scroll.jumpTo(_scroll.position.maxScrollExtent);
    });
  }

  void _send([String? text]) {
    final t = (text ?? _input.text).trim();
    if (t.isEmpty) return;
    _input.clear();
    setState(() {
      msgs.add(ChatMsg('me', t, 'Now'));
      typing = true;
    });
    _scrollDown();
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (!mounted) return;
      setState(() {
        typing = false;
        msgs.add(ChatMsg('host', _hostReplies[Random().nextInt(_hostReplies.length)], 'Now'));
      });
      _scrollDown();
    });
  }

  @override
  void dispose() {
    _scroll.dispose();
    _input.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final topPad = MediaQuery.of(context).padding.top;
    return Scaffold(
      backgroundColor: C.cloud,
      body: Column(children: [
        // header
        Container(
          padding: EdgeInsets.fromLTRB(14, topPad + 8, 14, 14),
          decoration: const BoxDecoration(gradient: G.greenGlass, boxShadow: [BoxShadow(color: Color(0x330B5A4A), blurRadius: 18, offset: Offset(0, 6))]),
          child: Row(children: [
            Pressable(
              onTap: () => Navigator.pop(context),
              child: Container(width: 40, height: 40, decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.2), shape: BoxShape.circle), child: const Ic('chevL', size: 22, color: Colors.white)),
            ),
            const SizedBox(width: 11),
            ClipRRect(
              borderRadius: BorderRadius.circular(13),
              child: SizedBox(
                width: 42,
                height: 42,
                child: thread.img != null
                    ? Photo(src: unsplash(thread.img!, 120), hue: thread.hue, radius: 0)
                    : Container(color: hsl(thread.hue.toDouble(), 0.4, 0.55), alignment: Alignment.center, child: Text(thread.name[0], style: T.d(18, w: FontWeight.w700, color: Colors.white))),
              ),
            ),
            const SizedBox(width: 11),
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
                Row(children: [
                  Flexible(child: Text(thread.name, maxLines: 1, overflow: TextOverflow.ellipsis, style: T.d(16, w: FontWeight.w700, color: Colors.white))),
                  if (thread.verified) ...[
                    const SizedBox(width: 5),
                    Container(width: 15, height: 15, decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle), child: const Icon(Icons.check_rounded, size: 9, color: C.info)),
                  ],
                ]),
                Row(children: [
                  Container(width: 7, height: 7, decoration: const BoxDecoration(color: C.mint, shape: BoxShape.circle)),
                  const SizedBox(width: 5),
                  Flexible(child: Text('Online · ${thread.sub}', maxLines: 1, overflow: TextOverflow.ellipsis, style: T.b(11.5, w: FontWeight.w500, color: Colors.white.withValues(alpha: 0.85)))),
                ]),
              ]),
            ),
          ]),
        ),
        // messages
        Expanded(
          child: ListView(
            controller: _scroll,
            padding: const EdgeInsets.fromLTRB(16, 18, 16, 8),
            children: [
              Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                  decoration: BoxDecoration(color: C.surface, borderRadius: BorderRadius.circular(999), border: Border.all(color: C.hairline)),
                  child: Text('Today', style: T.b(11, w: FontWeight.w600, color: C.mist)),
                ),
              ),
              const SizedBox(height: 12),
              Center(
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 320),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(color: const Color(0x1FE8A33D), borderRadius: BorderRadius.circular(12), border: Border.all(color: const Color(0x40E8A33D))),
                  child: Row(mainAxisSize: MainAxisSize.min, children: [
                    const Ic('shield', size: 15, color: C.saffronDark),
                    const SizedBox(width: 8),
                    Flexible(child: Text('Keep chats & payments inside Tour Shongi for full protection.', style: T.b(11, w: FontWeight.w500, color: C.saffronDark, height: 1.4))),
                  ]),
                ),
              ),
              const SizedBox(height: 12),
              for (final m in msgs) Padding(padding: const EdgeInsets.only(bottom: 12), child: _Bubble(m)),
              if (typing) const Padding(padding: EdgeInsets.only(bottom: 12), child: _TypingDots()),
            ],
          ),
        ),
        // quick replies
        SizedBox(
          height: 50,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
            itemCount: _quicks.length,
            separatorBuilder: (_, _) => const SizedBox(width: 8),
            itemBuilder: (_, i) => GestureDetector(
              onTap: () => _send(_quicks[i]),
              child: Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(horizontal: 13),
                decoration: BoxDecoration(color: C.surface, borderRadius: BorderRadius.circular(999), border: Border.all(color: C.hairline)),
                child: Text(_quicks[i], style: T.b(12, w: FontWeight.w600, color: C.emeraldDark)),
              ),
            ),
          ),
        ),
        // input
        Container(
          padding: EdgeInsets.fromLTRB(14, 8, 14, 14 + MediaQuery.of(context).padding.bottom),
          decoration: const BoxDecoration(color: C.surface, border: Border(top: BorderSide(color: C.hairline))),
          child: Row(children: [
            Container(width: 42, height: 42, decoration: BoxDecoration(color: C.cloud, shape: BoxShape.circle, border: Border.all(color: C.hairline)), child: const Ic('plus', size: 20, color: C.slate)),
            const SizedBox(width: 10),
            Expanded(
              child: Container(
                padding: const EdgeInsets.only(left: 16, right: 6, top: 4, bottom: 4),
                decoration: BoxDecoration(color: C.cloud, borderRadius: BorderRadius.circular(999), border: Border.all(color: C.hairline)),
                child: Row(children: [
                  Expanded(
                    child: TextField(
                      controller: _input,
                      onChanged: (_) => setState(() {}),
                      onSubmitted: (_) => _send(),
                      textInputAction: TextInputAction.send,
                      style: T.b(14, w: FontWeight.w500),
                      decoration: InputDecoration(border: InputBorder.none, isDense: true, hintText: 'Message the host…', hintStyle: T.b(14, w: FontWeight.w500, color: C.mist)),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => _send(),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: 38,
                      height: 38,
                      decoration: BoxDecoration(gradient: _input.text.trim().isEmpty ? null : G.emerald, color: _input.text.trim().isEmpty ? C.hairline : null, shape: BoxShape.circle),
                      child: Ic('send', size: 18, color: _input.text.trim().isEmpty ? C.mist : Colors.white),
                    ),
                  ),
                ]),
              ),
            ),
          ]),
        ),
      ]),
    );
  }
}

class _Bubble extends StatelessWidget {
  final ChatMsg m;
  const _Bubble(this.m);
  @override
  Widget build(BuildContext context) {
    final me = m.from == 'me';
    return StaggerIn(
      dy: 8,
      child: Row(
        mainAxisAlignment: me ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          ConstrainedBox(
            constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.78),
            child: Column(crossAxisAlignment: me ? CrossAxisAlignment.end : CrossAxisAlignment.start, children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
                decoration: BoxDecoration(
                  gradient: me ? G.emerald : null,
                  color: me ? null : C.surface,
                  border: me ? null : Border.all(color: C.hairline),
                  borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(18),
                    topRight: const Radius.circular(18),
                    bottomLeft: Radius.circular(me ? 18 : 5),
                    bottomRight: Radius.circular(me ? 5 : 18),
                  ),
                  boxShadow: const [BoxShadow(color: Color(0x0D14201D), blurRadius: 8, offset: Offset(0, 2))],
                ),
                child: Text(m.text, style: T.b(14, w: FontWeight.w500, color: me ? Colors.white : C.ink, height: 1.45)),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(4, 4, 4, 0),
                child: Text(m.time, style: T.b(10, w: FontWeight.w500, color: C.mist)),
              ),
            ]),
          ),
        ],
      ),
    );
  }
}

class _TypingDots extends StatefulWidget {
  const _TypingDots();
  @override
  State<_TypingDots> createState() => _TypingDotsState();
}

class _TypingDotsState extends State<_TypingDots> with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(vsync: this, duration: const Duration(milliseconds: 1000))..repeat();
  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
        decoration: BoxDecoration(color: C.surface, border: Border.all(color: C.hairline), borderRadius: const BorderRadius.only(topLeft: Radius.circular(18), topRight: Radius.circular(18), bottomRight: Radius.circular(18), bottomLeft: Radius.circular(5))),
        child: AnimatedBuilder(
          animation: _c,
          builder: (_, _) => Row(mainAxisSize: MainAxisSize.min, children: [
            for (int d = 0; d < 3; d++) ...[
              Builder(builder: (_) {
                final t = ((_c.value - d * 0.18) % 1).clamp(0.0, 1.0);
                final scale = 0.6 + 0.4 * (1 - (t - 0.5).abs() * 2).clamp(0.0, 1.0);
                return Transform.scale(scale: scale, child: Container(width: 7, height: 7, decoration: const BoxDecoration(color: C.mist, shape: BoxShape.circle)));
              }),
              if (d < 2) const SizedBox(width: 4),
            ],
          ]),
        ),
      ),
    );
  }
}
