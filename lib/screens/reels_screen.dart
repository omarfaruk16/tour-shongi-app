import 'package:flutter/material.dart';
import '../core/theme.dart';
import '../core/icons.dart';
import '../data/models.dart';
import '../data/content.dart';
import 'detail_screen.dart';

class ReelsScreen extends StatelessWidget {
  const ReelsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      scrollDirection: Axis.vertical,
      itemCount: reels.length,
      itemBuilder: (_, i) => ReelCard(reel: reels[i], onOpenLink: (id) => _open(context, id)),
    );
  }

  void _open(BuildContext context, String id) {
    final l = listingById(id);
    if (l != null) Navigator.of(context).push(MaterialPageRoute(builder: (_) => DetailScreen(item: l)));
  }
}

class ReelCard extends StatefulWidget {
  final Reel reel;
  final void Function(String) onOpenLink;
  final bool solo;
  const ReelCard({super.key, required this.reel, required this.onOpenLink, this.solo = false});
  @override
  State<ReelCard> createState() => _ReelCardState();
}

class _ReelCardState extends State<ReelCard> {
  bool liked = false;
  bool saved = false;
  bool following = false;
  bool muted = true;

  @override
  void initState() {
    super.initState();
    liked = widget.reel.id == 'r2';
  }

  @override
  Widget build(BuildContext context) {
    final r = widget.reel;
    final likeCount = r.likes + (liked ? 1 : 0);
    final topPad = MediaQuery.of(context).padding.top;
    final botPad = MediaQuery.of(context).padding.bottom;
    return Container(
      color: hsl(r.hue.toDouble(), 0.4, 0.22),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.network(unsplash(r.img, 800), fit: BoxFit.cover,
              errorBuilder: (_, _, _) => const SizedBox.shrink()),
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  hsl(r.hue.toDouble(), 0.30, 0.12).withValues(alpha: 0.28),
                  hsl(r.hue.toDouble(), 0.35, 0.08).withValues(alpha: 0.42),
                ],
              ),
            ),
          ),
          // top bar
          Positioned(
            top: topPad + 6,
            left: 20,
            right: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Opacity(
                  opacity: widget.solo ? 0 : 1,
                  child: Text('Reels', style: T.d(22, w: FontWeight.w800, color: Colors.white)),
                ),
                Row(mainAxisSize: MainAxisSize.min, children: [
                  if (visited.contains(r.linkId)) ...[
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 5),
                      decoration: BoxDecoration(color: const Color(0xEB1F8A5B), borderRadius: BorderRadius.circular(999)),
                      child: Row(mainAxisSize: MainAxisSize.min, children: [
                        const Icon(Icons.check_rounded, size: 12, color: Colors.white),
                        const SizedBox(width: 5),
                        Text('Visited', style: T.b(11, w: FontWeight.w700, color: Colors.white)),
                      ]),
                    ),
                    const SizedBox(width: 7),
                  ],
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 5),
                    decoration: BoxDecoration(color: Colors.black.withValues(alpha: 0.3), borderRadius: BorderRadius.circular(999)),
                    child: Row(mainAxisSize: MainAxisSize.min, children: [
                      Ic(r.tag == 'Stay' ? 'bed' : 'compass', size: 13, color: Colors.white),
                      const SizedBox(width: 5),
                      Text(r.tag, style: T.b(11, w: FontWeight.w700, color: Colors.white)),
                    ]),
                  ),
                ]),
              ],
            ),
          ),
          // bottom scrim
          const Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            height: 300,
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [Color(0xB8000000), Color(0x00000000)],
                ),
              ),
            ),
          ),
          // right action rail
          Positioned(
            right: 12,
            bottom: 150 + botPad,
            child: Column(
              children: [
                GestureDetector(
                  onTap: () => setState(() => following = !following),
                  child: SizedBox(
                    width: 48,
                    height: 54,
                    child: Stack(clipBehavior: Clip.none, alignment: Alignment.topCenter, children: [
                      Container(
                        width: 46,
                        height: 46,
                        decoration: BoxDecoration(
                          color: hsl(r.hue.toDouble(), 0.45, 0.55),
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                        alignment: Alignment.center,
                        child: Text(r.owner[0], style: T.d(16, w: FontWeight.w700, color: Colors.white)),
                      ),
                      Positioned(
                        bottom: -2,
                        child: Container(
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                            color: following ? C.success : C.saffron,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 1.5),
                          ),
                          child: Icon(following ? Icons.check_rounded : Icons.add_rounded, size: 12, color: Colors.white),
                        ),
                      ),
                    ]),
                  ),
                ),
                const SizedBox(height: 18),
                _action('heart', '${(likeCount / 1000).toStringAsFixed(1)}k', active: liked, onTap: () => setState(() => liked = !liked)),
                const SizedBox(height: 18),
                _action('comment', '${r.comments}'),
                const SizedBox(height: 18),
                _action('send', '${r.shares}'),
                const SizedBox(height: 18),
                _action('bookmark', 'Save', active: saved, activeColor: C.saffron, onTap: () => setState(() => saved = !saved)),
                const SizedBox(height: 14),
                GestureDetector(
                  onTap: () => setState(() => muted = !muted),
                  child: Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(color: Colors.black.withValues(alpha: 0.28), shape: BoxShape.circle),
                    child: Ic(muted ? 'mute' : 'volume', size: 20, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
          // bottom info
          Positioned(
            left: 20,
            right: 84,
            bottom: 116 + botPad,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(children: [
                  Flexible(
                    child: Text(r.owner, maxLines: 1, overflow: TextOverflow.ellipsis, style: T.d(15, w: FontWeight.w700, color: Colors.white)),
                  ),
                  if (r.verified) ...[
                    const SizedBox(width: 6),
                    Container(
                      width: 17,
                      height: 17,
                      decoration: const BoxDecoration(color: C.info, shape: BoxShape.circle),
                      child: const Icon(Icons.check_rounded, size: 11, color: Colors.white),
                    ),
                  ],
                  const SizedBox(width: 8),
                  Text(r.kind, style: T.b(12, w: FontWeight.w500, color: Colors.white70)),
                ]),
                const SizedBox(height: 9),
                Text(r.caption, style: T.b(13.5, w: FontWeight.w400, color: Colors.white, height: 1.45)),
                const SizedBox(height: 10),
                Row(children: [
                  const Ic('music', size: 14, color: Colors.white),
                  const SizedBox(width: 7),
                  Flexible(child: Text(r.music, maxLines: 1, overflow: TextOverflow.ellipsis, style: T.b(12, w: FontWeight.w500, color: Colors.white))),
                ]),
                const SizedBox(height: 13),
                GestureDetector(
                  onTap: () => widget.onOpenLink(r.linkId),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 11),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.95),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Row(mainAxisSize: MainAxisSize.min, children: visited.contains(r.linkId)
                        ? [
                            const Icon(Icons.check_rounded, size: 17, color: C.emeraldDark),
                            const SizedBox(width: 8),
                            Text("You've been here · Book again", style: T.d(14, w: FontWeight.w700, color: C.emeraldDark)),
                          ]
                        : [
                            Ic(r.tag == 'Stay' ? 'bed' : 'compass', size: 17, color: C.emeraldDark),
                            const SizedBox(width: 8),
                            Text(r.cta, style: T.d(14, w: FontWeight.w700, color: C.emeraldDark)),
                            const SizedBox(width: 8),
                            const Ic('arrowR', size: 16, color: C.emeraldDark),
                          ]),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _action(String icon, String label, {bool active = false, Color activeColor = C.error, VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Container(
          width: 46,
          height: 46,
          decoration: BoxDecoration(color: Colors.black.withValues(alpha: 0.28), shape: BoxShape.circle),
          child: Ic(icon, size: 25, color: active ? activeColor : Colors.white),
        ),
        const SizedBox(height: 5),
        Text(label, style: T.b(11, w: FontWeight.w700, color: Colors.white)),
      ]),
    );
  }
}

/// Single-reel fullscreen viewer (ReelViewer).
class ReelViewer extends StatelessWidget {
  final Reel reel;
  const ReelViewer({super.key, required this.reel});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(children: [
        ReelCard(
          reel: reel,
          solo: true,
          onOpenLink: (id) {
            final l = listingById(id);
            if (l != null) {
              Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => DetailScreen(item: l)));
            }
          },
        ),
        Positioned(
          top: MediaQuery.of(context).padding.top + 8,
          left: 16,
          child: GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(color: Colors.black.withValues(alpha: 0.4), shape: BoxShape.circle),
              child: const Ic('chevL', size: 22, color: Colors.white),
            ),
          ),
        ),
      ]),
    );
  }
}
