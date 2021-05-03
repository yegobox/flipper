final RegExp socketIdRegex = new RegExp(r'^\d+\.\d+$');

/// A regular expression to check that a channel name is in a format allowed and accepted by Pusher.
final RegExp channelNameRegex = new RegExp(r'^[A-Za-z0-9_\-=@,.;]+$');

final int channelNameMaxLength = 164;

/// Validate a socket_id value
void validateSocketId(String? socketId) {
  if (socketId != null && socketIdRegex.hasMatch(socketId) == false)
    throw new FormatException(
        "socket_id $socketId was not in the form: ${socketIdRegex.toString()}");
}

/// Validate a single channel name is in the allowed format.
void validateChannelName(String name) {
  if (name.length > channelNameMaxLength)
    throw new ArgumentError(
        "The length of the channel name was greater than the allowed $channelNameMaxLength characters");
  else if (channelNameRegex.hasMatch(name) == false)
    throw new FormatException(
        "channel name $name was not in the form: ${channelNameRegex.toString()}");
}

/// Validate a list of channel names
void validateListOfChannelNames(List<String> names) {
  names.forEach(validateChannelName);
}
