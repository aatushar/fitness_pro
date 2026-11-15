import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/network/api_exception.dart';
import '../../../domain/entities/admin_dashboard_entity.dart';
import '../../../domain/entities/managed_user_entity.dart';
import '../../../domain/repositories/admin_repository.dart';
import 'admin_users_cubit.dart' show LoadStatus;

class AdminDashboardState {
  final LoadStatus status;
  final AdminDashboardEntity? dashboard;

  /// A few of the newest members, for the "Recent Members" list.
  final List<ManagedUserEntity> recentMembers;
  final String? message;

  const AdminDashboardState({
    this.status = LoadStatus.loading,
    this.dashboard,
    this.recentMembers = const [],
    this.message,
  });
}

class AdminDashboardCubit extends Cubit<AdminDashboardState> {
  final AdminRepository _repo;
  AdminDashboardCubit(this._repo) : super(const AdminDashboardState());

  Future<void> load() async {
    try {
      final dashboard = await _repo.getDashboard();
      final users = await _repo.getUsers();
      final members = users
          .where((u) => u.roleLabel == 'Member')
          .toList()
        ..sort((a, b) => b.userId.compareTo(a.userId));
      emit(AdminDashboardState(
        status: LoadStatus.loaded,
        dashboard: dashboard,
        recentMembers: members.take(3).toList(),
      ));
    } catch (e) {
      emit(AdminDashboardState(
        status: LoadStatus.failure,
        dashboard: state.dashboard,
        recentMembers: state.recentMembers,
        message: ApiException.messageOf(e),
      ));
    }
  }
}
