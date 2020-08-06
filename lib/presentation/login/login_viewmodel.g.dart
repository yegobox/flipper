// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_viewmodel.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$LoginViewModel extends LoginViewModel {
  @override
  final bool hasData;

  factory _$LoginViewModel([void Function(LoginViewModelBuilder) updates]) =>
      (new LoginViewModelBuilder()..update(updates)).build();

  _$LoginViewModel._({this.hasData}) : super._() {
    if (hasData == null) {
      throw new BuiltValueNullFieldError('LoginViewModel', 'hasData');
    }
  }

  @override
  LoginViewModel rebuild(void Function(LoginViewModelBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  LoginViewModelBuilder toBuilder() =>
      new LoginViewModelBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is LoginViewModel && hasData == other.hasData;
  }

  @override
  int get hashCode {
    return $jf($jc(0, hasData.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('LoginViewModel')
          ..add('hasData', hasData))
        .toString();
  }
}

class LoginViewModelBuilder
    implements Builder<LoginViewModel, LoginViewModelBuilder> {
  _$LoginViewModel _$v;

  bool _hasData;
  bool get hasData => _$this._hasData;
  set hasData(bool hasData) => _$this._hasData = hasData;

  LoginViewModelBuilder();

  LoginViewModelBuilder get _$this {
    if (_$v != null) {
      _hasData = _$v.hasData;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(LoginViewModel other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$LoginViewModel;
  }

  @override
  void update(void Function(LoginViewModelBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$LoginViewModel build() {
    final _$result = _$v ?? new _$LoginViewModel._(hasData: hasData);
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
