import 'package:flipper/data/business.dart';
import 'package:flipper/data/dao/UserBusiness.dart';
import 'package:flipper/data/main_database.dart';
import 'package:moor/moor.dart';

part 'business_dao.g.dart';

@UseDao(tables: [BusinessTable])
class BusinessDao extends DatabaseAccessor<Database> with _$BusinessDaoMixin {
  final Database db;

  BusinessDao(this.db) : super(db);

  Future insert(Insertable<BusinessTableData> business) =>
      into(db.businessTable).insert(business);

  Future assignBusinessToUser(Insertable<BusinessUserTableData> data) =>
      into(db.businessUserTable).insert(data);

  Future updateBusiness(BusinessTableData entry) {
    // using replace will update all fields from the entry that are not marked as a primary key.
    // it will also make sure that only the entry with the same primary key will be updated.
    // Here, this means that the row that has the same id as entry will be updated to reflect
    // the entry's title, content and category. As it set's its where clause automatically, it
    // can not be used together with where.
    return update(db.businessTable).replace(entry);
  }

  // Return BusinessAssociated to a user
  Stream<List<UserBusiness>> watchAllTasks() {
    // Wrap the whole select statement in parenthesis
    return (select(db.businessTable)
          // Statements like orderBy and where return void => the need to use a cascading '..' operator
          ..orderBy(
            ([
              // Primary sorting by due date
              (t) => OrderingTerm(expression: t.id, mode: OrderingMode.asc),
              // Secondary alphabetical sorting
              (t) => OrderingTerm(expression: t.id),
            ]),
          ))
        // As opposed to orderBy or where, join returns a value. This is what we want to watch/get.
        .join(
          [
            // Join all the tasks with their tags.
            // It's important that we use equalsExp and not just equals.
            // This way, we can join using all tag names in the tasks table, not just a specific one.
            leftOuterJoin(
                db.businessUserTable,
                db.businessUserTable.userId
                    .equalsExp(db.businessUserTable.businessId)),
          ],
        )
        // watch the whole select statement including the join
        .watch()
        // Watching a join gets us a Stream of List<TypedResult>
        // Mapping each List<TypedResult> emitted by the Stream to a List<UserBusiness>
        .map(
          (rows) => rows.map(
            (row) {
//          return UserBusiness(
//            business: row.readTable(db.businessTable),
//            user: row.readTable(db.userTable),
//          );
            },
          ).toList(),
        );
  }

  Future<BusinessTableData> getBusinesById({String id}) {
    return (select(db.businessTable)..where((t) => t.id.equals(id)))
        .getSingle();
  }

  Future<List<BusinessTableData>> getBusinesses() =>
      select(db.businessTable).get();

  Future<BusinessTableData> getActiveBusiness() {
    return (select(db.businessTable)
          ..orderBy(
              [(t) => OrderingTerm(expression: t.id, mode: OrderingMode.desc)])
          ..where((t) => t.active.equals(true))
          ..limit(1))
        .getSingle();
  }
}
