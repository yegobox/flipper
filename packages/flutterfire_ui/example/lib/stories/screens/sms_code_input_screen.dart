import 'package:flutter/material.dart';
import 'package:flutterfire_ui/auth.dart';
import 'package:flutterfire_ui_example/decorations.dart';
import 'package:flutterfire_ui_example/stories/stories_lib/story.dart';

class SMSCodeInputScreenStory extends StoryWidget {
  const SMSCodeInputScreenStory({Key? key})
      : super(key: key, category: 'Screens', title: 'SMSCodeInputScreen');

  @override
  Widget build(StoryElement context) {
    final withImage = context.knob<bool>(title: 'With image', value: true);

    return SMSCodeInputScreen(
      flowKey: Object(),
      headerBuilder: withImage ? headerIcon(Icons.sms) : null,
      sideBuilder: withImage ? sideIcon(Icons.sms) : null,
    );
  }
}
