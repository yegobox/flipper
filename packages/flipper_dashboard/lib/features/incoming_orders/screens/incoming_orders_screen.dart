// ignore_for_file: unused_result

import 'package:flipper_dashboard/checkout.dart' show OrderStatus;
import 'package:flipper_dashboard/features/incoming_orders/om_tokens.dart';
import 'package:flipper_dashboard/features/incoming_orders/widgets/bulk_action_bar.dart';
import 'package:flipper_dashboard/features/incoming_orders/widgets/om_segmented.dart';
import 'package:flipper_dashboard/features/incoming_orders/widgets/request_card.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_models/providers/active_branch_provider.dart';
import 'package:flipper_models/providers/orders_provider.dart';
import 'package:flipper_models/view_models/mixins/riverpod_states.dart';
import 'package:flipper_services/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

enum OmDirection { incoming, outgoing }

class IncomingOrdersScreen extends HookConsumerWidget {
  const IncomingOrdersScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stringValue = ref.watch(stringProvider);
    final status = ref.watch(requestStatusProvider);
    final search = stringValue?.isNotEmpty == true ? stringValue : null;
    final direction = useState(OmDirection.incoming);
    // Gates pagination so loadMore() fires once per scroll-to-bottom, not on
    // every settling scroll notification while parked at the end.
    final loadMoreGate = useRef(false);
    final orderStatus = ref.watch(orderStatusProvider);

    final incomingRequestsAsync = ref.watch(
      stockRequestsProvider(status: status, search: search),
    );
    final outgoingRequestsAsync = ref.watch(
      outgoingStockRequestsProvider(status: status, search: search),
    );
    final branchAsync = ref.watch(activeBranchProvider);

    final isIncoming = direction.value == OmDirection.incoming;
    final requestsAsync =
        isIncoming ? incomingRequestsAsync : outgoingRequestsAsync;

    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth == 0 || constraints.maxHeight == 0) {
          return const SizedBox.shrink();
        }

        final compact = constraints.maxWidth < OmTokens.compactBreakpoint;
        final hPad = compact ? 16.0 : 32.0;
        final vPad = compact ? 20.0 : 36.0;

        return Stack(
          children: [
            ColoredBox(
              color: OmTokens.canvas,
              child: Align(
                alignment: Alignment.topCenter,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxWidth: OmTokens.maxContentWidth,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Padding(
                        padding: EdgeInsets.fromLTRB(hPad, vPad, hPad, 0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            _OmHeader(
                              compact: compact,
                              orderStatus: orderStatus,
                              onStatusChanged: (newStatus) {
                                ref.read(orderStatusProvider.notifier).state =
                                    newStatus;
                                ref.read(requestStatusProvider.notifier).state =
                                    newStatus == OrderStatus.approved
                                        ? RequestStatus.approved
                                        : RequestStatus.pending;
                              },
                            ),
                            SizedBox(height: compact ? 16 : 22),
                            OmSegmented<OmDirection>(
                              value: direction.value,
                              large: true,
                              onChanged: (v) => direction.value = v,
                              options: const [
                                OmSegOption(
                                  value: OmDirection.incoming,
                                  label: 'Incoming',
                                  icon: Icons.move_to_inbox_outlined,
                                ),
                                OmSegOption(
                                  value: OmDirection.outgoing,
                                  label: 'Outgoing',
                                  icon: Icons.outbox_outlined,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: _buildBody(
                          ref: ref,
                          requestsAsync: requestsAsync,
                          branchAsync: branchAsync,
                          isIncoming: isIncoming,
                          status: status,
                          search: search,
                          compact: compact,
                          hPad: hPad,
                          loadMoreGate: loadMoreGate,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: BulkActionBar(),
            ),
          ],
        );
      },
    );
  }

  Widget _buildBody({
    required WidgetRef ref,
    required AsyncValue<List<InventoryRequest>> requestsAsync,
    required AsyncValue<Branch?> branchAsync,
    required bool isIncoming,
    required String status,
    String? search,
    required bool compact,
    required double hPad,
    required ObjectRef<bool> loadMoreGate,
  }) {
    return requestsAsync.when(
      data: (requests) {
        return branchAsync.when(
          data: (currentBranch) {
            if (currentBranch == null) {
              return _OmErrorState(
                title: 'Branch not found',
                message: 'Could not load active branch',
                onRetry: () => ref.refresh(activeBranchProvider),
              );
            }

            final isPending = status == RequestStatus.pending;
            final sectionTitle =
                isIncoming ? 'Received Orders' : 'Sent Orders';

            final listPadding =
                EdgeInsets.fromLTRB(hPad, compact ? 16 : 22, hPad, 80);

            Widget header() => Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (isPending) ...[
                      _OmStatCard(count: requests.length),
                      SizedBox(height: compact ? 16 : 22),
                    ],
                    Text(
                      sectionTitle,
                      style: OmTokens.text(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.01 * 15,
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],
                );

            return NotificationListener<ScrollNotification>(
              onNotification: (scrollInfo) {
                final atEnd = scrollInfo.metrics.pixels >=
                    scrollInfo.metrics.maxScrollExtent - 40;
                if (atEnd) {
                  if (!loadMoreGate.value) {
                    loadMoreGate.value = true;
                    if (isIncoming) {
                      ref
                          .read(
                            stockRequestsProvider(
                              status: status,
                              search: search,
                            ).notifier,
                          )
                          .loadMore();
                    } else {
                      ref
                          .read(
                            outgoingStockRequestsProvider(
                              status: status,
                              search: search,
                            ).notifier,
                          )
                          .loadMore();
                    }
                  }
                } else {
                  loadMoreGate.value = false;
                }
                return false;
              },
              child: requests.isEmpty
                  ? ListView(
                      padding: listPadding,
                      children: [
                        header(),
                        _OmEmptyState(status: status),
                      ],
                    )
                  : ListView.builder(
                      padding: listPadding,
                      itemCount: requests.length + 1,
                      itemBuilder: (context, i) {
                        if (i == 0) return header();
                        final index = i - 1;
                        final request = requests[index];
                        return Padding(
                          key: ValueKey(request.id),
                          padding: EdgeInsets.only(
                            bottom: index == requests.length - 1 ? 0 : 12,
                          ),
                          child: RequestCard(
                            request: request,
                            incomingBranch: currentBranch,
                            isIncoming: isIncoming,
                          ),
                        );
                      },
                    ),
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, _) => _OmErrorState(
            title: 'Error loading branch',
            message: err.toString(),
            onRetry: () => ref.refresh(activeBranchProvider),
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, _) => _OmErrorState(
        title: 'Error loading requests',
        message: err.toString(),
        onRetry: () {
          ref.refresh(
            isIncoming
                ? stockRequestsProvider(status: status, search: search)
                : outgoingStockRequestsProvider(status: status, search: search),
          );
        },
      ),
    );
  }
}

class _OmHeader extends StatelessWidget {
  const _OmHeader({
    required this.compact,
    required this.orderStatus,
    required this.onStatusChanged,
  });

  final bool compact;
  final OrderStatus orderStatus;
  final ValueChanged<OrderStatus> onStatusChanged;

  @override
  Widget build(BuildContext context) {
    final title = Text(
      'Orders Management',
      style: OmTokens.text(
        fontSize: compact ? 22 : 28,
        fontWeight: FontWeight.w800,
        letterSpacing: -0.02 * (compact ? 22 : 28),
      ),
    );
    final subtitle = Text(
      'Track and manage incoming and outgoing orders',
      style: OmTokens.text(
        fontSize: 14.5,
        fontWeight: FontWeight.w400,
        color: OmTokens.muted,
      ),
    );
    final statusSeg = OmSegmented<OrderStatus>(
      value: orderStatus,
      onChanged: onStatusChanged,
      options: const [
        OmSegOption(
          value: OrderStatus.pending,
          label: 'Pending',
          icon: Icons.check_circle_outline,
        ),
        OmSegOption(
          value: OrderStatus.approved,
          label: 'Approved',
          icon: Icons.check_circle_outline,
        ),
      ],
    );

    if (compact) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          title,
          const SizedBox(height: 6),
          subtitle,
          const SizedBox(height: 12),
          statusSeg,
        ],
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              title,
              const SizedBox(height: 6),
              subtitle,
            ],
          ),
        ),
        const SizedBox(width: 24),
        statusSeg,
      ],
    );
  }
}

