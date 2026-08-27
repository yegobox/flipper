import 'package:flipper_services/constants.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter/material.dart';

/// The receipt type new sales are issued under on this device.
///
/// Desktop exposes this as two mutually exclusive switches in System Config
/// (Training Mode / Proforma Mode). They are mutually exclusive by nature — a
/// sale carries exactly one EBM code — so mobile presents them as one choice.
enum SaleMode {
  normal(TransactionReceptType.NS),
  proforma(TransactionReceptType.PS),
  training(TransactionReceptType.TS);

  const SaleMode(this.receiptType);

  final String receiptType;
}

SaleMode currentSaleMode() {
  if (ProxyService.box.isProformaMode()) return SaleMode.proforma;
  if (ProxyService.box.isTrainingMode()) return SaleMode.training;
  return SaleMode.normal;
}

String saleModeLabel(SaleMode mode) => switch (mode) {
  SaleMode.normal => 'Normal sale (NS)',
  SaleMode.proforma => 'Proforma (PS)',
  SaleMode.training => 'Training (TS)',
};

/// Writes the two flags together so the device can never end up in both modes
/// (or stuck in one, which the paired setters on `SettingViewModel` allow).
Future<void> applySaleMode(SaleMode mode) async {
  await ProxyService.box.writeBool(
    key: 'isProformaMode',
    value: mode == SaleMode.proforma,
  );
  await ProxyService.box.writeBool(
    key: 'isTrainingMode',
    value: mode == SaleMode.training,
  );
}

/// Opens the sale mode picker. Resolves to the mode in force when it closes.
Future<SaleMode> showMobileSaleModeSheet(BuildContext context) async {
  await showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => const _MobileSaleModeSheet(),
  );
  return currentSaleMode();
}

class _MobileSaleModeSheet extends StatefulWidget {
  const _MobileSaleModeSheet();

  @override
  State<_MobileSaleModeSheet> createState() => _MobileSaleModeSheetState();
}

class _MobileSaleModeSheetState extends State<_MobileSaleModeSheet> {
  late SaleMode _mode = currentSaleMode();
  bool _saving = false;

  Future<void> _select(SaleMode mode) async {
    if (_saving || mode == _mode) return;
    setState(() {
      _saving = true;
      _mode = mode;
    });
    await applySaleMode(mode);
    if (mounted) setState(() => _saving = false);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              margin: const EdgeInsets.only(top: 12, bottom: 8),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 4),
              child: Row(
                children: [
                  const Expanded(
                    child: Text(
                      'Sale mode',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close, size: 20),
                  ),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.fromLTRB(20, 0, 20, 16),
              child: Text(
                'The receipt type new sales are issued under. Leave this on '
                'Normal sale unless you are practising or quoting.',
                style: TextStyle(
                  fontSize: 13,
                  height: 1.4,
                  color: Color(0xFF6B7280),
                ),
              ),
            ),
            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
              child: Column(
                children: [
                  _SaleModeOption(
                    title: 'Normal sale',
                    code: 'NS',
                    subtitle: 'Real, fiscal sales. The default.',
                    selected: _mode == SaleMode.normal,
                    onTap: () => _select(SaleMode.normal),
                  ),
                  const SizedBox(height: 10),
                  _SaleModeOption(
                    title: 'Proforma',
                    code: 'PS',
                    subtitle: 'Quotes. Not a receipt, no stock movement.',
                    selected: _mode == SaleMode.proforma,
                    onTap: () => _select(SaleMode.proforma),
                  ),
                  const SizedBox(height: 10),
                  _SaleModeOption(
                    title: 'Training',
                    code: 'TS',
                    subtitle:
                        'Practice sales. Training receipts cannot be shared '
                        'or printed.',
                    selected: _mode == SaleMode.training,
                    onTap: () => _select(SaleMode.training),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SaleModeOption extends StatelessWidget {
  const _SaleModeOption({
    required this.title,
    required this.code,
    required this.subtitle,
    required this.selected,
    required this.onTap,
  });

  final String title;
  final String code;
  final String subtitle;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    const accent = Color(0xFF2563EB);
    return Container(
      decoration: BoxDecoration(
        color: selected ? const Color(0xFFEFF6FF) : Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: selected ? accent : const Color(0xFFE5E7EB),
          width: selected ? 1.6 : 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(14),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
            child: Row(
              children: [
                Icon(
                  selected
                      ? Icons.radio_button_checked
                      : Icons.radio_button_unchecked,
                  size: 20,
                  color: selected ? accent : const Color(0xFF9CA3AF),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            title,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF111827),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 7,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF3F4F6),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              code,
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF6B7280),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 3),
                      Text(
                        subtitle,
                        style: const TextStyle(
                          fontSize: 12.5,
                          height: 1.35,
                          color: Color(0xFF9CA3AF),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
