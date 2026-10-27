import 'package:fitness_pro/data/models/signin_request_model.dart';
import 'package:fitness_pro/data/models/signup_request_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('SigninRequestModel round-trips through JSON', () {
    const model = SigninRequestModel(username: 'alim', password: 'secret');
    final json = model.toJson();

    expect(json, {'username': 'alim', 'password': 'secret'});
    expect(SigninRequestModel.fromJson(json), model);
  });

  test('SignupRequestModel round-trips through JSON', () {
    const model = SignupRequestModel(
      username: 'alim',
      email: 'alim@gmail.com',
      password: 'secret',
      role: ['member'],
    );
    final json = model.toJson();

    expect(json, {
      'username': 'alim',
      'email': 'alim@gmail.com',
      'password': 'secret',
      'role': ['member'],
    });
    expect(SignupRequestModel.fromJson(json), model);
  });
}
