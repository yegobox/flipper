// Copyright 2019 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';

// import 'package:flutter_gen/gen_l10n/gallery_localizations.dart';
import 'package:flipper_finance/charts/pie_chart.dart';
import 'package:flipper_finance/data.dart';
import 'package:flipper_finance/finance.dart';
import 'package:flipper_finance/tabs/sidebar.dart';

/// A page that shows a summary of accounts.
class AccountsView extends StatelessWidget {
  const AccountsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final items = DummyDataService.getAccountDataList(context);
    final detailItems = DummyDataService.getAccountDetailList(context);
    final balanceTotal = sumAccountDataPrimaryAmount(items);

    return TabWithSidebar(
      restorationId: 'accounts_view',
      mainView: FinancialEntityView(
        heroLabel: "Total",
        heroAmount: balanceTotal,
        segments: buildSegmentsFromAccountItems(items),
        wholeAmount: balanceTotal,
        financialEntityCards: buildAccountDataListViews(items, context),
      ),
      sidebarItems: [
        for (UserDetailData item in detailItems)
          SidebarItem(title: item.title, value: item.value)
      ],
    );
  }
}
