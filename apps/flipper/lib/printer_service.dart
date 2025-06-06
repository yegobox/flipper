// Autogenerated by jnigen. DO NOT EDIT!

// ignore_for_file: annotate_overrides
// ignore_for_file: argument_type_not_assignable
// ignore_for_file: camel_case_extensions
// ignore_for_file: camel_case_types
// ignore_for_file: constant_identifier_names
// ignore_for_file: doc_directive_unknown
// ignore_for_file: file_names
// ignore_for_file: inference_failure_on_untyped_parameter
// ignore_for_file: invalid_internal_annotation
// ignore_for_file: invalid_use_of_internal_member
// ignore_for_file: library_prefixes
// ignore_for_file: lines_longer_than_80_chars
// ignore_for_file: no_leading_underscores_for_library_prefixes
// ignore_for_file: no_leading_underscores_for_local_identifiers
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: only_throw_errors
// ignore_for_file: overridden_fields
// ignore_for_file: prefer_double_quotes
// ignore_for_file: unintended_html_in_doc_comment
// ignore_for_file: unnecessary_cast
// ignore_for_file: unnecessary_non_null_assertion
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: unused_element
// ignore_for_file: unused_field
// ignore_for_file: unused_import
// ignore_for_file: unused_local_variable
// ignore_for_file: unused_shown_name
// ignore_for_file: use_super_parameters

import 'dart:core' show Object, String, bool, double, int;
import 'dart:core' as core$_;

import 'package:jni/_internal.dart' as jni$_;
import 'package:jni/jni.dart' as jni$_;

/// from: `com.printer.PrinterService`
class PrinterService extends jni$_.JObject {
  @jni$_.internal
  @core$_.override
  final jni$_.JObjType<PrinterService> $type;

  @jni$_.internal
  PrinterService.fromReference(
    jni$_.JReference reference,
  )   : $type = type,
        super.fromReference(reference);

  static final _class = jni$_.JClass.forName(r'com/printer/PrinterService');

  /// The type which includes information such as the signature of this class.
  static const nullableType = $PrinterService$NullableType();
  static const type = $PrinterService$Type();
  static final _id_getInstance = _class.staticMethodId(
    r'getInstance',
    r'()Lcom/printer/PrinterService;',
  );

  static final _getInstance = jni$_.ProtectedJniExtensions.lookup<
          jni$_.NativeFunction<
              jni$_.JniResult Function(
                jni$_.Pointer<jni$_.Void>,
                jni$_.JMethodIDPtr,
              )>>('globalEnv_CallStaticObjectMethod')
      .asFunction<
          jni$_.JniResult Function(
            jni$_.Pointer<jni$_.Void>,
            jni$_.JMethodIDPtr,
          )>();

  /// from: `synchronized static public com.printer.PrinterService getInstance()`
  /// The returned object must be released after use, by calling the [release] method.
  static PrinterService? getInstance() {
    return _getInstance(
            _class.reference.pointer, _id_getInstance as jni$_.JMethodIDPtr)
        .object<PrinterService?>(const $PrinterService$NullableType());
  }

  static final _id_initializePrinter = _class.instanceMethodId(
    r'initializePrinter',
    r'()I',
  );

  static final _initializePrinter = jni$_.ProtectedJniExtensions.lookup<
          jni$_.NativeFunction<
              jni$_.JniResult Function(
                jni$_.Pointer<jni$_.Void>,
                jni$_.JMethodIDPtr,
              )>>('globalEnv_CallIntMethod')
      .asFunction<
          jni$_.JniResult Function(
            jni$_.Pointer<jni$_.Void>,
            jni$_.JMethodIDPtr,
          )>();

  /// from: `public int initializePrinter()`
  int initializePrinter() {
    return _initializePrinter(
            reference.pointer, _id_initializePrinter as jni$_.JMethodIDPtr)
        .integer;
  }

  static final _id_printNow = _class.instanceMethodId(
    r'printNow',
    r'([B)I',
  );

