import 'package:flipper_dashboard/TaxSettingsModal.dart';
import 'package:flipper_dashboard/TenantManagement.dart';
import 'package:flipper_models/helperModels/talker.dart';
// import 'package:brick_offline_first/brick_offline_first.dart';
import 'package:supabase_models/brick/models/all_models.dart' as models;
import 'package:flipper_routing/app.locator.dart';
import 'package:flipper_routing/app.router.dart';
// import 'package:flipper_services/DatabaseProvider.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flipper_models/realm_model_export.dart';
import 'package:flutter/material.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:supabase_models/brick/repository.dart';

class AdminControl extends StatefulWidget {
  const AdminControl({super.key});

  @override
  State<AdminControl> createState() => _AdminControlState();
}

class _AdminControlState extends State<AdminControl> {
  final navigator = locator<RouterService>();
  bool isPosDefault = false;
  bool isOrdersDefault = true;
  bool enableDebug = false;
  bool filesDownloaded = false;
  bool forceUPSERT = false;
  bool stopTaxService = false;
  bool switchToCloudSync = false;
  @override
  void initState() {
    super.initState();
    isPosDefault = ProxyService.box.readBool(key: 'isPosDefault') ?? false;
    enableDebug = ProxyService.box.readBool(key: 'enableDebug') ?? false;
    isOrdersDefault = ProxyService.box.readBool(key: 'isOrdersDefault') ?? true;
    filesDownloaded =
        ProxyService.box.readBool(key: 'doneDownloadingAsset') ?? true;
    forceUPSERT = ProxyService.box.forceUPSERT();
    stopTaxService = ProxyService.box.stopTaxService() ?? false;
    switchToCloudSync = ProxyService.box.switchToCloudSync() ?? false;
  }

  Future<void> toggleDownload(bool value) async {
    await ProxyService.box.writeBool(
        key: 'doneDownloadingAsset',
        value: !ProxyService.box.doneDownloadingAsset());
    ProxyService.local.reDownloadAsset();
    setState(() {
      filesDownloaded = ProxyService.box.doneDownloadingAsset();
    });
  }

