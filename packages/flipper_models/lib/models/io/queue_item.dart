import 'package:objectbox/objectbox.dart';

@Entity()
class QueueItem {
  QueueItem({this.id = 0});
  @Id(assignable: true)
  int id;
}
