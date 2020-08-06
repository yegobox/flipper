// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'splash_viewmodel.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$SplashViewModel extends SplashViewModel {
  @override
  final bool hasData;

  factory _$SplashViewModel([void Function(SplashViewModelBuilder) updates]) =>
      (new SplashViewModelBuilder()..update(updates)).build();

  _$SplashViewModel._({this.hasData}) : super._() {
    if (hasData == null) {
      throw new BuiltValueNullFieldError('SplashViewModel', 'hasData');
    }
  }

  @override
  SplashViewModel rebuild(void Function(SplashViewModelBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  SplashViewModelBuilder toBuilder() =>
      new SplashViewModelBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is SplashViewModel && hasData == other.hasData;
  }

  @override
  int get hashCode {
    return $jf($jc(0, hasData.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('SplashViewModel')
          ..add('hasData', hasData))
        .toString();
  }
}

class SplashViewModelBuilder
    implements Builder<SplashViewModel, SplashViewModelBuilder> {
  _$SplashViewModel _$v;

  bool _hasData;
  bool get hasData => _$this._hasData;
  set hasData(bool hasData) => _$this._hasData = hasData;

  SplashViewModelBuilder();

  SplashViewModelBuilder get _$this {
    if (_$v != null) {
      _hasData = _$v.hasData;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(SplashViewModel other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$SplashViewModel;
  }

  @override
  void update(void Function(SplashViewModelBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$SplashViewModel build() {
    final _$result = _$v ?? new _$SplashViewModel._(hasData: hasData);
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
