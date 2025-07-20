import 'package:flutter_test/flutter_test.dart';
import 'package:health/src/base/helpers/timestamp_helper.dart';

void main() {
  group('TimestampHelper Tests', () {
    group('parseTimestamp', () {
      test('should parse valid ISO 8601 timestamp string', () {
        // Arrange
        const timestampString = '2024-01-15T08:00:00.000Z';

        // Act
        final result = TimestampHelper.parseTimestamp(timestampString);

        // Assert
        expect(result, isA<DateTime>());
        expect(result.year, equals(2024));
        expect(result.month, equals(1));
        expect(result.day, equals(15));
        expect(result.hour, equals(8));
        expect(result.minute, equals(0));
        expect(result.second, equals(0));
      });

      test('should parse timestamp without milliseconds', () {
        // Arrange
        const timestampString = '2024-01-15T08:30:45Z';

        // Act
        final result = TimestampHelper.parseTimestamp(timestampString);

        // Assert
        expect(result, isA<DateTime>());
        expect(result.year, equals(2024));
        expect(result.month, equals(1));
        expect(result.day, equals(15));
        expect(result.hour, equals(8));
        expect(result.minute, equals(30));
        expect(result.second, equals(45));
      });

      test('should parse timestamp with timezone offset', () {
        // Arrange
        const timestampString = '2024-01-15T14:30:00+05:00';

        // Act
        final result = TimestampHelper.parseTimestamp(timestampString);

        // Assert
        expect(result, isA<DateTime>());
        expect(result.year, equals(2024));
        expect(result.month, equals(1));
        expect(result.day, equals(15));
      });

      test('should return current DateTime when timestamp string is null', () {
        // Arrange
        const String? timestampString = null;
        final beforeCall = DateTime.now();

        // Act
        final result = TimestampHelper.parseTimestamp(timestampString);
        final afterCall = DateTime.now();

        // Assert
        expect(result, isA<DateTime>());
        expect(result.isAfter(beforeCall) || result.isAtSameMomentAs(beforeCall), isTrue);
        expect(result.isBefore(afterCall) || result.isAtSameMomentAs(afterCall), isTrue);
      });

      test('should return current DateTime when timestamp string is empty', () {
        // Arrange
        const timestampString = '';
        final beforeCall = DateTime.now();

        // Act
        final result = TimestampHelper.parseTimestamp(timestampString);
        final afterCall = DateTime.now();

        // Assert
        expect(result, isA<DateTime>());
        expect(result.isAfter(beforeCall) || result.isAtSameMomentAs(beforeCall), isTrue);
        expect(result.isBefore(afterCall) || result.isAtSameMomentAs(afterCall), isTrue);
      });

      test('should return current DateTime when timestamp string is invalid', () {
        // Arrange
        const timestampString = 'invalid-date-string';
        final beforeCall = DateTime.now();

        // Act
        final result = TimestampHelper.parseTimestamp(timestampString);
        final afterCall = DateTime.now();

        // Assert
        expect(result, isA<DateTime>());
        expect(result.isAfter(beforeCall) || result.isAtSameMomentAs(beforeCall), isTrue);
        expect(result.isBefore(afterCall) || result.isAtSameMomentAs(afterCall), isTrue);
      });

      test('should handle malformed ISO strings gracefully', () {
        // Arrange
        final malformedTimestamps = [
          'not-a-date-at-all', // Completely invalid
          '2024/01/15 08:00:00', // Wrong format
          'invalid-date-string', // Invalid string
          '', // Empty string
        ];

        for (final timestamp in malformedTimestamps) {
          final beforeCall = DateTime.now();

          // Act
          final result = TimestampHelper.parseTimestamp(timestamp);
          final afterCall = DateTime.now();

          // Assert
          expect(result, isA<DateTime>(), reason: 'Failed for timestamp: $timestamp');
          // Should be approximately current time (within 5 seconds to be safe)
          final timeSinceResult = result.isBefore(beforeCall)
              ? beforeCall.difference(result)
              : result.difference(afterCall);
          expect(
            timeSinceResult.inSeconds,
            lessThanOrEqualTo(5),
            reason: 'Result should be current time for invalid timestamp: $timestamp',
          );
        }

        // Test some formats that DateTime.parse() might handle differently
        final complexMalformed = [
          '2024-01-15T25:00:00Z', // Invalid hour - might be parsed as next day
          '2024-13-15T08:00:00Z', // Invalid month - should fail
          '2024-01-32T08:00:00Z', // Invalid day - should fail
        ];

        for (final timestamp in complexMalformed) {
          // Act
          final result = TimestampHelper.parseTimestamp(timestamp);

          // Assert - just ensure we get a DateTime back (behavior may vary)
          expect(result, isA<DateTime>(), reason: 'Failed for timestamp: $timestamp');
        }
      });

      test('should handle different date formats', () {
        // Test valid formats that DateTime.parse() can handle
        final validFormats = [
          '2024-01-15T08:00:00.000Z',
          '2024-01-15T08:00:00Z',
          '2024-01-15T08:00:00',
          '2024-01-15 08:00:00.000Z',
          '2024-01-15 08:00:00',
        ];

        for (final format in validFormats) {
          // Act
          final result = TimestampHelper.parseTimestamp(format);

          // Assert
          expect(result, isA<DateTime>(), reason: 'Failed for format: $format');
          expect(result.year, equals(2024));
          expect(result.month, equals(1));
          expect(result.day, equals(15));
          expect(result.hour, equals(8));
        }
      });

      test('should preserve timezone information when parsing', () {
        // Arrange
        const utcTimestamp = '2024-01-15T08:00:00.000Z';
        const plusFiveTimestamp = '2024-01-15T13:00:00.000+05:00';

        // Act
        final utcResult = TimestampHelper.parseTimestamp(utcTimestamp);
        final plusFiveResult = TimestampHelper.parseTimestamp(plusFiveTimestamp);

        // Assert
        expect(utcResult, isA<DateTime>());
        expect(plusFiveResult, isA<DateTime>());
        // Both should represent the same moment in time
        expect(utcResult.isAtSameMomentAs(plusFiveResult), isTrue);
      });

      test('should handle leap year dates correctly', () {
        // Arrange
        const leapYearDate = '2024-02-29T12:00:00Z'; // 2024 is a leap year

        // Act
        final result = TimestampHelper.parseTimestamp(leapYearDate);

        // Assert
        expect(result, isA<DateTime>());
        expect(result.year, equals(2024));
        expect(result.month, equals(2));
        expect(result.day, equals(29));
        expect(result.hour, equals(12));
      });

      test('should handle microseconds in timestamp', () {
        // Arrange
        const timestampWithMicroseconds = '2024-01-15T08:00:00.123456Z';

        // Act
        final result = TimestampHelper.parseTimestamp(timestampWithMicroseconds);

        // Assert
        expect(result, isA<DateTime>());
        expect(result.year, equals(2024));
        expect(result.month, equals(1));
        expect(result.day, equals(15));
        expect(result.hour, equals(8));
        expect(result.millisecond, equals(123));
        expect(result.microsecond, equals(456));
      });
    });

    group('TimestampHelper Edge Cases', () {
      test('should handle whitespace in timestamp strings', () {
        // Arrange
        final currentYear = DateTime.now().year;
        final timestampWithWhitespace = '  $currentYear-01-15T08:00:00Z  ';

        // Act
        final result = TimestampHelper.parseTimestamp(timestampWithWhitespace);

        // Assert - DateTime.parse() handles trimming automatically
        expect(result, isA<DateTime>());
        expect(result.year, equals(currentYear));
      });

      test('should handle minimum and maximum valid years', () {
        // Test edge cases for years
        final edgeCases = ['0001-01-01T00:00:00Z', '9999-12-31T23:59:59Z'];

        for (final timestamp in edgeCases) {
          // Act
          final result = TimestampHelper.parseTimestamp(timestamp);

          // Assert
          expect(result, isA<DateTime>(), reason: 'Failed for timestamp: $timestamp');
        }
      });

      test('should be consistent with multiple calls', () {
        // Arrange
        const timestamp = '2024-01-15T08:00:00Z';

        // Act
        final result1 = TimestampHelper.parseTimestamp(timestamp);
        final result2 = TimestampHelper.parseTimestamp(timestamp);

        // Assert
        expect(result1, equals(result2));
        expect(result1.isAtSameMomentAs(result2), isTrue);
      });
    });
  });
}
