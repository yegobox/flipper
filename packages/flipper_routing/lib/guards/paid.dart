import 'package:auto_route/auto_route.dart';
// import 'package:flipper_routing/routes.router.dart';

// import 'package:flipper_dashboard/add_discount.dart';
class CheckPayment extends AutoRouteGuard {
  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) {
    if (1 == 1) {
      resolver.next(true);
    } else {
      // router.push(Routes.home);
      //  router.push(LoginRoute(onResult: (success){
      //           // if success == true the navigation will be resumed
      //           // else it will be aborted
      //          resolver.next(success);
      //     }));
    }
  }
}
