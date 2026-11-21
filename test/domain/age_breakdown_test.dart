import 'package:fitness_pro/domain/entities/age_breakdown.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('exact parts and totals', () {
    final age = AgeBreakdown.between(
      DateTime(2000, 1, 15, 10, 30, 0),
      DateTime(2026, 3, 20, 12, 45, 30),
    );
    expect((age.years, age.months, age.days), (26, 2, 5));
    expect((age.hours, age.minutes, age.seconds), (2, 15, 30));
    expect(age.totalDays, DateTime(2026, 3, 20, 12, 45, 30)
        .difference(DateTime(2000, 1, 15, 10, 30)).inDays);
  });

  test('borrows from the previous month and year', () {
    final age = AgeBreakdown.between(
      DateTime(2000, 12, 25, 18),
      DateTime(2026, 3, 5, 9),
    );
    // 2000-12-25 18:00 -> 2026-03-05 09:00 = 25y 2m 7d 15h
    expect((age.years, age.months, age.days, age.hours), (25, 2, 7, 15));
  });

  test('a future birth counts as zero', () {
    final now = DateTime(2026, 1, 1);
    final age = AgeBreakdown.between(DateTime(2027, 1, 1), now);
    expect((age.years, age.months, age.days, age.totalSeconds), (0, 0, 0, 0));
  });
}