class _OmStatCard extends StatelessWidget {
  const _OmStatCard({required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 20),
      decoration: BoxDecoration(
        color: OmTokens.surface,
        borderRadius: BorderRadius.circular(OmTokens.radiusLg),
        border: Border.all(color: OmTokens.line),
        boxShadow: OmTokens.shadowSm,
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: OmTokens.accentWash,
              borderRadius: BorderRadius.circular(13),
            ),
            child: const Icon(
              Icons.move_to_inbox_outlined,
              color: OmTokens.accentStrong,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '$count',
                style: OmTokens.text(
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                  height: 1,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                'Pending Requests',
                style: OmTokens.text(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w600,
                  color: OmTokens.muted,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _OmEmptyState extends StatelessWidget {
  const _OmEmptyState({required this.status});

  final String status;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 54),
      decoration: BoxDecoration(
        color: OmTokens.surface2,
        borderRadius: BorderRadius.circular(OmTokens.radiusLg),
        border: Border.all(color: OmTokens.line2, width: 1.5),
      ),
      child: Column(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: OmTokens.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: OmTokens.line),
            ),
            child: const Icon(
              Icons.move_to_inbox_outlined,
              size: 28,
              color: OmTokens.faint,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'No $status requests',
            style: OmTokens.text(
              fontSize: 16,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Nothing to show here right now.',
            textAlign: TextAlign.center,
            style: OmTokens.text(
              fontSize: 14,
              color: OmTokens.muted,
            ),
          ),
        ],
      ),
    );
  }
}

class _OmErrorState extends StatelessWidget {
  const _OmErrorState({
    required this.title,
    required this.message,
    required this.onRetry,
  });

  final String title;
  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: OmTokens.redWash,
                borderRadius: BorderRadius.circular(OmTokens.radiusSm),
              ),
              child: const Icon(
                Icons.error_outline,
                size: 32,
                color: OmTokens.red,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: OmTokens.text(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: OmTokens.text(
                fontSize: 12,
                color: OmTokens.muted,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 16),
            TextButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh, size: 18),
              label: const Text('Try Again'),
              style: TextButton.styleFrom(
                foregroundColor: OmTokens.accentStrong,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
