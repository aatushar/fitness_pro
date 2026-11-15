import '../../domain/entities/address_entity.dart';
import '../../domain/repositories/account_repository.dart';
import '../datasources/account_remote_datasource.dart';
import '../models/address_model.dart';

class AccountRepositoryImpl implements AccountRepository {
  final AccountRemoteDatasource _datasource;
  AccountRepositoryImpl(this._datasource);

  @override
  Future<void> updateProfile({required String email, String? phone}) =>
      _datasource.updateProfile({'email': email, 'phone': phone});

  @override
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) =>
      _datasource.changePassword({
        'currentPassword': currentPassword,
        'newPassword': newPassword,
      });

  @override
  Future<List<AddressEntity>> getAddresses() async =>
      (await _datasource.getAddresses()).map((m) => m.toEntity()).toList();

  @override
  Future<void> saveAddress({
    int? addressId,
    required String street,
    required String buildingName,
    required String city,
    required String state,
    required String country,
    required String pincode,
  }) {
    final body = {
      'street': street,
      'buildingName': buildingName,
      'city': city,
      'state': state,
      'country': country,
      'pincode': pincode,
    };
    return addressId == null
        ? _datasource.createAddress(body)
        : _datasource.updateAddress(addressId, body);
  }

  @override
  Future<void> deleteAddress(int addressId) =>
      _datasource.deleteAddress(addressId);
}
