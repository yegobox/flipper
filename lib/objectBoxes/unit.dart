import 'package:objectbox/objectbox.dart';

@Entity()
class Note {
  // Each "Entity" needs a unique integer ID property.
  // Add `@Id()` annotation if its name isn't "id" (case insensitive).
  int id = 0;

  String? text;

  DateTime date;

  @Transient() // Make this field ignored, not stored in the database.
  int? notPersisted;

  // An empty default constructor is needed but you can use optional args.
  Note({this.text, DateTime? date}) : date = date ?? DateTime.now();

  // Note: just for logs in the examples below(), not needed by ObjectBox.
  // toString() => 'Note{id: $id, text: $text}';
}
