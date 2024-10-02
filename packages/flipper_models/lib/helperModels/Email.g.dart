// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Email.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Mail _$MailFromJson(Map<String, dynamic> json) => Mail(
      to: json['to'] as String,
      subject: json['subject'] as String,
      messageBody: json['messageBody'] as String,
      bcc: json['bcc'] as String?,
    );

const _$MailFieldMap = <String, String>{
  'to': 'to',
  'subject': 'subject',
  'messageBody': 'messageBody',
  'bcc': 'bcc',
};

// ignore: unused_element
abstract class _$MailPerFieldToJson {
  // ignore: unused_element
  static Object? to(String instance) => instance;
  // ignore: unused_element
  static Object? subject(String instance) => instance;
  // ignore: unused_element
  static Object? messageBody(String instance) => instance;
  // ignore: unused_element
  static Object? bcc(String? instance) => instance;
}

Map<String, dynamic> _$MailToJson(Mail instance) => <String, dynamic>{
      'to': instance.to,
      'subject': instance.subject,
      'messageBody': instance.messageBody,
      'bcc': instance.bcc,
    };
