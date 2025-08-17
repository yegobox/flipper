// import 'package:flipper_mfa/flipper_mfa.dart';
// import 'package:flipper_models/db_model_export.dart';
// import 'package:flipper_services/proxy.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:qr_flutter/qr_flutter.dart';

// class MfaSetupView extends ConsumerStatefulWidget {
//   const MfaSetupView({Key? key}) : super(key: key);

//   @override
//   ConsumerState<MfaSetupView> createState() => _MfaSetupViewState();
// }

// class _MfaSetupViewState extends ConsumerState<MfaSetupView> {
//   String? _secret;
//   QrPainter? _qrPainter;
//   bool _isLoading = true;
//   String? _error;

//   @override
//   void initState() {
//     super.initState();
//     _loadMfaSecret();
//   }

//   Future<void> _loadMfaSecret() async {
//     try {
//       final userId = ProxyService.box.getUserId();
//       if (userId == null) {
//         setState(() {
//           _error = 'User not logged in';
//           _isLoading = false;
//         });
//         return;
//       }

//       final userMfaSecretRepository = UserMfaSecretRepository(ProxyService.supabase.client);
//       UserMfaSecret? existingSecret = await userMfaSecretRepository.getSecretByUserId(userId);

//       if (existingSecret != null) {
//         _secret = existingSecret.secret;
//         _generateQrCode(existingSecret.secret);
//       } else {
//         // Generate a new secret if one doesn't exist
//         _secret = MfaService().generateSecret();
//         _generateQrCode(_secret!);
//         // Save the new secret to the database
//         await userMfaSecretRepository.addSecret(UserMfaSecret(
//           userId: userId,
//           secret: _secret!,
//           issuer: 'Flipper',
//           accountName: ProxyService.box.getUserPhone(), // Use user's phone as account name
//         ));
//       }
//     } catch (e) {
//       setState(() {
//         _error = 'Error loading/generating MFA secret: ${e.toString()}';
//       });
//     } finally {
//       setState(() {
//         _isLoading = false;
//       });
//     }
//   }

//   void _generateQrCode(String secret) {
//     _qrPainter = MfaService().generateQrCode(
//       secret: secret,
//       issuer: 'Flipper',
//       accountName: ProxyService.box.getUserPhone(),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (_isLoading) {
//       return const Scaffold(
//         appBar: AppBar(title: Text('Authenticator Setup')),
//         body: Center(child: CircularProgressIndicator()),
//       );
//     }

//     if (_error != null) {
//       return Scaffold(
//         appBar: AppBar(title: Text('Authenticator Setup')),
//         body: Center(child: Text(_error!)),
//       );
//     }

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Authenticator Setup'),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             const Text(
//               'Scan this QR code with your authenticator app',
//               style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//               textAlign: TextAlign.center,
//             ),
//             const SizedBox(height: 20),
//             if (_qrPainter != null)
//               SizedBox(
//                 width: 200,
//                 height: 200,
//                 child: CustomPaint(
//                   painter: _qrPainter,
//                 ),
//               )
//             else
//               const Text('Failed to generate QR code'),
//             const SizedBox(height: 20),
//             Text(
//               'Secret: $_secret',
//               style: const TextStyle(fontSize: 14),
//             ),
//             const SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: () {
//                 // Optionally, provide a way to copy the secret or regenerate
//                 // For now, just pop the screen
//                 Navigator.of(context).pop();
//               },
//               child: const Text('Done'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
