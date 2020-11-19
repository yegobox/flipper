// import 'dart:convert';
// import 'dart:io';

// import 'package:flipper/credit_card.dart';
// import 'package:flipper/domain/redux/app_state.dart';
// import 'package:flipper/domain/redux/authentication/auth_actions.dart';
// import 'package:flipper/error_handler/subscription_error.dart';
// import 'package:flipper/external-api/subscription_response.dart';
// import 'package:flipper/extra/card_type.dart';
// import 'package:flipper/generated/l10n.dart';
// import 'package:flipper/managers/dialog_manager.dart';
// import 'package:flipper/presentation/my_strings.dart';
// import 'package:flipper/routes/router.gr.dart';
// import 'package:flipper/style/card_background.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_masked_text/flutter_masked_text.dart';
// import 'package:flutter_redux/flutter_redux.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:http/http.dart' as http;
// import 'package:redux/src/store.dart';

// class Subscription extends StatefulWidget {
//   Subscription(
//       {Key key, this.name, this.avatar, this.email, this.token, this.authType})
//       : super(key: key);
//   final String name;
//   final String avatar;
//   final String email;
//   final String token;
//   final String authType;

//   @override
//   _SubscriptionState createState() => _SubscriptionState();
// }

// class _SubscriptionState extends State<Subscription> {
//   static String validateCardNumWithLuhnAlgorithm(String input) {
//     if (input.isEmpty) {
//       return Strings.fieldReq;
//     }

//     input = input.trim().replaceAll(" ", "");

//     if (input.length < 8) {
//       // No need to even proceed with the validation if it's less than 8 characters
//       return Strings.invalidNumber;
//     }

//     int sum = 0;
//     int length = input.length;
//     for (var i = 0; i < length; i++) {
//       // get digits in reverse order
//       int digit = int.parse(input[length - i - 1]);

//       // every 2nd number multiply with 2
//       if (i % 2 == 1) {
//         digit *= 2;
//       }
//       sum += digit > 9 ? (digit - 9) : digit;
//     }

//     if (sum % 10 == 0) {
//       return null;
//     }

//     return Strings.invalidNumber;
//   }

//   final MaskedTextController _cardNumberController =
//       MaskedTextController(mask: '0000 0000 0000 0000');
//   final TextEditingController _lastNameController = TextEditingController();
//   final TextEditingController _firstNameController = TextEditingController();
//   final TextEditingController _expiryYearController = TextEditingController();
//   final TextEditingController _cvvController = TextEditingController();
//   final _formKey = GlobalKey<FormState>();

//   CardType cardType;
//   String cardNumber;
//   String email;
//   String lastName;
//   String firstName;
//   String expDate;
//   String cvv;
//   @override
//   void initState() {
//     super.initState();
//     _cardNumberController.addListener(() {
//       setState(() {
//         cardNumber = _cardNumberController.text;
//         cardType = detectCCType(_cardNumberController.text);
//       });
//     });
//     _firstNameController.addListener(() {
//       setState(() {
//         firstName = _firstNameController.text;
//       });
//     });
//     _lastNameController.addListener(() {
//       setState(() {
//         lastName = _lastNameController.text;
//       });
//     });
//     _expiryYearController.addListener(() {
//       setState(() {
//         expDate = _expiryYearController.text;
//       });
//     });
//     _cvvController.addListener(() {
//       setState(() {
//         cvv = _cvvController.text;
//       });
//     });
//   }

//   /// Credit Card prefix patterns as of March 2019
//   /// A [List<String>] represents a range.
//   /// i.e. ['51', '55'] represents the range of cards starting with '51' to those starting with '55'
//   Map<CardType, Set<List<String>>> cardNumPatterns =
//       <CardType, Set<List<String>>>{
//     CardType.visa: <List<String>>{
//       <String>['4'],
//     },
//     CardType.americanExpress: <List<String>>{
//       <String>['34'],
//       <String>['37'],
//     },
//     CardType.discover: <List<String>>{
//       <String>['6011'],
//       <String>['60'],
//       <String>['622126', '622925'],
//       <String>['644', '649'],
//       <String>['65']
//     },
//     CardType.masterCard: <List<String>>{
//       <String>['51', '55'],
//       <String>['2221', '2229'],
//       <String>['223', '229'],
//       <String>['23', '26'],
//       <String>['270', '271'],
//       <String>['2720'],
//     },
//   };
//   CardType detectCCType(String cardNumber) {
//     //Default card type is other
//     CardType cardType = CardType
//         .visa; //TODO(richard): change to other once we have icon for that.

