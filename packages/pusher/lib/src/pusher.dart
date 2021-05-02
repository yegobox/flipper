import 'package:http/http.dart' show Request, StreamedResponse;
import 'dart:convert';
import 'dart:async';
import 'dart:collection';
import 'validation.dart';
import 'response.dart';
import 'trigger.dart';
import 'utils.dart';
import 'user.dart';
import 'options.dart';

/// Provides access to functionality within the Pusher service such as Trigger to trigger events
/// and authenticating subscription requests to private and presence channels.
class Pusher {
  String? _id;

  String? _key;

  String? _secret;

  late PusherOptions _options;

  Pusher(String? id, String? key, String? secret, [PusherOptions? options]) {
    this._id = id;
    this._secret = secret;
    this._key = key;
    this._options = options == null ? new PusherOptions() : options;
  }

  /// Authenticates the subscription request for a presence channel.
  ///
  /// Pusher provides a mechanism for authenticating a user's access to a channel at the point of subscription.
  ///
  /// This can be used both to restrict access to private channels,
  /// and in the case of presence channels notify subscribers of who else is also subscribed via presence events.
  ///
  /// This library provides a mechanism for generating an authentication signature to send back to the client and authorize them.
  ///
  /// For more information see [docs](https://pusher.com/docs/authenticating_users).
  ///
  /// ## Private channels
  ///
  ///      String socketId = '74124.3251944';
  ///      String auth = pusher.authenticate('test_channel',socketId);
  /// ##  Authenticating presence channels
  ///
  /// Using presence channels is similar to private channels, but in order to identify a user,
  /// clients are sent a user_id and, optionally, custom data.
  ///      String socketId = '74124.3251944';
  ///      User user = new User('1',{'name':'Adao'});
  ///      String auth = pusher.authenticate('presence-test_channel',socketId,user);
  ///
  /// Throws a [JsonUnsupportedObjectError] if [User] cannot be serialized
  String authenticate(String channel, String socketId, [User? user]) {
    validateChannelName(channel);
    validateSocketId(socketId);
    String signature;
    String token;

    if (user == null) {
      signature = "$socketId:$channel";
      token = "$_key:${hmac256(_secret!, signature)}";
      return json.encode({'auth': token});
    } else {
      String data = json.encode(user.toMap());
      signature = "$socketId:$channel:$data";
      token = "$_key:${hmac256(_secret!, signature)}";
      return json.encode({'auth': token, 'channel_data': data});
    }
  }

  /// Allows you to query Pusher API to retrieve information about your application's channels,
  /// their individual properties, and, for presence-channels, the users currently subscribed to them.
  ///
  /// ## List channels
  /// You can get a list of channels that are present within your application:
  ///      Response result = await pusher.get("/channels");
  /// You can provide additional parameters to filter the list of channels that is returned.
  ///      Response result = await pusher.get("/channels", new { filter_by_prefix = "presence-" } );
  /// ## Fetch channel information
  /// Retrive information about a single channel:
  ///      Response result = await pusher.get("/channels/my_channel");
  /// ## Fetch a list of users on a presence channel
  /// Retrive a list of users that are on a presence channel:
  ///      Response result = await pusher.get('/channels/presence-channel/users');
  Future<Response> get(String resource,
      [Map<String, String>? parameters]) async {
    parameters = (parameters != null) ? parameters : new Map<String, String>();
    Request request =
        _createAuthenticatedRequest('GET', resource, parameters, null);
    StreamedResponse response = await request.send();
    return new Response(
        response.statusCode, await response.stream.bytesToString());
  }

  /// Triggers an event on one or more channels.
  ///
  /// Channel names can contain only characters which are alphanumeric, _ or -`. Event name can be at most 200 characters long too.
  ///
  /// ## Triggering events
  ///      Response response = await pusher.trigger(['test_channel'],'my_event',data);
  Future<Response> trigger(List<String> channels, String event, Map data,
      [TriggerOptions? options]) {
    options = options == null ? new TriggerOptions() : options;
    validateListOfChannelNames(channels);
    validateSocketId(options.socketId);
    TriggerBody body = new TriggerBody(
        name: event,
        data: data.toString(),
        channels: channels,
        socketId: options.socketId);
    return _executeTrigger(channels, event, body);
  }

  Future<Response> _executeTrigger(
      List<String> channels, String event, TriggerBody body) async {
    Request request =
        _createAuthenticatedRequest('POST', "/events", null, body);
    StreamedResponse response = await request.send();
    return new Response(
        response.statusCode, await response.stream.bytesToString());
  }

  int _secondsSinceEpoch() {
    return (new DateTime.now().toUtc().millisecondsSinceEpoch * 0.001).toInt();
  }

  String _mapToQueryString(Map<String, String> params) {
    List values = [];
    params.forEach((k, v) {
      values.add("$k=$v");
    });
    return values.join('&');
  }

  Request _createAuthenticatedRequest(String method, String resource,
      Map<String, String>? parameters, TriggerBody? body) {
    resource = resource.startsWith('/') ? resource.substring(1) : resource;
    parameters = parameters == null
        ? new SplayTreeMap()
        : new SplayTreeMap.from(parameters);
    parameters['auth_key'] = this._key!;
    parameters['auth_timestamp'] = _secondsSinceEpoch().toString();
    parameters['auth_version'] = '1.0';

    if (body != null) {
      parameters['body_md5'] = body.toMD5();
    }

    String queryString = _mapToQueryString(parameters);
    String path = "/apps/${this._id}/$resource";
    String toSign = "$method\n$path\n$queryString";

    String authSignature = hmac256(this._secret!, toSign);

    Uri uri = Uri.parse(
        "${_options.getBaseUrl()}$path?$queryString&auth_signature=$authSignature");
    Request request = new Request(method, uri);
    request.headers['Content-Type'] = 'application/json';
    if (body != null) {
      request.body = body.toJson();
    }
    return request;
  }
}
