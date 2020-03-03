import 'dart:async';

import 'package:flipper/domain/redux/app_state.dart';
import 'package:flipper/model/branch.dart';
import 'package:flipper/model/business.dart';
import 'package:flutter/services.dart';
import 'package:fluttercouch/fluttercouch.dart';
import 'package:redux/redux.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:uuid/uuid.dart';

import 'model/user.dart';

class CouchBase extends Model with Fluttercouch {
  String _databaseName;
  Document docExample;
  MutableDocument _doc = MutableDocument();
  Query query;
  final bool shouldInitDb;

  CouchBase({this.shouldInitDb}) {
    if (shouldInitDb) {
      initPlatformState();
    } else {
      //no need
      print('none');
    }
  }

  //create a branch
  Future<dynamic> createBranch(Map map) async {
    assert(map['_id'] != null);
    Document doc = await getDocumentWithId(map['_id']);
    assert(map['name'] != null);
    assert(map['active'] != null);
    assert(map['businessId'] != null);
    assert(map['mapLatitude'] != null);
    assert(map['mapLongitude'] != null);
    assert(map['id'] != null);
    assert(map['updatedAt'] != null);
    assert(map['createdAt'] != null);
    assert(map['userId'] != null);
    assert(map['_id'] != null);

    if (doc.getList(map['_id']) == null) {
      List m = [map];
      _doc.setString('uid', Uuid().v1());
      _doc.setList(map['_id'], m);
      return saveDocumentWithId(map['_id'], _doc);
    } else {
      List list = doc.getList(map['_id']);

      list.add(map);
      _doc.setString('uid', Uuid().v1());
      _doc.setList(map['_id'], list);
      return await saveDocumentWithId(map['_id'], _doc);
    }
  }

  //create business.
  Future<dynamic> createBusiness(Map map) async {
    assert(map['_id'] != null);
    Document doc = await getDocumentWithId(map['_id']);
    assert(map['name'] != null);
    assert(map['active'] != null);
    assert(map['businessCategoryId'] != null);
    assert(map['businessTypeId'] != null);
    assert(map['businessUrl'] != null);
    assert(map['country'] != null);
    assert(map['currency'] != null);
    assert(map['id'] != null);
    assert(map['taxRate'] != null);
    assert(map['timeZone'] != null);
    assert(map['createdAt'] != null);
    assert(map['updatedAt'] != null);
    assert(map['userId'] != null);

    if (doc.getList(map['_id']) == null) {
      List m = [map];
      _doc.setString('uid', Uuid().v1());
      _doc.setList(map['_id'], m);
      return await saveDocumentWithId(map['_id'], _doc);
    } else {
      List list = doc.getList(map['_id']);
      list.add(map);
      _doc.setString('uid', Uuid().v1());
      _doc.setList(map['_id'], list);
      return await saveDocumentWithId(map['_id'], _doc);
    }
  }

  //create user
  Future<dynamic> createUser(Map map) async {
    assert(map['_id'] != null);
    Document doc = await getDocumentWithId(map['_id']);

    assert(map['name'] != null);
    assert(map['role'] != null);
    assert(map['permissions'] != null);
    assert(map['token'] != null);
    assert(map['id'] != null);
    assert(map['active'] != null);
    assert(map['email'] != null);
    assert(map['createdAt'] != null);
    assert(map['updatedAt'] != null);

    if (doc.getList(map['_id']) == null) {
      //create it
      List m = [map];
      _doc.setString('_id', map['_id']);
      _doc.setString('uid', Uuid().v1());
      _doc.setList(map['_id'], m);
      return await saveDocumentWithId(map['_id'], _doc);
    } else {
      //todo: what happen if desktop first initiated all users, and there is some I created
      //todo: here? how will data merge?
      //todo: testing scenario:
      //todo:1. create document offline no internet on mobile
      //todo:2. let other side create same document with more data than I
      //todo:3. turn on internet see how my data merge with the other side.
      //add to existing document do not overwrite anything.
      List list = doc.getList(map['_id']);
      print(doc.toMap());
      print(doc.getString('_rev'));
      list.add(map);
      _doc.setString('_id', map['_id']);
      _doc.setString('uid', Uuid().v1());
      _doc.setList(map['_id'], list);
      //should pass a rev to update.

      return await saveDocumentWithId(map['_id'], _doc);
    }
  }

  //sampleCode
  // CouchBase(shouldInitDb: false).getDocument(docId:'richie')
  Future<dynamic> getDocumentByDocId({String docId, T}) async {
    Document doc = await getDocumentWithId(docId);

    switch (T.toString()) {
      case 'User':
        {
          return buildUserModel(doc);
        }
        break;

      case 'Business':
        {
          return buildBusinessModel(doc);
        }
      case 'Branch':
        {
          return buildBranchModel(doc);
        }
        break;

      default:
        return null;
        break;
    }
  }

