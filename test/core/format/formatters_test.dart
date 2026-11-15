import 'package:fitness_pro/core/format/formatters.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('formatDate', () {
    test('day, short month, year', () {
      expect(formatDate(DateTime(2027, 2, 11)), '11 Feb 2027');
      expect(formatDate(DateTime(2026, 12, 1)), '1 Dec 2026');
    });
  });

  group('formatDateTime', () {
    final now = DateTime(2026, 11, 11);

    test('uses a 12-hour clock and hides the current year', () {
      expect(formatDateTime(DateTime(2026, 11, 11, 9, 5), now: now),
          '11 Nov, 9:05 AM');
      expect(formatDateTime(DateTime(2026, 11, 11, 0, 30), now: now),
          '11 Nov, 12:30 AM');
      expect(formatDateTime(DateTime(2026, 11, 11, 12, 0), now: now),
          '11 Nov, 12:00 PM');
      expect(formatDateTime(DateTime(2026, 11, 11, 21, 45), now: now),
          '11 Nov, 9:45 PM');
    });

    test('shows the year for other years', () {
      expect(formatDateTime(DateTime(2025, 3, 2, 8, 0), now: now),
          '2 Mar 2025, 8:00 AM');
    });
  });

  group('formatTaka', () {
    test('groups digits the Bangladeshi way', () {
      expect(formatTaka(0), '৳ 0');
      expect(formatTaka(450), '৳ 450');
      expect(formatTaka(8450), '৳ 8,450');
      expect(formatTaka(124500), '৳ 1,24,500');
      expect(formatTaka(12345678), '৳ 1,23,45,678');
    });

    test('keeps two decimals only when there are some', () {
      expect(formatTaka(1500.5), '৳ 1,500.50');
      expect(formatTaka(1500), '৳ 1,500');
    });
  });

  group('addMonths', () {
    test('adds whole months', () {
      expect(addMonths(DateTime(2026, 11, 11), 1), DateTime(2026, 12, 11));
      expect(addMonths(DateTime(2026, 11, 11), 3), DateTime(2027, 2, 11));
      expect(addMonths(DateTime(2026, 11, 11), 12), DateTime(2027, 11, 11));
    });

    test('never spills into the next month', () {
      expect(addMonths(DateTime(2026, 1, 31), 1), DateTime(2026, 2, 28));
      expect(addMonths(DateTime(2028, 1, 31), 1), DateTime(2028, 2, 29));
      expect(addMonths(DateTime(2026, 8, 31), 1), DateTime(2026, 9, 30));
    });
  });
}
