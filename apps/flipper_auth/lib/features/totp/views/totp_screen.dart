// lib/features/totp/views/totp_screen.dart
import 'dart:async';

import 'package:flipper_auth/features/totp/providers/providers/totp_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TOTPScreen extends ConsumerStatefulWidget {
  @override
  ConsumerState<TOTPScreen> createState() => _TOTPScreenState();
}

class _TOTPScreenState extends ConsumerState<TOTPScreen> {
  @override
  void initState() {
    super.initState();
    // Load accounts when the screen is initialized
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(totpNotifierProvider.notifier).loadAccounts();
    });
  }

  @override
  Widget build(BuildContext context) {
    final totpState = ref.watch(totpNotifierProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Authenticator')),
      body: totpState.isLoading
          ? const Center(child: CircularProgressIndicator())
          : totpState.error != null
              ? Center(child: Text(totpState.error!))
              : ListView.builder(
                  itemCount: totpState.accounts.length,
                  itemBuilder: (context, index) {
                    final account = totpState.accounts[index];
                    return ListTile(
                      title: Text(account['issuer']),
                      subtitle: Text(account['account_name']),
                      trailing: TOTPDisplay(secret: account['secret']),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, '/add-totp'),
        child: const Icon(Icons.add),
      ),
    );
  }
}

class TOTPDisplay extends ConsumerStatefulWidget {
  final String secret;

  const TOTPDisplay({super.key, required this.secret});

  @override
  ConsumerState<TOTPDisplay> createState() => _TOTPDisplayState();
}

class _TOTPDisplayState extends ConsumerState<TOTPDisplay> {
  Timer? _timer;
  String _currentCode = '';
  int _remainingSeconds = 0;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _updateCode();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => _updateCode());
  }

  void _updateCode() {
    final now = DateTime.now();
    final remainingSeconds = 30 - (now.second % 30);
    
    try {
      if (widget.secret.isEmpty) {
        throw Exception('Invalid secret');
      }
      
      final code = ref.read(totpNotifierProvider.notifier).generateCode(widget.secret);
      
      setState(() {
        _currentCode = code;
        _remainingSeconds = remainingSeconds;
        _errorMessage = null;
      });
    } catch (e) {
      debugPrint('TOTP generation error: $e');
      setState(() {
        _currentCode = '------';
        _remainingSeconds = remainingSeconds;
        _errorMessage = 'Code generation failed';
      });
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to generate TOTP code')),
        );
      }
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _timer = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          _currentCode,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: _errorMessage != null ? Colors.red : null,
          ),
        ),
        Text('$_remainingSeconds s'),
      ],
    );
  }
}
