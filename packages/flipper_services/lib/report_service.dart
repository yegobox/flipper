import 'package:cron/cron.dart';
import 'package:flipper_models/order.dart';
import 'package:flipper_services/constants.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flipper_routing/routes.logger.dart';

class ReportService {
  final cron = Cron();
  final log = getLogger('flipper.services.report');

  /// This is the report mainly for yegobox|flipper business
  /// the report shall help the company know what customers are selling
  /// when they are selling the item and to him plus any other relevant information
  /// that can help sales team to develop product and increase sales
  void companyWideReport() {}

  /// this report should be sent to a customer given email.
  /// for a daly report, should create a spreadsheet tab naming it with the date of the report
  /// when a customer update the email, it should trigger the server(us) to create a new google sheet document
  /// and add it to the setting modal of the client,then on report generation the same document should be used
  /// so the document will be share do the user's email.
  /// check the user has spreadsheet document assigned, a log out and log in can assist
  /// since we update the business permissions and everytime a login happen we update business model from the server

  void customerBasedReport() {
    //TODOcheck if the user has email' in his settings
  }
  schedule() {
    cron.schedule(Schedule.parse('1-5 * * * *'), () async {
      log.i('raport scheduled..');
      //TODO: load the sales report and sump them to api which will also dump them in shared customer sheets
      //look where we have order is completed from the db
      List<OrderF> completed_orders =
          await ProxyService.api.getOrderByStatus(status: completeStatus);
      //send http request with json as body to the api
    });
  }
}
