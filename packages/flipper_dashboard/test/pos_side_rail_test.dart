// The rail's building blocks, shared by the POS ([EnhancedSideMenu]) and
// Flipper HR. These pin how an entry draws its states and how the column lays
// out groups, so a change here is a change to both apps, on purpose.
//
// Run from `flipper/packages/flipper_dashboard`:
//   flutter test test/pos_side_rail_test.dart

import 'package:flipper_dashboard/pos_layout_breakpoints.dart';
import 'package:flipper_dashboard/theme/pos_tokens.dart';
import 'package:flipper_dashboard/widgets/pos_side_rail.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _host(Widget child) => MaterialApp(
  home: Scaffold(
    body: Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [PosRailFrame(child: child)],
    ),
  ),
);

PosRailItem _item(
  String tooltip, {
  bool isSelected = false,
  bool isLogout = false,
  VoidCallback? onTap,
}) => PosRailItem(
  key: Key(tooltip),
  iconBuilder: (c) => Icon(Icons.circle, color: c),
  isSelected: isSelected,
  isLogout: isLogout,
  onTap: onTap ?? () {},
  tooltip: tooltip,
);

Color? _iconColor(WidgetTester tester, String key) => tester
    .widget<Icon>(
      find.descendant(of: find.byKey(Key(key)), matching: find.byType(Icon)),
    )
    .color;

Color? _tint(WidgetTester tester, String key) {
  final box = tester.widget<AnimatedContainer>(
    find.descendant(
      of: find.byKey(Key(key)),
      matching: find.byType(AnimatedContainer),
    ),
  );
  return (box.decoration as BoxDecoration?)?.color;
}

