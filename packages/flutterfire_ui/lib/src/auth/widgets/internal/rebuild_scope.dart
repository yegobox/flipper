import 'package:flutter/widgets.dart';

class RebuildScopeKey {
  RebuildScopeKey();

  final _elements = <RebuildScopeElement>[];

  void rebuild() {
    _elements.forEach((element) {
      element.markNeedsBuild();
    });
  }
}

class RebuildScope extends Widget {
  final WidgetBuilder builder;
  final RebuildScopeKey scopeKey;

  const RebuildScope({
    Key? key,
    required this.builder,
    required this.scopeKey,
  }) : super(key: key);

  @override
  RebuildScopeElement createElement() {
    return RebuildScopeElement(this);
  }
}

class RebuildScopeElement extends ComponentElement {
  RebuildScopeElement(RebuildScope widget) : super(widget);

  @override
  RebuildScope get widget => super.widget as RebuildScope;

  late RebuildScopeKey scopeKey;

  void _registerElement(RebuildScope widget) {
    scopeKey = widget.scopeKey;
    scopeKey._elements.add(this);
  }

  @override
  void mount(Element? parent, Object? newSlot) {
    _registerElement(widget);
    super.mount(parent, newSlot);
  }

  @override
  void update(RebuildScope newWidget) {
    scopeKey._elements.clear();
    _registerElement(widget);

    super.update(newWidget);
    markNeedsBuild();
  }

  @override
  Widget build() {
    return widget.builder(this);
  }
}
