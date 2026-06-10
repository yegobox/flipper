import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Stroke icons from design handoff `onboarding/icons.jsx` (1.5px, 24×24).
enum AccIcon {
  home,
  receipt,
  users,
  arrowUpRight,
  truck,
  arrowDown,
  stack,
  group,
  refresh,
  wallet,
  chart,
  shieldCheck,
  building,
  clock,
  eye,
  user,
  plus,
  check,
  calendar,
  warn,
  mail,
  download,
  search,
  bell,
  grid,
  phone,
  cog,
  chevRight,
  chevDown,
  x,
  filter,
  trash,
  layers,
  minus,
  more,
  hash,
}

const _svgAttrs =
    'viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"';

String _svg(List<String> paths) =>
    '<svg $_svgAttrs>${paths.map((p) => '<path d="$p"/>').join()}</svg>';

String _svgMixed(String inner) => '<svg $_svgAttrs>$inner</svg>';

String _iconSvg(AccIcon icon) => switch (icon) {
      AccIcon.home => _svg([
          'm3 11 9-7 9 7',
          'M5 10v9a1 1 0 0 0 1 1h12a1 1 0 0 0 1-1v-9',
        ]),
      AccIcon.receipt => _svg([
          'M6 3h12v18l-3-2-3 2-3-2-3 2z',
          'M9 8h6',
          'M9 12h6',
        ]),
      AccIcon.users => _svgMixed(
          '<circle cx="9" cy="9" r="3.5"/><path d="M3 19c0-3 3-5 6-5s6 2 6 5"/><circle cx="17" cy="8" r="2.5"/><path d="M16 14c2 0 5 1.5 5 4"/>',
        ),
      AccIcon.arrowUpRight => _svg(['M7 17 17 7', 'M8 7h9v9']),
      AccIcon.truck => _svgMixed(
          '<rect x="2.5" y="6" width="11" height="9" rx="1.5"/><path d="M13.5 9H18l3 3v3h-7.5z"/><circle cx="7" cy="17.5" r="1.6" fill="currentColor" stroke="none"/><circle cx="17" cy="17.5" r="1.6" fill="currentColor" stroke="none"/>',
        ),
      AccIcon.arrowDown => _svg(['M12 5v14', 'm6 13 6 6 6-6']),
      AccIcon.stack => _svg([
          'M4 7l8-4 8 4-8 4z',
          'M4 12l8 4 8-4',
          'M4 17l8 4 8-4',
        ]),
      AccIcon.group => _svg([
          'M3 4h18v3H3z',
          'M3 10.5h18v3H3z',
          'M3 17h18v3H3z',
        ]),
      AccIcon.refresh => _svg([
          'M4 12a8 8 0 0 1 14-5.3L20 9',
          'M20 4v5h-5',
          'M20 12a8 8 0 0 1-14 5.3L4 15',
          'M4 20v-5h5',
        ]),
      AccIcon.wallet => _svgMixed(
          '<path d="M3 7a2 2 0 0 1 2-2h12v3"/><path d="M3 7v10a2 2 0 0 0 2 2h14a1 1 0 0 0 1-1V9a1 1 0 0 0-1-1H5a2 2 0 0 1-2-2Z"/><circle cx="17" cy="13.5" r="1.3" fill="currentColor" stroke="none"/>',
        ),
      AccIcon.chart => _svg(['M4 4v16h16', 'm7 14 3-3 3 3 5-6']),
      AccIcon.shieldCheck => _svg([
          'M12 3 5 6v5c0 4.5 3 7.6 7 9 4-1.4 7-4.5 7-9V6z',
          'm9 11.5 2 2 4-4',
        ]),
      AccIcon.building => _svgMixed(
          '<rect x="4" y="3" width="16" height="18" rx="2"/><path d="M9 7h2M9 11h2M9 15h2M13 7h2M13 11h2M13 15h2"/>',
        ),
      AccIcon.clock => _svgMixed(
          '<circle cx="12" cy="12" r="9"/><path d="M12 7v5l3 2"/>',
        ),
      AccIcon.eye => _svgMixed(
          '<path d="M2 12s3.5-7 10-7 10 7 10 7-3.5 7-10 7S2 12 2 12Z"/><circle cx="12" cy="12" r="3"/>',
        ),
      AccIcon.user => _svgMixed(
          '<circle cx="12" cy="8" r="4"/><path d="M4 20c0-4 4-6 8-6s8 2 8 6"/>',
        ),
      AccIcon.plus => _svg(['M12 5v14', 'M5 12h14']),
      AccIcon.check => _svg(['M5 12.5 10 17 19 7.5']),
      AccIcon.calendar => _svgMixed(
          '<rect x="3" y="5" width="18" height="16" rx="2"/><path d="M3 9h18"/><path d="M8 3v4"/><path d="M16 3v4"/>',
        ),
      AccIcon.warn => _svg(['M12 4 2.5 20h19z', 'M12 10v4', 'M12 17.5h.01']),
      AccIcon.mail => _svgMixed(
          '<rect x="3" y="5" width="18" height="14" rx="2.5"/><path d="m4 7 8 6 8-6"/>',
        ),
      AccIcon.download => _svg(['M12 4v12', 'm7 11 5 5 5-5', 'M5 20h14']),
      AccIcon.search => _svgMixed(
          '<circle cx="11" cy="11" r="7"/><path d="m20 20-3.5-3.5"/>',
        ),
      AccIcon.bell => _svg(['M6 8a6 6 0 0 1 12 0c0 7 3 8 3 8H3s3-1 3-8', 'M10 20a2 2 0 0 0 4 0']),
      AccIcon.grid => _svgMixed(
          '<rect x="3.5" y="3.5" width="7" height="7" rx="1.5"/><rect x="13.5" y="3.5" width="7" height="7" rx="1.5"/><rect x="3.5" y="13.5" width="7" height="7" rx="1.5"/><rect x="13.5" y="13.5" width="7" height="7" rx="1.5"/>',
        ),
      AccIcon.phone => _svgMixed(
          '<rect x="6" y="3" width="12" height="18" rx="2.5"/><path d="M11 18h2"/>',
        ),
      AccIcon.cog => _svgMixed(
          '<circle cx="12" cy="12" r="3"/><path d="M19.4 15a1.7 1.7 0 0 0 .3 1.8l.1.1a2 2 0 1 1-2.8 2.8l-.1-.1a1.7 1.7 0 0 0-1.8-.3 1.7 1.7 0 0 0-1 1.5V21a2 2 0 1 1-4 0v-.1a1.7 1.7 0 0 0-1.1-1.5 1.7 1.7 0 0 0-1.8.3l-.1.1a2 2 0 1 1-2.8-2.8l.1-.1a1.7 1.7 0 0 0 .3-1.8 1.7 1.7 0 0 0-1.5-1H3a2 2 0 1 1 0-4h.1a1.7 1.7 0 0 0 1.5-1.1 1.7 1.7 0 0 0-.3-1.8l-.1-.1a2 2 0 1 1 2.8-2.8l.1.1a1.7 1.7 0 0 0 1.8.3H9a1.7 1.7 0 0 0 1-1.5V3a2 2 0 1 1 4 0v.1a1.7 1.7 0 0 0 1 1.5 1.7 1.7 0 0 0 1.8-.3l.1-.1a2 2 0 1 1 2.8 2.8l-.1.1a1.7 1.7 0 0 0-.3 1.8V9a1.7 1.7 0 0 0 1.5 1H21a2 2 0 1 1 0 4h-.1a1.7 1.7 0 0 0-1.5 1Z"/>',
        ),
      AccIcon.chevRight => _svg(['m9 6 6 6-6 6']),
      AccIcon.chevDown => _svg(['m6 9 6 6 6-6']),
      AccIcon.x => _svg(['m6 6 12 12', 'm18 6-12 12']),
      AccIcon.filter => _svg(['M3 5h18l-7 9v6l-4-2v-4z']),
      AccIcon.trash => _svg([
          'M4 7h16',
          'M9 7V5a1 1 0 0 1 1-1h4a1 1 0 0 1 1 1v2',
          'M6 7l1 13a1 1 0 0 0 1 1h8a1 1 0 0 0 1-1l1-13',
          'M10 11v6M14 11v6',
        ]),
      AccIcon.layers => _svg([
          'M4 7l8-4 8 4-8 4z',
          'M4 12l8 4 8-4',
          'M4 17l8 4 8-4',
        ]),
      AccIcon.minus => _svg(['M5 12h14']),
      AccIcon.more => _svgMixed(
          '<circle cx="5" cy="12" r="1.2" fill="currentColor" stroke="none"/>'
          '<circle cx="12" cy="12" r="1.2" fill="currentColor" stroke="none"/>'
          '<circle cx="19" cy="12" r="1.2" fill="currentColor" stroke="none"/>',
        ),
      AccIcon.hash => _svg(['M4 9h16', 'M4 15h16', 'M10 3v18', 'M14 3v18']),
    };