  //validation methods (business name will be docId)
  Future<bool> docExist(String docId) async {
    var doc = await getDocumentWithId(docId);
    if (doc == null) {
      return false;
    }
    return true;
  }

  //return stream of branches
  static getBranches(int userId) {}

  initPlatformState() async {
    try {
      await initDatabaseWithName("lagrace");
      //todo: enable this sync replication when user has paid.
      setReplicatorEndpoint(
          "ws://enexus.rw:4984/lagrace"); //todo: move this to credential file to avoid security breach
      setReplicatorType("PUSH_AND_PULL");
      setReplicatorBasicAuthentication(<String, String>{
        "username":
            "Administrator", //todo: move this to credential file to avoid security breach
        "password":
            "password" //todo: move this to credential file to avoid security breach
      });
      setConflictResolver('localWin');
      //todo: discuss more on setting the channel with ganza.
//      Map channels = {"name": "lagrace"};
//      setReplicationChannel(channels);
      setReplicatorContinuous(true);
      initReplicator();
      startReplicator();
    } on PlatformException {}
  }

  //return
  Stream<dynamic> getDocumentByQuery(Store<AppState> store) async* {
    Query query = QueryBuilder.select([SelectResult.all()])
        .from(store.state.couchDbClient.name)
        .where(Expression.property("_id")
            .equalTo(Expression.string('businesses')));

    ResultSet results = await query.execute();
    query.addChangeListener((change) => {
          // if(change.results != null)
          //   {
          print(change.results)
          //resultsCallback(change.results);
          // }
        });

    yield results.allResults();
  }

  Future<dynamic> queryEmail(Store<AppState> store, String email) async {
    Query query = QueryBuilder.select([SelectResult.all()])
        .from(store.state.couchDbClient.name)
        .where(Expression.property("_id").equalTo(Expression.string('users')));

    ResultSet results = await query.execute();
  }

  List<User> buildUserModel(Document doc) {
    List<User> users = [];
    if (doc.getList('users') == null) return users;
    for (var i = 0; i < doc.getList('users').length; i++) {
      users.add(User(
        (u) => u
          ..email = doc.getList('users')[i]['email']
          ..name = doc.getList('users')[i]['name']
          ..role = doc.getList('users')[i]['role']
          ..permissions = doc.getList('users')[i]['permissions']
          ..createdAt = doc.getList('users')[i]['createdAt']
          ..updatedAt = doc.getList('users')[i]['updatedAt']
          ..active = doc.getList('users')[i]['active']
          ..token = doc.getList('users')[i]['token'],
      ));
    }
    return users;
  }

  List<Business> buildBusinessModel(Document doc) {
    List<Business> business = [];
    if (doc.getList('businesses') == null) return business;
    for (var i = 0; i < doc.getList('businesses').length; i++) {
      business.add(Business((b) => b
        ..name = doc.getList('businesses')[i]['name']
        ..country = doc.getList('businesses')[i]['country']
        ..taxRate = doc.getList('businesses')[i]['taxRate']
        ..userId = doc.getList('businesses')[i]['userId'].toString()
        ..active = doc.getList('businesses')[i]['active']
        ..businessTypeId = doc.getList('businesses')[i]['businessTypeId']
        ..userId = doc.getList('businesses')[i]['userId'].toString()
        ..timeZone = doc.getList('businesses')[i]['timeZone']
        ..businessUrl = doc.getList('businesses')[i]['businessUrl']
        ..createdAt = doc.getList('businesses')[i]['country']));
    }
    return business;
  }

  List<Branch> buildBranchModel(Document doc) {
    List<Branch> branch = [];
    if (doc.getList('branches') == null) return branch;
    for (var i = 0; i < doc.getList('branches').length; i++) {
      branch.add(Branch((b) => b
        ..name = doc.getList('branches')[i]['name']
        ..active = doc.getList('branches')[i]['active']
        ..businessId = doc
            .getList('branches')[i]['businessId']
            .toString() //todo: remove toString() when desktop set it as string
        ..createdAt = doc.getList('branches')[i]['createdAt']
        ..mapLatitude = doc
            .getList('branches')[i]['mapLatitude']
            .toString() //todo:remove casting
        ..mapLongitude = doc.getList('branches')[i]['mapLongitude'].toString()
        ..mapLongitude = doc.getList('branches')[i]['mapLongitude'].toString()
        ..updatedAt = doc.getList('branches')[i]['updatedAt']));
    }
    return branch;
  }
}
