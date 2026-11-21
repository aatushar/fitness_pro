import 'package:fitness_pro/data/models/birth_info_model.dart';
import 'package:fitness_pro/data/models/save_birth_info_request_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('fromJson parses a saved birth date/time', () {
    final entity = BirthInfoModel.fromJson({
      'birthDateTime': '2000-05-17T15:27:00',
      'updatedAt': '2026-11-16T10:00:00.123',
    }).toEntity();

    expect(entity.isSet, isTrue);
    expect(entity.birthDateTime, DateTime(2000, 5, 17, 15, 27));
  });

  test('fromJson with nulls (nothing saved yet) is not set', () {
    final entity = BirthInfoModel.fromJson(
        {'birthDateTime': null, 'updatedAt': null}).toEntity();
    expect(entity.isSet, isFalse);
  });

  test('request toJson sends birthDateTime', () {
    expect(
      const SaveBirthInfoRequestModel(birthDateTime: '2000-05-17T15:27:00')
          .toJson(),
      {'birthDateTime': '2000-05-17T15:27:00'},
    );
  });
}
