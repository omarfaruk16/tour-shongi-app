import 'package:flutter/material.dart';
import '../core/theme.dart';
import '../core/icons.dart';
import 'ui.dart';

const _months = ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'];
const _wdays = ['S', 'M', 'T', 'W', 'T', 'F', 'S'];
const _wdaysFull = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];

DateTime startOfDay(DateTime d) => DateTime(d.year, d.month, d.day);
DateTime addDays(DateTime d, int n) => DateTime(d.year, d.month, d.day + n);
int nightsBetween(DateTime? a, DateTime? b) =>
    (a != null && b != null) ? startOfDay(b).difference(startOfDay(a)).inDays : 0;
String fmtShort(DateTime? d) => d == null ? '—' : '${d.day} ${_months[d.month - 1].substring(0, 3)}';
String _fmtLong(DateTime? d) => d == null ? 'Select' : '${_wdaysFull[d.weekday % 7]}, ${d.day} ${_months[d.month - 1].substring(0, 3)}';
bool _sameDay(DateTime? a, DateTime? b) => a != null && b != null && a.year == b.year && a.month == b.month && a.day == b.day;

/// Date-range field that expands into a calendar (DateRangeField).
class DateRangeField extends StatefulWidget {
  final DateTime? from, to;
  final bool single;
  final void Function(DateTime? from, DateTime? to) onChange;
  const DateRangeField({super.key, required this.from, required this.to, this.single = false, required this.onChange});
  @override
  State<DateRangeField> createState() => _DateRangeFieldState();
}

class _DateRangeFieldState extends State<DateRangeField> {
  bool open = false;
  @override
  Widget build(BuildContext context) {
    final n = nightsBetween(widget.from, widget.to);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () => setState(() => open = !open),
          child: Row(children: [
            Expanded(child: _pill(open && (widget.from == null || widget.to != null), widget.single ? 'Date' : 'Check in', _fmtLong(widget.from))),
            if (!widget.single) ...[
              const SizedBox(width: 9),
              const Ic('arrowR', size: 16, color: C.mist),
              const SizedBox(width: 9),
              Expanded(child: _pill(open && widget.from != null && widget.to == null, 'Check out', _fmtLong(widget.to))),
            ],
            const SizedBox(width: 9),
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: open ? C.emerald : C.cloud,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: C.hairline),
              ),
              child: Ic('cal', size: 18, color: open ? Colors.white : C.emeraldDark),
            ),
          ]),
        ),
        if (!widget.single && n > 0)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 4),
              decoration: BoxDecoration(color: C.emeraldTint, borderRadius: BorderRadius.circular(999)),
              child: Row(mainAxisSize: MainAxisSize.min, children: [
                const Ic('clock', size: 13, color: C.emeraldDark),
                const SizedBox(width: 6),
                Text('$n night${n > 1 ? 's' : ''}', style: T.b(12, w: FontWeight.w600, color: C.emeraldDark)),
              ]),
            ),
          ),
        AnimatedCrossFade(
          firstChild: const SizedBox(width: double.infinity),
          secondChild: Padding(
            padding: const EdgeInsets.only(top: 12),
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(color: C.surface, borderRadius: BorderRadius.circular(18), border: Border.all(color: C.hairline), boxShadow: S.card),
              child: _RangeCalendar(
                from: widget.from,
                to: widget.to,
                onChange: (f, t) {
                  if (widget.single) {
                    widget.onChange(f, null);
                    setState(() => open = false);
                  } else {
                    widget.onChange(f, t);
                    if (f != null && t != null) setState(() => open = false);
                  }
                },
              ),
            ),
          ),
          crossFadeState: open ? CrossFadeState.showSecond : CrossFadeState.showFirst,
          duration: const Duration(milliseconds: 250),
        ),
      ],
    );
  }

  Widget _pill(bool active, String top, String val) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
        decoration: BoxDecoration(
          color: active ? C.emeraldTint : C.cloud,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: active ? C.emerald : C.hairline, width: active ? 1.5 : 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(top.toUpperCase(), style: T.b(10, w: FontWeight.w600, color: C.mist, spacing: 0.5)),
            const SizedBox(height: 2),
            Text(val, maxLines: 1, overflow: TextOverflow.ellipsis, style: T.d(14, w: FontWeight.w700, color: val == 'Select' ? C.mist : C.ink)),
          ],
        ),
      );
}

class _RangeCalendar extends StatefulWidget {
  final DateTime? from, to;
  final void Function(DateTime? from, DateTime? to) onChange;
  const _RangeCalendar({required this.from, required this.to, required this.onChange});
  @override
  State<_RangeCalendar> createState() => _RangeCalendarState();
}

class _RangeCalendarState extends State<_RangeCalendar> {
  late DateTime view = startOfDay(widget.from ?? DateTime.now());

  void _shift(int n) => setState(() => view = DateTime(view.year, view.month + n));

