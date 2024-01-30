import 'package:flipper_models/isar/random.dart';
import 'package:flipper_models/isar_models.dart';
import 'package:flipper_models/view_models/gate.dart';
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
  bool _businessChosen = false;
  bool _businessCheckbox = false; // Separate variable for business ListView
  bool _branchCheckbox = false; // Separate variable for branch ListView

  final _routerService = locator<RouterService>();

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<CoreViewModel>.reactive(
      viewModelBuilder: () => CoreViewModel(),
      onViewModelReady: (model) async {
        List<Business> _b = await ProxyService.isar.businesses();
        List<Branch> branches = await ProxyService.isar.branches();
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
            value: _businessCheckbox, // Use the correct variable here
            onChanged: (value) async {
              await chooseBusiness(value, model, business);
            },
          ),
        );
      },
    );
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
            value: _branchCheckbox, // Use the correct variable here
            onChanged: (value) async {
              await chooseBranch(value, model, branch);
            },
          ),
        );
      },
    );
  }

  Future<void> chooseBusiness(
      bool? value,
      CoreViewModel model,
      Business business,
      ) async {
    _businessChosen = value!;
    if (_businessChosen) {
      model.setDefaultBusiness(business: business);
      print(business.id);

      List<Business> businesses = await ProxyService.isar.businesses();
      for(Business business in businesses){
        await ProxyService.isar.update(data: business..isDefault=false);
      }
      await ProxyService.isar.update(data: business..isDefault=true);
      setState(() {
        _isNext = true;
      });
    }
  }

  Future<void> chooseBranch(
      bool? value,
      CoreViewModel model,
      Branch branch,
      ) async {
    model.setDefaultBranch(branch: branch);

    List<Branch> branches = await ProxyService.isar.branches();
    for(Branch branch in branches){
      await ProxyService.isar.update(data: branch..isDefault=false);
    }
    await ProxyService.isar.update(data: branch..isDefault=true);

    ProxyService.box.writeBool(key: "authComplete", value: true);

    if (await ProxyService.isar
        .isDrawerOpen(cashierId: ProxyService.box.getBusinessId()!)) {
      Drawers drawer = Drawers(
        id: randomString(),
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
    LoginInfo().isLoggedIn = true;

    _routerService.navigateTo(FlipperAppRoute());
  }
}
