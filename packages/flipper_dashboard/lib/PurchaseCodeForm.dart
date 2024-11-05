import 'package:flipper_models/realm/schemas.dart';
import 'package:flipper_models/view_models/mixins/_transaction.dart';
import 'package:flipper_services/constants.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:flutter/material.dart';

class PurchaseCodeFormBloc extends FormBloc<String, String>
    with TransactionMixin {
  final TextFieldBloc purchaseCode = TextFieldBloc(
    validators: [
      FieldBlocValidators.required,
    ],
    asyncValidatorDebounceTime: const Duration(milliseconds: 300),
  );

  final double amount;
  final double discount;
  final String paymentType;
  final ITransaction transaction;
  final BuildContext context;
  final TextEditingController customerNameController;
  final GlobalKey<FormState> formKey;
  Function onComplete;

  PurchaseCodeFormBloc({
    required this.customerNameController,
    required this.formKey,
    required this.amount,
    required this.discount,
    required this.paymentType,
    required this.transaction,
    required this.context,
    required this.onComplete,
  }) {
    addFieldBlocs(fieldBlocs: [purchaseCode]);
  }

  @override
  void onSubmitting() async {
    try {
      final response = await finalizePayment(
        onComplete: onComplete,
        formKey: formKey,
        customerNameController: customerNameController,
        transactionType: TransactionType.sale,
        context: context,
        categoryId: "0",
        paymentType: paymentType,
        transaction: transaction,
        amount: amount,
        discount: discount,
        purchaseCode: purchaseCode.value,
      );

      if (response.resultCd == "000") {
        emitSuccess();
      } else {
        purchaseCode.addFieldError(response.resultMsg);
        emitFailure();
      }
    } catch (e) {
      // Extract only the specific part of the error message
      final errorMessage = e.toString();
      final regex =
          RegExp(r"size must be between 6 and 6\. rejected value: '(\d+)'");
      final match = regex.firstMatch(errorMessage);

      if (match != null) {
        // Capture the exact part you want
        final capturedMessage =
            "size must be between 6 and 6. rejected value: '${match.group(1)}'";
        purchaseCode.addFieldError(capturedMessage);
      } else {
        // If the message format doesn't match, you may still want to log the whole error
        purchaseCode.addFieldError("Unexpected error: ${errorMessage}");
      }
      emitFailure(failureResponse: 'An error occurred. Please try again.');
    }
  }
}
