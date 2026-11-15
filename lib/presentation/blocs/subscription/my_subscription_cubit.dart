import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/network/api_exception.dart';
import '../../../domain/entities/subscription_entity.dart';
import '../../../domain/services/reminder_scheduler.dart';
import '../../../domain/usecases/get_my_subscription_usecase.dart';

sealed class MySubscriptionState {
  const MySubscriptionState();
}

class MySubscriptionLoading extends MySubscriptionState {
  const MySubscriptionLoading();
}

class MySubscriptionLoaded extends MySubscriptionState {
  final SubscriptionEntity subscription;
  const MySubscriptionLoaded(this.subscription);
}

class MySubscriptionFailure extends MySubscriptionState {
  final String message;
  const MySubscriptionFailure(this.message);
}

/// The signed-in member's subscription for their dashboard. Every time it is
/// loaded it also re-sets the phone reminders, so a renewal by the admin moves
/// them to the new end date.
class MySubscriptionCubit extends Cubit<MySubscriptionState> {
  final GetMySubscriptionUseCase _getMySubscription;
  final ReminderScheduler _reminders;

  MySubscriptionCubit(this._getMySubscription, this._reminders)
      : super(const MySubscriptionLoading());

  Future<void> load() async {
    emit(const MySubscriptionLoading());
    final SubscriptionEntity subscription;
    try {
      subscription = await _getMySubscription();
    } catch (e) {
      emit(MySubscriptionFailure(ApiException.messageOf(e)));
      return;
    }
    emit(MySubscriptionLoaded(subscription));

    // Reminders are a bonus: a notification problem must not break the card.
    try {
      await _reminders.scheduleFor(subscription);
    } catch (_) {}
  }
}
