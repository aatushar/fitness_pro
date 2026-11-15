import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/address_entity.dart';
part 'address_model.freezed.dart';
part 'address_model.g.dart';

@freezed
class AddressModel with _$AddressModel {
  const factory AddressModel({
    required int addressId,
    required String street,
    required String buildingName,
    required String city,
    required String state,
    required String country,
    required String pincode,
  }) = _AddressModel;

  factory AddressModel.fromJson(Map<String, dynamic> json) =>
      _$AddressModelFromJson(json);
}

extension AddressModelMapper on AddressModel {
  AddressEntity toEntity() => AddressEntity(
        addressId: addressId,
        street: street,
        buildingName: buildingName,
        city: city,
        state: state,
        country: country,
        pincode: pincode,
      );
}
