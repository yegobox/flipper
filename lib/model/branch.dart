import "package:built_value/built_value.dart";

part 'branch.g.dart';

abstract class Branch implements Built<Branch, BranchBuilder> {
  @nullable
  int get id;

  String get businessId;

  String get createdAt;

  String get name;
  String get mapLatitude;
  String get mapLongitude;
  String get updatedAt;
  @nullable
  String get description;

  @nullable
  bool get active;

  @nullable
  String get location;

  Branch._();

  factory Branch([void Function(BranchBuilder) updates]) = _$Branch;
}

class UserHelper {
  static List<String> branchIds(List<dynamic> branchIds) {
    if (branchIds == null) return [];
    return branchIds.whereType<String>().toList();
  }
}

enum RSVP { YES, MAYBE, NO, UNSET }

class RSVPHelper {
  static String stringOf(RSVP rsvp) {
    switch (rsvp) {
      case RSVP.YES:
        return "YES";
      case RSVP.MAYBE:
        return "MAYBE";
      case RSVP.NO:
        return "NO";
      case RSVP.UNSET:
      default:
        return "UNSET";
    }
  }

  static RSVP valueOf(String string) {
    switch (string) {
      case "YES":
        return RSVP.YES;
      case "MAYBE":
        return RSVP.MAYBE;
      case "NO":
        return RSVP.NO;
      case "UNSET":
      default:
        return RSVP.UNSET;
    }
  }
}

enum ChannelVisibility { OPEN, CLOSED }

class ChannelVisibilityHelper {
  static String stringOf(ChannelVisibility visibility) {
    switch (visibility) {
      case ChannelVisibility.OPEN:
        return "OPEN";
      case ChannelVisibility.CLOSED:
        return "CLOSED";
    }
    return null;
  }

  static ChannelVisibility valueOf(String string) {
    switch (string) {
      case "OPEN":
        return ChannelVisibility.OPEN;
      case "CLOSED":
        return ChannelVisibility.CLOSED;
    }
    return null;
  }
}

enum ChannelType { TOPIC, EVENT }

class ChannelTypeHelper {
  static String stringOf(ChannelType type) {
    switch (type) {
      case ChannelType.EVENT:
        return "EVENT";
      case ChannelType.TOPIC:
        return "TOPIC";
    }
    return null;
  }

  static ChannelType valueOf(String string) {
    switch (string) {
      case "EVENT":
        return ChannelType.EVENT;
      case "TOPIC":
        return ChannelType.TOPIC;
    }
    return null;
  }
}
