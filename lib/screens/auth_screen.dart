import 'package:flutter/material.dart';
import '../core/theme.dart';
import '../core/icons.dart';
import '../widgets/ui.dart';

/// Login / Register, switchable. `onEnter` enters the app.
class AuthScreen extends StatefulWidget {
  final VoidCallback onEnter;
  const AuthScreen({super.key, required this.onEnter});
  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool register = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: C.cloud,
      body: register
          ? _Register(onRegister: widget.onEnter, onGoLogin: () => setState(() => register = false))
          : _Login(onLogin: widget.onEnter, onGoRegister: () => setState(() => register = true)),
    );
  }
}

class _AuthHero extends StatelessWidget {
  final String title, sub;
  const _AuthHero({required this.title, required this.sub});
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 330,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.network(unsplash('1507525428034-b723cf961d3e', 900), fit: BoxFit.cover,
              errorBuilder: (_, _, _) => Container(color: C.emeraldDark)),
          const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0x8C0A5A4A), Color(0x2614201D), C.cloud],
                stops: [0, 0.4, 0.99],
              ),
            ),
          ),
          Positioned(
            top: 60,
            left: 24,
            right: 24,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.95),
                        borderRadius: BorderRadius.circular(13),
                      ),
                      child: const Ic('compass', size: 25, color: C.emeraldDark),
                    ),
                    const SizedBox(width: 10),
                    Text('Tour Shongi',
                        style: T.d(22, w: FontWeight.w800, color: Colors.white, spacing: -0.4)),
                  ],
                ),
                const SizedBox(height: 26),
                Text(title,
                    style: T.d(30, w: FontWeight.w800, color: Colors.white, height: 1.08, spacing: -0.7)),
                const SizedBox(height: 8),
                Text(sub, style: T.bn(14, color: Colors.white.withValues(alpha: 0.95))),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AuthField extends StatelessWidget {
  final String icon, label;
  final String value;
  final bool obscure;
  final String? prefix;
  final Widget? trailing;
  const _AuthField(
      {required this.icon, required this.label, required this.value, this.obscure = false, this.prefix, this.trailing});
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: T.b(12, w: FontWeight.w600, color: C.slate)),
        const SizedBox(height: 7),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
          decoration: BoxDecoration(
            color: C.cloud,
            borderRadius: BorderRadius.circular(R.input),
            border: Border.all(color: C.hairline),
          ),
          child: Row(
            children: [
              Ic(icon, size: 18, color: C.emerald),
              const SizedBox(width: 10),
              if (prefix != null) ...[
                Text(prefix!, style: T.b(14, w: FontWeight.w600)),
                const SizedBox(width: 6),
              ],
              Expanded(
                child: Text(obscure ? '••••••••' : (value.isEmpty ? '' : value),
                    style: T.b(14, w: FontWeight.w500, color: value.isEmpty ? C.mist : C.ink)),
              ),
              ?trailing,
            ],
          ),
        ),
      ],
    );
  }
}

class _ContinueButtons extends StatelessWidget {
  final bool row;
  final VoidCallback onTap;
  const _ContinueButtons({this.row = false, required this.onTap});
  @override
  Widget build(BuildContext context) {
    Widget btn(Widget child) => GestureDetector(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: C.surface,
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: C.hairline, width: 1.5),
              boxShadow: const [BoxShadow(color: Color(0x0D14201D), blurRadius: 10, offset: Offset(0, 2))],
            ),
            child: child,
          ),
        );
    Widget twoLine(String bottom) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Continue with', style: T.b(9, w: FontWeight.w500, color: C.mist)),
            Text(bottom, style: T.d(13, w: FontWeight.w700)),
          ],
        );
    final g = Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      const Icon(Icons.g_mobiledata_rounded, size: 26, color: Color(0xFF4285F4)),
      const SizedBox(width: 8),
      if (row) twoLine('Gmail') else Text('Continue with Gmail', style: T.d(14.5, w: FontWeight.w700)),
    ]);
    final p = Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      Container(
          width: 24,
          height: 24,
          decoration: const BoxDecoration(color: C.emeraldTint, shape: BoxShape.circle),
          child: const Ic('phone', size: 14, color: C.emeraldDark)),
      const SizedBox(width: 8),
      if (row) twoLine('Phone') else Text('Continue with phone number', style: T.d(14.5, w: FontWeight.w700)),
    ]);
    if (row) {
      return Row(children: [Expanded(child: btn(g)), const SizedBox(width: 11), Expanded(child: btn(p))]);
    }
    return Column(children: [btn(g), const SizedBox(height: 11), btn(p)]);
  }
}

