import 'package:demo_ui_components/demo_ui_components.dart';
import 'package:flipper_dashboard/home/pages/modal_page_name.dart';
import 'package:flipper_dashboard/home/pages/sheet_page_with_custom_top_bar.dart';
import 'package:flipper_dashboard/home/pages/sheet_page_with_forced_max_height.dart';
import 'package:flipper_dashboard/home/pages/sheet_page_with_hero_image.dart';
import 'package:flipper_dashboard/home/pages/sheet_page_with_in_app_navigation.dart';
import 'package:flipper_dashboard/home/pages/sheet_page_with_lazy_list.dart';
import 'package:flipper_dashboard/home/pages/sheet_page_with_min_height.dart';
import 'package:flipper_dashboard/home/pages/sheet_page_with_no_page_title_and_no_top_bar.dart';
import 'package:flipper_dashboard/home/pages/sheet_page_with_non_scrolling_layout.dart';
import 'package:flipper_dashboard/home/pages/sheet_page_with_text_field.dart';
import 'package:flipper_dashboard/home/pages/sheet_page_with_update_page_method.dart';
import 'package:flutter/material.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

class RootSheetPage {
  RootSheetPage._();

  static const String pageId = 'RootSheetPage';

  static List<SliverWoltModalSheetPage> _constructAllPagesAfterRootPage(
          BuildContext context) =>
      [
        SheetPageWithForcedMaxHeight.build(
          Theme.of(context).brightness,
          isLastPage: false,
        ),
        SheetPageWithHeroImage.build(isLastPage: false),
        SheetPageWithLazyList.build(isLastPage: false),
        SheetPageWithTextField.build(isLastPage: false),
        SheetPageWithMinHeight.build(isLastPage: false),
        SheetPageWithInAppNavigation.build(isLastPage: false),
        SheetPageWithCustomTopBar.build(isLastPage: false),
        SheetPageWithNoPageTitleNoTopBar.build(isLastPage: false),
        SheetPageWithUpdatePage.build(context, isLastPage: true),
      ];

  static WoltModalSheetPage build(BuildContext context) {
    final ValueNotifier<bool> isButtonEnabledNotifier = ValueNotifier(false);
    const title = 'Choose a use case';

    return WoltModalSheetPage(
      id: pageId,
      stickyActionBar: ValueListenableBuilder<bool>(
        valueListenable: isButtonEnabledNotifier,
        builder: (_, value, __) {
          return Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: WoltElevatedButton(
              onPressed: WoltModalSheet.of(context).showNext,
              enabled: value,
              child: const Text("Let's start!"),
            ),
          );
        },
      ),
      pageTitle: const ModalSheetTitle(title),
      hasTopBarLayer: false,
      trailingNavBarWidget: const WoltModalSheetCloseButton(),
      child: Builder(builder: (context) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(0, 16, 0, 120),
          child: Column(
            children: [
              WoltSelectionList<ModalPageName?>.singleSelect(
                itemTileDataGroup: const WoltSelectionListItemDataGroup(
                  group: [
                    WoltSelectionListItemData(
                      title: 'Page with forced max height',
                      value: SheetPageWithForcedMaxHeight.pageId,
                      isSelected: false,
                    ),
                    WoltSelectionListItemData(
                      title: 'All the pages in one flow',
                      value: null,
                      isSelected: false,
                    ),
                  ],
                ),
                onSelectionUpdateInSingleSelectionList: (selectedItemData) {
                  final pathName = selectedItemData.value;
                  late SliverWoltModalSheetPage destinationPage;
                  switch (pathName) {
                    case ModalPageName.forcedMaxHeight:
                      destinationPage = SheetPageWithForcedMaxHeight.build(
                          Theme.of(context).brightness);
                      break;
                    case ModalPageName.heroImage:
                      destinationPage = SheetPageWithHeroImage.build();
                      break;
                    case ModalPageName.lazyLoadingList:
                      destinationPage = SheetPageWithLazyList.build();
                      break;
                    case ModalPageName.textField:
                      destinationPage = SheetPageWithTextField.build();
                      break;
                    case ModalPageName.minHeight:
                      destinationPage = SheetPageWithMinHeight.build();
                      break;
                    case ModalPageName.noTitleNoTopBar:
                      destinationPage =
                          SheetPageWithNoPageTitleNoTopBar.build();
                      break;
                    case ModalPageName.customTopBar:
                      destinationPage = SheetPageWithCustomTopBar.build();
                      break;
                    case ModalPageName.updatePage:
                      destinationPage = SheetPageWithUpdatePage.build(context);
                      break;
                    case ModalPageName.flexibleLayout:
                      destinationPage = SheetPageWithNonScrollingLayout.build();
                      break;
                    case ModalPageName.inAppNavigation:
                      destinationPage = SheetPageWithInAppNavigation.build();
                      break;
                    case null:
                      WoltModalSheet.of(context).addOrReplacePages(
                        _constructAllPagesAfterRootPage(context),
                      );
                      return;
                  }
                  WoltModalSheet.of(context).addOrReplacePage(destinationPage);
                  isButtonEnabledNotifier.value = selectedItemData.isSelected;
                },
              ),
              _AllPagesPushWidget(
                allPagesAfterRootPage: _constructAllPagesAfterRootPage(context),
                isButtonEnabledNotifier: isButtonEnabledNotifier,
              )
            ],
          ),
        );
      }),
    );
  }
}

class _AllPagesPushWidget extends StatelessWidget {
  const _AllPagesPushWidget({
    required this.allPagesAfterRootPage,
    required this.isButtonEnabledNotifier,
  });

  final List<SliverWoltModalSheetPage> allPagesAfterRootPage;
  final ValueNotifier<bool> isButtonEnabledNotifier;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Divider(),
        ListTile(
          contentPadding: EdgeInsets.zero,
          visualDensity: VisualDensity.compact,
          trailing: const Icon(Icons.arrow_forward_ios),
          title: const Text('All the pages in one flow'),
          subtitle: const Text(
            'Pressing this tile will append the page list and show the next page',
          ),
          onTap: () {
            WoltModalSheet.of(context).pushPages(allPagesAfterRootPage);
            isButtonEnabledNotifier.value = true;
          },
        ),
      ],
    );
  }
}