  Future<void> toggleForceUPSERT(bool value) async {
    /// get product attempt to save'em in sqlite.
    final repository = Repository();
    List<Product> products = await ProxyService.local
        .products(branchId: ProxyService.box.getBranchId()!);
    for (Product product in products) {
      await repository.upsert(models.Product(
        id: product.id!,
        name: product.name,
        taxId: product.taxId,
        description: product.description,
        color: product.color,
        businessId: product.businessId,
        branchId: product.branchId,
        supplierId: product.supplierId,
        categoryId: product.categoryId,
        // taxId: product.taxId,
        unit: product.unit,
        imageUrl: product.imageUrl,
        expiryDate: product.expiryDate,
        barCode: product.barCode,
        nfcEnabled: product.nfcEnabled,
        bindedToTenantId: product.bindedToTenantId,
        isFavorite: product.isFavorite,
        lastTouched: product.lastTouched,
        deletedAt: product.deletedAt,
        searchMatch: product.searchMatch,
        spplrNm: product.spplrNm,
        isComposite: product.isComposite,
        composites: [],
      ));
    }
    List<Variant> variants =
        ProxyService.local.variants(branchId: ProxyService.box.getBranchId()!);
    for (Variant variant in variants) {
      final vv = models.Variant(
        id: variant.id!,
        // branchIds: [ProxyService.box.getBranchId()!],
        stockId: variant.stock!.id,
        deletedAt: variant.deletedAt,
        name: variant.name ?? "", // Use empty string if name is null
        color: variant.color,
        sku: variant.sku,
        productId: variant.productId,
        unit: variant.unit,
        productName: variant.productName ?? "",
        branchId: variant.branchId, // Assuming this is optional
        taxName: variant.taxName ?? "",
        taxPercentage: variant.taxPercentage,
        itemSeq: variant.itemSeq,
        isrccCd: variant.isrccCd ?? "",
        isrccNm: variant.isrccNm ?? "",
        isrcRt: variant.isrcRt ?? 0,
        isrcAmt: variant.isrcAmt ?? 0,
        taxTyCd: variant.taxTyCd ?? "B", // Default to "B" if null
        bcd: variant.bcd ?? "",
        itemClsCd: variant.itemClsCd,
        itemTyCd: variant.itemTyCd,
        itemStdNm: variant.itemStdNm ?? "",
        orgnNatCd: variant.orgnNatCd ?? "",
        pkg: variant.pkg ?? "1", // Default to "1" if null
        itemCd: variant.itemCd ?? "",
        pkgUnitCd: variant.pkgUnitCd ?? "CT", // Default to "CT" if null
        qtyUnitCd: variant.qtyUnitCd ?? "BX", // Default to "BX" if null
        itemNm: variant.itemNm,
        prc: variant.prc,
        splyAmt: variant.splyAmt,
        tin: variant.tin,
        bhfId: variant.bhfId,
        dftPrc: variant.dftPrc ?? 0,
        addInfo: variant.addInfo ?? "",
        isrcAplcbYn: variant.isrcAplcbYn ?? "",
        useYn: variant.useYn ?? "",
        regrId: variant.regrId,
        regrNm: variant.regrNm,
        modrId: variant.modrId,
        modrNm: variant.modrNm,
        lastTouched: variant.lastTouched,
        supplyPrice: variant.supplyPrice,
        retailPrice: variant.retailPrice,
        spplrItemClsCd: variant.spplrItemClsCd,
        spplrItemCd: variant.spplrItemCd,
        spplrItemNm: variant.spplrItemNm,
        ebmSynced: variant.ebmSynced,
        dcRt: variant.dcRt,
        expirationDate: variant.expirationDate,
      );
      // upsert stock first
      await repository.upsert(models.Stock(
        id: variant.stock!.id!,
        tin: variant.stock!.tin,
        bhfId: variant.stock!.bhfId,
        branchId: variant.stock!.branchId,
        currentStock: variant.stock!.currentStock,
        lowStock: variant.stock!.lowStock,
        canTrackingStock: variant.stock!.canTrackingStock,
        showLowStockAlert: variant.stock!.showLowStockAlert,
        productId: variant.stock!.productId,
        active: variant.stock!.active,
        value: variant.stock!.value,
        rsdQty: variant.stock!.rsdQty,
        lastTouched: variant.stock!.lastTouched,
        ebmSynced: variant.stock!.ebmSynced,
        variant: vv,
        variantId: variant.id,
      ));
      await repository.upsert(vv);
    }
    try {
      await ProxyService.box.writeBool(
          key: 'forceUPSERT', value: !ProxyService.box.forceUPSERT());

      setState(() {
        forceUPSERT = ProxyService.box.forceUPSERT();
      });
    } catch (e, s) {
      talker.error(e, s);
    }
  }

  Future<void> toggleTaxService(bool value) async {
    await ProxyService.box.writeBool(
        key: 'stopTaxService', value: !ProxyService.box.stopTaxService()!);
    //TODO: put this behind payment plan

    setState(() {
      stopTaxService = ProxyService.box.stopTaxService()!;
    });
  }

  void togglePos(bool value) {
    setState(() {
      isPosDefault = value;
      if (value) {
        isOrdersDefault = false;
        ProxyService.box.writeBool(key: 'isOrdersDefault', value: false);
      }
      ProxyService.box.writeBool(key: 'isPosDefault', value: value);
    });
  }

  void toggleOrders(bool value) {
    setState(() {
      isOrdersDefault = value;
      if (value) {
        isPosDefault = false;
        ProxyService.box.writeBool(key: 'isPosDefault', value: false);
      }
      ProxyService.box.writeBool(key: 'isOrdersDefault', value: value);
    });
  }

  void enableSyncStrategyFunc(bool value) async {
    await ProxyService.box.writeBool(
        key: 'switchToCloudSync',
        value: !ProxyService.box.switchToCloudSync()!);

    setState(() {
      switchToCloudSync = ProxyService.box.switchToCloudSync()!;
    });
    if (switchToCloudSync) {
      // ProxyService.setStrategy(Strategy.cloudSync);
      ProxyService.strategy.whoAmI();
    } else {
      // ProxyService.setStrategy(Strategy.capella);
      ProxyService.strategy.whoAmI();
    }
  }

