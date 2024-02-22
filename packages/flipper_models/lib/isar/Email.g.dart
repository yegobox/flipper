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

Map<String, dynamic> _$MailToJson(Mail instance) => <String, dynamic>{
      'to': instance.to,
      'subject': instance.subject,
      'messageBody': instance.messageBody,
      'bcc': instance.bcc,
    };
