class AddressEntity {
  final int addressId;
  final String street;
  final String buildingName;
  final String city;
  final String state;
  final String country;
  final String pincode;

  const AddressEntity({
    required this.addressId,
    required this.street,
    required this.buildingName,
    required this.city,
    required this.state,
    required this.country,
    required this.pincode,
  });

  String get oneLine => '$buildingName, $street, $city, $state, $country $pincode';
}
