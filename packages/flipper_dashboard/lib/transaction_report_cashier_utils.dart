import 'package:flutter/material.dart';

/// True for RFC-style UUIDs or long opaque hex/hyphen ids (not a human-readable id).
bool agentIdLooksLikeOpaqueTechnicalId(String agentId) {
  final id = agentId.trim();
  if (id.isEmpty) return false;
  final uuid = RegExp(
    r'^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$',
    caseSensitive: false,
  );
  if (uuid.hasMatch(id)) return true;
  if (id.length >= 24 &&
      id.length <= 72 &&
      RegExp(r'^[0-9a-fA-F-]+$').hasMatch(id)) {
    return true;
  }
  return false;
}

/// Pretty label from agent id (email local-part → title case words).
String cashierLabelFromAgentId(String agentId) {
  final id = agentId.trim();
  if (id.isEmpty) return 'User';
  if (id.contains('@')) {
    final namePart = id.split('@').first;
    final parts = namePart.replaceAll('_', '.').split('.');
    return parts
        .where((p) => p.isNotEmpty)
        .map(
          (p) => '${p[0].toUpperCase()}${p.substring(1).toLowerCase()}',
        )
        .join(' ');
  }
  return id;
}

String initialsFromLabel(String label) {
  final parts = label.trim().split(' ').where((p) => p.isNotEmpty).toList();
  if (parts.isEmpty) return 'U';
  if (parts.length == 1) return parts.first[0].toUpperCase();
  return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
}

/// Stable accent for cashier avatars when not using mock profiles.
Color cashierAccentColorForAgentId(String agentId) {
  const palette = <Color>[
    Color(0xFF2563EB),
    Color(0xFF7C3AED),
    Color(0xFF0D9488),
    Color(0xFFEA580C),
  ];
  final id = agentId.trim();
  if (id.isEmpty) return palette[0];
  return palette[id.hashCode.abs() % palette.length];
}
