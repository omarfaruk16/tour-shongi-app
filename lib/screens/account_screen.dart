import 'package:flutter/material.dart';
import '../core/theme.dart';
import '../core/icons.dart';
import '../data/models.dart';
import '../data/content.dart';
import '../app_state.dart';
import '../nav.dart';
import '../widgets/cards.dart';

class AccountScreen extends StatelessWidget {
  final VoidCallback onLogout;
  final void Function(String) onTab;
  const AccountScreen({super.key, required this.onLogout, required this.onTab});

  void _item(BuildContext context, String to) {
    if (to == 'saved') {
      Navigator.of(context).push(MaterialPageRoute(builder: (_) => const SavedScreen()));
      return;
    }
    if (to == 'grouphost') {
      openHostFlow(context);
      return;
    }
    openProfileRoute(context, to, onLogout: onLogout, onOpen: (l) => openDetail(context, l));
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.only(bottom: 120),
      children: [
        _ProfileHeader(
          onSettings: () => openProfileRoute(context, 'settings', onLogout: onLogout),
          onEdit: () => openProfileRoute(context, 'details'),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
          child: _StatBlock(user.stats),
        ),
        const SizedBox(height: 22),
        _WalletCard(onTopUp: () => openProfileRoute(context, 'wallet')),
        const SizedBox(height: 22),
        const _PaymentMethods(),
        const SizedBox(height: 22),
        for (final g in accountGroups) ...[
          _MenuGroup(g, onItem: (to) => _item(context, to)),
          const SizedBox(height: 22),
        ],
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 2, 20, 0),
          child: GestureDetector(
            onTap: onLogout,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 14),
              decoration: BoxDecoration(
                color: Color.alphaBlend(C.error.withValues(alpha: 0.07), Colors.white),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: C.error.withValues(alpha: 0.35), width: 1.5),
              ),
              child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                const Ic('logout', size: 19, color: C.error),
                const SizedBox(width: 9),
                Text('Log out', style: T.d(15, w: FontWeight.w700, color: C.error)),
              ]),
            ),
          ),
        ),
        const SizedBox(height: 14),
        Center(child: Text('Tour Shongi · v1.0.0', style: T.b(11, w: FontWeight.w500, color: C.mist))),
      ],
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  final VoidCallback onSettings, onEdit;
  const _ProfileHeader({required this.onSettings, required this.onEdit});
  @override
  Widget build(BuildContext context) {
    final topPad = MediaQuery.of(context).padding.top;
    return Column(
      children: [
        SizedBox(
          height: 150 + topPad,
          child: Stack(fit: StackFit.expand, children: [
            Image.network(unsplash('1506905925346-21bda4d32df4', 800), fit: BoxFit.cover,
                errorBuilder: (_, _, _) => Container(color: C.emeraldDark)),
            const DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xD10E7C66), Color(0xE60A5A4A)],
                ),
              ),
            ),
            Positioned(
              top: topPad + 14,
              left: 20,
              right: 20,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('My Profile', style: T.d(22, w: FontWeight.w800, color: Colors.white, spacing: -0.4)),
                  Row(children: [
                    _glassBtn('share', () {}),
                    const SizedBox(width: 9),
                    _glassBtn('cog', onSettings),
                  ]),
                ],
              ),
            ),
          ]),
        ),
        Transform.translate(
          offset: const Offset(0, -46),
          child: Column(
            children: [
              Stack(children: [
                Container(
                  width: 92,
                  height: 92,
                  decoration: BoxDecoration(
                    color: hsl(user.hue.toDouble(), 0.45, 0.58),
                    shape: BoxShape.circle,
                    border: Border.all(color: C.cloud, width: 4),
                    boxShadow: const [BoxShadow(color: Color(0x2E14201D), blurRadius: 20, offset: Offset(0, 8))],
                  ),
                  alignment: Alignment.center,
                  child: Text(user.initials, style: T.d(32, w: FontWeight.w800, color: Colors.white)),
                ),
                Positioned(
                  bottom: 2,
                  right: 2,
                  child: GestureDetector(
                    onTap: onEdit,
                    child: Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(color: C.emerald, shape: BoxShape.circle, border: Border.all(color: C.cloud, width: 2.5)),
                      child: const Ic('edit', size: 14, color: Colors.white),
                    ),
                  ),
                ),
              ]),
              const SizedBox(height: 12),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Text(user.name, style: T.d(20, w: FontWeight.w800, spacing: -0.3)),
                const SizedBox(width: 7),
                Container(
                  width: 18,
                  height: 18,
                  decoration: const BoxDecoration(color: C.info, shape: BoxShape.circle),
                  child: const Icon(Icons.check_rounded, size: 11, color: Colors.white),
                ),
              ]),
              const SizedBox(height: 2),
              Text('${user.handle} · ${user.email}', style: T.b(13, w: FontWeight.w500, color: C.mist)),
              const SizedBox(height: 11),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                decoration: BoxDecoration(gradient: G.gold, borderRadius: BorderRadius.circular(999)),
                child: Row(mainAxisSize: MainAxisSize.min, children: [
                  const Icon(Icons.workspace_premium_rounded, size: 14, color: Colors.white),
                  const SizedBox(width: 6),
                  Text('${user.tier} · since ${user.since}', style: T.d(12, w: FontWeight.w700, color: Colors.white)),
                ]),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _glassBtn(String icon, VoidCallback onTap) => GestureDetector(
        onTap: onTap,
        child: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.22), shape: BoxShape.circle),
          child: Ic(icon, size: 19, color: Colors.white),
        ),
      );
}

