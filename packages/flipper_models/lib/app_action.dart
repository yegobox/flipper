library flipper_models;

import 'package:built_value/built_value.dart';

part 'app_action.g.dart';

abstract class AppActions implements Built<AppActions, AppActionsBuilder> {
  @nullable
  String get name;

  AppActions._();
  factory AppActions([void Function(AppActionsBuilder) updates]) = _$AppActions;
}
