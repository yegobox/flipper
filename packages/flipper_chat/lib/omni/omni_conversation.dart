import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flipper_chat/omni/widgets/chat_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flipper_models/models/models.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:stacked/stacked.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:http/http.dart' as http;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flipper_routing/routes.logger.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';

import 'custom_input_chat.dart';

// ignore: must_be_immutable
class OmniConversation extends StatefulWidget {
  OmniConversation({Key? key, required this.room}) : super(key: key);
  final types.Room room;

  @override
  _OmniConversationState createState() => _OmniConversationState();
}

class _OmniConversationState extends State<OmniConversation> {
  final log = getLogger('_ChatPageState');
  bool _isAttachmentUploading = false;
  int author = 0;
  void _handleAtachmentPressed() {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: SizedBox(
            height: 144,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    _handleImageSelection();
                  },
                  child: const Align(
                    alignment: Alignment.centerLeft,
                    child: Text('Photo'),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    _handleFileSelection();
                  },
                  child: const Align(
                    alignment: Alignment.centerLeft,
                    child: Text('File'),
                  ),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Align(
                    alignment: Alignment.centerLeft,
                    child: Text('Cancel'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _handleFileSelection() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.any,
    );

    if (result != null) {
      _setAttachmentUploading(true);
      final name = result.files.single.name;
      final filePath = result.files.single.path;
      final file = File(filePath!);

      try {
        final reference = FirebaseStorage.instance.ref(name);
        await reference.putFile(file);
        final uri = await reference.getDownloadURL();

        final message = types.PartialFile(
          mimeType: lookupMimeType(filePath),
          name: name,
          size: result.files.single.size,
          uri: uri,
        );

        FirebaseChatCore.instance.sendMessage(message, widget.room);
        _setAttachmentUploading(false);
      } finally {
        _setAttachmentUploading(false);
      }
    }
  }

  void _handleImageSelection() async {
    final result = await ImagePicker().pickImage(
      imageQuality: 70,
      maxWidth: 1440,
      source: ImageSource.gallery,
    );

    if (result != null) {
      _setAttachmentUploading(true);
      final file = File(result.path);
      final size = file.lengthSync();
      final bytes = await result.readAsBytes();
      final image = await decodeImageFromList(bytes);
      final name = result.name;

      try {
        final reference = FirebaseStorage.instance.ref(name);
        await reference.putFile(file);
        final uri = await reference.getDownloadURL();

        final message = types.PartialImage(
          height: image.height.toDouble(),
          name: name,
          size: size,
          uri: uri,
          width: image.width.toDouble(),
        );

        FirebaseChatCore.instance.sendMessage(
          message,
          widget.room,
        );
        _setAttachmentUploading(false);
      } finally {
        _setAttachmentUploading(false);
      }
    }
  }

  void _handleMessageTap(types.Message message) async {
    if (message is types.FileMessage) {
      var localPath = message.uri;

      if (message.uri.startsWith('http')) {
        final client = http.Client();
        final request = await client.get(Uri.parse(message.uri));
        final bytes = request.bodyBytes;
        final documentsDir = (await getApplicationDocumentsDirectory()).path;
        localPath = '$documentsDir/${message.name}';

        if (!File(localPath).existsSync()) {
          final file = File(localPath);
          await file.writeAsBytes(bytes);
        }
      }
      await OpenFile.open(localPath);
    }
  }

  void _handlePreviewDataFetched(
    types.TextMessage message,
    types.PreviewData previewData,
  ) {
    final updatedMessage = message.copyWith(previewData: previewData);

    FirebaseChatCore.instance.updateMessage(updatedMessage, widget.room.id);
  }

  void _handleSendPressed(types.PartialText message) {
    FirebaseChatCore.instance.sendMessage(
      message,
      widget.room,
    );
    //update room with new updatedAt property
    // FirebaseChatCore.instance.updateRoom(widget.room, message.toJson());
  }

  void _setAttachmentUploading(bool uploading) {
    setState(() {
      _isAttachmentUploading = uploading;
    });
  }

  @override
  Widget build(BuildContext context) {
    final roundedContainer = ClipRRect(
      borderRadius: BorderRadius.circular(20.0),
      child: Container(
        color: Colors.white,
        child: Row(
          children: <Widget>[
            SizedBox(width: 8.0),
            Icon(Icons.insert_emoticon,
                size: 30.0, color: Theme.of(context).hintColor),
            SizedBox(width: 8.0),
            Expanded(
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Type a message',
                  border: InputBorder.none,
                ),
              ),
            ),
            // Icon(Icons.attach_file,
            //     size: 30.0, color: Theme.of(context).hintColor),
            SizedBox(width: 8.0),
            Icon(Icons.send, size: 30.0, color: Theme.of(context).hintColor),
            SizedBox(width: 8.0),
          ],
        ),
      ),
    );

    return ViewModelBuilder<MessageViewModel>.reactive(
      builder: (context, model, child) {
        return Scaffold(
          appBar: ChatAppBar(
            'Flipper',
          ),
          body: StreamBuilder<types.Room>(
            initialData: widget.room,
            stream: FirebaseChatCore.instance.room(widget.room.id),
            builder: (context, snapshot) {
              return StreamBuilder<List<types.Message>>(
                initialData: const [],
                stream: snapshot.hasData
                    ? FirebaseChatCore.instance.messages(snapshot.data!)
                    : null,
                builder: (context, snapshot) {
                  return SafeArea(
                    bottom: false,
                    child: Chat(
                        isAttachmentUploading: _isAttachmentUploading,
                        messages: snapshot.data ?? [],
                        showUserAvatars: false,
                        showUserNames: true,
                        onAttachmentPressed: _handleAtachmentPressed,
                        onMessageTap: _handleMessageTap,
                        onPreviewDataFetched: _handlePreviewDataFetched,
                        onSendPressed: _handleSendPressed,
                        user: types.User(
                          id: FirebaseChatCore.instance.firebaseUser?.uid ?? '',
                        ),
                        customBottomWidget: FInput(
                          onAttachmentPressed: _handleAtachmentPressed,
                          onSendPressed: _handleSendPressed,
                          sendButtonVisibilityMode:
                              SendButtonVisibilityMode.always,
                        )
                        // customBottomWidget: Padding(
                        //   padding: EdgeInsets.all(8.0),
                        //   child: Row(
                        //     children: <Widget>[
                        //       Expanded(
                        //         child: roundedContainer,
                        //       ),
                        //       SizedBox(
                        //         width: 5.0,
                        //       ),
                        //       GestureDetector(
                        //         onTap: () {},
                        //         child: CircleAvatar(
                        //           child: Icon(Icons.send),
                        //         ),
                        //       ),
                        //     ],
                        //   ),
                        // ),
                        ),
                  );
                },
              );
            },
          ),
        );
      },
      onModelReady: (model) {},
      viewModelBuilder: () => MessageViewModel(),
    );
  }
}
