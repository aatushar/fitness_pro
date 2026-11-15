import 'package:dio/dio.dart';
import '../../core/network/api_endpoints.dart';
import '../../core/network/api_exception.dart';
import '../models/address_model.dart';

abstract class AccountRemoteDatasource {
  Future<void> updateProfile(Map<String, dynamic> body);
  Future<void> changePassword(Map<String, dynamic> body);
  Future<List<AddressModel>> getAddresses();
  Future<void> createAddress(Map<String, dynamic> body);
  Future<void> updateAddress(int addressId, Map<String, dynamic> body);
  Future<void> deleteAddress(int addressId);
}

class AccountRemoteDatasourceImpl implements AccountRemoteDatasource {
  final Dio _dio;
  AccountRemoteDatasourceImpl(this._dio);

  Future<T> _run<T>(Future<T> Function() call) async {
    try {
      return await call();
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  @override
  Future<void> updateProfile(Map<String, dynamic> body) => _run(() async {
        await _dio.put<dynamic>(ApiEndpoints.profile, data: body);
      });

  @override
  Future<void> changePassword(Map<String, dynamic> body) => _run(() async {
        await _dio.post<dynamic>(ApiEndpoints.changePassword, data: body);
      });

  @override
  Future<List<AddressModel>> getAddresses() => _run(() async {
        final r = await _dio.get<List<dynamic>>(ApiEndpoints.addresses);
        return (r.data ?? const [])
            .map((e) => AddressModel.fromJson(e as Map<String, dynamic>))
            .toList();
      });

  @override
  Future<void> createAddress(Map<String, dynamic> body) => _run(() async {
        await _dio.post<dynamic>(ApiEndpoints.addresses, data: body);
      });

  @override
  Future<void> updateAddress(int addressId, Map<String, dynamic> body) =>
      _run(() async {
        await _dio.put<dynamic>('${ApiEndpoints.addresses}/$addressId', data: body);
      });

  @override
  Future<void> deleteAddress(int addressId) => _run(() async {
        await _dio.delete<dynamic>('${ApiEndpoints.addresses}/$addressId');
      });
}
