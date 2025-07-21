/// Helper class for timestamp parsing and manipulation
abstract class TimestampHelper {
  /// Parses a timestamp string to DateTime
  /// Returns current DateTime if parsing fails or string is null
  static DateTime parseTimestamp(String? timestampString) {
    if (timestampString == null || timestampString.isEmpty) {
      return DateTime.now();
    }
    try {
      return DateTime.parse(timestampString);
    } catch (e) {
      return DateTime.now();
    }
  }
}
