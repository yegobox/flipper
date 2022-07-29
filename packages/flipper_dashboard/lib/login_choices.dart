import 'package:flipper_models/isar_models.dart';
import 'package:flipper_models/view_models/gate.dart';
import 'package:flipper_routing/routes.router.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:stacked/stacked.dart';

class LoginChoices extends StatefulWidget {
  const LoginChoices({Key? key}) : super(key: key);

  @override
  State<LoginChoices> createState() => _LoginChoicesState();
}

class _LoginChoicesState extends State<LoginChoices> {
  List<Business> _businesses = [];
  late List<Branch> _branches = [];
  bool _isNext = false;
  bool _businessChoosen = false;
  final bool _chooseBranch = false;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<BusinessHomeViewModel>.reactive(
        viewModelBuilder: () => BusinessHomeViewModel(),
        onModelReady: (model) async {
          String? userId = ProxyService.box.getUserId();
          List<Business> _b =
              await ProxyService.isarApi.businesses(userId: userId!);
          setState(() {
            _businesses = _b;
          });
        },
        builder: (context, model, child) {
          return Scaffold(
            body: SafeArea(
              child: Center(
                  child: !_isNext
                      ? Column(
                          children: [
                            Text(_isNext
                                ? "Choose a Branch"
                                : "Choose a business"),
                            ListView(
                              shrinkWrap: true,
                              children: _businesses
                                  .map((e) => Card(
                                        margin: const EdgeInsets.fromLTRB(
                                          8.0,
                                          20,
                                          8,
                                          0,
                                        ),
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
                                                  style: const TextStyle(
                                                      fontSize: 17.0),
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
                                children: _branches
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
                                                      await chooseBranch(value,
                                                          model, e, context);
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
      bool? value, BusinessHomeViewModel model, Business e) async {
    _businessChoosen = value!;
    if (_businessChoosen) {
      model.setDefaultBusiness(business: e);
      _branches = await ProxyService.isarApi.branches(businessId: e.id!);
      await ProxyService.isarApi.tenantsFromOnline(businessId: e.id!);
      await model.app.loadCounters(e);
      setState(() {
        _isNext = true;
      });
    }
  }

  Future<void> chooseBranch(bool? value, BusinessHomeViewModel model,
      Branch branch, BuildContext context) async {
    model.setDefaultBranch(branch: branch);
    if (await ProxyService.isarApi
            .isDrawerOpen(cashierId: ProxyService.box.getBusinessId()!) ==
        null) {
      GoRouter.of(context).push("/drawer/open");
    }
    loginInfo.isLoggedIn = true;

    GoRouter.of(context).push(Routes.home);
  }
}
