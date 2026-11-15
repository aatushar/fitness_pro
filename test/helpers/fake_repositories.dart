import 'package:fitness_pro/domain/entities/address_entity.dart';
import 'package:fitness_pro/domain/entities/admin_dashboard_entity.dart';
import 'package:fitness_pro/domain/entities/gym_entity.dart';
import 'package:fitness_pro/domain/entities/managed_user_entity.dart';
import 'package:fitness_pro/domain/repositories/account_repository.dart';
import 'package:fitness_pro/domain/repositories/admin_repository.dart';
import 'package:fitness_pro/domain/entities/app_notification_entity.dart';
import 'package:fitness_pro/domain/entities/member_subscription_entity.dart';
import 'package:fitness_pro/domain/entities/subscription_entity.dart';
import 'package:fitness_pro/domain/entities/subscription_summary_entity.dart';
import 'package:fitness_pro/domain/repositories/notification_repository.dart';
import 'package:fitness_pro/domain/repositories/subscription_repository.dart';
import 'package:fitness_pro/domain/services/reminder_scheduler.dart';
import 'package:fitness_pro/domain/entities/profile_entity.dart';
import 'package:fitness_pro/domain/entities/user_entity.dart';
import 'package:fitness_pro/domain/repositories/auth_repository.dart';
import 'package:fitness_pro/domain/repositories/profile_repository.dart';

const testUser = UserEntity(
  id: 1,
  token: 'jwt-123',
  username: 'alim',
  roles: ['ROLE_MANAGER'],
);

const testProfile = ProfileEntity(
  id: 7,
  username: 'alim',
  email: 'alim@gmail.com',
  roles: ['ROLE_MEMBER'],
);

/// Hand-written fake: records calls, and throws [error] when it is set.
class FakeAuthRepository implements AuthRepository {
  Object? error;
  String? savedUsername = 'alim';
  final calls = <String>[];
  Map<String, Object> lastArgs = {};

  @override
  Future<void> signup({
    required String username,
    required String email,
    required String password,
    required List<String> role,
    int? gymsId,
  }) async {
    calls.add('signup');
    lastArgs = {
      'username': username,
      'email': email,
      'password': password,
      'role': role,
    };
    if (error != null) throw error!;
  }

  @override
  Future<UserEntity> signin({
    required String username,
    required String password,
  }) async {
    calls.add('signin');
    lastArgs = {'username': username, 'password': password};
    if (error != null) throw error!;
    return testUser;
  }

  @override
  Future<void> signout() async {
    calls.add('signout');
    if (error != null) throw error!;
  }

  @override
  Future<String?> getSavedUsername() async {
    calls.add('getSavedUsername');
    if (error != null) throw error!;
    return savedUsername;
  }
}

class FakeProfileRepository implements ProfileRepository {
  Object? error;
  int calls = 0;

  @override
  Future<ProfileEntity> getProfile() async {
    calls++;
    if (error != null) throw error!;
    return testProfile;
  }
}


// ── Gym subscription fees ──────────────────────────────────────

const activeSubscription = SubscriptionEntity(
  status: SubscriptionStatus.active,
  startDate: null,
  endDate: null,
  daysLeft: 20,
  totalDays: 30,
  planMonths: 1,
  lastAmount: 1500,
);

final testMember = MemberSubscriptionEntity(
  userId: 12,
  username: 'rakib',
  email: 'rakib@gmail.com',
  phone: '01700000002',
  status: SubscriptionStatus.expired,
  endDate: DateTime(2026, 11, 10),
  daysLeft: 0,
  lastAmount: 500,
);

const testSummary = SubscriptionSummaryEntity(
  totalMembers: 3,
  active: 1,
  expiringSoon: 1,
  expired: 1,
  notSubscribed: 0,
  collectedThisMonth: 3500,
);

class FakeSubscriptionRepository implements SubscriptionRepository {
  Object? error;
  SubscriptionEntity mine = activeSubscription;
  List<MemberSubscriptionEntity> members = [];
  int membersCalls = 0;
  Map<String, Object?> lastActivation = {};

  @override
  Future<SubscriptionEntity> getMySubscription() async {
    if (error != null) throw error!;
    return mine;
  }

  @override
  Future<List<MemberSubscriptionEntity>> getMembers() async {
    membersCalls++;
    if (error != null) throw error!;
    return members;
  }

  @override
  Future<SubscriptionSummaryEntity> getSummary() async {
    if (error != null) throw error!;
    return testSummary;
  }

  @override
  Future<SubscriptionEntity> activate({
    required int userId,
    int? months,
    int? testMinutes,
    required double amount,
    required String paymentMethod,
    String? note,
  }) async {
    if (error != null) throw error!;
    lastActivation = {
      'userId': userId,
      'months': months,
      'testMinutes': testMinutes,
      'amount': amount,
      'paymentMethod': paymentMethod,
      'note': note,
    };
    return activeSubscription;
  }
}

