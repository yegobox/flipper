// Copyright (c) 2015, <your name>. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'package:pusher/pusher.dart';
import 'package:pusher/src/options.dart' show defaultHttpsPort, defaultHttpPort;
import 'package:pusher/src/validation.dart' show channelNameMaxLength;
import 'package:test/test.dart';
import 'dart:convert' show json , JsonUnsupportedObjectError;
import 'dart:io' show Platform;
import 'utils.dart' as utils;

final String? pusherAppId = Platform.environment['PUSHER_APP_ID'];
final String? pusherAppKey = Platform.environment['PUSHER_APP_KEY'];
final String? pusherAppSecret = Platform.environment['PUSHER_APP_SECRET'];

void main() {
  group('PusherOptions', () {
    test('Test default values', () {
      PusherOptions options = new PusherOptions();
      expect(options.encrypted, false);
      expect(options.port, defaultHttpPort);
    });

    test('Should use HTTPS if encrypted is `true` and port if `null`', () {
      PusherOptions options = new PusherOptions(encrypted: true);
      expect(options.port, defaultHttpsPort);
    });

    test('Constructor #1', () {
      PusherOptions options = new PusherOptions(encrypted: true, port: 1000);
      expect(options.encrypted, true);
      expect(options.port, 1000);
    });

    test('PusherOptions with cluster', () {
      PusherOptions options = new PusherOptions(cluster: 'ap1');
      expect(options.host, "api-ap1.pusher.com");
    });

    test('PusherOptions without cluster', () {
      PusherOptions options = new PusherOptions();
      expect(options.host, 'api.pusherapp.com');
    });
  });

  group('TriggerOptions', () {
    late TriggerOptions options;
    late String socketId;

    setUp(() {
      socketId = '444.444';
      options = new TriggerOptions(socketId: socketId);
    });

    test('Should get `socketId`', () {
      expect(options.socketId, socketId);
    });
  });

  group('TriggerBody', () {
    late TriggerBody body;
    late String name;
    late String data;
    late List<String> channels;
    late String socketId;

    setUp(() {
      name = 'my-event';
      data = 'Hello World';
      channels = ['my-channel'];
      socketId = '444.444';
      body = new TriggerBody(name: name, data: data, channels: channels, socketId: socketId);
    });

    test('Should get `name`', () {
      expect(body.name, name);
    });

    test('Should get `data`', () {
      expect(body.data, data);
    });

    test('Should get `channels`', () {
      expect(body.channels, channels);
    });

    test('Should get `socketId`', () {
      expect(body.socketId, socketId);
    });

    test('Should get a body Map', () {
      expect(
          body.toMap(), {'name': name, 'data': data, 'channels': channels, 'socketId': socketId});
    });

    test('Should get a JSON encoded body', () {
      expect(body.toJson(),
          json.encode({'name': name, 'data': data, 'channels': channels, 'socketId': socketId}));
    });

    test('Should get a MD5 encoded body', () {
      expect(body.toMD5(), '641c5a9f422d824e5ee6070df4cd3f1e');
    });
  });

  group('Response', () {
    late Response result;
    late int status;
    late String message;

    setUp(() {
      status = 200;
      message = '{}';
      result = new Response(status, message);
    });

    test('Should get `status`', () {
      expect(result.status, status);
    });

    test('Should get `message`', () {
      expect(result.message, message);
    });

    test('.toString()', () {
      expect(result.toString(),message);
    });

  });

  group('Pusher', () {
    late Pusher pusher;

    setUp(() {
      pusher = new Pusher(pusherAppId, pusherAppKey, pusherAppSecret);
    });

    test('Should get `/channels`', () async {
      Response result = await pusher.get('/channels');
      expect(result.status, 200);
    });

    test('.trigger() Should trigger events', () async {
      Response respose =
          await pusher.trigger(['channel-test'], 'event-test', {'message': 'Hello World!'});
      expect(respose.status, 200);
    });

    test('.trigger() validates channels name format', () {
      var list = utils.listOfInvalidChannelsName();
      var event = 'my-event';
      var data = {'message':'hello world'};
      list.forEach((value) {
        expect(() => pusher.trigger([value],event,data),throwsFormatException);
      });
    });

    test('trigger() validates channels name lenght', () {
      var event = 'my-event';
      var data = {'message':'hello world'};
      var channel = utils.strRepeat('a',channelNameMaxLength + 1);
      expect(() =>  pusher.trigger([channel],event,data), throwsArgumentError);
    });

    test('.trigger() Should validate  socketId', () {
      var list = utils.listOfInvalidSocketId();
      var event = 'my-event';
      var channels = ['my-channel'];
      var data = {'message':'hello world'};
      list.forEach((value) {
        var options = new TriggerOptions(socketId: value);
        expect(() => pusher.trigger(channels,event,data,options),throwsFormatException);
      });
    });

    test('Should authenticate socketId', () {
      String key = 'thisisaauthkey';
      Pusher instance = new Pusher('1', key, 'thisisasecret');
      String auth = instance.authenticate('test_channel', '74124.3251944');
      String expected =
          '{"auth":"$key:f8390ffe4df18cc755d3191b9db75182c71354e0b3ad7be1d186ac86f3c0fc4b"}';
      expect(auth, expected);
    });

    test('Should authenticate presence', () {
      String key = 'thisisaauthkey';
      Pusher instance = new Pusher('1', key, 'thisisasecret');
      String channel = 'presence-test_channel';
      String socketId = '74124.3251944';
      String userId = "1";
      Map<String, String> userInfo = {'name': 'Adao'};

      expect(
          instance.authenticate(channel, socketId , new User(userId,userInfo)),
          json.encode({
            "auth":"$key:ca6b9a5d11a7b5909eef43f49cba4c64a083c9298c9b1dc75c4073c0f4e7d2e2",
            "channel_data":json.encode({
              "user_id":"1",
              "user_info":{"name":"Adao"}
            })
          })
      );

      expect(
          instance.authenticate(channel, socketId , new User(userId)),
          json.encode({
            "auth":"$key:048b6b48bdf0302132ab7742cb5552c7bdb9aacb66c7c5e543ff49db8f7a33cf",
            "channel_data":json.encode({
              "user_id": "1"
            })
          })
      );

      expect(() =>
        instance.authenticate(channel,socketId,new User(userId,{
          "int":1,
          "double":444.444,
          "boolean":true
        })),
        returnsNormally
      );

      expect(() =>
          instance.authenticate(channel,socketId,new User(userId,{
            "int":1,
            "double":444.444,
            "boolean":true,
            "aObjectInstance":instance
          })),
          throwsA(predicate((dynamic e) => e is JsonUnsupportedObjectError))
      );

    });
  });
}
