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
  bool _businessChoosen = false;
  final bool _chooseBranch = false;
  final _routerService = locator<RouterService>();

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<BusinessHomeViewModel>.reactive(
        viewModelBuilder: () => BusinessHomeViewModel(),
        onViewModelReady: (model) async {
          int? userId = ProxyService.box.getUserId();
          List<Business> _b =
              await ProxyService.isar.businesses(userId: userId!);
          if (_b.isEmpty) {
            await ProxyService.isar.logOut();
            _routerService.clearStackAndShow(LoginViewRoute());
          }

          setState(() {
            _businesses = _b;
          });
        },
        builder: (context, model, child) {
          return Scaffold(
            body: SafeArea(
              child: Padding(
                  padding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * 0.1),
                  child: !_isNext
                      ? Column(
                          children: [
                            Text(
                              _isNext ? "Choose a Branch" : "Choose a business",
                              style: GoogleFonts.poppins(
                                fontSize: 16.0,
                                fontWeight: FontWeight.w500,
                                color: Colors.black,
                              ),
                            ),
                            ListView(
                              shrinkWrap: true,
                              children: _businesses
                                  .map((e) => Card(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(0.0),
                                        ),
                                        margin: const EdgeInsets.fromLTRB(
                                            8.0, 20, 8, 0),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: <Widget>[
                                                Text(
                                                  e.name!,
                                                  style: GoogleFonts.poppins(
                                                    fontSize: 16.0,
                                                    fontWeight: FontWeight.w500,
                                                    color: Colors.black,
                                                  ),
                                                ), //Text

                                                Checkbox(
                                                  value: _chooseBranch,
                                                  onChanged: (value) async {
                                                    await chooseBusiness(
                                                        value, model, e);
                                                  },
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ))
                                  .toList(),
                            )
                          ],
                        )
                      : Column(
                          children: [
                            const Text("Choose a branch"),
                            ListView(
                                shrinkWrap: true,
                                children: model.branches
                                    .map((e) => Card(
                                          margin: const EdgeInsets.fromLTRB(
                                              120.0, 20, 120, 0),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceAround,
                                                children: <Widget>[
                                                  Text(
                                                    e.name!,
                                                    style: const TextStyle(
                                                        fontSize: 17.0),
                                                  ), //Text

                                                  Checkbox(
                                                    value: _chooseBranch,
                                                    onChanged: (value) async {
                                                      await chooseBranch(
                                                          value, model, e);
                                                    },
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ))
                                    .toList()),
                          ],
                        )),
            ),
          );
        });
  }

  Future<void> chooseBusiness(
      bool? value, BusinessHomeViewModel model, Business business) async {
    _businessChoosen = value!;
    if (_businessChoosen) {
      model.setDefaultBusiness(business: business);
      print(business.id);

      model.branchesList(
          await ProxyService.isar.branches(businessId: business.id!));
      List<ITenant> tenants =
          await ProxyService.isar.tenants(businessId: business.id!);
      if (tenants.isEmpty) {
        await ProxyService.isar.tenantsFromOnline(businessId: business.id!);
      }
      await model.app.loadCounters(business);
      setState(() {
        _isNext = true;
      });
    }
  }

  Future<void> chooseBranch(
      bool? value, BusinessHomeViewModel model, Branch branch) async {
    model.setDefaultBranch(branch: branch);
    if (await ProxyService.isar
            .isDrawerOpen(cashierId: ProxyService.box.getBusinessId()!) ==
        null) {
      _routerService.navigateTo(DrawerScreenRoute(open: "open"));
    }
    LoginInfo().isLoggedIn = true;

    _routerService.navigateTo(FlipperAppRoute());
  }
}
