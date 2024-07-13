// ignore_for_file: unused_result

import 'package:flipper_dashboard/DownloadCard.dart';
import 'package:flipper_dashboard/ReportCard.dart';
import 'package:flipper_dashboard/customappbar.dart';
import 'package:flipper_dashboard/transactionList.dart';
import 'package:flipper_models/view_models/mixins/riverpod_states.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter/material.dart';
import 'package:flipper_dashboard/widgets/back_button.dart' as back;
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flipper_routing/app.locator.dart';
import 'package:stacked_services/stacked_services.dart';

class Reports extends StatefulHookConsumerWidget {
  const Reports({super.key});

  @override
  ReportsState createState() => ReportsState();
}

class ReportsState extends ConsumerState<Reports>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final stockValue =
        ref.watch(stocValueProvider(ProxyService.box.getBranchId()!));
    final soldStock =
        ref.watch(soldStockValueProvider(ProxyService.box.getBranchId()!));
    final reports = ref.watch(reportsProvider(ProxyService.box.getBranchId()!));

    return SafeArea(
      child: Scaffold(
        appBar: CustomAppBar(
          closeButton: CLOSEBUTTON.WIDGET,
          isDividerVisible: false,
          onPop: () async {
            talker.info("Invalidating transactionItemListProvider");
            ref.invalidate(transactionItemListProvider);
          },
          customLeadingWidget: back.BackButton(popCallback: () {
            talker.info("Invalidating transactionItemListProvider");
            ref.invalidate(transactionItemListProvider);
            ref.invalidate(transactionListProvider);
            //pop();
            locator<RouterService>().pop();
          }),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Stock Performance',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.blueGrey[700],
                            ),
                          ),
                          const SizedBox(height: 16),
                          ReportCard(
                            cardName: "Stock Value",
                            wordingA: "Current Stock",
                            wordingB: "Gross Sales",
                            valueA: stockValue.asData?.value ?? 0,
                            valueB: soldStock.asData?.value ?? 0,
                            description: "Stock Performance",
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 24),
                    Expanded(
                      flex: 3,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                ref.watch(showAiReport)
                                    ? 'Past Reports'
                                    : 'AI Reports',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blueGrey[700],
                                ),
                              ),
                              Switch(
                                value: ref.watch(showAiReport),
                                onChanged: (value) {
                                  ref
                                      .read(showAiReport.notifier)
                                      .toggleReport();

                                  talker.warning(
                                      "toggledReportValue ${ref.watch(showAiReport)}");

                                  ref
                                      .read(dateRangeProvider.notifier)
                                      .setStartDate(DateTime.now());
                                  ref
                                      .read(dateRangeProvider.notifier)
                                      .setEndDate(DateTime.now());

                                  ref.refresh(transactionItemListProvider);
                                },
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          ref.watch(showAiReport)
                              ? Center(
                                  child: ConstrainedBox(
                                    constraints: BoxConstraints(maxHeight: 500),
                                    child: TransactionList(
                                      showPluReportWidget:
                                          ref.watch(showAiReport),
                                    ),
                                  ),
                                )
                              : reports.when(
                                  data: (reports) {
                                    if (reports.isEmpty) {
                                      return Center(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.inbox_outlined,
                                              size: 64,
                                              color: Colors.grey,
                                            ),
                                            SizedBox(height: 16),
                                            Text(
                                              'No reports available',
                                              style: TextStyle(
                                                fontSize: 18,
                                                color: Colors.grey[600],
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    } else {
                                      return ListView.builder(
                                        shrinkWrap: true,
                                        physics: NeverScrollableScrollPhysics(),
                                        itemCount: reports.length,
                                        itemBuilder: (context, index) {
                                          final report = reports[index];
                                          return Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 12.0),
                                            child: DownloadCard(
                                              url: report.s3Url!,
                                              filename: report.filename!,
                                              downloaded:
                                                  report.downloaded ?? false,
                                              report: report,
                                            ),
                                          );
                                        },
                                      );
                                    }
                                  },
                                  loading: () => Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.inbox_outlined,
                                          size: 64,
                                          color: Colors.grey,
                                        ),
                                        SizedBox(height: 16),
                                        Text(
                                          'No reports available',
                                          style: TextStyle(
                                            fontSize: 18,
                                            color: Colors.grey[600],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  error: (error, stack) => Center(
                                    child:
                                        Text('Error loading reports: $error'),
                                  ),
                                ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
