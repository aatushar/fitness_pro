import 'package:fitness_pro/data/models/user_profile_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('fromJson parses a full profile', () {
    final model = UserProfileModel.fromJson({
      'id': 7,
      'username': 'alim',
      'roles': ['ROLE_MEMBER'],
      'email': 'alim@gmail.com',
      'jwtToken': 'jwt-123',
    });

    expect(model.id, 7);
    expect(model.username, 'alim');
    expect(model.roles, ['ROLE_MEMBER']);
    expect(model.email, 'alim@gmail.com');
    expect(model.jwtToken, 'jwt-123');
  });

  test('fromJson leaves optional email and token null', () {
    final model = UserProfileModel.fromJson({
      'id': 7,
      'username': 'alim',
      'roles': <String>[],
    });

    expect(model.email, isNull);
    expect(model.jwtToken, isNull);
  });
}
