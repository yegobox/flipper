// GENERATED CODE - DO NOT MODIFY BY HAND

part of flipper_models;

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$KeyPad extends KeyPad {
  @override
  final String note;
  @override
  final int amount;

  factory _$KeyPad([void Function(KeyPadBuilder) updates]) =>
      (new KeyPadBuilder()..update(updates)).build();

  _$KeyPad._({this.note, this.amount}) : super._() {
    if (note == null) {
      throw new BuiltValueNullFieldError('KeyPad', 'note');
    }
    if (amount == null) {
      throw new BuiltValueNullFieldError('KeyPad', 'amount');
    }
  }

  @override
  KeyPad rebuild(void Function(KeyPadBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  KeyPadBuilder toBuilder() => new KeyPadBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is KeyPad && note == other.note && amount == other.amount;
  }

  @override
  int get hashCode {
    return $jf($jc($jc(0, note.hashCode), amount.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('KeyPad')
          ..add('note', note)
          ..add('amount', amount))
        .toString();
  }
}

class KeyPadBuilder implements Builder<KeyPad, KeyPadBuilder> {
  _$KeyPad _$v;

  String _note;
  String get note => _$this._note;
  set note(String note) => _$this._note = note;

  int _amount;
  int get amount => _$this._amount;
  set amount(int amount) => _$this._amount = amount;

  KeyPadBuilder();

  KeyPadBuilder get _$this {
    if (_$v != null) {
      _note = _$v.note;
      _amount = _$v.amount;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(KeyPad other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$KeyPad;
  }

  @override
  void update(void Function(KeyPadBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$KeyPad build() {
    final _$result = _$v ?? new _$KeyPad._(note: note, amount: amount);
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