class _StatBlock extends StatelessWidget {
  final List<({int n, String l})> stats;
  const _StatBlock(this.stats);
  @override
  Widget build(BuildContext context) {
    // header overlaps avatar (-46), so pull up the rest
    return Transform.translate(
      offset: const Offset(0, -26),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 15),
        decoration: BoxDecoration(
          color: C.surface,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: C.hairline),
          boxShadow: S.card,
        ),
        child: Row(
          children: [
            for (int i = 0; i < stats.length; i++)
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    border: i > 0 ? const Border(left: BorderSide(color: C.hairline)) : null,
                  ),
                  child: Column(mainAxisSize: MainAxisSize.min, children: [
                    Text('${stats[i].n}', style: T.d(21, w: FontWeight.w800)),
                    Text(stats[i].l, style: T.b(12, w: FontWeight.w500, color: C.mist)),
                  ]),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _WalletCard extends StatelessWidget {
  final VoidCallback onTopUp;
  const _WalletCard({required this.onTopUp});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          gradient: G.emerald,
          borderRadius: BorderRadius.circular(22),
          boxShadow: const [BoxShadow(color: Color(0x4D0E7C66), blurRadius: 28, offset: Offset(0, 12))],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Wallet balance', style: T.b(12, w: FontWeight.w500, color: Colors.white70)),
                      Text(taka(1240), style: T.d(28, w: FontWeight.w800, color: Colors.white)),
                    ],
                  ),
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
              ],
            ),
            const SizedBox(height: 18),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(children: [
                  const Icon(Icons.auto_awesome_rounded, size: 14, color: Colors.white),
                  const SizedBox(width: 6),
                  Text('${thou(user.points)} points', style: T.b(12, w: FontWeight.w600, color: Colors.white)),
                ]),
                GestureDetector(
                  onTap: onTopUp,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
                    child: Row(mainAxisSize: MainAxisSize.min, children: [
                      const Ic('plusCircle', size: 15, color: C.emeraldDark),
                      const SizedBox(width: 5),
                      Text('Top up', style: T.d(12, w: FontWeight.w700, color: C.emeraldDark)),
                    ]),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _PaymentMethods extends StatelessWidget {
  const _PaymentMethods();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('PAYMENT METHODS', style: T.b(12, w: FontWeight.w700, color: C.mist, spacing: 0.6)),
              Row(mainAxisSize: MainAxisSize.min, children: [
                const Ic('plus', size: 14, color: C.emerald),
                const SizedBox(width: 3),
                Text('Add', style: T.b(12, w: FontWeight.w600, color: C.emerald)),
              ]),
            ],
          ),
          const SizedBox(height: 10),
          for (final m in paymentMethods)
            Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
              decoration: BoxDecoration(
                color: C.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: C.hairline),
                boxShadow: S.card,
              ),
              child: Row(children: [
                Container(
                  width: 44,
                  height: 30,
                  decoration: BoxDecoration(color: hsl(m.hue.toDouble(), 0.6, 0.48), borderRadius: BorderRadius.circular(7)),
                  alignment: Alignment.center,
                  child: Text(m.brand[0], style: T.d(10, w: FontWeight.w800, color: Colors.white)),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(m.brand, style: T.b(13, w: FontWeight.w600)),
                      Text(m.last, style: T.b(12, w: FontWeight.w500, color: C.mist)),
                    ],
                  ),
                ),
                if (m.primary)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                    decoration: BoxDecoration(color: C.emeraldTint, borderRadius: BorderRadius.circular(999)),
                    child: Text('Primary', style: T.b(10, w: FontWeight.w600, color: C.emeraldDark)),
                  ),
              ]),
            ),
        ],
      ),
    );
  }
}

