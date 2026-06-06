import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Design tokens ported from the prototype's `:root` (warm-editorial mood).
class C {
  static const emerald = Color(0xFF0C8A66);
  static const emeraldDark = Color(0xFF07664A);
  static const emeraldDeep = Color(0xFF053B2C);
  static const emeraldTint = Color(0xFFDEF4EA);
  static const mint = Color(0xFF6FD3A6);
  static const saffron = Color(0xFFE8A33D);
  static const saffronDark = Color(0xFFC9821E);
  static const ink = Color(0xFF14201D);
  static const slate = Color(0xFF5B6B66);
  static const mist = Color(0xFF9AA8A3);
  static const cloud = Color(0xFFF4F7F6);
  static const surface = Color(0xFFFFFFFF);
  static const hairline = Color(0xFFE7ECEA);
  static const success = Color(0xFF2E9E6B);
  static const error = Color(0xFFE0524B);
  static const info = Color(0xFF3B82C4);

  // tier colors
  static const tierBudget = Color(0xFF3B82C4);
  static const tierPremium = Color(0xFF0C8A66);
  static const tierLuxA = Color(0xFFE8A33D);
  static const tierLuxB = Color(0xFFC9821E);
}

/// Radii (--r-*).
class R {
  static const card = 24.0;
  static const image = 20.0;
  static const button = 16.0;
  static const input = 14.0;
}

/// Shadows.
class S {
  static const card = [
    BoxShadow(color: Color(0x14141D1A), blurRadius: 24, offset: Offset(0, 8)),
  ];
  static const sheet = [
    BoxShadow(color: Color(0x1A141D1A), blurRadius: 24, offset: Offset(0, -6)),
  ];
  static const float = [
    BoxShadow(color: Color(0x24141D1A), blurRadius: 30, offset: Offset(0, 10)),
  ];
  static const greenBtn = [
    BoxShadow(color: Color(0x520E7C66), blurRadius: 20, offset: Offset(0, 8)),
  ];
}

/// Gradients used throughout (`linear-gradient(140deg, emerald, emerald-dark)`).
class G {
  static const emerald = LinearGradient(
    begin: Alignment(-0.6, -1),
    end: Alignment(0.6, 1),
    colors: [C.emerald, C.emeraldDark],
  );
  static const gold = LinearGradient(
    begin: Alignment(-0.6, -1),
    end: Alignment(0.6, 1),
    colors: [C.saffron, C.saffronDark],
  );
  static const greenGlass = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xDB0C8A66), Color(0xD107664A)],
  );
}

/// Typography. display = Plus Jakarta Sans, body = Inter, bn = Hind Siliguri.
class T {
  static TextStyle d(double size,
          {FontWeight w = FontWeight.w700,
          Color color = C.ink,
          double? height,
          double spacing = -0.2}) =>
      GoogleFonts.plusJakartaSans(
          fontSize: size, fontWeight: w, color: color, height: height, letterSpacing: spacing);

  static TextStyle b(double size,
          {FontWeight w = FontWeight.w400,
          Color color = C.ink,
          double? height,
          double spacing = 0}) =>
      GoogleFonts.inter(
          fontSize: size, fontWeight: w, color: color, height: height, letterSpacing: spacing);

  static TextStyle bn(double size, {FontWeight w = FontWeight.w500, Color color = C.ink}) =>
      GoogleFonts.hindSiliguri(fontSize: size, fontWeight: w, color: color);
}

ThemeData buildTheme() {
  final base = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(seedColor: C.emerald, primary: C.emerald),
    scaffoldBackgroundColor: C.cloud,
  );
  return base.copyWith(
    textTheme: GoogleFonts.interTextTheme(base.textTheme)
        .apply(bodyColor: C.ink, displayColor: C.ink),
    splashFactory: NoSplash.splashFactory,
    highlightColor: Colors.transparent,
  );
}

/// Format a BDT amount: ৳12,500 (fmtBDT).
String taka(num n) {
  final s = n.round().toString();
  final b = StringBuffer();
  for (var i = 0; i < s.length; i++) {
    if (i > 0 && (s.length - i) % 3 == 0) b.write(',');
    b.write(s[i]);
  }
  return '৳${b.toString()}';
}

/// Thousands separator without the ৳ (for review counts etc.).
String thou(num n) {
  final s = n.round().toString();
  final b = StringBuffer();
  for (var i = 0; i < s.length; i++) {
    if (i > 0 && (s.length - i) % 3 == 0) b.write(',');
    b.write(s[i]);
  }
  return b.toString();
}

/// Unsplash URL helper (matches the prototype's `unsplash(id, w)`).
String unsplash(String id, [int w = 800]) =>
    'https://images.unsplash.com/photo-$id?w=$w&q=80&auto=format&fit=crop';

/// HSL helper for the striped placeholder backgrounds (`hsl(hue 26% 80%)`).
Color hsl(double h, double s, double l) =>
    HSLColor.fromAHSL(1, h % 360, s, l).toColor();