  void enableDebugFunc(bool value) async {
    await ProxyService.box
        .writeBool(key: 'enableDebug', value: !ProxyService.box.enableDebug()!);

    setState(() {
      enableDebug = ProxyService.box.enableDebug()!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            navigator.navigateTo(FlipperAppRoute());
          },
          tooltip: 'Back',
        ),
        title: Text(
          'Management',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: Colors.black87,
                fontWeight: FontWeight.bold,
              ),
        ),
        // actions: actions,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(
            color: Colors.grey[300],
            height: 1.0,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: SettingsSection(
                      title: 'Account',
                      children: [
                        const SizedBox(height: 16),
                        SettingsCard(
                          title: 'User Management',
                          subtitle: 'Manage users and permissions',
                          icon: Icons.people,
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return TenantManagement();
                              },
                            );
                          },
                        ),
                        SettingsCard(
                          title: 'Branch Management',
                          subtitle: 'Manage Branch (Locations)',
                          icon: Icons.people,
                          onTap: () {
                            locator<RouterService>()
                                .navigateTo(AddBranchRoute());
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 24),
                  Expanded(
                    child: SettingsSection(
                      title: 'Financial',
                      children: [
                        SettingsCard(
                          title: 'Tax Control',
                          subtitle: 'Manage tax settings',
                          icon: Icons.attach_money,
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (context) => TaxSettingsModal(
                                  branchId: ProxyService.box.getBranchId()!),
                            );
                          },
                        ),
                        const SizedBox(height: 16),
                        SettingsCard(
                          title: 'Payment Methods',
                          subtitle: 'Manage your payment options',
                          icon: Icons.credit_card,
                          onTap: () {},
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              SettingsSection(
                title: 'Preferences',
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: SwitchSettingsCard(
                          title: 'POS',
                          subtitle: 'Make POS default app',
                          icon: Icons.shopping_cart,
                          value: isPosDefault,
                          onChanged: togglePos,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: SwitchSettingsCard(
                          title: 'Orders',
                          subtitle: 'Make Orders default app',
                          icon: Icons.receipt,
                          value: isOrdersDefault,
                          onChanged: toggleOrders,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SettingsSection(
                title: 'Debugging',
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: SwitchSettingsCard(
                          title: 'Enable Debug',
                          subtitle: 'Enable Debug mode',
                          icon: Icons.bug_report,
                          value: enableDebug,
                          onChanged: enableDebugFunc,
                        ),
                      )
                    ],
                  ),
                ],
              ),
              SettingsSection(
                title: 'Sync Strategy',
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: SwitchSettingsCard(
                          title: 'Switch to Cloud Sync',
                          subtitle: 'Switch to Cloud Sync',
                          icon: Icons.sync,
                          value: switchToCloudSync,
                          onChanged: enableSyncStrategyFunc,
                        ),
                      )
                    ],
                  ),
                ],
              ),
              SettingsSection(
                title: 'Tax Service',
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: SwitchSettingsCard(
                          title: 'Tax Service',
                          subtitle: 'Stop Tax Service',
                          icon: Icons.sync,
                          value: stopTaxService,
                          onChanged: toggleTaxService,
                        ),
                      )
                    ],
                  ),
                ],
              ),
              SettingsSection(
                title: 'Sync',
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: SwitchSettingsCard(
                          title: 'Synchronize',
                          subtitle: 'Force upsert',
                          icon: Icons.sync,
                          value: forceUPSERT,
                          onChanged: toggleForceUPSERT,
                        ),
                      )
                    ],
                  ),
                ],
              ),
              SettingsSection(
                title: 'Downloads',
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: SwitchSettingsCard(
                          title: 'Images',
                          subtitle: 'Force Download images',
                          icon: Icons.download,
                          value: filesDownloaded,
                          onChanged: toggleDownload,
                        ),
                      )
                    ],
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

class SettingsSection extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const SettingsSection({
    required this.title,
    required this.children,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 16),
        ...children,
      ],
    );
  }
}

class SettingsCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;

  const SettingsCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(icon, size: 32, color: Theme.of(context).primaryColor),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 4),
                    Text(subtitle,
                        style: Theme.of(context).textTheme.bodyMedium),
                  ],
                ),
              ),
              Icon(Icons.chevron_right, color: Colors.grey[600]),
            ],
          ),
        ),
      ),
    );
  }
}

class SwitchSettingsCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final bool value;
  final ValueChanged<bool> onChanged;

  const SwitchSettingsCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.value,
    required this.onChanged,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(icon, size: 32, color: Theme.of(context).primaryColor),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 4),
                  Text(subtitle, style: Theme.of(context).textTheme.bodyMedium),
                ],
              ),
            ),
            Switch(
              value: value,
              onChanged: onChanged,
              activeColor: Theme.of(context).primaryColor,
            ),
          ],
        ),
      ),
    );
  }
}
