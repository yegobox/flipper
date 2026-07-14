import 'dart:async';
import 'dart:isolate';

import 'package:turso_dart/src/config.dart' as turso;
import 'package:turso_dart/src/connect.dart' as turso;
import 'package:turso_dart/src/connection.dart' as turso;
import 'package:turso_dart/src/database.dart' as turso;
import 'package:turso_dart/src/params.dart' as turso;
import 'package:turso_dart/src/statement.dart' as turso;
import 'package:turso_dart/src/transaction.dart' as turso;

export 'package:turso_dart/turso_dart.dart'
    show LocalDbConfig, Params, SyncDbConfig, TransactionBehavior;

Future<Database> connect(turso.LocalDbConfig config) async {
  return _initIsolate((reply) => _InitLocalCmd(reply, config));
}

Future<Database> connectSync(turso.SyncDbConfig config) async {
  return _initIsolate((reply) => _InitSyncCmd(reply, config));
}

Future<Database> _initIsolate(_IsolateCmd Function(SendPort) cmd) async {
  final initPort = ReceivePort();
  await Isolate.spawn(_tursoWorkerIsolate, initPort.sendPort);

  final commandPort = await initPort.first as SendPort;
  final db = Database._(commandPort);

  await db._sendCmd((port) => cmd(port));
  return db;
}

mixin _Sender {
  late SendPort _commandPort;

  Future<T> _sendCmd<T extends Object>(
    _IsolateCmd Function(SendPort) cmdBuilder,
  ) async {
    final port = ReceivePort();
    _commandPort.send(cmdBuilder(port.sendPort));
    final result = await port.first;
    if (result is Exception) throw result;
    return result as T;
  }
}

class Database with _Sender {
  Database._(SendPort port) {
    _commandPort = port;
  }

  Future<Connection> connect() async {
    await _sendCmd(_DbConnectCmd.new);
    return Connection._(_commandPort);
  }

  Future<bool> pull() => _sendCmd(_DbPullCmd.new);
  Future<void> push() => _sendCmd(_DbPushCmd.new);
}

class Connection with _Sender {
  Connection._(SendPort port) {
    _commandPort = port;
  }

  Future<List<Map<String, dynamic>>> query(
    String sql, {
    turso.Params? params,
  }) => _sendCmd((port) => _ConnQueryCmd(port, sql, params));

  Future<void> execute(String sql, {turso.Params? params}) =>
      _sendCmd((port) => _ConnExecuteCmd(port, sql, params));

  Future<Statement> prepare(String sql) async {
    final stmtId = await _sendCmd<int>((port) => _ConnPrepareCmd(port, sql));
    return Statement._(_commandPort, stmtId);
  }

  Future<Transaction> transaction({
    turso.TransactionBehavior behavior = turso.TransactionBehavior.deferred,
  }) async {
    final txId = await _sendCmd<int>((port) => _ConnTxCmd(port, behavior));
    return Transaction._(_commandPort, txId);
  }
}

class Statement with _Sender {
  Statement._(SendPort port, this._stmtId) {
    _commandPort = port;
  }
  final int _stmtId;
  bool _isDisposed = false;

  Future<List<Map<String, dynamic>>> query({turso.Params? params}) {
    if (_isDisposed) throw Exception('Statement disposed');
    return _sendCmd((port) => _StmtQueryCmd(port, _stmtId, params));
  }

  Future<void> execute({turso.Params? params}) {
    if (_isDisposed) throw Exception('Statement disposed');
    return _sendCmd((port) => _StmtExecuteCmd(port, _stmtId, params));
  }

  Future<void> dispose() async {
    if (_isDisposed) return;
    _isDisposed = true;
    await _sendCmd((port) => _StmtDisposeCmd(port, _stmtId));
  }
}

class Transaction with _Sender {
  Transaction._(SendPort port, this._txId) {
    _commandPort = port;
  }
  final int _txId;
  bool _isFinished = false;

  Future<Statement> prepare(String sql) async {
    if (_isFinished) throw Exception('Transaction finished');
    final stmtId = await _sendCmd<int>(
      (port) => _TxPrepareCmd(port, _txId, sql),
    );
    return Statement._(_commandPort, stmtId);
  }

  Future<void> commit() async {
    if (_isFinished) return;
    _isFinished = true;
    await _sendCmd((port) => _TxCommitCmd(port, _txId));
  }

  Future<void> rollback() async {
    if (_isFinished) return;
    _isFinished = true;
    await _sendCmd((port) => _TxRollbackCmd(port, _txId));
  }
}

sealed class _IsolateCmd {
  SendPort get replyPort;
}

class _InitLocalCmd implements _IsolateCmd {
  _InitLocalCmd(this.replyPort, this.config);
  @override
  final SendPort replyPort;
  final turso.LocalDbConfig config;
}

class _InitSyncCmd implements _IsolateCmd {
  _InitSyncCmd(this.replyPort, this.config);
  @override
  final SendPort replyPort;
  final turso.SyncDbConfig config;
}

