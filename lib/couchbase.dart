import 'dart:async';

import 'package:flipper/domain/redux/app_state.dart';
import 'package:flipper/model/branch.dart';
import 'package:flipper/model/business.dart';
import 'package:flutter/services.dart';
import 'package:fluttercouch/fluttercouch.dart';
import 'package:redux/redux.dart';
import 'package:scoped_model/scoped_model.dart';

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

  //create user
  createUser(Map map) {
    assert(map['last_name'] != null);
    assert(map['daily_target'] != null);
    assert(map['name'] != null);
    assert(map['last_name'] != null);
    assert(map['last_name'] != null);
    assert(map['weekly_target'] != null);
    assert(map['personalToken'] != null);
    assert(map['last_active'] != null);
    assert(map['email'] != null);
    map.forEach((k, v) {
      _doc.setString(k, v);
    });
    //this can be used for update.
    saveDocumentWithId(map['email'], _doc);
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

  //create business.
  createOrUpdateBusiness(Map map) {
    //todo: take existing list of business, then modify the business I want from a list
    //todo: then re-post it with the same key.
    //todo: get existing business add another one then save with same doc Id.
    assert(map['name'] != null);
    assert(map['userId'] != null);
    map.forEach((k, v) {
      _doc.setString(k, v);
    });
    //this can be used for update.
    saveDocumentWithId(map['email'], _doc);
  }

  //branches
  static createBranch(String name, int businessId) {}
  //return stream of branches
  static getBranches(int userId) {}

  initPlatformState() async {
    try {
      _databaseName = await initDatabaseWithName("lagrace");

      //todo: enable this sync replication when user has paid.
      setReplicatorEndpoint("ws://enexus.rw:4984/lagrace");
      setReplicatorType("PUSH_AND_PULL");
      setReplicatorBasicAuthentication(<String, String>{
        "username": "Administrator",
        "password": "password"
      });
      setReplicatorContinuous(true);
      initReplicator();
      startReplicator();

      notifyListeners();
      MutableDocument _doc = MutableDocument();
    } on PlatformException {}
  }

  //return
  Stream<dynamic> getDocumentByQuery(Store<AppState> store) async* {
    Query query = QueryBuilder.select([SelectResult.all()])
        .from(store.state.couchDbClient.name)
        .where(Expression.property("_id")
            .equalTo(Expression.string('businesses')));

    ResultSet results = await query.execute();

    yield results.allResults();
  }

  List<User> buildUserModel(Document doc) {
    List<User> users = [];
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

    for (var i = 0; i < doc.getList('businesses').length; i++) {
      business.add(Business((b) => b
        ..name = doc.getList('businesses')[i]['name']
        ..country = doc.getList('businesses')[i]['country']
        ..taxRate = doc.getList('businesses')[i]['taxRate']
        ..userId = doc.getList('businesses')[i]['userId']
        ..active = doc.getList('businesses')[i]['active']
        ..businessTypeId = doc.getList('businesses')[i]['businessTypeId']
        ..userId = doc.getList('businesses')[i]['userId']
        ..timeZone = doc.getList('businesses')[i]['timeZone']
        ..businessUrl = doc.getList('businesses')[i]['businessUrl']
        ..createdAt = doc.getList('businesses')[i]['country']));
    }
    return business;
  }

  List<Branch> buildBranchModel(Document doc) {
    List<Branch> branch = [];
    for (var i = 0; i < doc.getList('businesses').length; i++) {
      branch.add(
          //todo: update a branch full.
          Branch((b) => b
            ..name = doc.getList('branches')[i]['name']
            ..active = doc.getList('branches')[i]['active']
            ..businessId = doc.getList('branches')[i]['businessId']
            ..createdAt = doc.getList('branches')[i]['createdAt']
            ..mapLatitude = doc.getList('branches')[i]['mapLatitude']
            ..mapLongitude = doc.getList('branches')[i]['mapLongitude']
            ..mapLongitude = doc.getList('branches')[i]['mapLongitude']
            ..updatedAt = doc.getList('branches')[i]['updatedAt']));
    }
    return branch;
  }
}