  static final _printNow = jni$_.ProtectedJniExtensions.lookup<
              jni$_.NativeFunction<
                  jni$_.JniResult Function(
                      jni$_.Pointer<jni$_.Void>,
                      jni$_.JMethodIDPtr,
                      jni$_.VarArgs<(jni$_.Pointer<jni$_.Void>,)>)>>(
          'globalEnv_CallIntMethod')
      .asFunction<
          jni$_.JniResult Function(jni$_.Pointer<jni$_.Void>,
              jni$_.JMethodIDPtr, jni$_.Pointer<jni$_.Void>)>();

  /// from: `public int printNow(byte[] imageData)`
  int printNow(
    jni$_.JByteArray? imageData,
  ) {
    final _$imageData = imageData?.reference ?? jni$_.jNullReference;
    return _printNow(reference.pointer, _id_printNow as jni$_.JMethodIDPtr,
            _$imageData.pointer)
        .integer;
  }

  static final _id_toGrayscale = _class.staticMethodId(
    r'toGrayscale',
    r'(Landroid/graphics/Bitmap;)Landroid/graphics/Bitmap;',
  );

  static final _toGrayscale = jni$_.ProtectedJniExtensions.lookup<
              jni$_.NativeFunction<
                  jni$_.JniResult Function(
                      jni$_.Pointer<jni$_.Void>,
                      jni$_.JMethodIDPtr,
                      jni$_.VarArgs<(jni$_.Pointer<jni$_.Void>,)>)>>(
          'globalEnv_CallStaticObjectMethod')
      .asFunction<
          jni$_.JniResult Function(jni$_.Pointer<jni$_.Void>,
              jni$_.JMethodIDPtr, jni$_.Pointer<jni$_.Void>)>();

  /// from: `static public android.graphics.Bitmap toGrayscale(android.graphics.Bitmap bmpOriginal)`
  /// The returned object must be released after use, by calling the [release] method.
  static jni$_.JObject? toGrayscale(
    jni$_.JObject? bmpOriginal,
  ) {
    final _$bmpOriginal = bmpOriginal?.reference ?? jni$_.jNullReference;
    return _toGrayscale(_class.reference.pointer,
            _id_toGrayscale as jni$_.JMethodIDPtr, _$bmpOriginal.pointer)
        .object<jni$_.JObject?>(const jni$_.JObjectNullableType());
  }
}

final class $PrinterService$NullableType
    extends jni$_.JObjType<PrinterService?> {
  @jni$_.internal
  const $PrinterService$NullableType();

  @jni$_.internal
  @core$_.override
  String get signature => r'Lcom/printer/PrinterService;';

  @jni$_.internal
  @core$_.override
  PrinterService? fromReference(jni$_.JReference reference) => reference.isNull
      ? null
      : PrinterService.fromReference(
          reference,
        );
  @jni$_.internal
  @core$_.override
  jni$_.JObjType get superType => const jni$_.JObjectNullableType();

  @jni$_.internal
  @core$_.override
  jni$_.JObjType<PrinterService?> get nullableType => this;

  @jni$_.internal
  @core$_.override
  final superCount = 1;

  @core$_.override
  int get hashCode => ($PrinterService$NullableType).hashCode;

  @core$_.override
  bool operator ==(Object other) {
    return other.runtimeType == ($PrinterService$NullableType) &&
        other is $PrinterService$NullableType;
  }
}

final class $PrinterService$Type extends jni$_.JObjType<PrinterService> {
  @jni$_.internal
  const $PrinterService$Type();

  @jni$_.internal
  @core$_.override
  String get signature => r'Lcom/printer/PrinterService;';

  @jni$_.internal
  @core$_.override
  PrinterService fromReference(jni$_.JReference reference) =>
      PrinterService.fromReference(
        reference,
      );
  @jni$_.internal
  @core$_.override
  jni$_.JObjType get superType => const jni$_.JObjectNullableType();

  @jni$_.internal
  @core$_.override
  jni$_.JObjType<PrinterService?> get nullableType =>
      const $PrinterService$NullableType();

  @jni$_.internal
  @core$_.override
  final superCount = 1;

  @core$_.override
  int get hashCode => ($PrinterService$Type).hashCode;

  @core$_.override
  bool operator ==(Object other) {
    return other.runtimeType == ($PrinterService$Type) &&
        other is $PrinterService$Type;
  }
}