  void _pick(DateTime d) {
    final from = widget.from, to = widget.to;
    if (from == null || (to != null)) {
      widget.onChange(d, null);
    } else if (!d.isAfter(from)) {
      widget.onChange(d, null);
    } else {
      widget.onChange(from, d);
    }
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final atStart = view.year == now.year && view.month == now.month;
    return Column(children: [
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        _nav('chevL', atStart ? null : () => _shift(-1)),
        Text('${_months[view.month - 1]} ${view.year}', style: T.d(15, w: FontWeight.w700)),
        _nav('chevR', () => _shift(1)),
      ]),
      const SizedBox(height: 12),
      _MonthGrid(year: view.year, month: view.month, from: widget.from, to: widget.to, onPick: _pick),
    ]);
  }

  Widget _nav(String icon, VoidCallback? onTap) => Opacity(
        opacity: onTap == null ? 0.35 : 1,
        child: GestureDetector(
          onTap: onTap,
          child: Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(color: C.surface, shape: BoxShape.circle, border: Border.all(color: C.hairline)),
            child: Ic(icon, size: 17, color: C.ink),
          ),
        ),
      );
}

class _MonthGrid extends StatelessWidget {
  final int year, month;
  final DateTime? from, to;
  final void Function(DateTime) onPick;
  const _MonthGrid({required this.year, required this.month, required this.from, required this.to, required this.onPick});
  @override
  Widget build(BuildContext context) {
    final today = startOfDay(DateTime.now());
    final lead = DateTime(year, month, 1).weekday % 7; // Sun=0
    final daysIn = DateTime(year, month + 1, 0).day;
    final cells = <DateTime?>[for (var i = 0; i < lead; i++) null, for (var d = 1; d <= daysIn; d++) DateTime(year, month, d)];
    return Column(children: [
      Row(children: [for (final w in _wdays) Expanded(child: Center(child: Text(w, style: T.b(11, w: FontWeight.w700, color: C.mist))))]),
      const SizedBox(height: 6),
      for (int r = 0; r < (cells.length / 7).ceil(); r++)
        Row(
          children: [
            for (int ci = r * 7; ci < r * 7 + 7; ci++)
              Expanded(child: ci < cells.length ? _cell(cells[ci], today) : const SizedBox(height: 42)),
          ],
        ),
    ]);
  }

  Widget _cell(DateTime? d, DateTime today) {
    if (d == null) return const SizedBox(height: 42);
    final past = d.isBefore(today);
    final isFrom = _sameDay(d, from);
    final isTo = _sameDay(d, to);
    final inRange = from != null && to != null && d.isAfter(from!) && d.isBefore(to!);
    final isEdge = isFrom || isTo;
    final hasRange = from != null && to != null;
    return SizedBox(
      height: 42,
      child: Stack(
        alignment: Alignment.center,
        children: [
          if ((inRange || isEdge) && hasRange)
            Positioned(
              top: 4,
              bottom: 4,
              left: 0,
              right: 0,
              child: Row(children: [
                // left half tints when this cell connects to an earlier day
                Expanded(child: ColoredBox(color: (inRange || isTo) ? C.emeraldTint : Colors.transparent)),
                // right half tints when it connects to a later day
                Expanded(child: ColoredBox(color: (inRange || isFrom) ? C.emeraldTint : Colors.transparent)),
              ]),
            ),
          GestureDetector(
            onTap: past ? null : () => onPick(d),
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(color: isEdge ? C.emerald : Colors.transparent, shape: BoxShape.circle),
              alignment: Alignment.center,
              child: Text(
                '${d.day}',
                style: isEdge
                    ? T.d(14, w: FontWeight.w800, color: Colors.white)
                    : T.b(14, w: FontWeight.w600, color: past ? C.hairline : (inRange ? C.emeraldDark : C.ink)),
              ),
            ),
          ),
          if (_sameDay(d, today) && !isEdge)
            const Positioned(bottom: 5, child: SizedBox(width: 4, height: 4, child: DecoratedBox(decoration: BoxDecoration(color: C.emerald, shape: BoxShape.circle)))),
        ],
      ),
    );
  }
}

/// Persons / rooms stepper row used in sheets (PersonsRow).
class PersonsRow extends StatelessWidget {
  final int value, min, max;
  final ValueChanged<int> onChange;
  final String label, icon;
  final String? sub;
  const PersonsRow({super.key, required this.value, required this.onChange, this.min = 1, this.max = 12, required this.label, this.sub, this.icon = 'users'});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(color: C.cloud, borderRadius: BorderRadius.circular(14), border: Border.all(color: C.hairline)),
      child: Row(children: [
        Container(width: 38, height: 38, decoration: BoxDecoration(color: C.surface, borderRadius: BorderRadius.circular(11), border: Border.all(color: C.hairline)), child: Ic(icon, size: 18, color: C.emeraldDark)),
        const SizedBox(width: 11),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
            Text(label, style: T.d(14, w: FontWeight.w700)),
            if (sub != null) Text(sub!, style: T.b(11, w: FontWeight.w500, color: C.mist)),
          ]),
        ),
        QtyStepper(value, onChange, min: min, max: max),
      ]),
    );
  }
}
