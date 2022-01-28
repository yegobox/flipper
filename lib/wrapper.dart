import 'package:flipper/deferred_widget.dart';
import 'package:flutter/rendering.dart';
import 'package:flipper/flipper_options.dart';
import 'package:flutter/material.dart';

class Wrapper extends StatefulWidget {
  const Wrapper({
    Key? key,
    required this.study,
    this.alignment = AlignmentDirectional.bottomStart,
    this.hasBottomNavBar = false,
    DeferredLoadingPlaceholder? placeholder,
  }) : super(key: key);

  final Widget study;
  final bool hasBottomNavBar;
  final AlignmentDirectional alignment;

  @override
  _WrapperState createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return ApplyTextOptions(
      child: Stack(
        children: [
          Semantics(
            sortKey: const OrdinalSortKey(1),
            child: RestorationScope(
              restorationId: 'study_wrapper',
              child: widget.study,
            ),
          ),
          SafeArea(
            child: Align(
              alignment: widget.alignment,
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: widget.hasBottomNavBar
                        ? kBottomNavigationBarHeight + 16.0
                        : 16.0),
                child: Semantics(
                  sortKey: const OrdinalSortKey(0),
                  label: "Back",
                  button: true,
                  enabled: true,
                  excludeSemantics: true,
                  child: FloatingActionButton.extended(
                    heroTag: _BackButtonHeroTag(),
                    key: const ValueKey('Back'),
                    onPressed: () {
                      Navigator.of(context)
                          .popUntil((route) => route.settings.name == '/');
                    },
                    icon: IconTheme(
                      data: IconThemeData(color: colorScheme.onPrimary),
                      child: const BackButtonIcon(),
                    ),
                    label: Text(
                      MaterialLocalizations.of(context).backButtonTooltip,
                      style:
                          textTheme.button?.apply(color: colorScheme.onPrimary),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BackButtonHeroTag {}
