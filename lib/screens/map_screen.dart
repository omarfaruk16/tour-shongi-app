import 'package:flutter/material.dart';
import '../core/theme.dart';
import '../core/icons.dart';
import '../data/models.dart';
import '../data/content.dart';
import '../nav.dart';
import '../widgets/photo.dart';

const _coords = <String, Offset>{
  'sayeman': Offset(408, 250),
  'mermaid': Offset(360, 360),
  'sajek-cloud': Offset(150, 150),
  'tea-bungalow': Offset(210, 470),
  'paraglide': Offset(120, 300),
  'scuba': Offset(470, 560),
  'cruise': Offset(250, 620),
};

int _mapPrice(Listing it) {
  final p = it.base.budget * (it.discount > 0 ? 1 - it.discount / 100 : 1);
  return (p / 50).round() * 50;
}

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});
  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final _tc = TransformationController();
  String filter = 'all';
  int sel = 0;
  late final List<Listing> _all;

  @override
  void initState() {
    super.initState();
    _all = [...hotels, ...activities].where((it) => _coords.containsKey(it.id)).toList();
    _tc.value = Matrix4.identity()
      ..translateByDouble(-60.0, -120.0, 0, 1)
      ..scaleByDouble(1.1, 1.1, 1.1, 1);
  }

  @override
  void dispose() {
    _tc.dispose();
    super.dispose();
  }

  List<Listing> get points => _all
      .where((p) => filter == 'all' || (filter == 'stays' ? p.kind == 'hotel' : p.kind != 'hotel'))
      .toList();

  @override
  Widget build(BuildContext context) {
    final topPad = MediaQuery.of(context).padding.top;
    final pts = points;
    final selItem = sel < pts.length ? pts[sel] : (pts.isNotEmpty ? pts[0] : null);
    return Scaffold(
      backgroundColor: const Color(0xFFBFE3DF),
      body: Stack(children: [
        InteractiveViewer(
          transformationController: _tc,
          minScale: 0.55,
          maxScale: 2.8,
          constrained: false,
          boundaryMargin: const EdgeInsets.all(400),
          child: SizedBox(
            width: 600,
            height: 760,
            child: Stack(children: [
              CustomPaint(size: const Size(600, 760), painter: _MapPainter()),
              for (int i = 0; i < pts.length; i++)
                Positioned(
                  left: _coords[pts[i].id]!.dx,
                  top: _coords[pts[i].id]!.dy,
                  child: FractionalTranslation(
                    translation: const Offset(-0.5, -1),
                    child: _Pin(
                      item: pts[i],
                      selected: i == sel,
                      onTap: () => setState(() => sel = i),
                    ),
                  ),
                ),
              const Positioned(
                left: 300,
                top: 410,
                child: FractionalTranslation(
                  translation: Offset(-0.5, -0.5),
                  child: _YouDot(),
                ),
              ),
            ]),
          ),
        ),
        // top bar
        Positioned(
          top: topPad + 6,
          left: 16,
          right: 16,
          child: Column(children: [
            Container(
              padding: const EdgeInsets.fromLTRB(12, 8, 8, 8),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.85),
                borderRadius: BorderRadius.circular(999),
                boxShadow: const [BoxShadow(color: Color(0x2414201D), blurRadius: 20, offset: Offset(0, 6))],
              ),
              child: Row(children: [
                GestureDetector(onTap: () => Navigator.pop(context), child: const Ic('chevL', size: 22, color: C.ink)),
                const SizedBox(width: 8),
                const Ic('search', size: 18, color: C.mist),
                const SizedBox(width: 8),
                Expanded(child: Text('Find via map', style: T.b(14, w: FontWeight.w600, color: C.slate))),
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(gradient: G.emerald, shape: BoxShape.circle),
                  child: const Ic('filter', size: 18, color: Colors.white),
                ),
              ]),
            ),
            const SizedBox(height: 10),
            Row(children: [
              for (final f in const [('all', 'All', 'layers'), ('stays', 'Stays', 'bed'), ('activities', 'Activities', 'compass')]) ...[
                GestureDetector(
                  onTap: () => setState(() {
                    filter = f.$1;
                    sel = 0;
                  }),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: filter == f.$1 ? C.emerald : Colors.white.withValues(alpha: 0.85),
                      borderRadius: BorderRadius.circular(999),
                      boxShadow: const [BoxShadow(color: Color(0x1F14201D), blurRadius: 12, offset: Offset(0, 4))],
                    ),
                    child: Row(mainAxisSize: MainAxisSize.min, children: [
                      Ic(f.$3, size: 15, color: filter == f.$1 ? Colors.white : C.emerald),
                      const SizedBox(width: 6),
                      Text(f.$2, style: T.d(12.5, w: FontWeight.w700, color: filter == f.$1 ? Colors.white : C.ink)),
                    ]),
                  ),
                ),
                const SizedBox(width: 8),
              ],
            ]),
          ]),
        ),
        // count pill
        Positioned(
          left: 16,
          bottom: 200,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.9),
              borderRadius: BorderRadius.circular(999),
              boxShadow: const [BoxShadow(color: Color(0x2414201D), blurRadius: 16, offset: Offset(0, 6))],
            ),
            child: Row(mainAxisSize: MainAxisSize.min, children: [
              const Ic('pin', size: 15, color: C.emerald),
              const SizedBox(width: 7),
              Text('${pts.length} places', style: T.d(12.5, w: FontWeight.w700)),
            ]),
          ),
        ),
        // zoom controls
        Positioned(
          right: 16,
          bottom: 196,
          child: Column(children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.9),
                borderRadius: BorderRadius.circular(16),
                boxShadow: const [BoxShadow(color: Color(0x2914201D), blurRadius: 20, offset: Offset(0, 8))],
              ),
              child: Column(children: [
                _zoomBtn('plus', () => _zoom(1.35)),
                const Divider(height: 1, color: Color(0x1A14201D)),
                _zoomBtn('minus', () => _zoom(1 / 1.35)),
              ]),
            ),
            const SizedBox(height: 10),
            GestureDetector(
              onTap: () => setState(() => _tc.value = Matrix4.identity()
                ..translateByDouble(-60.0, -120.0, 0, 1)
                ..scaleByDouble(1.1, 1.1, 1.1, 1)),
              child: Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.9),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: const [BoxShadow(color: Color(0x2914201D), blurRadius: 20, offset: Offset(0, 8))],
                ),
                child: const Ic('locate', size: 20, color: C.emerald),
              ),
            ),
          ]),
        ),
        // bottom carousel
        if (selItem != null)
          Positioned(
            left: 0,
            right: 0,
            bottom: 26,
            child: SizedBox(
              height: 96,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: pts.length,
                separatorBuilder: (_, _) => const SizedBox(width: 12),
                itemBuilder: (_, i) => GestureDetector(
                  onTap: () => i == sel ? openDetail(context, pts[i]) : setState(() => sel = i),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    transform: Matrix4.translationValues(0, i == sel ? -4 : 0, 0),
                    child: _PeekCard(pts[i]),
                  ),
                ),
              ),
            ),
          ),
      ]),
    );
  }

  void _zoom(double factor) {
    final m = _tc.value.clone()..scaleByDouble(factor, factor, factor, 1);
    _tc.value = m;
    setState(() {});
  }

  Widget _zoomBtn(String icon, VoidCallback onTap) => GestureDetector(
        onTap: onTap,
        child: SizedBox(width: 44, height: 44, child: Ic(icon, size: 20, color: C.ink)),
      );
}

