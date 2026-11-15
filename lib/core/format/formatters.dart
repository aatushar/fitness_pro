const _months = [
  'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
  'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
];

/// `11 Feb 2027`
String formatDate(DateTime d) => '${d.day} ${_months[d.month - 1]} ${d.year}';

/// `11 Feb, 9:05 AM` (with the year when it is not [now]'s year).
String formatDateTime(DateTime d, {DateTime? now}) {
  final hour12 = d.hour % 12 == 0 ? 12 : d.hour % 12;
  final minute = d.minute.toString().padLeft(2, '0');
  final period = d.hour < 12 ? 'AM' : 'PM';
  final year = d.year == (now ?? DateTime.now()).year ? '' : ' ${d.year}';
  return '${d.day} ${_months[d.month - 1]}$year, $hour12:$minute $period';
}

/// `৳ 1,24,500` — Bangladeshi digit grouping (last 3 digits, then pairs).
/// Whole amounts show no decimals; others show two.
String formatTaka(double amount) {
  final negative = amount < 0;
  final fixed = amount.abs().toStringAsFixed(
      amount == amount.roundToDouble() ? 0 : 2);
  final parts = fixed.split('.');
  final digits = parts[0];

  String grouped;
  if (digits.length <= 3) {
    grouped = digits;
  } else {
    final head = digits.substring(0, digits.length - 3);
    final tail = digits.substring(digits.length - 3);
    final pairs = <String>[];
    for (var end = head.length; end > 0; end -= 2) {
      pairs.insert(0, head.substring(end - 2 < 0 ? 0 : end - 2, end));
    }
    grouped = '${pairs.join(',')},$tail';
  }
  final decimals = parts.length > 1 ? '.${parts[1]}' : '';
  return '${negative ? '-' : ''}৳ $grouped$decimals';
}

/// [date] plus [months] calendar months, keeping the day of month but never
/// spilling into the next month (31 Jan + 1 month = 28 Feb). Matches how the
/// server adds months, so the "access until" preview agrees with the result.
DateTime addMonths(DateTime date, int months) {
  final total = date.year * 12 + (date.month - 1) + months;
  final year = total ~/ 12;
  final month = total % 12 + 1;
  final lastDay = DateTime(year, month + 1, 0).day;
  return DateTime(year, month, date.day > lastDay ? lastDay : date.day);
}
