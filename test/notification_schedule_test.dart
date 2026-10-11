import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lumen/core/services/notification_service.dart';

void main() {
  const times = [
    TimeOfDay(hour: 9, minute: 0),
    TimeOfDay(hour: 14, minute: 0),
    TimeOfDay(hour: 21, minute: 0),
  ];

  test('schedules exactly one reminder per time slot per day', () {
    final occurrences = NotificationService.upcomingOccurrences(
      times: times,
      startDate: DateTime(2026, 1, 1),
      durationInDays: 21,
      now: DateTime(2026, 1, 1, 8),
      limit: 1000,
    );

    expect(occurrences, hasLength(63));
    expect(occurrences.map((o) => o.time).toSet(), hasLength(63));
    expect(occurrences.first.time, DateTime(2026, 1, 1, 9));
    expect(occurrences.last.time, DateTime(2026, 1, 21, 21));
  });

  test('skips past times and respects the limit in chronological order', () {
    final occurrences = NotificationService.upcomingOccurrences(
      times: const [
        TimeOfDay(hour: 21, minute: 0),
        TimeOfDay(hour: 9, minute: 0)
      ],
      startDate: DateTime(2026, 1, 1),
      durationInDays: 90,
      now: DateTime(2026, 1, 3, 12),
      limit: 4,
    );

    expect(occurrences.map((o) => o.time), [
      DateTime(2026, 1, 3, 21),
      DateTime(2026, 1, 4, 9),
      DateTime(2026, 1, 4, 21),
      DateTime(2026, 1, 5, 9),
    ]);
    expect(occurrences.map((o) => o.timeIndex), [0, 1, 0, 1]);
  });

  test('returns nothing once the schedule has ended', () {
    final occurrences = NotificationService.upcomingOccurrences(
      times: times,
      startDate: DateTime(2026, 1, 1),
      durationInDays: 7,
      now: DateTime(2026, 1, 8),
      limit: 30,
    );

    expect(occurrences, isEmpty);
  });
}