//     if (cardNumber.isEmpty || cardNumber == null || cardNumber == '') {
//       return cardType;
//     }
//     cardNumPatterns.forEach(
//       (CardType type, Set<List<String>> patterns) {
//         for (List<String> patternRange in patterns) {
//           // Remove any spaces
//           String ccPatternStr =
//               cardNumber.replaceAll(RegExp(r'\s+\b|\b\s'), '');
//           final int rangeLen = patternRange[0].length;
//           // Trim the Credit Card number string to match the pattern prefix length
//           if (rangeLen < cardNumber.length) {
//             ccPatternStr = ccPatternStr.substring(0, rangeLen);
//           }

//           if (patternRange.length > 1) {
//             // Convert the prefix range into numbers then make sure the
//             // Credit Card num is in the pattern range.
//             // Because Strings don't have '>=' type operators
//             final int ccPrefixAsInt = int.parse(ccPatternStr);
//             final int startPatternPrefixAsInt = int.parse(patternRange[0]);
//             final int endPatternPrefixAsInt = int.parse(patternRange[1]);
//             if (ccPrefixAsInt >= startPatternPrefixAsInt &&
//                 ccPrefixAsInt <= endPatternPrefixAsInt) {
//               // Found a match
//               cardType = type;
//               break;
//             }
//           } else {
//             // Just compare the single pattern prefix with the Credit Card prefix
//             if (ccPatternStr == patternRange[0]) {
//               // Found a match
//               cardType = type;
//               break;
//             }
//           }
//         }
//       },
//     );

//     return cardType;
//   }