extension AccIconSvg on AccIcon {
  String get iconSvg => _iconSvg(this);
}

AccIcon? accIconFromHandoff(String name) => switch (name) {
      'Home' => AccIcon.home,
      'Receipt' => AccIcon.receipt,
      'Users' => AccIcon.users,
      'ArrowUpRight' => AccIcon.arrowUpRight,
      'Truck' => AccIcon.truck,
      'ArrowDown' => AccIcon.arrowDown,
      'Stack' => AccIcon.stack,
      'Group' => AccIcon.group,
      'Refresh' => AccIcon.refresh,
      'Wallet' => AccIcon.wallet,
      'Chart' => AccIcon.chart,
      'ShieldCheck' => AccIcon.shieldCheck,
      'Building' => AccIcon.building,
      'Clock' => AccIcon.clock,
      'Eye' => AccIcon.eye,
      'User' => AccIcon.user,
      'Plus' => AccIcon.plus,
      'Check' => AccIcon.check,
      'Calendar' => AccIcon.calendar,
      'Warn' => AccIcon.warn,
      'Mail' => AccIcon.mail,
      'Download' => AccIcon.download,
      'Hash' => AccIcon.hash,
      'Phone' => AccIcon.phone,
      'Search' => AccIcon.search,
      _ => null,
    };

class AccountingIcon extends StatelessWidget {
  const AccountingIcon({
    super.key,
    required this.icon,
    this.size = 16,
    this.color,
  });

  final AccIcon icon;
  final double size;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final c = color ?? IconTheme.of(context).color ?? Colors.black;
    return SvgPicture.string(
      icon.iconSvg,
      width: size,
      height: size,
      colorFilter: ColorFilter.mode(c, BlendMode.srcIn),
    );
  }
}
