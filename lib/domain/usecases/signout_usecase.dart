import '../repositories/auth_repository.dart';
import '../services/reminder_scheduler.dart';

class SignoutUseCase {
  final AuthRepository _repo;
  final ReminderScheduler _reminders;
  SignoutUseCase(this._repo, this._reminders);

  Future<void> call() async {
    await _repo.signout();
    // The next person to sign in on this phone must not get this member's
    // fee reminders. Best effort: signing out already succeeded.
    try {
      await _reminders.cancelAll();
    } catch (_) {}
  }
}
