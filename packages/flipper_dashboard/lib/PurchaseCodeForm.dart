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

  PurchaseCodeFormBloc({
    required this.customerNameController,
    required this.formKey,
    required this.amount,
    required this.discount,
    required this.paymentType,
    required this.transaction,
    required this.context,
  }) {
    addFieldBlocs(fieldBlocs: [purchaseCode]);
  }

  @override
  void onSubmitting() async {
    try {
      final response = await finalizePayment(
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
      purchaseCode
          .addFieldError('Timeout or internal server error, try again!');
      emitFailure(failureResponse: 'An error occurred. Please try again.');
    }
  }
}
