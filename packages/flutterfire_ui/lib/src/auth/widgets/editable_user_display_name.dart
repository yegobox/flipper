import 'package:firebase_auth/firebase_auth.dart' show FirebaseAuth;
import 'package:flutter/cupertino.dart';
import 'package:flutterfire_ui/auth.dart';
import 'package:flutterfire_ui/i10n.dart';
import 'package:flutter/material.dart';

import 'internal/subtitle.dart';

class EditableUserDisplayName extends StatefulWidget {
  final FirebaseAuth? auth;

  const EditableUserDisplayName({
    Key? key,
    this.auth,
  }) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _EditableUserDisplayNameState createState() =>
      _EditableUserDisplayNameState();
}

class _EditableUserDisplayNameState extends State<EditableUserDisplayName> {
  FirebaseAuth get auth => widget.auth ?? FirebaseAuth.instance;
  String? get displayName => auth.currentUser?.displayName;

  late final ctrl = TextEditingController(text: displayName ?? '');

  late bool _editing = displayName == null;
  bool _isLoading = false;

  void _onEdit() {
    setState(() {
      _editing = true;
    });
  }

  Future<void> _finishEditing() async {
    try {
      if (displayName == ctrl.text) return;

      setState(() {
        _isLoading = true;
      });

      await auth.currentUser?.updateDisplayName(ctrl.text);
      await auth.currentUser?.reload();
    } finally {
      setState(() {
        _editing = false;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l = FlutterFireUILocalizations.labelsOf(context);
    final isCupertino = CupertinoUserInterfaceLevel.maybeOf(context) != null;

    late Widget iconButton;

    if (isCupertino) {
      iconButton = Transform.translate(
        offset: Offset(0, _editing ? -12 : 0),
        child: CupertinoButton(
          onPressed: _editing ? _finishEditing : _onEdit,
          child: Icon(
            _editing ? CupertinoIcons.check_mark_circled : CupertinoIcons.pen,
          ),
        ),
      );
    } else {
      iconButton = IconButton(
        icon: Icon(_editing ? Icons.check : Icons.edit),
        color: theme.colorScheme.secondary,
        onPressed: _editing ? _finishEditing : _onEdit,
      );
    }

    if (!_editing) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 5.5),
        child: IntrinsicWidth(
          child: Row(
            children: [
              Subtitle(text: displayName ?? 'Unknown'),
              iconButton,
            ],
          ),
        ),
      );
    }

    late Widget textField;

    if (isCupertino) {
      textField = Padding(
        padding: const EdgeInsets.symmetric(vertical: 17.5),
        child: CupertinoTextField(
          autofocus: true,
          controller: ctrl,
          placeholder: l.name,
          onSubmitted: (_) => _finishEditing(),
        ),
      );
    } else {
      textField = TextField(
        autofocus: true,
        controller: ctrl,
        decoration: InputDecoration(hintText: l.name, labelText: l.name),
        onSubmitted: (_) => _finishEditing(),
      );
    }

    return Row(
      children: [
        Expanded(child: textField),
        const SizedBox(width: 8),
        SizedBox(
          width: 50,
          height: 32,
          child: Stack(
            children: [
              if (_isLoading)
                const LoadingIndicator(size: 24, borderWidth: 1)
              else
                Align(
                  alignment: Alignment.topLeft,
                  child: iconButton,
                ),
            ],
          ),
        ),
      ],
    );
  }
}
