import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/get_saved_username_usecase.dart';

/// Holds the signed-in user's name for the dashboards' greeting.
/// State is null until loaded (or if no name was saved).
class CurrentUserCubit extends Cubit<String?> {
  final GetSavedUsernameUseCase _getSavedUsername;

  CurrentUserCubit(this._getSavedUsername) : super(null);

  Future<void> load() async {
    try {
      emit(await _getSavedUsername());
    } catch (_) {
      emit(null);
    }
  }
}
