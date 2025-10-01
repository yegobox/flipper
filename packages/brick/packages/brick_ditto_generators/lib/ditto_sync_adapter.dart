/// Annotation to mark a class for Ditto synchronization adapter generation.
class DittoAdapter {
  /// The collection name in Ditto for this model.
  final String collectionName;

  /// Creates a DittoAdapter annotation.
  const DittoAdapter(this.collectionName);
}