//   @override
//   Widget build(BuildContext context) {
//     var cardHolder;
//     if (firstName != null || firstName != '') {
//       setState(() {
//         cardHolder = firstName;
//       });
//     }
//     if (lastName != null || firstName != '') {
//       setState(() {
//         cardHolder = firstName;
//       });
//     }
//     if (lastName != null && firstName != null) {
//       setState(() {
//         cardHolder = firstName.toUpperCase() + " " + lastName.toUpperCase();
//       });
//     }
//     return Scaffold(
//       body: SingleChildScrollView(
//         child: Column(
//           children: <Widget>[
//             Container(
//               height: 40,
//             ),
//             CreditCard(
//               cardNumber: cardNumber,
//               height: 180,
//               cardExpiry: expDate,
//               cardHolderName: cardHolder,
//               cvv: cvv,
//               bankName: "flipper",
//               cardType: cardType,
//               showBackSide: false,
//               frontBackground: CardBackgrounds.black,
//               backBackground: CardBackgrounds.white,
//               showShadow: true,
//             ),
//             Form(
//               key: _formKey,
//               child: Column(
//                 children: <Widget>[
//                   Container(
//                     padding: const EdgeInsets.symmetric(vertical: 2.0),
//                     margin: const EdgeInsets.only(left: 16, top: 16, right: 16),
//                     child: TextFormField(
//                       controller: _cardNumberController,
//                       style: const TextStyle(
//                         color: Colors.blue,
//                       ),
//                       validator: (String value) {
//                         if (value.isEmpty || value == null || value == '') {
//                           return 'Please add valid card';
//                         }
//                         if (validateCardNumWithLuhnAlgorithm(value) ==
//                                 'Invalid card number' ||
//                             validateCardNumWithLuhnAlgorithm(value) ==
//                                 'This field is required') {
//                           return 'Please add valid card';
//                         }
//                         return null;
//                       },
//                       decoration: const InputDecoration(
//                         border: OutlineInputBorder(),
//                         labelText: 'Card number',
//                         hintText: 'xxxx xxxx xxxx xxxx',
//                       ),
//                       onFieldSubmitted: (_) =>
//                           FocusScope.of(context).nextFocus(),
//                       keyboardType: TextInputType.number,
//                       textInputAction: TextInputAction.next,
//                     ),
//                   ),
//                   Container(
//                     padding: const EdgeInsets.symmetric(vertical: 2.0),
//                     margin: const EdgeInsets.only(left: 16, top: 16, right: 16),
//                     child: TextFormField(
//                       controller: _cvvController,
//                       style: TextStyle(
//                         color: Colors.blue,
//                       ),
//                       decoration: InputDecoration(
//                         border: OutlineInputBorder(),
//                         labelText: 'cvv',
//                         hintText: '223',
//                       ),
//                       validator: (value) {
//                         if (value.isEmpty) {
//                           return 'Please add valid cvv';
//                         }
//                         return null;
//                       },
//                       onFieldSubmitted: (_) =>
//                           FocusScope.of(context).nextFocus(),
//                       keyboardType: TextInputType.numberWithOptions(
//                           signed: false, decimal: false),
//                       textInputAction: TextInputAction.next,
//                     ),
//                   ),
//                   Container(
//                     padding: const EdgeInsets.symmetric(vertical: 2.0),
//                     margin: const EdgeInsets.only(left: 16, top: 16, right: 16),
//                     child: TextFormField(
//                       controller: _expiryYearController,
//                       style: TextStyle(
//                         color: Colors.blue,
//                       ),
//                       decoration: InputDecoration(
//                         border: OutlineInputBorder(),
//                         labelText: 'Exp year',
//                         hintText: "MM/YY",
//                       ),
//                       validator: (value) {
//                         if (value.isEmpty) {
//                           return 'Please enter valid expiration date';
//                         }
//                         return null;
//                       },
//                       onChanged: (value) {
//                         setState(() {
//                           value = value.replaceAll(RegExp(r"\D"), "");
//                           switch (value.length) {
//                             case 0:
//                               _expiryYearController.text = "MM/YY";
//                               _expiryYearController.selection =
//                                   TextSelection.collapsed(offset: 0);
//                               break;
//                             case 1:
//                               _expiryYearController.text = "${value}M/YY";
//                               _expiryYearController.selection =
//                                   TextSelection.collapsed(offset: 1);
//                               break;
//                             case 2:
//                               _expiryYearController.text = "$value/YY";
//                               _expiryYearController.selection =
//                                   TextSelection.collapsed(offset: 2);
//                               break;
//                             case 3:
//                               _expiryYearController.text =
//                                   "${value.substring(0, 2)}/${value.substring(2)}Y";
//                               _expiryYearController.selection =
//                                   TextSelection.collapsed(offset: 4);
//                               break;
//                             case 4:
//                               _expiryYearController.text =
//                                   "${value.substring(0, 2)}/${value.substring(2, 4)}";
//                               _expiryYearController.selection =
//                                   TextSelection.collapsed(offset: 5);
//                               break;
//                           }
//                           if (value.length > 4) {
//                             _expiryYearController.text =
//                                 "${value.substring(0, 2)}/${value.substring(2, 4)}";
//                             _expiryYearController.selection =
//                                 TextSelection.collapsed(offset: 5);
//                           }
//                         });
//                       },
//                       onFieldSubmitted: (_) =>
//                           FocusScope.of(context).nextFocus(),
//                       keyboardType: TextInputType.numberWithOptions(
//                           signed: false, decimal: false),
//                       textInputAction: TextInputAction.next,
//                     ),
//                   ),
//                   Container(
//                     padding: const EdgeInsets.symmetric(vertical: 2.0),
//                     margin: const EdgeInsets.only(left: 16, top: 16, right: 16),
//                     child: TextFormField(
//                       controller: _firstNameController,
//                       style: TextStyle(
//                         color: Colors.blue,
//                       ),
//                       decoration: InputDecoration(
//                         border: OutlineInputBorder(),
//                         labelText: 'First Name',
//                         hintText: 'Muragijimana',
//                       ),
//                       validator: (value) {
//                         if (value.isEmpty) {
//                           return 'Please enter your first name';
//                         }
//                         return null;
//                       },
//                       onFieldSubmitted: (_) =>
//                           FocusScope.of(context).nextFocus(),
//                       keyboardType: TextInputType.text,
//                       textInputAction: TextInputAction.next,
//                     ),
//                   ),
//                   Container(
//                     padding: const EdgeInsets.symmetric(vertical: 2.0),
//                     margin: const EdgeInsets.only(left: 16, top: 16, right: 16),
//                     child: TextFormField(
//                       controller: _lastNameController,
//                       style: TextStyle(
//                         color: Colors.blue,
//                       ),
//                       decoration: InputDecoration(
//                         border: OutlineInputBorder(),
//                         labelText: 'Last Name',
//                         hintText: 'Richard',
//                       ),
//                       validator: (value) {
//                         if (value.isEmpty) {
//                           return 'Please enter your last name';
//                         }
//                         return null;
//                       },
//                       onFieldSubmitted: (_) =>
//                           FocusScope.of(context).nextFocus(),
//                       keyboardType: TextInputType.text,
//                       textInputAction: TextInputAction.next,
//                     ),
//                   )
//                 ],
//               ),
//             ),
//             Container(
//               margin: const EdgeInsets.only(left: 16, top: 2, right: 16),
//               child: Center(
//                 child: SizedBox(
//                   width: 380,
//                   height: 60,
//                   child: FlatButton(
//                     color: Colors.blue,
//                     child: Text(
//                       S.of(context).pay,
//                       style: TextStyle(color: Colors.white),
//                     ),
//                     onPressed: () async {
//                       final store = StoreProvider.of<AppState>(context);

