import 'package:fitness_pro/data/models/signin_response_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('fromJson parses the sign-in response', () {
    final model = SigninResponseModel.fromJson({
      'id': 1,
      'username': 'alim',
      'roles': ['ROLE_MANAGER'],
      'jwtToken': 'jwt-123',
    });

    expect(model.id, 1);
    expect(model.username, 'alim');
    expect(model.roles, ['ROLE_MANAGER']);
    expect(model.jwtToken, 'jwt-123');
  });

  test('fromJson throws when a required field is missing', () {
    expect(
      () => SigninResponseModel.fromJson({'id': 1, 'username': 'alim'}),
      throwsA(isA<TypeError>()),
    );
  });
}