class _Pin extends StatelessWidget {
  final Listing item;
  final bool selected;
  final VoidCallback onTap;
  const _Pin({required this.item, required this.selected, required this.onTap});
  @override
  Widget build(BuildContext context) {
    final isStay = item.kind == 'hotel';
    final color = isStay ? C.emerald : C.saffronDark;
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: selected ? color : C.surface,
              borderRadius: BorderRadius.circular(999),
              border: selected ? null : Border.all(color: color, width: 1.5),
              boxShadow: const [BoxShadow(color: Color(0x3814201D), blurRadius: 12, offset: Offset(0, 4))],
            ),
            child: Row(mainAxisSize: MainAxisSize.min, children: [
              Ic(isStay ? 'bed' : 'compass', size: 14, color: selected ? Colors.white : color),
              const SizedBox(width: 5),
              Text(taka(_mapPrice(item)),
                  style: T.d(12, w: FontWeight.w700, color: selected ? Colors.white : color)),
            ]),
          ),
          Transform.translate(
            offset: const Offset(0, -1),
            child: CustomPaint(size: const Size(10, 7), painter: _StemPainter(selected ? color : C.surface)),
          ),
        ],
      ),
    );
  }
}

class _StemPainter extends CustomPainter {
  final Color color;
  _StemPainter(this.color);
  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()..color = color;
    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width, 0)
      ..lineTo(size.width / 2, size.height)
      ..close();
    canvas.drawPath(path, p);
  }

  @override
  bool shouldRepaint(covariant _StemPainter old) => old.color != color;
}

class _YouDot extends StatelessWidget {
  const _YouDot();
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 18,
      height: 18,
      decoration: BoxDecoration(
        color: C.info,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 3),
        boxShadow: [BoxShadow(color: C.info.withValues(alpha: 0.25), spreadRadius: 6)],
      ),
    );
  }
}

