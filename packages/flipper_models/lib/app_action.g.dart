// GENERATED CODE - DO NOT MODIFY BY HAND

part of flipper_models;

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AppActions extends AppActions {
  @override
  final String name;

  factory _$AppActions([void Function(AppActionsBuilder) updates]) =>
      (new AppActionsBuilder()..update(updates)).build();

  _$AppActions._({this.name}) : super._();

  @override
  AppActions rebuild(void Function(AppActionsBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AppActionsBuilder toBuilder() => new AppActionsBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AppActions && name == other.name;
  }

  @override
  int get hashCode {
    return $jf($jc(0, name.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('AppActions')..add('name', name))
        .toString();
  }
}

class AppActionsBuilder implements Builder<AppActions, AppActionsBuilder> {
  _$AppActions _$v;

  String _name;
  String get name => _$this._name;
  set name(String name) => _$this._name = name;

  AppActionsBuilder();

  AppActionsBuilder get _$this {
    if (_$v != null) {
      _name = _$v.name;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AppActions other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$AppActions;
  }

  @override
  void update(void Function(AppActionsBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$AppActions build() {
    final _$result = _$v ?? new _$AppActions._(name: name);
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
