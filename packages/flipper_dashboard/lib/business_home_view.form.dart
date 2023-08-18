// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// StackedFormGenerator
// **************************************************************************

// ignore_for_file: public_member_api_docs

import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

const String NoteValueKey = 'note';

mixin $BusinessHomeView on StatelessWidget {
  final TextEditingController noteController = TextEditingController();
  final FocusNode noteFocusNode = FocusNode();

  /// Registers a listener on every generated controller that calls [model.setData()]
  /// with the latest textController values
  void listenToFormUpdated(FormViewModel model) {
    noteController.addListener(() => _updateFormData(model));
  }

  /// Updates the formData on the FormViewModel
  void _updateFormData(FormViewModel model) => model.setData(
        model.formValueMap
          ..addAll({
            NoteValueKey: noteController.text,
          }),
      );

  /// Calls dispose on all the generated controllers and focus nodes
  void disposeForm() {
    // The dispose function for a TextEditingController sets all listeners to null

    noteController.dispose();
  }
}

extension ValueProperties on FormViewModel {
  String? get noteValue => this.formValueMap[NoteValueKey];

  bool get hasNote => this.formValueMap.containsKey(NoteValueKey);
}

extension Methods on FormViewModel {}
