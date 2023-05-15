class FlipperError {
  FlipperError(); // Prevent use as mixin.

  /// Safely convert a value to a [String] description.
  ///
}

/// Thrown by operations that have not been implemented yet.
///
/// This [Error] is thrown by missing branchId
///
/// If the method is expecting the branchId and is missing it should throw this error
/// an [UnsupportedError] instead. This error is only intended for
/// use during development.
class MissingBranchIdError extends Error {
  final String? message;
  MissingBranchIdError([this.message]);
  String toString() {
    var message = this.message;
    return (message != null)
        ? "MissingBranchIdError: $message"
        : "MissingBranchIdError";
  }
}
