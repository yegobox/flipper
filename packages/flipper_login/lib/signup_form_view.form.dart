// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// StackedFormGenerator
// **************************************************************************

// ignore_for_file: public_member_api_docs

import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

const nameValueKey = 'name';
const typeValueKey = 'type';

mixin $SignUpFormView on StatelessWidget {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController typeController = TextEditingController();
  final FocusNode nameFocusNode = FocusNode();
  final FocusNode typeFocusNode = FocusNode();

  /// Registers a listener on every generated controller that calls [model.setData()]
  /// with the latest textController values
  void listenToFormUpdated(FormViewModel model) {
    nameController.addListener(() => _updateFormData(model));
    typeController.addListener(() => _updateFormData(model));
  }

  /// Updates the formData on the FormViewModel
  void _updateFormData(FormViewModel model) => model.setData(
        model.formValueMap
          ..addAll({
            nameValueKey: nameController.text,
            typeValueKey: typeController.text,
          }),
      );

  /// Calls dispose on all the generated controllers and focus nodes
  void disposeForm() {
    // The dispose function for a TextEditingController sets all listeners to null

    nameController.dispose();
    typeController.dispose();
  }
}

extension ValueProperties on FormViewModel {
  String? get nameValue => this.formValueMap[nameValueKey];
  String? get typeValue => this.formValueMap[typeValueKey];

  bool get hasName => this.formValueMap.containsKey(nameValueKey);
  bool get hasType => this.formValueMap.containsKey(typeValueKey);
}

extension Methods on FormViewModel {}
