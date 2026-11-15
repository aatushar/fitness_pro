import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/entities/gym_entity.dart';
import '../../../domain/repositories/admin_repository.dart';

/// Gyms offered on the sign-up screen. A failure just leaves the list empty:
/// signing up without picking a gym still works.
class GymOptionsCubit extends Cubit<List<GymEntity>> {
  final AdminRepository _repo;
  GymOptionsCubit(this._repo) : super(const []);

  Future<void> load() async {
    try {
      emit(await _repo.getGymOptions());
    } catch (_) {
      emit(const []);
    }
  }
}
