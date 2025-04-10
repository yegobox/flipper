import 'dart:convert';
import 'sync_document.dart';

/// A model class for sync documents that works with database operations
class SyncDocumentModel {
  /// Unique identifier for this document
  final String documentId;

  /// Collection this document belongs to
  final String collection;

  /// The actual data stored in this document as a JSON string
  final String data;

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

  SyncDocumentModel({
    required this.documentId,
    required this.collection,
    required this.data,
    required this.createdAt,
    required this.updatedAt,
    required this.createdBy,
    required this.updatedBy,
    this.version = 1,
    this.deleted = false,
  });

  /// Convert from a SyncDocument to a SyncDocumentModel
  factory SyncDocumentModel.fromSyncDocument(SyncDocument doc) {
    return SyncDocumentModel(
      documentId: doc.id,
      collection: doc.collection,
      data: jsonEncode(doc.data),
      createdAt: doc.createdAt,
      updatedAt: doc.updatedAt,
      createdBy: doc.createdBy,
      updatedBy: doc.updatedBy,
      version: doc.version,
      deleted: doc.deleted,
    );
  }

  /// Convert to a SyncDocument
  SyncDocument toSyncDocument() {
    return SyncDocument(
      id: documentId,
      collection: collection,
      data: jsonDecode(data),
      createdAt: createdAt,
      updatedAt: updatedAt,
      createdBy: createdBy,
      updatedBy: updatedBy,
      version: version,
      deleted: deleted,
    );
  }
  
  /// Convert to a map for database storage
  Map<String, dynamic> toMap() {
    return {
      'id': documentId,
      'collection': collection,
      'data': data,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'created_by': createdBy,
      'updated_by': updatedBy,
      'version': version,
      'deleted': deleted ? 1 : 0,
    };
  }
  
  /// Create a SyncDocumentModel from a database map
  factory SyncDocumentModel.fromMap(Map<String, dynamic> map) {
    return SyncDocumentModel(
      documentId: map['id'] as String,
      collection: map['collection'] as String,
      data: map['data'] as String,
      createdAt: DateTime.parse(map['created_at'] as String),
      updatedAt: DateTime.parse(map['updated_at'] as String),
      createdBy: map['created_by'] as String,
      updatedBy: map['updated_by'] as String,
      version: map['version'] as int,
      deleted: (map['deleted'] as int) == 1,
    );
  }
}


