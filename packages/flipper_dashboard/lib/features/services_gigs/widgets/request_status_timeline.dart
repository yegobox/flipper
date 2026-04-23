import 'package:flipper_dashboard/features/services_gigs/models/service_gig_request.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

/// Vertical timeline of major gig request milestones.
class RequestStatusTimeline extends StatelessWidget {
  final ServiceGigRequest request;

  const RequestStatusTimeline({Key? key, required this.request}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final df = DateFormat.yMMMd().add_jm();
    final steps = <_Step>[
      _Step(
        label: 'Request sent',
        time: request.createdAt,
        done: true,
      ),
      _Step(
        label: 'Provider accepted',
        time: request.acceptedAt,
        done: request.acceptedAt != null ||
            _statusPast(request.status, 'pending_payment'),
      ),
      _Step(
        label: 'Payment received',
        time: request.paidAt,
        done: request.paidAt != null ||
            _statusPast(request.status, 'paid'),
      ),
      _Step(
        label: 'Work in progress',
        time: request.providerStartedAt,
        done: request.providerStartedAt != null ||
            _statusPast(request.status, 'in_progress'),
      ),
      _Step(
        label: 'Completed',
        time: request.providerCompletedAt,
        done: request.status == 'completed',
      ),
      if (request.customerRating != null)
        _Step(
          label: 'Review submitted',
          time: request.reviewSubmittedAt,
          done: true,
        ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Order timeline',
          style: GoogleFonts.outfit(
            fontWeight: FontWeight.w600,
            fontSize: 15,
          ),
        ),
        const SizedBox(height: 12),
        ...List.generate(steps.length, (i) {
          final s = steps[i];
          final last = i == steps.length - 1;
          return _TimelineRow(
            step: s,
            showLine: !last,
            dateFormat: df,
          );
        }),
      ],
    );
  }

  static bool _statusPast(String current, String threshold) {
    const order = [
      'requested',
      'pending_payment',
      'paid',
      'in_progress',
      'completed',
    ];
    final ti = order.indexOf(threshold);
    final ci = order.indexOf(current);
    if (ti < 0 || ci < 0) return false;
    return ci >= ti;
  }
}

class _Step {
  final String label;
  final DateTime? time;
  final bool done;

  _Step({
    required this.label,
    required this.time,
    required this.done,
  });
}

class _TimelineRow extends StatelessWidget {
  final _Step step;
  final bool showLine;
  final DateFormat dateFormat;

  const _TimelineRow({
    required this.step,
    required this.showLine,
    required this.dateFormat,
  });

  @override
  Widget build(BuildContext context) {
    final color = step.done ? const Color(0xFF0D9488) : Colors.grey.shade400;
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            width: 28,
            child: Column(
              children: [
                Container(
                  width: 14,
                  height: 14,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: step.done ? color : Colors.white,
                    border: Border.all(color: color, width: 2),
                  ),
                ),
                if (showLine)
                  Expanded(
                    child: Container(
                      width: 2,
                      margin: const EdgeInsets.symmetric(vertical: 2),
                      color: Colors.grey.shade300,
                    ),
                  ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(
                left: 8,
                bottom: showLine ? 16 : 0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    step.label,
                    style: GoogleFonts.outfit(
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                      color: step.done
                          ? Colors.grey.shade900
                          : Colors.grey.shade500,
                    ),
                  ),
                  if (step.time != null)
                    Text(
                      dateFormat.format(step.time!.toLocal()),
                      style: GoogleFonts.outfit(
                        fontSize: 11,
                        color: Colors.grey.shade600,
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
