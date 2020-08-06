import 'package:flipper/data/business.dart';
import 'package:flipper/data/user.dart';
import 'package:flutter/cupertino.dart';

class UserBusiness {
  final BusinessTable business;
  final UserTable user;

  UserBusiness({
    @required this.business,
    @required this.user,
  });
}
