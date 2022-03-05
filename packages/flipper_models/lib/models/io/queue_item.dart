import 'package:objectbox/objectbox.dart';

@Entity()
class QueueItem {
  QueueItem({this.id = 0});

  int id;
}
