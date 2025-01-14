
// // Core payment processing class
// import 'package:flipper_dashboard/services/payment_service.dart';
// import 'package:flipper_models/helperModels/talker.dart';
// import 'package:flipper_models/view_models/mixins/riverpod_states.dart';
// import 'package:flipper_services/proxy.dart';
// import 'package:supabase_models/brick/models/all_models.dart';
// import 'package:flutter/material.dart';
// import 'package:supabase_models/brick/repository.dart';
// class PaymentProcessor {
//   final ITransaction transaction;
//   final Function onComplete;
//   final List<Payment> paymentMethods;
//   final BuildContext context;
//   final GlobalKey<FormState> formKey;
//   final TextEditingController receivedAmountController;
//   final TextEditingController discountController;
//   final TextEditingController paymentTypeController;
//   final TextEditingController customerNameController;

//   PaymentProcessor({
//     required this.transaction,
//     required this.onComplete,
//     required this.paymentMethods,
//     required this.context,
//     required this.formKey,
//     required this.receivedAmountController,
//     required this.discountController,
//     required this.paymentTypeController,
//     required this.customerNameController, required PaymentService paymentService,
//   });

//   Future<void> startTransaction() async {
//     try {
//       await _validateAndSavePaymentMethods();
//       await _processPayment();
//     } catch (e, s) {
//       _handleError(e, s);
//     }
//   }

//   Future<void> _validateAndSavePaymentMethods() async {
//     if (transaction.subTotal == 0) {
//       throw Exception("No Payable");
//     }

//     for (var payment in paymentMethods) {
//       await ProxyService.strategy.savePaymentType(
//         singlePaymentOnly: paymentMethods.length == 1,
//         amount: payment.amount,
//         transactionId: transaction.id,
//         paymentMethod: payment.method,
//       );
//     }
//   }

//   Future<void> _processPayment() async {
//     final PaymentDetails details = await _getPaymentDetails();
//     if (!details.isValid) return;

//     final customer = await _getCustomer();
//     final branchId = await _getBranchId();

//     if (await _shouldProcessElectronicPayment(branchId)) {
//       await _handleElectronicPayment(customer, branchId, details);
//     } else {
//       await _handleCashPayment(customer, details);
//     }

//     await _refreshTransactionItems(transaction.id);
//   }

//   Future<PaymentDetails> _getPaymentDetails() async {
//     return PaymentDetails(
//       amount: double.tryParse(receivedAmountController.text) ?? 0,
//       discount: double.tryParse(discountController.text) ?? 0,
//       isValid: formKey.currentState?.validate() ?? true,
//     );
//   }

//   Future<Customer?> _getCustomer() async {
//     return (await ProxyService.strategy.customers(
//       id: transaction.customerId ?? "0",
//       branchId: ProxyService.box.getBranchId()!,
//     )).firstOrNull;
//   }

//   Future<String> _getBranchId() async {
//     return (await ProxyService.strategy.activeBranch()).id;
//   }

//   Future<bool> _shouldProcessElectronicPayment(String branchId) async {
//     return await ProxyService.strategy.isBranchEnableForPayment(
//       currentBranchId: branchId,
//     );
//   }

//   Future<void> _handleElectronicPayment(
//     Customer? customer,
//     String branchId,
//     PaymentDetails details,
//   ) async {
//     final phoneNumber = _getPhoneNumber(customer);
//     await _sendpaymentRequest(
//       phoneNumber: phoneNumber,
//       branchId: branchId,
//       finalPrice: details.amount.toInt(),
//     );

//     await _setupPaymentListener(
//       phoneNumber: phoneNumber,
//       details: details,
//       customer: customer,
//     );
//   }

//   String _getPhoneNumber(Customer? customer) {
//     if (customer != null) {
//       return customer.telNo!.replaceAll("+", "");
//     }
//     return "250" + ProxyService.box.currentSaleCustomerPhoneNumber()!;
//   }

//   Future<void> _setupPaymentListener({
//     required String phoneNumber,
//     required PaymentDetails details,
//     required Customer? customer,
//   }) async {
//     await ProxyService.strategy.upsertPayment(CustomerPayments(
//       phoneNumber: phoneNumber,
//       paymentStatus: "pending",
//       transactionId: transaction.id,
//     ));

//     final query = Query(where: [
//       Where('transactionId').isExactly(transaction.id),
//       Where('paymentStatus').isExactly('completed'),
//     ]);

//     Repository()
//         .subscribeToRealtime<CustomerPayments>(query: query)
//         .listen(
//           (data) => _handlePaymentCompletion(data, details, customer),
//           onError: (error) => talker.warning(error),
//         );
//   }

//   Future<void> _handlePaymentCompletion(
//     List<CustomerPayments> data,
//     PaymentDetails details,
//     Customer? customer,
//   ) async {
//     if (data.isEmpty) return;

//     talker.warning(data);
    
//     if (customer == null) {
//       await finalizePayment(
//         formKey: formKey,
//         customerNameController: customerNameController,
//         context: context,
//         paymentType: ProxyService.box.paymentType() ?? "Cash",
//         transactionType: TransactionType.sale,
//         transaction: transaction,
//         amount: details.amount,
//         onComplete: onComplete,
//         discount: details.discount,
//       );
//     } else {
//       await additionalInformationIsRequiredToCompleteTransaction(
//         amount: details.amount,
//         onComplete: onComplete,
//         discount: details.discount,
//         paymentType: paymentTypeController.text,
//         transaction: transaction,
//         context: context,
//       );
//     }
//   }
  

//   Future<void> _handleCashPayment(
//     Customer? customer,
//     PaymentDetails details,
//   ) async {
//     if (customer == null) {
//       await finalizePayment(
//         formKey: formKey,
//         customerNameController: customerNameController,
//         context: context,
//         paymentType: ProxyService.box.paymentType() ?? "Cash",
//         transactionType: TransactionType.sale,
//         transaction: transaction,
//         amount: details.amount,
//         onComplete: onComplete,
//         discount: details.discount,
//       );
//     } else {
//       await additionalInformationIsRequiredToCompleteTransaction(
//         amount: details.amount,
//         onComplete: onComplete,
//         discount: details.discount,
//         paymentType: paymentTypeController.text,
//         transaction: transaction,
//         context: context,
//       );
//     }
//   }

//   void _handleError(dynamic error, StackTrace stackTrace) {
//     talker.error(error, stackTrace);
//     ref.read(loadingProvider.notifier).stopLoading();
    
//     String errorMessage = error
//         .toString()
//         .split('Caught Exception: ')
//         .last
//         .replaceAll("Exception: ", "");
    
//     _handlePaymentError(errorMessage, stackTrace, context);
//     throw error; // Rethrow for upper-level handling if needed
//   }
// }

// // Data class to hold payment details
// class PaymentDetails {
//   final double amount;
//   final double discount;
//   final bool isValid;

//   PaymentDetails({
//     required this.amount,
//     required this.discount,
//     required this.isValid,
//   });
// }
