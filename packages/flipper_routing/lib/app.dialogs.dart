// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// StackedDialogGenerator
// **************************************************************************

import 'package:stacked_services/stacked_services.dart';

import 'app.locator.dart';
import 'package:flipper_dashboard/logout/logout.dart';
import 'package:flipper_socials/ui/dialogs/app_center/app_center.dart';
import 'package:flipper_socials/ui/dialogs/info_alert/info_alert_dialog.dart';

import 'package:flipper_dashboard/start_shift_dialog.dart';
import 'package:flipper_dashboard/close_shift_dialog.dart';
import 'package:flipper_dashboard/app_choice_dialog.dart';

enum DialogType {
  infoAlert,
  appCenter,
  logOut,
  startShift,
  closeShift,
  appChoice,
}

void setupDialogUi() {
  final dialogService = locator<DialogService>();

  final Map<DialogType, DialogBuilder> builders = {
    DialogType.infoAlert: (context, request, completer) =>
        InfoAlertDialog(request: request, completer: completer),
    DialogType.appCenter: (context, request, completer) =>
        AppCenter(request: request, completer: completer),
    DialogType.logOut: (context, request, completer) =>
        LogOut(request: request, completer: completer),
    DialogType.startShift: (context, request, completer) =>
        StartShiftDialog(request: request, completer: completer),
    DialogType.closeShift: (context, request, completer) =>
        CloseShiftDialog(request: request, completer: completer),
    DialogType.appChoice: (context, request, completer) =>
        AppChoiceDialog(request: request, completer: completer),
  };

  dialogService.registerCustomDialogBuilders(builders);
}
