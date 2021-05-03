/// Response of a resource request
class Response {
  final int _status;
  final String _message;

  Response(int status, String message)
      : _status = status,
        _message = message;

  /// HttpStatus.
  int get status => this._status;

  /// Request Body.
  String get message => this._message;

  /// Request body.
  @override
  String toString() => this.message;
}
