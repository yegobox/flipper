import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Shared checks for buttons that paint their background with a plain
/// [Container] instead of `Ink` (Windows tills did not draw Ink backgrounds).

/// The nearest decorated [Container] above [label]: the button's background.
Finder buttonBackground(Finder label) => find
    .ancestor(
      of: label,
      matching: find.byWidgetPredicate(
        (w) => w is Container && w.decoration is BoxDecoration,
      ),
    )
    .first;

/// The [InkWell] that handles taps for the button around [label].
Finder buttonInkWell(Finder label) =>
    find.ancestor(of: label, matching: find.byType(InkWell)).first;

BoxDecoration backgroundOf(WidgetTester tester, Finder label) =>
    tester.widget<Container>(buttonBackground(label)).decoration!
        as BoxDecoration;

/// Walking up from the button's [InkWell]: first a transparent [Material]
/// (so hover/press highlights still draw), then the decorated [Container]
/// that paints the background in the normal layer. No `Ink` anywhere.
void expectPaintedByContainer(WidgetTester tester, Finder label) {
  var sawTransparentMaterial = false;
  var sawBackground = false;
  tester.element(buttonInkWell(label)).visitAncestorElements((e) {
    final w = e.widget;
    if (!sawTransparentMaterial) {
      if (w is Material && w.type == MaterialType.transparency) {
        sawTransparentMaterial = true;
      }
      return true;
    }
    if (w is Container && w.decoration is BoxDecoration) {
      sawBackground = true;
      return false;
    }
    return true;
  });
  expect(sawTransparentMaterial, isTrue,
      reason: 'InkWell should sit in a transparent Material');
  expect(sawBackground, isTrue,
      reason: 'a decorated Container should paint the background');
  expect(find.byType(Ink), findsNothing);
}
