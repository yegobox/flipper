// lib/src/models/sync_document.dart
import 'dart:convert';

/// Represents a document that can be synced between peers
class SyncDocument {
  /// Unique identifier for this document
  final String id;

  /// Collection this document belongs to
  final String collection;

  /// The actual data stored in this document
  final Map<String, dynamic> data;

  /// When this document was created
  final DateTime createdAt;

  /// When this document was last updated
  final DateTime updatedAt;

  /// ID of the peer that created this document
  final String createdBy;

  /// ID of the peer that last updated this document
  final String updatedBy;

  /// Version of this document (increments with each update)
  final int version;

  /// Whether this document has been deleted
  final bool deleted;

  SyncDocument({
    required this.id,
    required this.collection,
    required this.data,
    required this.createdAt,
    required this.updatedAt,
    required this.createdBy,
    required this.updatedBy,
    this.version = 1,
    this.deleted = false,
  });

  /// Create a document from JSON
  factory SyncDocument.fromJson(Map<String, dynamic> json) {
    return SyncDocument(
      id: json['id'],
      collection: json['collection'],
      data: Map<String, dynamic>.from(json['data']),
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      createdBy: json['createdBy'],
      updatedBy: json['updatedBy'],
      version: json['version'] ?? 1,
      deleted: json['deleted'] ?? false,
    );
  }

  /// Convert document to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'collection': collection,
      'data': data,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'createdBy': createdBy,
      'updatedBy': updatedBy,
      'version': version,
      'deleted': deleted,
    };
  }

  /// Create a copy of this document with updated fields
  SyncDocument copyWith({
    String? id,
    String? collection,
    Map<String, dynamic>? data,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? createdBy,
    String? updatedBy,
    int? version,
    bool? deleted,
  }) {
    return SyncDocument(
      id: id ?? this.id,
      collection: collection ?? this.collection,
      data: data ?? this.data,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      createdBy: createdBy ?? this.createdBy,
      updatedBy: updatedBy ?? this.updatedBy,
      version: version ?? this.version + 1, // Increment version by default
      deleted: deleted ?? this.deleted,
    );
  }

  /// Serialize the document to a string
  String serialize() {
    return json.encode(toJson());
  }

  /// Deserialize a document from a string
  static SyncDocument deserialize(String data) {
    return SyncDocument.fromJson(json.decode(data));
  }
}
