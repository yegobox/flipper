/// Utility functions for string operations in the Flipper application.

/// Safely gets a substring from a string, handling null strings, empty strings,
/// and out of bounds indices.
///
/// [str] The string to get a substring from.
/// [start] The start index of the substring (inclusive).
/// [end] The end index of the substring (exclusive). If null, returns from [start] to the end of the string.
/// [ellipsis] Whether to add an ellipsis ('...') at the end if the string was truncated.
///
/// Returns the substring, or an empty string if the input is null or empty.
String safeSubstring(String? str, int start,
    {int? end, bool ellipsis = false}) {
  // Handle null or empty strings
  if (str == null || str.isEmpty) {
    return '';
  }

  // Ensure start is within bounds
  start = start.clamp(0, str.length);

  // If end is null, use the string length
  // Otherwise ensure end is within bounds and not less than start
  end = end == null ? str.length : end.clamp(start, str.length);

  // Get the substring
  final result = str.substring(start, end);

  // Add ellipsis if requested and the string was actually truncated
  if (ellipsis && end < str.length) {
    return '$result...';
  }

  return result;
}
