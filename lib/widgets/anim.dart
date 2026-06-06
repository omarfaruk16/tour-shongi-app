import 'package:flutter/material.dart';

/// Scales its child down briefly on tap (the prototype's `.press` effect).
class Pressable extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final double scale;
  final HitTestBehavior behavior;
  const Pressable({
    super.key,
    required this.child,
    this.onTap,
    this.scale = 0.96,
    this.behavior = HitTestBehavior.opaque,
  });
  @override
  State<Pressable> createState() => _PressableState();
}

class _PressableState extends State<Pressable> {
  bool _down = false;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: widget.behavior,
      onTapDown: widget.onTap == null ? null : (_) => setState(() => _down = true),
      onTapUp: widget.onTap == null ? null : (_) => setState(() => _down = false),
      onTapCancel: widget.onTap == null ? null : () => setState(() => _down = false),
      onTap: widget.onTap,
      child: AnimatedScale(
        scale: _down ? widget.scale : 1,
        duration: const Duration(milliseconds: 130),
        curve: Curves.easeOut,
        child: widget.child,
      ),
    );
  }
}

/// Fades + slides a child up on first build, with an optional stagger delay
/// (the prototype's `staggerIn` / `riseIn`).
class StaggerIn extends StatefulWidget {
  final Widget child;
  final int index;
  final Duration base;
  final double dy;
  const StaggerIn({
    super.key,
    required this.child,
    this.index = 0,
    this.base = const Duration(milliseconds: 60),
    this.dy = 16,
  });
  @override
  State<StaggerIn> createState() => _StaggerInState();
}

class _StaggerInState extends State<StaggerIn> with SingleTickerProviderStateMixin {
  late final AnimationController _c =
      AnimationController(vsync: this, duration: const Duration(milliseconds: 460));
  late final Animation<double> _a =
      CurvedAnimation(parent: _c, curve: const Cubic(0.22, 1, 0.36, 1));

  @override
  void initState() {
    super.initState();
    Future.delayed(widget.base * widget.index + const Duration(milliseconds: 30), () {
      if (mounted) _c.forward();
    });
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _a,
      builder: (_, child) => Opacity(
        opacity: _a.value,
        child: Transform.translate(offset: Offset(0, (1 - _a.value) * widget.dy), child: child),
      ),
      child: widget.child,
    );
  }
}

/// A bar/width that animates from 0 to [value] (0..1) — used by SlotBar.
class GrowBar extends StatelessWidget {
  final double value;
  final double height;
  final Color color;
  final Color track;
  final Gradient? gradient;
  const GrowBar({
    super.key,
    required this.value,
    this.height = 8,
    required this.color,
    required this.track,
    this.gradient,
  });
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(99),
      child: Container(
        height: height,
        color: track,
        alignment: Alignment.centerLeft,
        child: LayoutBuilder(builder: (context, c) {
          return TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: value.clamp(0, 1)),
            duration: const Duration(milliseconds: 600),
            curve: const Cubic(0.22, 1, 0.36, 1),
            builder: (_, v, _) => Container(
              width: c.maxWidth * v,
              height: height,
              decoration: BoxDecoration(
                color: gradient == null ? color : null,
                gradient: gradient,
                borderRadius: BorderRadius.circular(99),
              ),
            ),
          );
        }),
      ),
    );
  }
}