class _DbConnectCmd implements _IsolateCmd {
  _DbConnectCmd(this.replyPort);
  @override
  final SendPort replyPort;
}

class _DbPullCmd implements _IsolateCmd {
  _DbPullCmd(this.replyPort);
  @override
  final SendPort replyPort;
}

class _DbPushCmd implements _IsolateCmd {
  _DbPushCmd(this.replyPort);
  @override
  final SendPort replyPort;
}

class _ConnQueryCmd implements _IsolateCmd {
  _ConnQueryCmd(this.replyPort, this.sql, this.params);
  @override
  final SendPort replyPort;
  final String sql;
  final turso.Params? params;
}

class _ConnExecuteCmd implements _IsolateCmd {
  _ConnExecuteCmd(this.replyPort, this.sql, this.params);
  @override
  final SendPort replyPort;
  final String sql;
  final turso.Params? params;
}

class _ConnPrepareCmd implements _IsolateCmd {
  _ConnPrepareCmd(this.replyPort, this.sql);
  @override
  final SendPort replyPort;
  final String sql;
}

class _ConnTxCmd implements _IsolateCmd {
  _ConnTxCmd(this.replyPort, this.behavior);
  @override
  final SendPort replyPort;
  final turso.TransactionBehavior behavior;
}

class _StmtQueryCmd implements _IsolateCmd {
  _StmtQueryCmd(this.replyPort, this.stmtId, this.params);
  @override
  final SendPort replyPort;
  final int stmtId;
  final turso.Params? params;
}

class _StmtExecuteCmd implements _IsolateCmd {
  _StmtExecuteCmd(this.replyPort, this.stmtId, this.params);
  @override
  final SendPort replyPort;
  final int stmtId;
  final turso.Params? params;
}

class _StmtDisposeCmd implements _IsolateCmd {
  _StmtDisposeCmd(this.replyPort, this.stmtId);
  @override
  final SendPort replyPort;
  final int stmtId;
}

class _TxPrepareCmd implements _IsolateCmd {
  _TxPrepareCmd(this.replyPort, this.txId, this.sql);
  @override
  final SendPort replyPort;
  final int txId;
  final String sql;
}

class _TxCommitCmd implements _IsolateCmd {
  _TxCommitCmd(this.replyPort, this.txId);
  @override
  final SendPort replyPort;
  final int txId;
}

class _TxRollbackCmd implements _IsolateCmd {
  _TxRollbackCmd(this.replyPort, this.txId);
  @override
  final SendPort replyPort;
  final int txId;
}

void _tursoWorkerIsolate(SendPort initReplyPort) {
  final commandPort = ReceivePort();
  initReplyPort.send(commandPort.sendPort);

  turso.Database? db;
  turso.Connection? conn;

  var nextId = 1;
  final statements = <int, turso.Statement>{};
  final transactions = <int, turso.Transaction>{};

  commandPort.listen((message) {
    if (message is! _IsolateCmd) return;
    final reply = message.replyPort;

    try {
      switch (message) {
        case final _InitLocalCmd cmd:
          db = turso.connect(cmd.config);
          reply.send(true);
        case final _InitSyncCmd cmd:
          db = turso.connectSync(cmd.config);
          reply.send(true);
        case _DbConnectCmd _:
          conn = db!.connect();
          reply.send(true);
        case _DbPullCmd _:
          reply.send(db!.pull());
        case _DbPushCmd _:
          db!.push();
          reply.send(true);

        case final _ConnQueryCmd cmd:
          reply.send(conn!.query(cmd.sql, params: cmd.params));
        case final _ConnExecuteCmd cmd:
          conn!.execute(cmd.sql, params: cmd.params);
          reply.send(true);
        case final _ConnPrepareCmd cmd:
          final id = nextId++;
          statements[id] = conn!.prepare(cmd.sql);
          reply.send(id);
        case final _ConnTxCmd cmd:
          final id = nextId++;
          transactions[id] = conn!.transaction(behavior: cmd.behavior);
          reply.send(id);

        case final _StmtQueryCmd cmd:
          reply.send(statements[cmd.stmtId]!.query(params: cmd.params));
        case final _StmtExecuteCmd cmd:
          statements[cmd.stmtId]!.execute(params: cmd.params);
          reply.send(true);
        case final _StmtDisposeCmd cmd:
          statements.remove(cmd.stmtId);
          reply.send(true);

        case final _TxPrepareCmd cmd:
          final id = nextId++;
          statements[id] = transactions[cmd.txId]!.prepare(cmd.sql);
          reply.send(id);
        case final _TxCommitCmd cmd:
          transactions.remove(cmd.txId)?.commit();
          reply.send(true);
        case final _TxRollbackCmd cmd:
          transactions.remove(cmd.txId)?.rollback();
          reply.send(true);
      }
    } on Exception catch (e) {
      reply.send(Exception(e.toString()));
    }
  });
}