void main() {
  testWidgets('the frame is the rail width with a hairline edge', (
    tester,
  ) async {
    await tester.pumpWidget(_host(const SizedBox.expand()));

    final frame = find.byType(PosRailFrame);
    expect(tester.getSize(frame).width, PosLayoutBreakpoints.sideMenuWidth);

    final box = tester.widget<Container>(
      find.descendant(of: frame, matching: find.byType(Container)),
    );
    final decoration = box.decoration! as BoxDecoration;
    expect(decoration.color, PosTokens.posRail);
    expect((decoration.border! as Border).right.color, PosTokens.line);
  });

  testWidgets('entries paint their ink above the frame\'s fill', (
    tester,
  ) async {
    await tester.pumpWidget(
      _host(
        PosRailColumn(
          groups: [
            [_item('a')],
          ],
          bottom: const [],
        ),
      ),
    );

    // An InkWell draws hover and focus on the nearest Material. If that is
    // the Scaffold's, the frame's opaque fill covers it and focus is invisible.
    final inkWell = find.descendant(
      of: find.byKey(const Key('a')),
      matching: find.byType(InkWell),
    );
    final ink = Material.of(tester.element(inkWell)) as RenderObject;
    // The frame's own fill: the outermost box under it.
    final fillBox = find
        .descendant(
          of: find.byType(PosRailFrame),
          matching: find.byType(DecoratedBox),
        )
        .first;
    expect(
      (tester.widget<DecoratedBox>(fillBox).decoration as BoxDecoration).color,
      PosTokens.posRail,
    );
    final fill = tester.renderObject(fillBox);

    var aboveFill = false;
    for (RenderObject? node = ink.parent; node != null; node = node.parent) {
      if (identical(node, fill)) aboveFill = true;
    }
    expect(aboveFill, isTrue);

    // That Material is see-through, so the rail looks the same at rest.
    final material = tester.widget<Material>(
      find.ancestor(of: inkWell, matching: find.byType(Material)).first,
    );
    expect(material.type, MaterialType.transparency);
  });

  testWidgets('entries draw idle, selected and logout states', (tester) async {
    await tester.pumpWidget(
      _host(
        PosRailColumn(
          groups: [
            [_item('idle'), _item('selected', isSelected: true)],
          ],
          bottom: [
            _item('logout', isLogout: true),
            _item('logout-selected', isLogout: true, isSelected: true),
          ],
        ),
      ),
    );

    expect(_iconColor(tester, 'idle'), PosTokens.ink3);
    expect(_tint(tester, 'idle'), isNull);

    expect(_iconColor(tester, 'selected'), PosLayoutBreakpoints.posAccentBlue);
    expect(_tint(tester, 'selected'), PosTokens.blueTint);

    expect(_iconColor(tester, 'logout'), PosTokens.loss);
    expect(_tint(tester, 'logout'), isNull);
    expect(_tint(tester, 'logout-selected'), PosTokens.lossTint);

    // The selected bar on the left edge is drawn only for selected entries.
    Finder bar(String key) => find.descendant(
      of: find.byKey(Key(key)),
      matching: find.byType(Positioned),
    );
    expect(bar('idle'), findsOneWidget); // the fill only
    expect(bar('selected'), findsNWidgets(2)); // the fill + the bar
  });

  testWidgets('each entry is one slot tall, named and tappable', (
    tester,
  ) async {
    var taps = 0;
    await tester.pumpWidget(
      _host(
        PosRailColumn(
          groups: [
            [_item('a', onTap: () => taps++)],
          ],
          bottom: [_item('b')],
        ),
      ),
    );

    expect(
      tester.getSize(find.byKey(const Key('a'))).height,
      PosRailItem.slotHeight,
    );
    expect(
      tester.getSize(find.byKey(const Key('b'))).height,
      PosRailItem.slotHeight,
    );
    expect(find.byTooltip('a'), findsOneWidget);
    expect(find.bySemanticsLabel('a'), findsOneWidget);

    await tester.tap(find.byKey(const Key('a')));
    expect(taps, 1);
  });

  testWidgets('hairlines sit only between non-empty groups and above the '
      'pinned entries', (tester) async {
    await tester.pumpWidget(
      _host(
        PosRailColumn(
          groups: [
            [_item('one')],
            const [],
            [_item('two'), _item('three')],
            const [],
          ],
          bottom: [_item('end')],
          footer: const SizedBox(key: Key('footer'), height: 10),
        ),
      ),
    );

    // one | two three, then the pinned divider.
    expect(find.byType(PosRailDivider), findsNWidgets(2));
    expect(find.byKey(const Key('footer')), findsOneWidget);

    // Pinned entries and the footer sit below the scrolling groups.
    final threeY = tester.getTopLeft(find.byKey(const Key('three'))).dy;
    final endY = tester.getTopLeft(find.byKey(const Key('end'))).dy;
    final footerY = tester.getTopLeft(find.byKey(const Key('footer'))).dy;
    expect(endY, greaterThan(threeY));
    expect(footerY, greaterThan(endY));
  });

  testWidgets('the groups scroll under the pinned entries and footer', (
    tester,
  ) async {
    // Twenty one-entry groups are far taller than the 600px test surface.
    await tester.pumpWidget(
      _host(
        PosRailColumn(
          groups: [
            for (var i = 0; i < 20; i++) [_item('g$i')],
          ],
          bottom: [_item('end')],
          footer: const SizedBox(key: Key('footer'), height: 10),
        ),
      ),
    );

    double top(String key) => tester.getTopLeft(find.byKey(Key(key))).dy;
    final firstY = top('g0');
    final endY = top('end');
    final footerY = top('footer');
    expect(footerY, greaterThan(endY));

    await tester.drag(
      find.byType(SingleChildScrollView),
      const Offset(0, -200),
    );
    await tester.pumpAndSettle();

    expect(top('g0'), lessThan(firstY));
    expect(top('end'), endY);
    expect(top('footer'), footerY);
  });

  testWidgets('without a footer nothing is drawn under the pinned entries', (
    tester,
  ) async {
    await tester.pumpWidget(
      _host(PosRailColumn(groups: const [], bottom: [_item('end')])),
    );

    expect(find.byType(PosRailDivider), findsOneWidget);
    expect(find.byKey(const Key('end')), findsOneWidget);
  });

  testWidgets('posRailSvg tints a glyph to the given colour', (tester) async {
    await tester.pumpWidget(
      MaterialApp(home: posRailSvg(PosRailSvgs.logout, PosTokens.loss)),
    );

    final svg = tester.widget<SvgPicture>(find.byType(SvgPicture));
    expect(svg.width, PosTokens.iconMd);
    expect(
      svg.colorFilter,
      const ColorFilter.mode(PosTokens.loss, BlendMode.srcIn),
    );
  });
}