class _Divider extends StatelessWidget {
  final String label;
  const _Divider(this.label);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Row(children: [
        const Expanded(child: Divider(color: C.hairline, height: 1)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text(label, style: T.b(12, w: FontWeight.w500, color: C.mist)),
        ),
        const Expanded(child: Divider(color: C.hairline, height: 1)),
      ]),
    );
  }
}

class _Card extends StatelessWidget {
  final List<Widget> children;
  const _Card({required this.children});
  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: const Offset(0, -26),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(24, 26, 24, 40),
        decoration: const BoxDecoration(
          color: C.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          boxShadow: [BoxShadow(color: Color(0x1414201D), blurRadius: 30, offset: Offset(0, -10))],
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: children),
      ),
    );
  }
}

class _SwitchLine extends StatelessWidget {
  final String q, action;
  final VoidCallback onTap;
  const _SwitchLine(this.q, this.action, this.onTap);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 22),
      child: Center(
        child: Text.rich(TextSpan(children: [
          TextSpan(text: '$q ', style: T.b(13, w: FontWeight.w500, color: C.slate)),
          WidgetSpan(
            alignment: PlaceholderAlignment.middle,
            child: GestureDetector(
              onTap: onTap,
              child: Text(action, style: T.d(13, w: FontWeight.w700, color: C.emerald)),
            ),
          ),
        ])),
      ),
    );
  }
}

class _Login extends StatefulWidget {
  final VoidCallback onLogin, onGoRegister;
  const _Login({required this.onLogin, required this.onGoRegister});
  @override
  State<_Login> createState() => _LoginState();
}

class _LoginState extends State<_Login> {
  bool show = false;
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const _AuthHero(title: 'Welcome\nback', sub: 'বাংলাদেশ ঘুরে দেখুন — আপনার ভ্রমণ সঙ্গী'),
          _Card(children: [
            const _AuthField(icon: 'mail', label: 'Email', value: 'arefin.r@gmail.com'),
            const SizedBox(height: 14),
            _AuthField(
              icon: 'lock',
              label: 'Password',
              value: 'travel123',
              obscure: !show,
              trailing: GestureDetector(
                onTap: () => setState(() => show = !show),
                child: const Ic('eye', size: 18, color: C.mist),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 8),
              child: Align(
                alignment: Alignment.centerRight,
                child: Text('Forgot password?', textAlign: TextAlign.right),
              ),
            ),
            const SizedBox(height: 14),
            TSButton(
              full: true,
              large: true,
              onTap: widget.onLogin,
              child: const Row(mainAxisSize: MainAxisSize.min, children: [
                Text('Log in'),
                SizedBox(width: 8),
                Icon(Icons.arrow_forward_rounded, size: 18, color: Colors.white),
              ]),
            ),
            const _Divider('or continue with'),
            _ContinueButtons(onTap: widget.onLogin),
            _SwitchLine('New to Tour Shongi?', 'Create account', widget.onGoRegister),
            const SizedBox(height: 12),
            Center(
              child: GestureDetector(
                onTap: widget.onLogin,
                child: Text('Continue as guest', style: T.b(13, w: FontWeight.w600, color: C.mist)),
              ),
            ),
          ]),
        ],
      ),
    );
  }
}

class _Register extends StatefulWidget {
  final VoidCallback onRegister, onGoLogin;
  const _Register({required this.onRegister, required this.onGoLogin});
  @override
  State<_Register> createState() => _RegisterState();
}

