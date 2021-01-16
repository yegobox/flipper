// GENERATED CODE - DO NOT MODIFY BY HAND

part of flipper_models;

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$InAppNotification extends InAppNotification {
  @override
  final String message;

  factory _$InAppNotification(
          [void Function(InAppNotificationBuilder) updates]) =>
      (new InAppNotificationBuilder()..update(updates)).build();

  _$InAppNotification._({this.message}) : super._() {
    if (message == null) {
      throw new BuiltValueNullFieldError('InAppNotification', 'message');
    }
  }

  @override
  InAppNotification rebuild(void Function(InAppNotificationBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  InAppNotificationBuilder toBuilder() =>
      new InAppNotificationBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is InAppNotification && message == other.message;
  }

  @override
  int get hashCode {
    return $jf($jc(0, message.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('InAppNotification')
          ..add('message', message))
        .toString();
  }
}

class InAppNotificationBuilder
    implements Builder<InAppNotification, InAppNotificationBuilder> {
  _$InAppNotification _$v;

  String _message;
  String get message => _$this._message;
  set message(String message) => _$this._message = message;

  InAppNotificationBuilder();

  InAppNotificationBuilder get _$this {
    if (_$v != null) {
      _message = _$v.message;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(InAppNotification other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$InAppNotification;
  }

  @override
  void update(void Function(InAppNotificationBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$InAppNotification build() {
    final _$result = _$v ?? new _$InAppNotification._(message: message);
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
