import 'package:flutter/material.dart' show IconData, Icons;
import 'package:supabase_flutter/supabase_flutter.dart';

/// Add-on row from Supabase `subscription_plan_addon_templates`.
class SubscriptionPlanAddonTemplate {
  const SubscriptionPlanAddonTemplate({
    required this.id,
    required this.planTemplateId,
    required this.slug,
    required this.name,
    required this.monthlyPrice,
    this.sortOrder = 0,
  });

  final String id;
  final String planTemplateId;
  final String slug;
  final String name;
  final int monthlyPrice;
  final int sortOrder;

  factory SubscriptionPlanAddonTemplate.fromSupabaseJson(
    Map<String, dynamic> row,
  ) {
    return SubscriptionPlanAddonTemplate(
      id: row['id']?.toString() ?? '',
      planTemplateId: row['plan_template_id']?.toString() ?? '',
      slug: row['slug']?.toString() ?? '',
      name: row['name']?.toString() ?? '',
      monthlyPrice: (row['monthly_price'] as num?)?.toInt() ?? 0,
      sortOrder: (row['sort_order'] as num?)?.toInt() ?? 0,
    );
  }
}

/// Plan tier row from Supabase `subscription_plan_templates`.
class SubscriptionPlanTemplate {
  const SubscriptionPlanTemplate({
    required this.id,
    required this.slug,
    required this.name,
    required this.monthlyPrice,
    this.description,
    this.yearlyDiscountPercent = 20,
    this.tier = 'standard',
    this.icon,
    this.sortOrder = 0,
    this.addons = const [],
  });

  final String id;
  final String slug;
  final String name;
  final String? description;
  final int monthlyPrice;
  final double yearlyDiscountPercent;
  final String tier;
  final String? icon;
  final int sortOrder;
  final List<SubscriptionPlanAddonTemplate> addons;

  bool get isEnterprise => tier == 'enterprise';

  factory SubscriptionPlanTemplate.fromSupabaseJson(
    Map<String, dynamic> row, {
    List<SubscriptionPlanAddonTemplate> addons = const [],
  }) {
    return SubscriptionPlanTemplate(
      id: row['id']?.toString() ?? '',
      slug: row['slug']?.toString() ?? '',
      name: row['name']?.toString() ?? '',
      description: row['description']?.toString(),
      monthlyPrice: (row['monthly_price'] as num?)?.toInt() ?? 0,
      yearlyDiscountPercent:
          (row['yearly_discount_percent'] as num?)?.toDouble() ?? 20,
      tier: row['tier']?.toString() ?? 'standard',
      icon: row['icon']?.toString(),
      sortOrder: (row['sort_order'] as num?)?.toInt() ?? 0,
      addons: addons,
    );
  }

  IconData resolveIcon() {
    switch (icon) {
      case 'devices':
        return Icons.devices;
      case 'business':
        return Icons.business_rounded;
      case 'phone_iphone':
      default:
        return Icons.phone_iphone;
    }
  }

  SubscriptionPlanAddonTemplate? addonBySlug(String slug) {
    for (final addon in addons) {
      if (addon.slug == slug) return addon;
    }
    return null;
  }

  int monthlySubtotal({Iterable<String> selectedAddonSlugs = const []}) {
    var total = monthlyPrice;
    for (final slug in selectedAddonSlugs) {
      total += addonBySlug(slug)?.monthlyPrice ?? 0;
    }
    return total;
  }

  double calculateTotal({
    required bool isYearly,
    Iterable<String> selectedAddonSlugs = const [],
  }) {
    final monthly = monthlySubtotal(selectedAddonSlugs: selectedAddonSlugs);
    if (!isYearly) return monthly.toDouble();
    final discountMultiplier = 1 - (yearlyDiscountPercent / 100);
    return monthly * 12 * discountMultiplier;
  }

  String formatListPrice({required bool isYearly, String suffix = 'RWF'}) {
    final amount = calculateTotal(isYearly: isYearly);
    final period = isYearly ? '/year' : '/month';
    final formatted = _formatRwf(amount);
    if (isEnterprise && addons.isNotEmpty) {
      return '$formatted+ $suffix$period';
    }
    return '$formatted $suffix$period';
  }

  String formatAddonPrice(
    SubscriptionPlanAddonTemplate addon, {
    required bool isYearly,
  }) {
    final period = isYearly ? '/year' : '/month';
    if (isYearly) {
      final discountMultiplier = 1 - (yearlyDiscountPercent / 100);
      final yearly = (addon.monthlyPrice * 12 * discountMultiplier).round();
      return '${_formatRwf(yearly.toDouble())} RWF$period';
    }
    return '${_formatRwf(addon.monthlyPrice.toDouble())} RWF$period';
  }
}

/// Loaded catalogue of active plan templates and their add-ons.
class SubscriptionPlanCatalog {
  const SubscriptionPlanCatalog({required this.templates});

  final List<SubscriptionPlanTemplate> templates;

  SubscriptionPlanTemplate? byId(String? id) {
    if (id == null || id.isEmpty) return null;
    for (final template in templates) {
      if (template.id == id) return template;
    }
    return null;
  }

  SubscriptionPlanTemplate? byName(String? name) {
    if (name == null || name.isEmpty) return null;
    final normalized = name.trim().toLowerCase();
    for (final template in templates) {
      if (template.name.trim().toLowerCase() == normalized) return template;
    }
    return null;
  }

  SubscriptionPlanTemplate? bySlug(String? slug) {
    if (slug == null || slug.isEmpty) return null;
    for (final template in templates) {
      if (template.slug == slug) return template;
    }
    return null;
  }

  SubscriptionPlanTemplate? get firstOrNull =>
      templates.isEmpty ? null : templates.first;

  static Future<SubscriptionPlanCatalog> fetchFromSupabase() async {
    final rows = await Supabase.instance.client
        .from('subscription_plan_templates')
        .select(
          '*, subscription_plan_addon_templates(*)',
        )
        .eq('is_active', true)
        .order('sort_order', ascending: true);

    final templates = <SubscriptionPlanTemplate>[];
    for (final row in rows as List<dynamic>) {
      final map = Map<String, dynamic>.from(row as Map);
      final addonRows =
          (map.remove('subscription_plan_addon_templates') as List<dynamic>? ??
                  [])
              .map(
                (a) => SubscriptionPlanAddonTemplate.fromSupabaseJson(
                  Map<String, dynamic>.from(a as Map),
                ),
              )
              .where((a) => a.id.isNotEmpty)
              .toList()
            ..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
      templates.add(
        SubscriptionPlanTemplate.fromSupabaseJson(map, addons: addonRows),
      );
    }

    return SubscriptionPlanCatalog(templates: templates);
  }
}

String _formatRwf(double amount) {
  final rounded = amount.round();
  final s = rounded.toString();
  final buffer = StringBuffer();
  for (var i = 0; i < s.length; i++) {
    if (i > 0 && (s.length - i) % 3 == 0) buffer.write(',');
    buffer.write(s[i]);
  }
  return buffer.toString();
}
