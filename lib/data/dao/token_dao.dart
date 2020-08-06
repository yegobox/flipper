import 'package:flipper/data/main_database.dart';
import 'package:flipper/data/token.dart';
import 'package:moor/moor.dart';

part 'token_dao.g.dart';

@UseDao(tables: [TokenTable])
class TokenDao extends DatabaseAccessor<Database> with _$TokenDaoMixin {
  final Database db;
  TokenDao(this.db) : super(db);
  Future insertToken(Insertable<TokenTableData> token) =>
      into(db.tokenTable).insert(token);
  Future<List<TokenTableData>> getToken() {
    return (select(db.tokenTable)).get();
  }
}
