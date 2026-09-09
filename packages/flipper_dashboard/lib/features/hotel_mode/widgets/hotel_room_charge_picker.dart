import 'package:flutter/material.dart';
import 'package:flipper_dashboard/features/hotel_mode/theme/hotel_tokens.dart';
import 'package:flipper_models/SyncStrategy.dart';
import 'package:flipper_models/sync/utils/rra_line_utils.dart';
import 'package:flipper_services/proxy.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:supabase_models/brick/models/variant.model.dart';

/// Picks the product a nightly room charge is billed against.
///
/// Only variants that already carry a usable RRA `itemCd` are selectable —
/// choosing one without it would produce a folio line that cannot be
/// invoiced, and the failure would only surface at checkout.
class HotelRoomChargePicker extends StatefulWidget {
  const HotelRoomChargePicker({super.key, this.selectedVariantId});

  final String? selectedVariantId;

  static Future<Variant?> show(
    BuildContext context, {
    String? selectedVariantId,
  }) {
    return showDialog<Variant>(
      context: context,
      builder: (_) => Dialog(
        backgroundColor: Colors.transparent,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 460, maxHeight: 560),
          child: HotelRoomChargePicker(selectedVariantId: selectedVariantId),
        ),
      ),
    );
  }

  @override
  State<HotelRoomChargePicker> createState() => _HotelRoomChargePickerState();
}

class _HotelRoomChargePickerState extends State<HotelRoomChargePicker> {
  final _searchController = TextEditingController();
  List<Variant> _results = const [];
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _search('');
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _search(String term) async {
    final branchId = ProxyService.box.getBranchId();
    if (branchId == null) {
      setState(() {
        _loading = false;
        _error = 'No active branch';
      });
      return;
    }

    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final paged = await ProxyService.getStrategy(Strategy.capella).variants(
        branchId: branchId,
        name: term.trim().isEmpty ? null : term.trim(),
        itemsPerPage: 50,
        countTotal: false,
      );
      if (!mounted) return;
      setState(() {
        _results = paged.variants.cast<Variant>();
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _error = '$e';
      });
    }
  }

  bool _isBillable(Variant variant) =>
      rraItemCd(variant: variant, variantId: variant.id) != null;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 18),
      decoration: const BoxDecoration(
        color: HotelTokens.surface,
        borderRadius: BorderRadius.all(
          Radius.circular(HotelTokens.mobileSheetRadius),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Room charge product',
            style: GoogleFonts.outfit(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: HotelTokens.ink1,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            'The nightly rate is billed against this product, so it must be '
            'registered with RRA.',
            style: GoogleFonts.outfit(
              fontSize: 12.5,
              fontWeight: FontWeight.w500,
              color: HotelTokens.ink3,
              height: 1.35,
            ),
          ),
          const SizedBox(height: 14),
          TextField(
            controller: _searchController,
            onSubmitted: _search,
            onChanged: (v) {
              if (v.isEmpty) _search('');
            },
            style: GoogleFonts.outfit(fontSize: 14.5),
            decoration: InputDecoration(
              hintText: 'Search products…',
              isDense: true,
              prefixIcon: const Icon(Icons.search, size: 19),
              contentPadding: const EdgeInsets.symmetric(vertical: 13),
              filled: true,
              fillColor: HotelTokens.surface2,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(HotelTokens.radiusMd),
                borderSide: const BorderSide(color: HotelTokens.line),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(HotelTokens.radiusMd),
                borderSide: const BorderSide(color: HotelTokens.line),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Flexible(child: _body()),
        ],
      ),
    );
  }

  Widget _body() {
    if (_loading) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 40),
        child: Center(child: CircularProgressIndicator()),
      );
    }
    if (_error != null) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 30),
        child: Text(
          _error!,
          style: GoogleFonts.outfit(fontSize: 13, color: HotelTokens.lossInk),
        ),
      );
    }
    if (_results.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 30),
        child: Text(
          'No products found.',
          style: GoogleFonts.outfit(fontSize: 13, color: HotelTokens.ink3),
        ),
      );
    }

    return ListView.separated(
      shrinkWrap: true,
      itemCount: _results.length,
      separatorBuilder: (_, __) =>
          const Divider(height: 1, color: HotelTokens.line),
      itemBuilder: (context, i) {
        final variant = _results[i];
        final billable = _isBillable(variant);
        final selected = variant.id == widget.selectedVariantId;

        return ListTile(
          enabled: billable,
          selected: selected,
          contentPadding: const EdgeInsets.symmetric(horizontal: 4),
          title: Text(
            variant.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.outfit(
              fontSize: 14.5,
              fontWeight: FontWeight.w700,
              color: billable ? HotelTokens.ink1 : HotelTokens.ink4,
            ),
          ),
          subtitle: Text(
            billable
                ? 'RWF ${NumberFormat('#,###').format(variant.retailPrice ?? 0)}'
                  '${variant.itemCd == null ? '' : ' · ${variant.itemCd}'}'
                : 'Not registered with RRA — register it first',
            style: GoogleFonts.outfit(
              fontSize: 11.5,
              fontWeight: FontWeight.w500,
              color: billable ? HotelTokens.ink3 : HotelTokens.dirtyInk,
            ),
          ),
          trailing: selected
              ? const Icon(Icons.check_circle, color: HotelTokens.vacantInk)
              : null,
          onTap: billable
              ? () => Navigator.of(context).pop(variant)
              : null,
        );
      },
    );
  }
}
