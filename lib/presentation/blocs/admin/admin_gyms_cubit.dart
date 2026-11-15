import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/network/api_exception.dart';
import '../../../domain/entities/gym_entity.dart';
import '../../../domain/repositories/admin_repository.dart';
import 'admin_users_cubit.dart' show LoadStatus;

class AdminGymsState {
  final LoadStatus status;
  final List<GymEntity> gyms;
  final String? message;

  const AdminGymsState({
    this.status = LoadStatus.loading,
    this.gyms = const [],
    this.message,
  });
}

class AdminGymsCubit extends Cubit<AdminGymsState> {
  final AdminRepository _repo;
  AdminGymsCubit(this._repo) : super(const AdminGymsState());

  Future<void> load() async {
    if (state.gyms.isEmpty) emit(const AdminGymsState());
    try {
      emit(AdminGymsState(status: LoadStatus.loaded, gyms: await _repo.getGyms()));
    } catch (e) {
      emit(AdminGymsState(
          status: LoadStatus.failure,
          gyms: state.gyms,
          message: ApiException.messageOf(e)));
    }
  }

  /// Each returns null on success, or the message to show on failure.
  Future<String?> save({
    int? gymsId,
    required String name,
    required String email,
    required String city,
    required String phone,
  }) =>
      _change(() => _repo.saveGym(
          gymsId: gymsId, name: name, email: email, city: city, phone: phone));

  Future<String?> setStatus(int gymsId, String status) =>
      _change(() => _repo.setGymStatus(gymsId, status));

  Future<String?> delete(int gymsId) => _change(() => _repo.deleteGym(gymsId));

  Future<String?> _change(Future<void> Function() action) async {
    try {
      await action();
    } catch (e) {
      return ApiException.messageOf(e);
    }
    await load();
    return null;
  }
}
