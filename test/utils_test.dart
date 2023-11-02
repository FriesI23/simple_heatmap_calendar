// Copyright 2023 weooh
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import 'package:flutter_test/flutter_test.dart';
import 'package:simple_heatmap_calendar/src/utils.dart';

void main() {
  group("test HeatmapCalendarDataModel", () {
    test("init", () {
      var obj = HeatmapCalendarLocationCalclator(
          startDate: DateTime(2022, 1, 1),
          endedDate: DateTime(2023, 1, 1),
          firstDay: DateTime.sunday,
          withUTC: false);
      expect(obj.startDate, DateTime(2022, 1, 1));
      expect(obj.endedDate, DateTime(2023, 1, 1));
      expect(obj.firstDay, DateTime.sunday);
    });
    test("init with firstday", () {
      var obj = HeatmapCalendarLocationCalclator(
        startDate: DateTime(2022, 1, 1),
        endedDate: DateTime(2023, 1, 1),
        firstDay: DateTime.saturday,
        withUTC: false,
      );
      expect(obj.startDate, DateTime(2022, 1, 1));
      expect(obj.endedDate, DateTime(2023, 1, 1));
      expect(obj.firstDay, DateTime.saturday);
    });
    test('withUTC true should use UTC time', () {
      final utcStartDate = DateTime(2023, 3, 5, 12, 0, 0);
      expect(
          () => HeatmapCalendarLocationCalclator(
                startDate: utcStartDate,
                endedDate: utcStartDate.add(const Duration(days: 1)),
                firstDay: 1,
                withUTC: true,
              ),
          throwsA(const TypeMatcher<AssertionError>()));
    });

    test('withUTC false should use local time', () {
      final localStartDate = DateTime.utc(2023, 3, 5, 12, 0, 0);
      expect(
          () => HeatmapCalendarLocationCalclator(
                startDate: localStartDate,
                endedDate: localStartDate.add(const Duration(days: 1)),
                firstDay: 1,
                withUTC: false,
              ),
          throwsA(const TypeMatcher<AssertionError>()));
    });
    group("api getOffsetRow", () {
      test("firstday is sat", () {
        var obj = HeatmapCalendarLocationCalclator(
          startDate: DateTime(2022, 1, 4), // tuesday
          endedDate: DateTime(2023, 1, 1),
          firstDay: DateTime.saturday, withUTC: false,
        );
        expect(obj.getOffsetRow(obj.startDate), 3);
      });
      test("firstday is sun", () {
        var obj = HeatmapCalendarLocationCalclator(
          startDate: DateTime(2022, 1, 4), // tuesday
          endedDate: DateTime(2023, 1, 1),
          firstDay: DateTime.sunday, withUTC: false,
        );
        expect(obj.getOffsetRow(obj.startDate), 2);
      });
      test("firstday is mon", () {
        var obj = HeatmapCalendarLocationCalclator(
          startDate: DateTime(2022, 1, 4), // tuesday
          endedDate: DateTime(2023, 1, 1),
          firstDay: DateTime.monday, withUTC: false,
        );
        expect(obj.getOffsetRow(obj.startDate), 1);
      });
      test("firstday is tue", () {
        var obj = HeatmapCalendarLocationCalclator(
          startDate: DateTime(2022, 1, 4), // tuesday
          endedDate: DateTime(2023, 1, 1),
          firstDay: DateTime.tuesday, withUTC: false,
        );
        expect(obj.getOffsetRow(obj.startDate), 0);
      });
      test("firstday is wed", () {
        var obj = HeatmapCalendarLocationCalclator(
          startDate: DateTime(2022, 1, 4), // tuesday
          endedDate: DateTime(2023, 1, 1),
          firstDay: DateTime.wednesday, withUTC: false,
        );
        expect(obj.getOffsetRow(obj.startDate), 6);
      });
      test("firstday is tur", () {
        var obj = HeatmapCalendarLocationCalclator(
          startDate: DateTime(2022, 1, 4), // tuesday
          endedDate: DateTime(2023, 1, 1),
          firstDay: DateTime.thursday, withUTC: false,
        );
        expect(obj.getOffsetRow(obj.startDate), 5);
      });
      test("firstday is fri", () {
        var obj = HeatmapCalendarLocationCalclator(
          startDate: DateTime(2022, 1, 4), // tuesday
          endedDate: DateTime(2023, 1, 1),
          firstDay: DateTime.friday, withUTC: false,
        );
        expect(obj.getOffsetRow(obj.startDate), 4);
      });
      test("firstday is fri and custom start date", () {
        var obj = HeatmapCalendarLocationCalclator(
          startDate: DateTime(2022, 1, 4), // tuesday
          endedDate: DateTime(2023, 1, 1),
          firstDay: DateTime.friday, withUTC: false,
        );
        expect(obj.getOffsetRow(DateTime(2022, 1, 20)), 6);
      });
    });
    group('api getOffsetColumn', () {
      test("after startDate 01", () {
        /**
         * Sat  s
         * Sun  x
         * Mon  o
         * Tue  o
         * Wed  o
         * Tur  o
         * Fri  o
         */
        var obj = HeatmapCalendarLocationCalclator(
          startDate: DateTime(2022, 1, 1), // saturday
          endedDate: DateTime(2023, 1, 1),
          firstDay: DateTime.saturday, withUTC: false,
        );
        expect(obj.getOffsetColumn(DateTime(2022, 1, 2)), 0);
      });
      test("after startDate 02", () {
        /**
         * Sat  s x
         * Sun  o o
         * Mon  o o
         * Tue  o o
         * Wed  o o
         * Tur  o o
         * Fri  o o
         */
        var obj = HeatmapCalendarLocationCalclator(
          startDate: DateTime(2022, 1, 1), // saturday
          endedDate: DateTime(2023, 1, 1),
          firstDay: DateTime.saturday, withUTC: false,
        );
        expect(obj.getOffsetColumn(DateTime(2022, 1, 7)), 0);
        expect(obj.getOffsetColumn(DateTime(2022, 1, 8)), 1);
        expect(obj.getOffsetColumn(DateTime(2022, 1, 9)), 1);
      });
      test("after startDate multi weeks", () {
        /**
         * Sat  s o x
         * Sun  o o o
         * Mon  o o o
         * Tue  o o o
         * Wed  o o o
         * Tur  o o o
         * Fri  o o o
         */
        var obj = HeatmapCalendarLocationCalclator(
          startDate: DateTime(2022, 1, 1), // saturday
          endedDate: DateTime(2023, 1, 1),
          firstDay: DateTime.saturday, withUTC: false,
        );
        expect(obj.getOffsetColumn(DateTime(2022, 1, 14)), 1);
        expect(obj.getOffsetColumn(DateTime(2022, 1, 15)), 2);
        expect(obj.getOffsetColumn(DateTime(2022, 1, 16)), 2);
        expect(obj.getOffsetColumn(DateTime(2022, 1, 17)), 2);
        expect(obj.getOffsetColumn(DateTime(2022, 1, 18)), 2);
        expect(obj.getOffsetColumn(DateTime(2022, 1, 19)), 2);
        expect(obj.getOffsetColumn(DateTime(2022, 1, 20)), 2);
        expect(obj.getOffsetColumn(DateTime(2022, 1, 21)), 2);
        expect(obj.getOffsetColumn(DateTime(2022, 1, 22)), 3);
        expect(obj.getOffsetColumn(DateTime(2022, 1, 23)), 3);
      });

      test("before startDate 01", () {
        /**
         * Sat  o s
         * Sun  o o
         * Mon  o o
         * Tue  o o
         * Wed  o o
         * Tur  o o
         * Fri  x o
         */
        var obj = HeatmapCalendarLocationCalclator(
          startDate: DateTime(2022, 1, 1), // saturday
          endedDate: DateTime(2023, 1, 1),
          firstDay: DateTime.saturday, withUTC: false,
        );
        expect(obj.getOffsetColumn(DateTime(2022, 1, 0)), -1);
      });
      test("before startDate 02", () {
        /**
         * Sat  x s
         * Sun  o o
         * Mon  o o
         * Tue  o o
         * Wed  o o
         * Tur  o o
         * Fri  o o
         */
        var obj = HeatmapCalendarLocationCalclator(
          startDate: DateTime(2022, 1, 1), // saturday
          endedDate: DateTime(2023, 1, 1),
          firstDay: DateTime.saturday, withUTC: false,
        );
        expect(obj.getOffsetColumn(DateTime(2021, 12, 25)), -1);
      });
      test("before startDate multi weeks", () {
        /**
         * Sat  x o s
         * Sun  o o o
         * Mon  o o o
         * Tue  o o o
         * Wed  o o o
         * Tur  o o o
         * Fri  o o o
         */
        var obj = HeatmapCalendarLocationCalclator(
          startDate: DateTime(2022, 1, 1), // saturday
          endedDate: DateTime(2023, 1, 1),
          firstDay: DateTime.saturday, withUTC: false,
        );
        expect(obj.getOffsetColumn(DateTime(2021, 12, 16)), -3);
        expect(obj.getOffsetColumn(DateTime(2021, 12, 17)), -3);
        expect(obj.getOffsetColumn(DateTime(2021, 12, 18)), -2);
        expect(obj.getOffsetColumn(DateTime(2021, 12, 19)), -2);
        expect(obj.getOffsetColumn(DateTime(2021, 12, 20)), -2);
        expect(obj.getOffsetColumn(DateTime(2021, 12, 21)), -2);
        expect(obj.getOffsetColumn(DateTime(2021, 12, 22)), -2);
        expect(obj.getOffsetColumn(DateTime(2021, 12, 23)), -2);
        expect(obj.getOffsetColumn(DateTime(2021, 12, 24)), -2);
        expect(obj.getOffsetColumn(DateTime(2021, 12, 25)), -1);
        expect(obj.getOffsetColumn(DateTime(2021, 12, 26)), -1);
      });
      test("is startDate", () {
        /**
         * Sat  x/s o
         * Sun  o o
         * Mon  o o
         * Tue  o o
         * Wed  o o
         * Tur  o o
         * Fri  o o
         */
        var obj = HeatmapCalendarLocationCalclator(
          startDate: DateTime(2022, 1, 1), // saturday
          endedDate: DateTime(2023, 1, 1),
          firstDay: DateTime.saturday, withUTC: false,
        );
        expect(obj.getOffsetColumn(DateTime(2022, 1, 1)), 0);
      });
      test("with offset row 01", () {
        /**
         * Sat  x o
         * Sun  o s
         * Mon  o o
         * Tue  o o
         * Wed  o o
         * Tur  o o
         * Fri  o o
         */
        var obj = HeatmapCalendarLocationCalclator(
          startDate: DateTime(2022, 1, 1), // saturday
          endedDate: DateTime(2023, 1, 1),
          firstDay: DateTime.saturday, withUTC: false,
        );
        var date = DateTime(2022, 1, 9);
        var offsetRow = obj.getOffsetRow(date);
        expect(obj.getOffsetColumn(date, offsetRow: offsetRow), 1);
      });
      test("with offset row 02", () {
        /**
         * Sat  x o
         * Sun  o o
         * Mon  o o
         * Tue  o o
         * Wed  o o
         * Tur  o o
         * Fri  s o
         */
        var obj = HeatmapCalendarLocationCalclator(
          startDate: DateTime(2022, 1, 1), // saturday
          endedDate: DateTime(2023, 1, 1),
          firstDay: DateTime.saturday, withUTC: false,
        );
        var date = DateTime(2022, 1, 7);
        var offsetRow = obj.getOffsetRow(date);
        expect(obj.getOffsetColumn(date, offsetRow: offsetRow), 0);
      });
      test("with offset 2022-01-04 and first date is sunday", () {
        var obj = HeatmapCalendarLocationCalclator(
          startDate: DateTime(2022, 1, 1), // saturday
          endedDate: DateTime(2023, 1, 1),
          firstDay: DateTime.sunday, withUTC: false,
        );
        var date = DateTime(2022, 1, 4);
        var offsetRow = obj.getOffsetRow(date);
        expect(obj.getOffsetColumn(date, offsetRow: offsetRow), 1);
      });
    });
    group("api getDateWeekdyByOffsetRow", () {
      test("normal 01", () {
        var obj = HeatmapCalendarLocationCalclator(
          startDate: DateTime(2022, 1, 4), // tuesday
          endedDate: DateTime(2023, 1, 1),
          firstDay: DateTime.saturday, withUTC: false,
        );
        expect(obj.getOffsetRow(obj.startDate), 3);
        expect(obj.getDateWeekdyByOffsetRow(3), obj.startDate.weekday);
      });
      test("firstday is fri and custom start date", () {
        var obj = HeatmapCalendarLocationCalclator(
          startDate: DateTime(2022, 1, 4), // tuesday
          endedDate: DateTime(2023, 1, 1),
          firstDay: DateTime.friday, withUTC: false,
        );
        expect(obj.getOffsetRow(DateTime(2022, 1, 20)), 6);
        expect(obj.getDateWeekdyByOffsetRow(6), DateTime(2022, 1, 20).weekday);
      });
    });
    group("api getDateTimeByOffset", () {
      test("after startDate 01", () {
        /**
         * Sat  s
         * Sun  x
         * Mon  o
         * Tue  o
         * Wed  o
         * Tur  o
         * Fri  o
         */
        var obj = HeatmapCalendarLocationCalclator(
          startDate: DateTime(2022, 1, 1), // saturday
          endedDate: DateTime(2023, 1, 1),
          firstDay: DateTime.saturday, withUTC: false,
        );
        var date = DateTime(2022, 1, 2);
        var row = obj.getOffsetRow(date);
        var col = obj.getOffsetColumn(date, offsetRow: row);
        expect(row, 1);
        expect(col, 0);
        expect(obj.getDateTimeByOffset(row, col), DateTime(2022, 1, 2));
      });
      test("after startDate 02", () {
        /**
         * Sat  s o
         * Sun  o o
         * Mon  o o
         * Tue  o o
         * Wed  o o
         * Tur  o x
         * Fri  o o
         */
        var obj = HeatmapCalendarLocationCalclator(
          startDate: DateTime(2022, 1, 1), // saturday
          endedDate: DateTime(2023, 1, 1),
          firstDay: DateTime.saturday, withUTC: false,
        );
        var date = DateTime(2022, 1, 13);
        var row = obj.getOffsetRow(date);
        var col = obj.getOffsetColumn(date, offsetRow: row);
        expect(row, 5);
        expect(col, 1);
        expect(obj.getDateTimeByOffset(row, col), DateTime(2022, 1, 13));
      });
      test("before startDate 01", () {
        /**
         * Sat  o s
         * Sun  o o
         * Mon  o o
         * Tue  o o
         * Wed  o o
         * Tur  o o
         * Fri  x o
         */
        var obj = HeatmapCalendarLocationCalclator(
          startDate: DateTime(2022, 1, 1), // saturday
          endedDate: DateTime(2023, 1, 1),
          firstDay: DateTime.saturday, withUTC: false,
        );

        var date = DateTime(2022, 1, 0);
        var row = obj.getOffsetRow(date);
        var col = obj.getOffsetColumn(date, offsetRow: row);
        expect(row, 6);
        expect(col, -1);
        expect(obj.getDateTimeByOffset(row, col), DateTime(2021, 12, 31));
      });
      test("serial datetime", () {
        for (var i = 1; i <= 7; i++) {
          var obj = HeatmapCalendarLocationCalclator(
            startDate: DateTime(2020, 1, 1), // saturday
            endedDate: DateTime(2021, 1, 1),
            firstDay: i, withUTC: false,
          );
          for (var j = -10000; j < 10000; j++) {
            var date = obj.startDate.add(Duration(days: j));
            var row = obj.getOffsetRow(date);
            var col = obj.getOffsetColumn(date, offsetRow: row);
            // print('......$date $row $col ${obj.offsetRowWithStartDate}');
            expect(obj.getDateTimeByOffset(row, col), date);
          }
        }
      });
    });
    group('api getProtoDateByOffsetRow', () {
      test('getProtoDateByOffsetRow (Non-UTC)', () {
        final calculator = HeatmapCalendarLocationCalclator(
          startDate: DateTime(2023, 3, 1),
          endedDate: DateTime(2023, 3, 31),
          firstDay: 1,
          withUTC: false,
        );

        final protoDate = calculator.getProtoDateByOffsetRow(0);
        expect(protoDate, equals(DateTime(2023, 3, 6)));
      });

      test('getProtoDateByOffsetRow (UTC)', () {
        final calculatorWithUTC = HeatmapCalendarLocationCalclator(
          startDate: DateTime(2023, 3, 1).toUtc(),
          endedDate: DateTime(2023, 3, 31).toUtc(),
          firstDay: 1,
          withUTC: true,
        );

        final protoDate = calculatorWithUTC.getProtoDateByOffsetRow(0);
        expect(protoDate, equals(DateTime.utc(2023, 3, 6)));
      });
    });
  });
}
