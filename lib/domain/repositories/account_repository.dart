import '../entities/address_entity.dart';

/// The signed-in user's own account: profile edits, password, addresses.
abstract class AccountRepository {
  Future<void> updateProfile({required String email, String? phone});
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  });

  Future<List<AddressEntity>> getAddresses();
  Future<void> saveAddress({
    int? addressId,
    required String street,
    required String buildingName,
    required String city,
    required String state,
    required String country,
    required String pincode,
  });
  Future<void> deleteAddress(int addressId);
}