class _PeekCard extends StatelessWidget {
  final Listing item;
  const _PeekCard(this.item);
  @override
  Widget build(BuildContext context) {
    final isStay = item.kind == 'hotel';
    return Container(
      width: 252,
      decoration: BoxDecoration(
        color: C.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: C.hairline),
        boxShadow: S.float,
      ),
      clipBehavior: Clip.antiAlias,
      child: Row(children: [
        SizedBox(
          width: 96,
          child: Stack(fit: StackFit.expand, children: [
            Photo(src: unsplash(item.img, 300), hue: item.hue, radius: 0),
            Positioned(
              top: 7,
              left: 7,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(color: isStay ? C.emerald : C.saffronDark, borderRadius: BorderRadius.circular(999)),
                child: Text(isStay ? 'Stay' : 'Activity', style: T.d(9, w: FontWeight.w700, color: Colors.white)),
              ),
            ),
          ]),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(item.name, maxLines: 1, overflow: TextOverflow.ellipsis, style: T.d(13.5, w: FontWeight.w700, spacing: -0.2)),
                const SizedBox(height: 3),
                Row(children: [
                  const Ic('pin', size: 12, color: C.mist),
                  const SizedBox(width: 4),
                  Flexible(child: Text(item.location, maxLines: 1, overflow: TextOverflow.ellipsis, style: T.b(11, w: FontWeight.w500, color: C.slate))),
                ]),
                const SizedBox(height: 3),
                Row(children: [
                  const Icon(Icons.star_rounded, size: 12, color: C.saffron),
                  const SizedBox(width: 3),
                  Text('${item.rating}', style: T.b(11, w: FontWeight.w600)),
                  Text(' · ${item.reviews}', style: T.b(11, w: FontWeight.w500, color: C.mist)),
                ]),
                const SizedBox(height: 6),
                Text.rich(TextSpan(children: [
                  TextSpan(text: 'from ', style: T.b(11, w: FontWeight.w500, color: C.mist)),
                  TextSpan(text: taka(_mapPrice(item)), style: T.d(14, w: FontWeight.w800, color: C.emeraldDark)),
                ])),
              ],
            ),
          ),
        ),
      ]),
    );
  }
}

/// Stylised vector map background (MapBackground).
class _MapPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final sea = Paint()
      ..shader = const LinearGradient(colors: [Color(0xFFBFE3DF), Color(0xFFA6D6E0)])
          .createShader(Offset.zero & size);
    canvas.drawRect(Offset.zero & size, sea);

    final land = Paint()
      ..shader = const LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Color(0xFFE9F1E4), Color(0xFFDCE9D6)])
          .createShader(Offset.zero & size);
    final landPath = Path()
      ..moveTo(-20, -20)
      ..lineTo(470, -20)
      ..cubicTo(440, 80, 470, 150, 430, 220)
      ..cubicTo(400, 280, 440, 330, 380, 380)
      ..cubicTo(320, 430, 360, 500, 300, 540)
      ..cubicTo(250, 575, 280, 650, 210, 690)
      ..cubicTo(150, 720, 60, 740, -20, 760)
      ..close();
    canvas.drawPath(landPath, land);
    final pen = Path()
      ..moveTo(520, 600)
      ..cubicTo(560, 560, 600, 580, 620, 540)
      ..lineTo(620, 780)
      ..lineTo(420, 780)
      ..cubicTo(460, 720, 480, 660, 520, 600)
      ..close();
    canvas.drawPath(pen, land);

    final forest = Paint()..color = const Color(0xFFCFE3C2);
    canvas.drawOval(Rect.fromCenter(center: const Offset(120, 170), width: 156, height: 116), forest);
    canvas.drawOval(Rect.fromCenter(center: const Offset(240, 470), width: 140, height: 160), forest);
    canvas.drawOval(Rect.fromCenter(center: const Offset(260, 630), width: 120, height: 96), Paint()..color = const Color(0xFFBCDCB0));
    canvas.drawOval(Rect.fromCenter(center: const Offset(80, 430), width: 100, height: 88), forest);

    final river = Paint()
      ..color = const Color(0xFFA6D6E0)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 22
      ..strokeCap = StrokeCap.round;
    final riverPath = Path()
      ..moveTo(180, -20)
      ..cubicTo(200, 120, 120, 200, 160, 320)
      ..cubicTo(190, 410, 120, 470, 150, 600)
      ..cubicTo(165, 670, 130, 720, 150, 780);
    canvas.drawPath(riverPath, river);

    final road = Paint()
      ..color = Colors.white.withValues(alpha: 0.85)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 7
      ..strokeCap = StrokeCap.round;
    final r1 = Path()..moveTo(-20, 240)..cubicTo(120, 220, 260, 280, 430, 250);
    final r2 = Path()..moveTo(70, -20)..cubicTo(90, 160, 60, 360, 120, 560)..cubicTo(150, 660, 120, 740, 130, 780);
    final r3 = Path()..moveTo(430, 250)..cubicTo(380, 360, 300, 420, 250, 540);
    final r4 = Path()..moveTo(210, 470)..cubicTo(320, 460, 380, 520, 470, 560);
    for (final r in [r1, r2, r3, r4]) {
      canvas.drawPath(r, road);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
