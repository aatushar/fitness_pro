import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/network/api_exception.dart';
import '../../../domain/entities/member_subscription_entity.dart';
import '../../../domain/entities/subscription_entity.dart';
import '../../../domain/entities/subscription_summary_entity.dart';
import '../../../domain/usecases/activate_subscription_usecase.dart';
import '../../../domain/usecases/get_member_subscriptions_usecase.dart';

enum MemberFeesStatus { loading, loaded, failure }

class MemberFeesState {
  final MemberFeesStatus status;
  final List<MemberSubscriptionEntity> members;
  final SubscriptionSummaryEntity? summary;

  /// Only members in this status are listed; null lists everyone.
  final SubscriptionStatus? filter;

  /// Matches username, email or phone (case-insensitive).
  final String search;
  final String? message;

  const MemberFeesState({
    this.status = MemberFeesStatus.loading,
    this.members = const [],
    this.summary,
    this.filter,
    this.search = '',
    this.message,
  });

  List<MemberSubscriptionEntity> get visibleMembers {
    final needle = search.trim().toLowerCase();
    return members.where((m) {
      if (filter != null && m.status != filter) return false;
      if (needle.isEmpty) return true;
      return m.username.toLowerCase().contains(needle) ||
          m.email.toLowerCase().contains(needle) ||
          (m.phone ?? '').toLowerCase().contains(needle);
    }).toList();
  }

  MemberFeesState copyWith({
    MemberFeesStatus? status,
    List<MemberSubscriptionEntity>? members,
    SubscriptionSummaryEntity? summary,
    String? search,
    String? message,
    bool clearFilter = false,
    SubscriptionStatus? filter,
  }) =>
      MemberFeesState(
        status: status ?? this.status,
        members: members ?? this.members,
        summary: summary ?? this.summary,
        filter: clearFilter ? null : (filter ?? this.filter),
        search: search ?? this.search,
        message: message,
      );
}

/// Admin's fee-collection page: the member list, filters and "activate".
class MemberFeesCubit extends Cubit<MemberFeesState> {
  final GetMemberSubscriptionsUseCase _getMembers;
  final ActivateSubscriptionUseCase _activate;

  MemberFeesCubit(this._getMembers, this._activate)
      : super(const MemberFeesState());

  Future<void> load() async {
    // Keep the old list on screen while refreshing after an activation.
    if (state.members.isEmpty) {
      emit(state.copyWith(status: MemberFeesStatus.loading));
    }
    try {
      final data = await _getMembers();
      emit(state.copyWith(
        status: MemberFeesStatus.loaded,
        members: data.members,
        summary: data.summary,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: MemberFeesStatus.failure,
        message: ApiException.messageOf(e),
      ));
    }
  }

  void setFilter(SubscriptionStatus? filter) => emit(
        filter == null
            ? state.copyWith(clearFilter: true)
            : state.copyWith(filter: filter),
      );

  void setSearch(String search) => emit(state.copyWith(search: search));

  /// Records the fee and refreshes the list. Returns null on success, or the
  /// message to show the admin when it failed.
  Future<String?> activate({
    required int userId,
    int? months,
    int? testMinutes,
    required double amount,
    required String paymentMethod,
    String? note,
  }) async {
    try {
      await _activate(
        userId: userId,
        months: months,
        testMinutes: testMinutes,
        amount: amount,
        paymentMethod: paymentMethod,
        note: note,
      );
    } catch (e) {
      return ApiException.messageOf(e);
    }
    await load();
    return null;
  }
}
