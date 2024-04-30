import 'package:flipper_models/isar/random.dart';
import 'package:flipper_models/isar_models.dart';
import 'package:flipper_routing/app.locator.dart';
import 'package:flipper_routing/app.router.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stacked/stacked.dart';

class LoginChoices extends StatefulWidget {
  const LoginChoices({Key? key}) : super(key: key);

  @override
  State<LoginChoices> createState() => _LoginChoicesState();
}

class _LoginChoicesState extends State<LoginChoices> {
  List<Business> _businesses = [];
  bool _isNext = false;

  final _routerService = locator<RouterService>();

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<CoreViewModel>.reactive(
      viewModelBuilder: () => CoreViewModel(),
      onViewModelReady: (model) async {
        List<Business> _b = await ProxyService.isar.businesses();
        List<Branch> branches = await ProxyService.isar.branches();
        for (Branch branch in branches) {
          ProxyService.isar.update(data: branch..active = false);
        }
        model.branchesList(branches);
        setState(() {
          _businesses = _b;
        });
      },
      builder: (context, model, child) {
        return Scaffold(
          body: SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(
                vertical: MediaQuery.of(context).size.height * 0.1,
              ),
              child: Column(
                children: [
                  Text(
                    _isNext ? "Choose a Branch" : "Choose a business",
                    style: GoogleFonts.poppins(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                  Expanded(
                    child: _isNext
                        ? _buildBranchListView(model)
                        : _buildBusinessListView(model),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildBusinessListView(CoreViewModel model) {
    return ListView.builder(
      itemCount: _businesses.length,
      itemBuilder: (context, index) {
        Business business = _businesses[index];
        return ListTile(
          tileColor: Colors.white,
          contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          title: Text(
            business.name!,
            style: GoogleFonts.poppins(
              fontSize: 16.0,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),
          trailing: Checkbox(
            value: business.active, // Use the correct variable here
            onChanged: (value) async {
              await chooseBusiness(model, business);
            },
          ),
        );
      },
    );
  }

  Future<void> chooseBusiness(
    CoreViewModel model,
    Business selectedBusiness,
  ) async {
    model.setDefaultBusiness(business: selectedBusiness);
    ProxyService.box
        .writeString(key: 'bhfId', value: selectedBusiness.bhfId ?? "");
    ProxyService.box
        .writeInt(key: 'tin', value: selectedBusiness.tinNumber ?? 0);

    for (int i = 0; i < _businesses.length; i++) {
      Business currentBusiness = _businesses[i];

      _businesses[i] = Business.copy(
        currentBusiness,
        active: currentBusiness.id == selectedBusiness.id,
        name: currentBusiness.name,
        // Specify new values for additional properties if needed
        action: currentBusiness.action,
        encryptionKey: currentBusiness.encryptionKey,
      );

      ProxyService.isar.update(data: _businesses[i]);
    }

    await ProxyService.box
        .writeInt(key: "businessId", value: selectedBusiness.id!);
    await Future.delayed(Duration(seconds: 3));
    setState(() {
      _isNext = true;
    });
  }

  Widget _buildBranchListView(CoreViewModel model) {
    return ListView.builder(
      itemCount: model.branches.length,
      itemBuilder: (context, index) {
        Branch branch = model.branches[index];
        return ListTile(
          tileColor: Colors.white,
          contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          title: Text(
            branch.name!,
            style: TextStyle(fontSize: 17.0),
          ),
          trailing: Checkbox(
            value: branch.active, // Use the correct variable here
            onChanged: (value) async {
              await chooseBranch(model, branch);
            },
          ),
        );
      },
    );
  }

  Future<void> chooseBranch(
    CoreViewModel model,
    Branch branch,
  ) async {
    model.setDefaultBranch(branch: branch);

    for (int i = 0; i < model.branches.length; i++) {
      Branch currentBranch = model.branches[i];

      model.branches[i] = Branch.copy(
        currentBranch,
        active: currentBranch.id == branch.id,
        name: currentBranch.name,
      );

      ProxyService.isar.update(data: model.branches[i]);
    }

    ProxyService.box.writeBool(key: "authComplete", value: true);

    if (await ProxyService.isar
        .isDrawerOpen(cashierId: ProxyService.box.getBusinessId()!)) {
      _routerService.navigateTo(FlipperAppRoute());
    } else {
      Drawers drawer = Drawers(
        id: randomNumber(),
        openingBalance: 0.0,
        closingBalance: 0.0,
        cashierId: ProxyService.box.getBusinessId()!,
        tradeName: ProxyService.app.business!.name,
        openingDateTime: DateTime.now().toIso8601String(),
        open: true,
      );

      _routerService
          .navigateTo(DrawerScreenRoute(open: "open", drawer: drawer));
    }
  }
}