//                       if (_formKey.currentState.validate()) {
//                         Manager.showLoader(context);
//                         http.post(
//                             "https://mysterious-depths-19225.herokuapp.com/subscribe",
//                             body: {
//                               'card': cardNumber.trim().replaceAll(" ", ""),
//                               'expirymonth': expDate.split('/')[0],
//                               'expiryyear': expDate.split('/')[1],
//                               'cvv': cvv,
//                               'email': store.state.user.email,
//                               'firstname': firstName
//                             }).then((dynamic response) {
//                           final int statusCode = response.statusCode;
//                           if (statusCode < 200 ||
//                               statusCode > 400 ||
//                               json == null) {
//                             final subscriptionError =
//                                 subscriptionErrorFromJson(response.body);
//                             Fluttertoast.showToast(
//                                 msg: subscriptionError.message.message,
//                                 toastLength: Toast.LENGTH_LONG,
//                                 gravity: ToastGravity.BOTTOM,
//                                 timeInSecForIos: 1,
//                                 backgroundColor: Colors.red,
//                                 textColor: Colors.white,
//                                 fontSize: 16.0);
//                             return;
//                           }
//                           //TODO(richard): call authUrl for confirming subscription in a browser.
//                           Manager.dismissDialog();
//                           final subscriptionResponse =
//                               subscriptionResponseFromJson(response.body);
//                           if (subscriptionResponse.message.status ==
//                               'success') {
//                             //TODO(richard): update the couch with user payment info.
//                             //TODO(richard): log today payment date then build up the cron for the next payment enforcement.
//                             confirmFlipper(
//                                 store, subscriptionResponse.message.data);
//                           }
//                         }).catchError((dynamic onError) {
//                           Manager.dismissDialog();
//                         });
//                       }
//                     },
//                   ),
//                 ),
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }

//   void confirmFlipper(Store<AppState> store, RData data) {
//     http.post("https://test.flipper.rw/api/activate_subscription", headers: {
//       HttpHeaders.authorizationHeader: "Bearer " + store.state.user.token
//     }, body: {
//       'subscribed': 'subscribed',
//       'txRef': data.txRef,
//       'flwRef': data.flwRef,
//       'raveRef': data.raveRef,
//       'flutter_customer_id':
//           data.customer == null ? data.customerId : data.customer.id.toString(),
//       'flutter_customer_accountId': data.customer == null
//           ? data.accountId
//           : data.customer.accountId.toString(),
//       'amount': data.amount.toString(),
//       'currency': data.currency,
//       'app': 'flipper',
//       'customer_name':
//           data.customer == null ? firstName + lastName : data.customer.fullName
//     }).then((dynamic response) {
//       final int statusCode = response.statusCode;
//       if (statusCode < 200 || statusCode > 400 || json == null) {}
//       if (widget.authType == 'register') {
//         Routing.navigator.pushNamed(
//           Routing.signUpScreen,
//           arguments: SignUpScreenArguments(
//             name: widget.name,
//             avatar: widget.avatar,
//             email: widget.email,
//             token: widget.token,
//           ),
//         );
//       } else if (widget.authType == 'login') {
//         store.dispatch(VerifyAuthenticationState());
//       }
//     }).catchError((dynamic onError) {});
//   }
// }
