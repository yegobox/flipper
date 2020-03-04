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
    }
  }

  //create a branch
  Future<dynamic> createBranch(Map map) async {
    assert(map['_id'] != null);
    assert(map['name'] != null);
    assert(map['active'] != null);
    assert(map['businessId'] != null);
    assert(map['mapLatitude'] != null);
    assert(map['mapLongitude'] != null);
    assert(map['id'] != null);
    assert(map['updatedAt'] != null);
    assert(map['createdAt'] != null);
    assert(map['_id'] != null);

    Document doc = await getDocumentWithId(map['_id']);

    List m = [map];

    doc.toMutable().setList(map['_id'], m).setString('uid', Uuid().v1());
    return await saveDocumentWithId(map['_id'], doc);
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
    assert(map['timeZone'] != null);
    assert(map['createdAt'] != null);
    assert(map['updatedAt'] != null);
    assert(map['userId'] != null);

    List m = [map];
    doc.toMutable().setList(map['_id'], m);
    return await saveDocumentWithId(map['_id'], doc);
  }

  //create user
  Future<dynamic> createUser(Map map) async {
    assert(map['_id'] != null);

    assert(map['name'] != null);
    assert(map['token'] != null);
    assert(map['id'] != null);
    assert(map['active'] != null);
    assert(map['email'] != null);
    assert(map['channel'] != null);
    assert(map['createdAt'] != null);
    assert(map['updatedAt'] != null);

    Document doc = await getDocumentWithId(map['_id']);

    if (doc.toMutable().getString('email') != null) {
      MutableDocument mutableDocument = doc.toMutable();

      map.forEach((key, value) {
        if (value is int) {
          mutableDocument.setInt(key, value);
        }
        if (value is String) {
          mutableDocument.setString(key, value);
        }
        if (value is bool) {
          mutableDocument.setBoolean(key, value);
        }
        if (value is double) {
          mutableDocument.setDouble(key, value);
        }
      });
      return await saveDocumentWithId(map['_id'], mutableDocument);
    } else {
      _doc.setString('_id', map['_id']);
      _doc.setString('uid', Uuid().v1());
      map.forEach((key, value) {
        if (value is int) {
          _doc.setInt(key, value);
        }
        if (value is String) {
          _doc.setString(key, value);
        }
        if (value is bool) {
          _doc.setBoolean(key, value);
        }
        if (value is double) {
          _doc.setDouble(key, value);
        }
      });
      return await saveDocumentWithId(map['_id'], _doc);
    }
  }

  //sampleCode
  // CouchBase(shouldInitDb: false).getDocument(docId:'richie')
  Future<dynamic> getDocumentByDocId(
      {String docId, Store<AppState> store, T}) async {
    Document doc = await getDocumentWithId(docId);

    switch (T.toString()) {
      case 'User':
        {
          return buildUserModel(doc, store);
        }
        break;

      case 'Business':
        {
          return buildBusinessModel(doc, store);
        }
      case 'Branch':
        {
          return buildBranchModel(doc, store);
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

      //this is the way of getting notified about db change. adding a live query
      //https://docs.couchbase.com/couchbase-lite/2.5/java.html#live-query
      Query query = QueryBuilder.select([SelectResult.all()]).from("lagrace");

      ListenerToken token =
          await query.addChangeListener((change) => {print(change)});

      //call this on logout.
//      query.removeChangeListener(token);

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

  User buildUserModel(Document doc, Store<AppState> store) {
    return User(
      (u) => u
        ..id = doc.getString('id')
        ..email = doc.getString('email')
        ..name = doc.getString('name')
        ..createdAt = doc.getString('createdAt')
        ..updatedAt = doc.getString('createdAt')
        ..active = doc.getBoolean('active')
        ..token = doc.getString('token'),
    );
  }

  List<Business> buildBusinessModel(Document doc, Store<AppState> store) {
    List<Business> business = [];
    var business_ = 'business_' + store.state.userId.toString();
    if (doc.getList(business_) == null) return business;
    for (var i = 0; i < doc.getList(business_).length; i++) {
      business.add(Business((b) => b
        ..name = doc.getList(business_)[i]['name']
        ..country = doc.getList(business_)[i]['country']
        ..taxRate = doc.getList(business_)[i]['taxRate']
        ..userId = doc.getList(business_)[i]['userId'].toString()
        ..active = doc.getList(business_)[i]['active']
        ..businessTypeId = doc.getList(business_)[i]['businessTypeId']
        ..userId = doc.getList(business_)[i]['userId'].toString()
        ..timeZone = doc.getList(business_)[i]['timeZone']
        ..businessUrl = doc.getList(business_)[i]['businessUrl']
        ..createdAt = doc.getList(business_)[i]['country']));
    }
    return business;
  }

  List<Branch> buildBranchModel(Document doc, Store<AppState> store) {
    List<Branch> branch = [];
    var branch_ = 'branch_' + store.state.userId.toString();

    if (doc.getList(branch_) == null) return branch;
    for (var i = 0;
        i < doc.getList('branch_' + store.state.userId.toString()).length;
        i++) {
      branch.add(Branch((b) => b
        ..name = doc.getList(branch_)[i]['name']
        ..id = doc.getList(branch_)[i]['id']
        ..active = doc.getList(branch_)[i]['active']
        ..businessId = doc
            .getList(branch_)[i]['businessId']
            .toString() //todo: remove toString() when desktop set it as string
        ..createdAt = doc.getList(branch_)[i]['createdAt']
        ..mapLatitude = doc
            .getList(branch_)[i]['mapLatitude']
            .toString() //todo:remove casting
        ..mapLongitude = doc.getList(branch_)[i]['mapLongitude'].toString()
        ..mapLongitude = doc.getList(branch_)[i]['mapLongitude'].toString()
        ..updatedAt = doc.getList(branch_)[i]['updatedAt']));
    }
    return branch;
  }
}