class _MenuGroup extends StatelessWidget {
  final AccountGroup group;
  final void Function(String) onItem;
  const _MenuGroup(this.group, {required this.onItem});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 2, bottom: 10),
            child: Text(group.title.toUpperCase(), style: T.b(12, w: FontWeight.w700, color: C.mist, spacing: 0.6)),
          ),
          Container(
            decoration: BoxDecoration(
              color: C.surface,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: C.hairline),
              boxShadow: S.card,
            ),
            clipBehavior: Clip.antiAlias,
            child: Column(
              children: [
                for (int i = 0; i < group.items.length; i++) ...[
                  _MenuRow(group.items[i], onTap: () => onItem(group.items[i].to)),
                  if (i < group.items.length - 1)
                    const Padding(padding: EdgeInsets.only(left: 65), child: Divider(height: 1, color: C.hairline)),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MenuRow extends StatelessWidget {
  final AccountItem item;
  final VoidCallback onTap;
  const _MenuRow(this.item, {required this.onTap});
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
        child: Row(children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(color: C.emeraldTint, borderRadius: BorderRadius.circular(12)),
            child: Ic(item.icon, size: 19, color: C.emeraldDark),
          ),
          const SizedBox(width: 13),
          Expanded(child: Text(item.label, style: T.b(14, w: FontWeight.w600))),
          if (item.meta.isNotEmpty)
            Text(item.meta, style: T.b(12, w: FontWeight.w600, color: C.mist)),
          const SizedBox(width: 6),
          const Ic('chevR', size: 17, color: C.mist),
        ]),
      ),
    );
  }
}

/// Saved (favourited) trips.
class SavedScreen extends StatelessWidget {
  const SavedScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final c = AppScope.of(context);
    final topPad = MediaQuery.of(context).padding.top;
    return Scaffold(
      backgroundColor: C.cloud,
      body: AnimatedBuilder(
        animation: c,
        builder: (context, _) {
          final saved = c.savedListings();
          return ListView(
            padding: EdgeInsets.only(top: topPad + 16, bottom: 40),
            children: [
              Padding(padding: const EdgeInsets.symmetric(horizontal: 20), child: PushHeader('Saved', sub: '${saved.length} trip${saved.length == 1 ? '' : 's'} you loved')),
              const SizedBox(height: 20),
              if (saved.isEmpty)
                Padding(
                  padding: const EdgeInsets.fromLTRB(40, 60, 40, 0),
                  child: Column(children: [
                    Container(
                      width: 70,
                      height: 70,
                      decoration: const BoxDecoration(color: C.emeraldTint, shape: BoxShape.circle),
                      child: const Ic('heart', size: 32, color: C.emeraldDark),
                    ),
                    const SizedBox(height: 16),
                    Text('Nothing saved yet', style: T.d(18, w: FontWeight.w700)),
                    const SizedBox(height: 6),
                    Text('Tap the heart on any stay or activity to keep it here.',
                        textAlign: TextAlign.center, style: T.b(13, w: FontWeight.w400, color: C.slate)),
                  ]),
                )
              else
                for (final it in saved)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
                    child: CompactCard(it, onOpen: () => openDetail(context, it), fav: true, onFav: () => c.toggleFav(it.id)),
                  ),
            ],
          );
        },
      ),
    );
  }
}
