import 'package:flutter/material.dart';

/// Maps the prototype's named line icons (`Icon name="…"`) to the closest
/// Material icon so the data/components port renders consistently.
const Map<String, IconData> _icons = {
  'pin': Icons.place_outlined,
  'bell': Icons.notifications_none_rounded,
  'search': Icons.search_rounded,
  'filter': Icons.tune_rounded,
  'sliders': Icons.tune_rounded,
  'heart': Icons.favorite_rounded,
  'star': Icons.star_rounded,
  'chevL': Icons.chevron_left_rounded,
  'chevR': Icons.chevron_right_rounded,
  'chevD': Icons.keyboard_arrow_down_rounded,
  'arrowR': Icons.arrow_forward_rounded,
  'share': Icons.ios_share_rounded,
  'home': Icons.home_outlined,
  'compass': Icons.explore_outlined,
  'bookmark': Icons.bookmark_border_rounded,
  'user': Icons.person_outline_rounded,
  'plus': Icons.add_rounded,
  'minus': Icons.remove_rounded,
  'cal': Icons.calendar_today_outlined,
  'users': Icons.groups_outlined,
  'clock': Icons.schedule_rounded,
  'gauge': Icons.speed_rounded,
  'check': Icons.check_rounded,
  'x': Icons.close_rounded,
  'wallet': Icons.account_balance_wallet_outlined,
  'diamond': Icons.diamond_outlined,
  'crown': Icons.workspace_premium_outlined,
  'globe': Icons.public_rounded,
  'bed': Icons.king_bed_outlined,
  'kaaba': Icons.mosque_outlined,
  'spa': Icons.spa_outlined,
  'wifi': Icons.wifi_rounded,
  'pool': Icons.pool_outlined,
  'food': Icons.restaurant_rounded,
  'parking': Icons.local_parking_rounded,
  'ac': Icons.ac_unit_rounded,
  'beach': Icons.beach_access_outlined,
  'gym': Icons.fitness_center_rounded,
  'yoga': Icons.self_improvement_rounded,
  'bonfire': Icons.local_fire_department_outlined,
  'viewpoint': Icons.filter_hdr_rounded,
  'garden': Icons.local_florist_outlined,
  'map': Icons.map_outlined,
  'locate': Icons.my_location_rounded,
  'layers': Icons.layers_outlined,
  'gift': Icons.card_giftcard_rounded,
  'moon': Icons.dark_mode_outlined,
  'camera': Icons.photo_camera_outlined,
  'sparkle': Icons.auto_awesome_rounded,
  'sparkles2': Icons.auto_awesome_rounded,
  'trendD': Icons.trending_down_rounded,
  'trendU': Icons.trending_up_rounded,
  'shield': Icons.shield_outlined,
  'headset': Icons.headset_mic_outlined,
  'tag': Icons.local_offer_outlined,
  'comment': Icons.chat_bubble_outline_rounded,
  'music': Icons.music_note_rounded,
  'play': Icons.play_arrow_rounded,
  'mute': Icons.volume_off_rounded,
  'volume': Icons.volume_up_rounded,
  'send': Icons.send_rounded,
  'plusCircle': Icons.add_circle_outline_rounded,
  'logout': Icons.logout_rounded,
  'cog': Icons.settings_outlined,
  'edit': Icons.edit_outlined,
  'eye': Icons.visibility_outlined,
  'lock': Icons.lock_outline_rounded,
  'mail': Icons.mail_outline_rounded,
  'google': Icons.g_mobiledata_rounded,
  'trash': Icons.delete_outline_rounded,
  'info': Icons.info_outline_rounded,
  'bag': Icons.shopping_bag_outlined,
  'receipt': Icons.receipt_long_outlined,
  'nagad': Icons.account_balance_wallet_rounded,
  'card': Icons.credit_card_rounded,
  'phone': Icons.phone_rounded,
  'route': Icons.route_outlined,
  'bus': Icons.directions_bus_outlined,
  'tent': Icons.cabin_outlined,
  'flag': Icons.flag_outlined,
  'badge': Icons.military_tech_outlined,
  'idcard': Icons.badge_outlined,
  'genderM': Icons.male_rounded,
  'genderF': Icons.female_rounded,
  'sunrise': Icons.wb_twilight_rounded,
};

/// Icons that read better filled when `fill` is requested.
IconData iconData(String name) => _icons[name] ?? Icons.circle_outlined;

/// Named icon widget (mirrors the prototype's `<Icon name=… size=… color=… />`).
class Ic extends StatelessWidget {
  final String name;
  final double size;
  final Color? color;
  const Ic(this.name, {super.key, this.size = 22, this.color});

  @override
  Widget build(BuildContext context) =>
      Icon(iconData(name), size: size, color: color ?? kCurrentColor);
}

/// Fallback "currentColor" — the prototype defaults icons to currentColor.
const Color kCurrentColor = Color(0xFF14201D);
