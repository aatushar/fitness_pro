/// A person's age at a moment, as calendar parts plus running totals.
class AgeBreakdown {
  final int years;
  final int months;
  final int days;
  final int hours;
  final int minutes;
  final int seconds;
  final int totalDays;
  final int totalHours;
  final int totalMinutes;
  final int totalSeconds;

  const AgeBreakdown({
    required this.years,
    required this.months,
    required this.days,
    required this.hours,
    required this.minutes,
    required this.seconds,
    required this.totalDays,
    required this.totalHours,
    required this.totalMinutes,
    required this.totalSeconds,
  });

  /// Age of someone born at [birth], measured at [now]. A [birth] after [now]
  /// counts as zero.
  factory AgeBreakdown.between(DateTime birth, DateTime now) {
    if (birth.isAfter(now)) birth = now;

    var years = now.year - birth.year;
    var months = now.month - birth.month;
    var days = now.day - birth.day;
    var hours = now.hour - birth.hour;
    var minutes = now.minute - birth.minute;
    var seconds = now.second - birth.second;

    if (seconds < 0) {
      seconds += 60;
      minutes--;
    }
    if (minutes < 0) {
      minutes += 60;
      hours--;
    }
    if (hours < 0) {
      hours += 24;
      days--;
    }
    if (days < 0) {
      months--;
      days += DateTime(now.year, now.month, 0).day; // days in previous month
    }
    if (months < 0) {
      years--;
      months += 12;
    }

    final diff = now.difference(birth);
    return AgeBreakdown(
      years: years,
      months: months,
      days: days,
      hours: hours,
      minutes: minutes,
      seconds: seconds,
      totalDays: diff.inDays,
      totalHours: diff.inHours,
      totalMinutes: diff.inMinutes,
      totalSeconds: diff.inSeconds,
    );
  }
}
