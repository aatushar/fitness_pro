import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/network/api_exception.dart';
import '../../../domain/entities/address_entity.dart';
import '../../../domain/repositories/account_repository.dart';

class AccountState {
  final bool loading;
  final List<AddressEntity> addresses;
  final String? message;

  const AccountState({
    this.loading = true,
    this.addresses = const [],
    this.message,
  });
}

/// Profile edit, password change and the user's saved addresses.
class AccountCubit extends Cubit<AccountState> {
  final AccountRepository _repo;
  AccountCubit(this._repo) : super(const AccountState());

  Future<void> load() async {
    try {
      emit(AccountState(loading: false, addresses: await _repo.getAddresses()));
    } catch (e) {
      emit(AccountState(
          loading: false,
          addresses: state.addresses,
          message: ApiException.messageOf(e)));
    }
  }

  /// Each returns null on success, or the message to show on failure.
  Future<String?> updateProfile({required String email, String? phone}) =>
      _run(() => _repo.updateProfile(email: email, phone: phone), reload: false);

  Future<String?> changePassword(String current, String next) => _run(
      () => _repo.changePassword(currentPassword: current, newPassword: next),
      reload: false);

  Future<String?> saveAddress({
    int? addressId,
    required String street,
    required String buildingName,
    required String city,
    required String state,
    required String country,
    required String pincode,
  }) =>
      _run(() => _repo.saveAddress(
            addressId: addressId,
            street: street,
            buildingName: buildingName,
            city: city,
            state: state,
            country: country,
            pincode: pincode,
          ));

  Future<String?> deleteAddress(int addressId) =>
      _run(() => _repo.deleteAddress(addressId));

  Future<String?> _run(Future<void> Function() action,
      {bool reload = true}) async {
    try {
      await action();
    } catch (e) {
      return ApiException.messageOf(e);
    }
    if (reload) await load();
    return null;
  }
}
