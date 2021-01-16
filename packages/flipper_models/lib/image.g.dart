// GENERATED CODE - DO NOT MODIFY BY HAND

part of flipper_models;

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ImageP extends ImageP {
  @override
  final String path;
  @override
  final bool isLocal;

  factory _$ImageP([void Function(ImagePBuilder) updates]) =>
      (new ImagePBuilder()..update(updates)).build();

  _$ImageP._({this.path, this.isLocal}) : super._() {
    if (path == null) {
      throw new BuiltValueNullFieldError('ImageP', 'path');
    }
    if (isLocal == null) {
      throw new BuiltValueNullFieldError('ImageP', 'isLocal');
    }
  }

  @override
  ImageP rebuild(void Function(ImagePBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ImagePBuilder toBuilder() => new ImagePBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ImageP && path == other.path && isLocal == other.isLocal;
  }

  @override
  int get hashCode {
    return $jf($jc($jc(0, path.hashCode), isLocal.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('ImageP')
          ..add('path', path)
          ..add('isLocal', isLocal))
        .toString();
  }
}

class ImagePBuilder implements Builder<ImageP, ImagePBuilder> {
  _$ImageP _$v;

  String _path;
  String get path => _$this._path;
  set path(String path) => _$this._path = path;

  bool _isLocal;
  bool get isLocal => _$this._isLocal;
  set isLocal(bool isLocal) => _$this._isLocal = isLocal;

  ImagePBuilder();

  ImagePBuilder get _$this {
    if (_$v != null) {
      _path = _$v.path;
      _isLocal = _$v.isLocal;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ImageP other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$ImageP;
  }

  @override
  void update(void Function(ImagePBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$ImageP build() {
    final _$result = _$v ?? new _$ImageP._(path: path, isLocal: isLocal);
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