class FakeNotificationRepository implements NotificationRepository {
  Object? error;
  List<AppNotificationEntity> items = [];
  final calls = <String>[];

  @override
  Future<List<AppNotificationEntity>> getNotifications() async {
    if (error != null) throw error!;
    return items;
  }

  @override
  Future<void> markRead(int id) async => calls.add('markRead:$id');

  @override
  Future<void> markAllRead() async => calls.add('markAllRead');
}

class FakeReminderScheduler implements ReminderScheduler {
  Object? error;
  final scheduled = <SubscriptionEntity>[];
  int cancelAllCalls = 0;

  @override
  Future<void> scheduleFor(SubscriptionEntity subscription) async {
    if (error != null) throw error!;
    scheduled.add(subscription);
  }

  @override
  Future<void> cancelAll() async {
    cancelAllCalls++;
    if (error != null) throw error!;
  }
}


// ── Admin / account ────────────────────────────────────────────

class FakeAdminRepository implements AdminRepository {
  Object? error;
  List<ManagedUserEntity> users = const [
    ManagedUserEntity(
        userId: 1, username: 'rakib', email: 'rakib@x.com', status: 'ACTIVE',
        roles: ['ROLE_USER']),
    ManagedUserEntity(
        userId: 2, username: 'sadia', email: 'sadia@x.com', status: 'INACTIVE',
        roles: ['ROLE_TRAINER']),
  ];
  List<GymEntity> gyms = const [
    GymEntity(gymsId: 1, gymName: 'Fitness Plus Dhaka', city: 'Dhaka'),
  ];
  final calls = <String>[];

  Future<T> _ok<T>(String call, T value) async {
    calls.add(call);
    if (error != null) throw error!;
    return value;
  }

  @override
  Future<AdminDashboardEntity> getDashboard() => _ok(
      'dashboard',
      const AdminDashboardEntity(
        totalMembers: 5,
        totalTrainers: 2,
        totalManagers: 1,
        totalGyms: 1,
        subscriptions: SubscriptionSummaryEntity(
            totalMembers: 5, active: 3, expiringSoon: 1, expired: 1,
            notSubscribed: 0, collectedThisMonth: 3000),
      ));

  @override
  Future<List<ManagedUserEntity>> getUsers() => _ok('users', users);

  @override
  Future<List<ManagedUserEntity>> getTrainerMembers() => _ok('members', users);

  @override
  Future<void> setUserStatus(int userId, String status) =>
      _ok('status:$userId:$status', null);

  @override
  Future<void> setUserRoles(int userId, List<String> roles) =>
      _ok('roles:$userId:${roles.join(",")}', null);

  @override
  Future<void> deleteUser(int userId) => _ok('delete:$userId', null);

  @override
  Future<List<GymEntity>> getGyms() => _ok('gyms', gyms);

  @override
  Future<List<GymEntity>> getGymOptions() => _ok('gymOptions', gyms);

  @override
  Future<void> saveGym({
    int? gymsId,
    required String name,
    required String email,
    required String city,
    required String phone,
  }) =>
      _ok('saveGym:$gymsId:$name', null);

  @override
  Future<void> setGymStatus(int gymsId, String status) =>
      _ok('gymStatus:$gymsId:$status', null);

  @override
  Future<void> deleteGym(int gymsId) => _ok('deleteGym:$gymsId', null);
}

class FakeAccountRepository implements AccountRepository {
  Object? error;
  List<AddressEntity> addresses = const [
    AddressEntity(
        addressId: 1, street: 'Road 5', buildingName: 'House 12',
        city: 'Dhaka', state: 'Dhaka', country: 'Bangladesh', pincode: '12050'),
  ];
  final calls = <String>[];

  Future<T> _ok<T>(String call, T value) async {
    calls.add(call);
    if (error != null) throw error!;
    return value;
  }

  @override
  Future<void> updateProfile({required String email, String? phone}) =>
      _ok('updateProfile:$email', null);

  @override
  Future<void> changePassword(
          {required String currentPassword, required String newPassword}) =>
      _ok('changePassword', null);

  @override
  Future<List<AddressEntity>> getAddresses() => _ok('addresses', addresses);

  @override
  Future<void> saveAddress({
    int? addressId,
    required String street,
    required String buildingName,
    required String city,
    required String state,
    required String country,
    required String pincode,
  }) =>
      _ok('saveAddress:$addressId', null);

  @override
  Future<void> deleteAddress(int addressId) => _ok('deleteAddress:$addressId', null);
}
