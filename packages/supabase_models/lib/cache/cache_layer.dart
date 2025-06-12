/// Abstract interface for cache providers
/// This allows for switching between different cache implementations
abstract class CacheLayer<T> {
  /// Initialize the cache
  Future<void> initialize();

  /// Save an item to the cache
  Future<void> save(T item);

  /// Save multiple items to the cache
  Future<void> saveAll(List<T> items);

  /// Get an item from the cache by its ID
  Future<T?> get(String id);

  /// Get all items from the cache that match the given criteria
  Future<List<T>> getAll({Map<String, dynamic>? filter});

  /// Clear all items from the cache
  Future<void> clear();

  /// Close the cache connection
  Future<void> close();
}