class _RegisterState extends State<_Register> {
  String acct = 'traveller';
  bool agree = true;
  @override
  Widget build(BuildContext context) {
    final isGroup = acct == 'group';
    return SingleChildScrollView(
      child: Column(
        children: [
          const _AuthHero(title: 'Start your\njourney', sub: 'শুরু করুন — নতুন অ্যাকাউন্ট তৈরি করুন'),
          _Card(children: [
            Text('I want to sign up as', style: T.b(12, w: FontWeight.w600, color: C.slate)),
            const SizedBox(height: 9),
            Row(children: [
              Expanded(child: _acctOpt('traveller', 'Traveller', 'Join & book trips', 'user')),
              const SizedBox(width: 10),
              Expanded(child: _acctOpt('group', 'Tour Group', 'Host group tours', 'flag')),
            ]),
            const SizedBox(height: 14),
            _AuthField(
                icon: isGroup ? 'flag' : 'user',
                label: isGroup ? 'Group / organiser name' : 'Full name',
                value: ''),
            const SizedBox(height: 14),
            const _AuthField(icon: 'phone', label: 'Phone number', value: '', prefix: '+880'),
            const SizedBox(height: 14),
            const _AuthField(icon: 'lock', label: 'Password', value: '', obscure: false),
            const SizedBox(height: 14),
            GestureDetector(
              onTap: () => setState(() => agree = !agree),
              child: Row(children: [
                _CheckBox(agree),
                const SizedBox(width: 9),
                Expanded(
                  child: Text.rich(TextSpan(children: [
                    TextSpan(text: 'I agree to the ', style: T.b(12, w: FontWeight.w500, color: C.slate)),
                    TextSpan(text: 'Terms', style: T.b(12, w: FontWeight.w700, color: C.emerald)),
                    TextSpan(text: ' & ', style: T.b(12, w: FontWeight.w500, color: C.slate)),
                    TextSpan(text: 'Privacy Policy', style: T.b(12, w: FontWeight.w700, color: C.emerald)),
                  ])),
                ),
              ]),
            ),
            const SizedBox(height: 14),
            TSButton(
              full: true,
              large: true,
              onTap: widget.onRegister,
              child: Row(mainAxisSize: MainAxisSize.min, children: [
                Text(isGroup ? 'Register your group' : 'Create account'),
                const SizedBox(width: 8),
                const Icon(Icons.arrow_forward_rounded, size: 18, color: Colors.white),
              ]),
            ),
            const _Divider('or continue with'),
            _ContinueButtons(row: true, onTap: widget.onRegister),
            _SwitchLine('Already have an account?', 'Log in', widget.onGoLogin),
          ]),
        ],
      ),
    );
  }

  Widget _acctOpt(String key, String label, String sub, String icon) {
    final on = acct == key;
    return GestureDetector(
      onTap: () => setState(() => acct = key),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 12),
        decoration: BoxDecoration(
          color: on ? C.emeraldTint : C.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: on ? C.emerald : C.hairline, width: 1.5),
        ),
        child: Row(children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
                color: on ? C.emerald : C.cloud, borderRadius: BorderRadius.circular(11)),
            child: Ic(icon, size: 18, color: on ? Colors.white : C.slate),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: T.d(13.5, w: FontWeight.w700, color: on ? C.emeraldDark : C.ink)),
                Text(sub,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: T.b(10.5, w: FontWeight.w500, color: on ? C.emerald : C.mist)),
              ],
            ),
          ),
        ]),
      ),
    );
  }
}

class _CheckBox extends StatelessWidget {
  final bool on;
  const _CheckBox(this.on);
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 22,
      height: 22,
      decoration: BoxDecoration(
        color: on ? C.emerald : Colors.transparent,
        borderRadius: BorderRadius.circular(7),
        border: on ? null : Border.all(color: C.hairline, width: 2),
      ),
      child: on ? const Icon(Icons.check_rounded, size: 14, color: Colors.white) : null,
    );
  }
}
