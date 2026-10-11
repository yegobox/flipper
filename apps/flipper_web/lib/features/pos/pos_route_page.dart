import 'package:flipper_dashboard/web/pos_web_entry.dart' deferred as pos;
import 'package:flipper_localize/flipper_localize.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart'
    deferred as sqflite_web
    show databaseFactoryFfiWeb;

/// `/pos` — the Flipper POS, opened from Books' app launcher.
///
/// The POS and everything it pulls in (the native service locator, Stacked
/// router, Brick repository, the sqlite web bindings) are loaded deferred: a
/// separate JS part fetched on first open, so Books' startup bundle does not
/// grow. Keep both imports deferred — an eager one drags its whole graph into
/// main.dart.js.
class PosRoutePage extends StatefulWidget {
  const PosRoutePage({super.key});

  @override
  State<PosRoutePage> createState() => _PosRoutePageState();
}

class _PosRoutePageState extends State<PosRoutePage> {
  late Future<void> _loaded = _load();

  static Future<void> _load() =>
      Future.wait([pos.loadLibrary(), sqflite_web.loadLibrary()]);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<void>(
        future: _loaded,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            debugPrint('[POS web] loading the POS failed: ${snapshot.error}');
            return Center(
              child: FilledButton(
                onPressed: () => setState(() => _loaded = _load()),
                child: Text(context.flipperL10n.retry),
              ),
            );
          }
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          return pos.PosWebEntry(
            databaseFactory: sqflite_web.databaseFactoryFfiWeb,
            onExit: () => context.go('/accounting'),
          );
        },
      ),
    );
  }
}
