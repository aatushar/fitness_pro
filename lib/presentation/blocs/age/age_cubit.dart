import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/network/api_exception.dart';
import '../../../domain/entities/birth_info_entity.dart';
import '../../../domain/usecases/get_birth_info_usecase.dart';
import '../../../domain/usecases/save_birth_info_usecase.dart';

enum AgeStatus { loading, ready, saving, failure }

class AgeState {
  final AgeStatus status;
  final BirthInfoEntity? info;
  final String? message;

  const AgeState({this.status = AgeStatus.loading, this.info, this.message});
}

/// The signed-in user's saved birth date/time for the dashboard Age card.
class AgeCubit extends Cubit<AgeState> {
  final GetBirthInfoUseCase _get;
  final SaveBirthInfoUseCase _save;

  AgeCubit(this._get, this._save) : super(const AgeState());

  Future<void> load() async {
    emit(const AgeState());
    try {
      emit(AgeState(status: AgeStatus.ready, info: await _get()));
    } catch (e) {
      emit(AgeState(
          status: AgeStatus.failure, message: ApiException.messageOf(e)));
    }
  }

  /// Saves [birthDateTime]; returns an error message, or null on success.
  Future<String?> save(DateTime birthDateTime) async {
    final previous = state.info;
    emit(AgeState(status: AgeStatus.saving, info: previous));
    try {
      emit(AgeState(status: AgeStatus.ready, info: await _save(birthDateTime)));
      return null;
    } catch (e) {
      final message = ApiException.messageOf(e);
      emit(AgeState(status: AgeStatus.ready, info: previous, message: message));
      return message;
    }
  }
}
