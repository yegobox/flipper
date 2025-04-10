// lib/src/models/peer.dart
import 'dart:convert';

/// Represents a peer device in the P2P network
class Peer {
  /// Unique identifier for the peer
  final String id;
  
  /// Human-readable name of the peer
  final String name;
  
  /// Device type (e.g., "mobile", "tablet", "desktop")
  final String deviceType;
  
  /// Address used for communication (e.g., Bluetooth MAC address)
  final String address;
  
  /// Whether this peer is currently connected
  bool isConnected;
  
  /// Last time this peer was seen
  DateTime lastSeen;
  
  /// Metadata associated with this peer
  Map<String, dynamic> metadata;
  
  Peer({
    required this.id,
    required this.name,
    required this.address,
    this.deviceType = 'mobile',
    this.isConnected = false,
    DateTime? lastSeen,
    Map<String, dynamic>? metadata,
  }) : 
    this.lastSeen = lastSeen ?? DateTime.now(),
    this.metadata = metadata ?? {};
  
  /// Create a Peer from JSON
  factory Peer.fromJson(Map<String, dynamic> json) {
    return Peer(
      id: json['id'],
      name: json['name'],
      address: json['address'],
      deviceType: json['deviceType'] ?? 'mobile',
      isConnected: json['isConnected'] ?? false,
      lastSeen: json['lastSeen'] != null 
          ? DateTime.parse(json['lastSeen']) 
          : DateTime.now(),
      metadata: json['metadata'] ?? {},
    );
  }
  
  /// Convert Peer to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'address': address,
      'deviceType': deviceType,
      'isConnected': isConnected,
      'lastSeen': lastSeen.toIso8601String(),
      'metadata': metadata,
    };
  }
  
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Peer &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}

