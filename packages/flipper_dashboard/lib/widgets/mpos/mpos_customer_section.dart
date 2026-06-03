import 'package:flutter/material.dart';
import 'package:flipper_dashboard/theme/pos_tokens.dart';
import 'package:flipper_dashboard/utils/mpos_helpers.dart';
import 'package:flipper_dashboard/widgets/mpos/mpos_card.dart';

class MposCustomerSection extends StatelessWidget {
  const MposCustomerSection({
    super.key,
    required this.customerName,
    required this.customerPhone,
    required this.onAttach,
    required this.onClear,
  });

  final String? customerName;
  final String? customerPhone;
  final VoidCallback onAttach;
  final VoidCallback onClear;

  bool get _hasCustomer {
    final name = customerName?.trim();
    final phone = customerPhone?.trim();
    return (name != null && name.isNotEmpty) ||
        (phone != null && phone.isNotEmpty);
  }

  @override
  Widget build(BuildContext context) {
    return MposCard(
      child: _hasCustomer
          ? _AttachedRow(
              name: customerName ?? customerPhone ?? 'Customer',
              phone: customerPhone,
              onClear: onClear,
            )
          : _WalkInRow(onAttach: onAttach),
    );
  }
}

class _WalkInRow extends StatelessWidget {
  const _WalkInRow({required this.onAttach});

  final VoidCallback onAttach;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onAttach,
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: PosTokens.surface2,
                  borderRadius: BorderRadius.circular(13),
                  border: Border.all(
                    color: PosTokens.lineStrong,
                    width: 1.5,
                    style: BorderStyle.solid,
                  ),
                ),
                child: const Icon(
                  Icons.person_outline_rounded,
                  size: 20,
                  color: PosTokens.ink3,
                ),
              ),
              const SizedBox(width: 13),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Walk-in customer',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: PosTokens.ink1,
                      ),
                    ),
                    SizedBox(height: 1),
                    Text(
                      'Tap to attach a customer (optional)',
                      style: TextStyle(fontSize: 12.5, color: PosTokens.ink3),
                    ),
                  ],
                ),
              ),
              const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Add',
                    style: TextStyle(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w700,
                      color: PosTokens.blue,
                    ),
                  ),
                  Icon(
                    Icons.chevron_right_rounded,
                    size: 18,
                    color: PosTokens.blue,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AttachedRow extends StatelessWidget {
  const _AttachedRow({
    required this.name,
    required this.phone,
    required this.onClear,
  });

  final String name;
  final String? phone;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    final color = mposColorForName(name);
    return Padding(
      padding: const EdgeInsets.all(14),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(13),
            ),
            child: Text(
              mposAbbreviation(name),
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: PosTokens.ink1,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                if (phone != null && phone!.trim().isNotEmpty) ...[
                  const SizedBox(height: 1),
                  Text(
                    phone!,
                    style: const TextStyle(
                      fontSize: 12.5,
                      color: PosTokens.ink3,
                      fontFeatures: [FontFeature.tabularFigures()],
                    ),
                  ),
                ],
              ],
            ),
          ),
          IconButton(
            onPressed: onClear,
            icon: const Icon(Icons.close_rounded, size: 18),
            color: PosTokens.ink3,
            padding: const EdgeInsets.all(6),
            constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
          ),
        ],
      ),
    );
  }
}
