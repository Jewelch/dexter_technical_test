/// Helper class for timestamp parsing and manipulation
final class TimestampHelper {
  const TimestampHelper._();

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
