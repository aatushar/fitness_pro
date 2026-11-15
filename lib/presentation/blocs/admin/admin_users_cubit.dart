import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/network/api_exception.dart';
import '../../../domain/entities/managed_user_entity.dart';
import '../../../domain/repositories/admin_repository.dart';

enum LoadStatus { loading, loaded, failure }

class AdminUsersState {
  final LoadStatus status;
  final List<ManagedUserEntity> users;

  /// 'Manager' | 'Trainer' | 'Member'; null lists everyone.
  final String? roleFilter;
  final String search;
  final String? message;

  const AdminUsersState({
    this.status = LoadStatus.loading,
    this.users = const [],
    this.roleFilter,
    this.search = '',
    this.message,
  });

  List<ManagedUserEntity> get visibleUsers {
    final needle = search.trim().toLowerCase();
    return users.where((u) {
      if (roleFilter != null && u.roleLabel != roleFilter) return false;
      if (needle.isEmpty) return true;
      return u.username.toLowerCase().contains(needle) ||
          u.email.toLowerCase().contains(needle) ||
          (u.phone ?? '').toLowerCase().contains(needle);
    }).toList();
  }

  AdminUsersState copyWith({
    LoadStatus? status,
    List<ManagedUserEntity>? users,
    String? roleFilter,
    bool clearRole = false,
    String? search,
    String? message,
  }) =>
      AdminUsersState(
        status: status ?? this.status,
        users: users ?? this.users,
        roleFilter: clearRole ? null : (roleFilter ?? this.roleFilter),
        search: search ?? this.search,
        message: message,
      );
}

/// Admin's user list (manage = true) or a trainer's read-only member list.
class AdminUsersCubit extends Cubit<AdminUsersState> {
  final AdminRepository _repo;
  final bool trainerMode;

  AdminUsersCubit(this._repo, {this.trainerMode = false})
      : super(const AdminUsersState());

  Future<void> load() async {
    if (state.users.isEmpty) emit(state.copyWith(status: LoadStatus.loading));
    try {
      final users =
          trainerMode ? await _repo.getTrainerMembers() : await _repo.getUsers();
      emit(state.copyWith(status: LoadStatus.loaded, users: users));
    } catch (e) {
      emit(state.copyWith(
          status: LoadStatus.failure, message: ApiException.messageOf(e)));
    }
  }

  void setRoleFilter(String? role) => emit(
      role == null ? state.copyWith(clearRole: true) : state.copyWith(roleFilter: role));

  void setSearch(String search) => emit(state.copyWith(search: search));

  /// Each returns null on success, or the message to show on failure.
  Future<String?> setStatus(int userId, String status) =>
      _change(() => _repo.setUserStatus(userId, status));

  Future<String?> setRole(int userId, String role) =>
      _change(() => _repo.setUserRoles(userId, [role]));

  Future<String?> delete(int userId) => _change(() => _repo.deleteUser(userId));

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
