import 'package:flutter/material.dart';
import '../core/theme.dart';

/// Image with a striped-hue placeholder fallback + optional scrim — the
/// prototype's `Placeholder` component.
class Photo extends StatelessWidget {
  final String? src; // unsplash url (already built) or null
  final int hue;
  final double? height;
  final double radius;
  final bool scrim;
  final bool dark;
  final BoxFit fit;
  final Widget? child;
  const Photo({
    super.key,
    this.src,
    this.hue = 150,
    this.height,
    this.radius = R.image,
    this.scrim = false,
    this.dark = false,
    this.fit = BoxFit.cover,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    final base = hsl(hue.toDouble(), 0.26, dark ? 0.30 : 0.80);
    final stripe = hsl(hue.toDouble(), 0.24, dark ? 0.26 : 0.75);
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: SizedBox(
        height: height,
        width: double.infinity,
        child: Stack(
          fit: StackFit.expand,
          children: [
            // striped placeholder background
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: const Alignment(-1, -1),
                  end: const Alignment(1, 1),
                  colors: [base, stripe, base],
                  stops: const [0.0, 0.5, 1.0],
                  tileMode: TileMode.repeated,
                ),
              ),
            ),
            if (src != null)
              Image.network(
                src!,
                fit: fit,
                gaplessPlayback: true,
                errorBuilder: (_, _, _) => const SizedBox.shrink(),
                loadingBuilder: (_, child, p) => p == null ? child : const SizedBox.shrink(),
              ),
            if (scrim)
              const DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [Color(0x9E14201D), Color(0x0014201D)],
                    stops: [0.0, 0.55],
                  ),
                ),
              ),
            ?child,
          ],
        ),
      ),
    );
  }
}
