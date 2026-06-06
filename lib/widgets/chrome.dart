import 'package:flutter/material.dart';
import '../core/theme.dart';
import '../core/icons.dart';
import 'ui.dart';

/// Top location header (LocationHeader): "You are at · Dhaka, BD" + actions.
class LocationHeader extends StatelessWidget {
  final VoidCallback? onBell;
  final VoidCallback? onSearch;
  const LocationHeader({super.key, this.onBell, this.onSearch});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: C.emeraldTint,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Ic('pin', size: 19, color: C.emeraldDark),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('You are at', style: T.b(11, w: FontWeight.w500, color: C.mist)),
              Row(
                children: [
                  Text('Dhaka, BD', style: T.d(16, w: FontWeight.w700, spacing: -0.2)),
                  const SizedBox(width: 4),
                  const Ic('chevD', size: 15, color: C.slate),
                ],
              ),
            ],
          ),
          const Spacer(),
          IconBtn('sliders', onTap: onSearch),
          const SizedBox(width: 10),
          IconBtn(
            'bell',
            onTap: onBell,
            badge: Positioned(
              top: 8,
              right: 8,
              child: Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: C.saffron,
                  shape: BoxShape.circle,
                  border: Border.all(color: C.surface, width: 1.5),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Search field + filter button (TSSearchBar).
class TSSearchBar extends StatelessWidget {
  final VoidCallback? onFilter;
  final String placeholder;
  const TSSearchBar({super.key, this.onFilter, this.placeholder = 'Search stays, activities, places…'});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: onFilter,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
                decoration: BoxDecoration(
                  color: C.surface,
                  borderRadius: BorderRadius.circular(R.input),
                  border: Border.all(color: C.hairline),
                  boxShadow: const [BoxShadow(color: Color(0x0A14201D), blurRadius: 10, offset: Offset(0, 2))],
                ),
                child: Row(
                  children: [
                    const Ic('search', size: 19, color: C.mist),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(placeholder,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: T.b(14, w: FontWeight.w500, color: C.mist)),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          GestureDetector(
            onTap: onFilter,
            child: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                gradient: G.emerald,
                borderRadius: BorderRadius.circular(R.input),
                boxShadow: const [BoxShadow(color: Color(0x4D0E7C66), blurRadius: 16, offset: Offset(0, 6))],
              ),
              child: const Ic('filter', size: 20, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}

/// A horizontal scrollable category chip row.
class ChipRow extends StatelessWidget {
  final List<String> items;
  final String value;
  final ValueChanged<String> onChange;
  const ChipRow({super.key, required this.items, required this.value, required this.onChange});
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 38,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: items.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (_, i) =>
            TSChip(items[i], active: value == items[i], onTap: () => onChange(items[i])),
      ),
    );
  }
}
