import 'package:flutter/material.dart';

class LoadingStateHandler extends StatelessWidget {
  final bool isLoading;
  final String? error;
  final Widget child;

  const LoadingStateHandler({
    required this.isLoading,
    required this.error,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    if (error != null) {
      return Center(child: Text('Error: $error'));
    }
    return isLoading ? const Center(child: CircularProgressIndicator()) : child;
  }
}
