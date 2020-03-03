import 'package:flipper/data/main_database.dart';
import 'package:flipper/data/user.dart';
import 'package:moor/moor.dart';

part 'user_dao.g.dart';

@UseDao(tables: [UserTable])
class UserDao extends DatabaseAccessor<Database> with _$UserDaoMixin {
  final Database db;

  UserDao(this.db) : super(db);

  Future insertUser(Insertable<UserTableData> user) =>
      into(db.userTable).insert(user);

  Future updateUser(UserTableData entry) {
    return update(db.userTable).replace(entry);
  }

  Future<UserTableData> getUser() {
    return (select(db.userTable)
          ..orderBy(
              [(t) => OrderingTerm(expression: t.id, mode: OrderingMode.desc)])
          ..limit(1))
        .getSingle();
  }
}
