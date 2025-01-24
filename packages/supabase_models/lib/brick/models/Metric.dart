import 'package:flutter/material.dart';

class Metric {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  Metric({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });
}
