// To parse this JSON data, do
//
//     final subscriptionResponse = subscriptionResponseFromJson(jsonString);

import 'dart:convert';

SubscriptionResponse subscriptionResponseFromJson(String str) =>
    SubscriptionResponse.fromJson(json.decode(str));

String subscriptionResponseToJson(SubscriptionResponse data) =>
    json.encode(data.toJson());

class SubscriptionResponse {
  Message message;

  SubscriptionResponse({
    this.message,
  });

  factory SubscriptionResponse.fromJson(Map<String, dynamic> json) =>
      SubscriptionResponse(
        message: Message.fromJson(json['message']),
      );

  Map<String, dynamic> toJson() => {
        'message': message.toJson(),
      };
}

class Message {
  String status;
  String message;
  RData data;

  Message({
    this.status,
    this.message,
    this.data,
  });

  factory Message.fromJson(Map<String, dynamic> json) => Message(
        status: json['status'],
        message: json['message'],
        data: RData.fromJson(json['data']),
      );

  Map<String, dynamic> toJson() => {
        'status': status,
        'message': message,
        'data': data.toJson(),
      };
}

class RData {
  int id;
  String txRef;
  String orderRef;
  String flwRef;
  String redirectUrl;
  String deviceFingerprint;
  dynamic settlementToken;
  String cycle;
  int amount;
  int chargedAmount;
  double appfee;
  int merchantfee;
  int merchantbearsfee;
  String chargeResponseCode;
  String raveRef;
  String chargeResponseMessage;
  String authModelUsed;
  String currency;
  String ip;
  String narration;
  String status;
  String modalauditid;
  String vbvrespmessage;
  String authurl;
  String vbvrespcode;
  dynamic acctvalrespmsg;
  dynamic acctvalrespcode;
  String paymentType;
  dynamic paymentPlan;
  dynamic paymentPage;
  String paymentId;
  String fraudStatus;
  String chargeType;
  int isLive;
  dynamic retryAttempt;
  dynamic getpaidBatchId;
  DateTime createdAt;
  DateTime updatedAt;
  dynamic deletedAt;
  int customerId;
  int accountId;
  Customer customer;
  bool customercandosubsequentnoauth;

  RData({
    this.id,
    this.txRef,
    this.orderRef,
    this.flwRef,
    this.redirectUrl,
    this.deviceFingerprint,
    this.settlementToken,
    this.cycle,
    this.amount,
    this.chargedAmount,
    this.appfee,
    this.merchantfee,
    this.merchantbearsfee,
    this.chargeResponseCode,
    this.raveRef,
    this.chargeResponseMessage,
    this.authModelUsed,
    this.currency,
    this.ip,
    this.narration,
    this.status,
    this.modalauditid,
    this.vbvrespmessage,
    this.authurl,
    this.vbvrespcode,
    this.acctvalrespmsg,
    this.acctvalrespcode,
    this.paymentType,
    this.paymentPlan,
    this.paymentPage,
    this.paymentId,
    this.fraudStatus,
    this.chargeType,
    this.isLive,
    this.retryAttempt,
    this.getpaidBatchId,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.customerId,
    this.accountId,
    this.customer,
    this.customercandosubsequentnoauth,
  });

  factory RData.fromJson(Map<String, dynamic> json) => RData(
        id: json['id'],
        txRef: json['txRef'],
        orderRef: json['orderRef'],
        flwRef: json['flwRef'],
        redirectUrl: json['redirectUrl'],
        deviceFingerprint: json['device_fingerprint'],
        settlementToken: json['settlement_token'],
        cycle: json['cycle'],
        amount: json['amount'],
        chargedAmount: json['charged_amount'],
        appfee: json['appfee'].toDouble(),
        merchantfee: json['merchantfee'],
        merchantbearsfee: json['merchantbearsfee'],
        chargeResponseCode: json['chargeResponseCode'],
        raveRef: json['raveRef'],
        chargeResponseMessage: json['chargeResponseMessage'],
        authModelUsed: json['authModelUsed'],
        currency: json['currency'],
        ip: json['IP'],
        narration: json['narration'],
        status: json['status'],
        modalauditid: json['modalauditid'],
        vbvrespmessage: json['vbvrespmessage'],
        authurl: json['authurl'],
        vbvrespcode: json['vbvrespcode'],
        acctvalrespmsg: json['acctvalrespmsg'],
        acctvalrespcode: json['acctvalrespcode'],
        paymentType: json['paymentType'],
        paymentPlan: json['paymentPlan'],
        paymentPage: json['paymentPage'],
        paymentId: json['paymentId'],
        fraudStatus: json['fraud_status'],
        chargeType: json['charge_type'],
        isLive: json['is_live'],
        retryAttempt: json['retry_attempt'],
        getpaidBatchId: json['getpaidBatchId'],
        createdAt: DateTime.parse(json['createdAt']),
        updatedAt: DateTime.parse(json['updatedAt']),
        deletedAt: json['deletedAt'],
        customerId: json['customerId'],
        accountId: json['AccountId'],
        customer: Customer.fromJson(json['customer']),
        customercandosubsequentnoauth: json['customercandosubsequentnoauth'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'txRef': txRef,
        'orderRef': orderRef,
        'flwRef': flwRef,
        'redirectUrl': redirectUrl,
        'device_fingerprint': deviceFingerprint,
        'settlement_token': settlementToken,
        'cycle': cycle,
        'amount': amount,
        'charged_amount': chargedAmount,
        'appfee': appfee,
        'merchantfee': merchantfee,
        'merchantbearsfee': merchantbearsfee,
        'chargeResponseCode': chargeResponseCode,
        'raveRef': raveRef,
        'chargeResponseMessage': chargeResponseMessage,
        'authModelUsed': authModelUsed,
        'currency': currency,
        'IP': ip,
        'narration': narration,
        'status': status,
        'modalauditid': modalauditid,
        'vbvrespmessage': vbvrespmessage,
        'authurl': authurl,
        'vbvrespcode': vbvrespcode,
        'acctvalrespmsg': acctvalrespmsg,
        'acctvalrespcode': acctvalrespcode,
        'paymentType': paymentType,
        'paymentPlan': paymentPlan,
        'paymentPage': paymentPage,
        'paymentId': paymentId,
        'fraud_status': fraudStatus,
        'charge_type': chargeType,
        'is_live': isLive,
        'retry_attempt': retryAttempt,
        'getpaidBatchId': getpaidBatchId,
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
        'deletedAt': deletedAt,
        'customerId': customerId,
        'AccountId': accountId,
        'customer': customer.toJson(),
        'customercandosubsequentnoauth': customercandosubsequentnoauth,
      };
}

class Customer {
  int id;
  dynamic phone;
  String fullName;
  dynamic customertoken;
  String email;
  DateTime createdAt;
  DateTime updatedAt;
  dynamic deletedAt;
  int accountId;

  Customer({
    this.id,
    this.phone,
    this.fullName,
    this.customertoken,
    this.email,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.accountId,
  });

  factory Customer.fromJson(Map<String, dynamic> json) => Customer(
        id: json['id'],
        phone: json['phone'],
        fullName: json['fullName'],
        customertoken: json['customertoken'],
        email: json['email'],
        createdAt: DateTime.parse(json['createdAt']),
        updatedAt: DateTime.parse(json['updatedAt']),
        deletedAt: json['deletedAt'],
        accountId: json['AccountId'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'phone': phone,
        'fullName': fullName,
        'customertoken': customertoken,
        'email': email,
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
        'deletedAt': deletedAt,
        'AccountId': accountId,
      };
}
