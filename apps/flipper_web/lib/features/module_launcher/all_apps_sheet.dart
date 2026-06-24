import 'dart:ui';

import 'package:flipper_web/features/login/signin_styles.dart';
import 'package:flipper_web/features/module_launcher/all_apps_catalog.dart';
import 'package:flipper_web/modules/accounting/theme/accounting_tokens.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AllAppsSheet {
  AllAppsSheet._();

  static Future<void> show(BuildContext context) {
    final isDesktop = MediaQuery.sizeOf(context).width >= SITokens.desktopBreakpoint;
    if (isDesktop) {
      return showDialog<void>(
        context: context,
        barrierDismissible: true,
        builder: (context) => const Center(
          child: Material(
            color: Colors.transparent,
            child: SizedBox(width: 480, child: _AllAppsSheetBody()),
          ),
        ),
      );
    }

    return showGeneralDialog<void>(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'All apps',
      barrierColor: Colors.transparent,
      transitionDuration: const Duration(milliseconds: 320),
      pageBuilder: (context, animation, secondaryAnimation) => const Align(
        alignment: Alignment.bottomCenter,
        child: _AllAppsSheetBody(),
      ),
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return Stack(
          fit: StackFit.expand,
          children: [
            FadeTransition(
              opacity: animation,
              child: GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
                  child: Container(color: const Color(0x6B0B1220)),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: SlideTransition(
                position: Tween<Offset>(begin: const Offset(0, 1), end: Offset.zero).animate(animation),
                child: child,
              ),
            ),
          ],
        );
      },
    );
  }
}

class _AllAppsSheetBody extends StatelessWidget {
  const _AllAppsSheetBody();

  @override
  Widget build(BuildContext context) {
    final sections = webAllAppsCatalog();
    final bottomInset = MediaQuery.paddingOf(context).bottom;
    final maxHeight = MediaQuery.sizeOf(context).height * 0.86;

    return Material(
      color: Colors.transparent,
      child: Container(
        constraints: BoxConstraints(maxHeight: maxHeight),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(26)),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF0B1220).withValues(alpha: 0.3),
              offset: const Offset(0, -16),
              blurRadius: 44,
              spreadRadius: -12,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 10),
            Container(width: 40, height: 5, decoration: BoxDecoration(color: AccountingTokens.lineStrong, borderRadius: BorderRadius.circular(3))),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('All apps', style: AccountingTokens.sans(fontSize: 19, fontWeight: FontWeight.w700)),
                        Text('Everything in your business', style: AccountingTokens.sans(fontSize: 12.5, color: AccountingTokens.ink3)),
                      ],
                    ),
                  ),
                  IconButton(onPressed: () => Navigator.of(context).pop(), icon: const Icon(Icons.close, size: 18)),
                ],
              ),
            ),
            Flexible(
              child: ListView(
                padding: EdgeInsets.fromLTRB(16, 0, 16, 22 + bottomInset),
                shrinkWrap: true,
                children: [
                  for (var i = 0; i < sections.length; i++) ...[
                    Padding(
                      padding: EdgeInsets.fromLTRB(6, i == 0 ? 0 : 16, 6, 12),
                      child: Text(
                        sections[i].label.toUpperCase(),
                        style: AccountingTokens.sans(fontSize: 11, fontWeight: FontWeight.w700, color: AccountingTokens.ink3, letterSpacing: 0.08 * 11),
                      ),
                    ),
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 4,
                        mainAxisSpacing: 8,
                        crossAxisSpacing: 4,
                        childAspectRatio: 0.78,
                      ),
                      itemCount: sections[i].apps.length,
                      itemBuilder: (context, index) {
                        final tile = sections[i].apps[index];
                        return _AppTile(
                          tile: tile,
                          onTap: () {
                            Navigator.of(context).pop();
                            if (tile.page == 'Accounting') {
                              context.go('/accounting');
                              return;
                            }
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('${tile.label} — coming soon')),
                            );
                          },
                        );
                      },
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AppTile extends StatelessWidget {
  const _AppTile({required this.tile, required this.onTap});

  final AllAppTile tile;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          children: [
            Container(
              width: 54,
              height: 54,
              decoration: BoxDecoration(
                color: Color.alphaBlend(tile.color.withValues(alpha: 0.13), Colors.white),
                borderRadius: BorderRadius.circular(17),
              ),
              child: Icon(tile.icon, color: tile.color, size: 24),
            ),
            const SizedBox(height: 8),
            Text(
              tile.label,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: AccountingTokens.sans(fontSize: 11.5, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}
