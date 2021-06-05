import 'package:cron/cron.dart';

class ReportService {
  final cron = Cron();
  scheduleReport() {
    cron.schedule(Schedule.parse('30-50 * * * *'), () async {
      // print('every three minutes');
      // TODOget the sale done and send them on the server. for analytics!
    });
  }
}
