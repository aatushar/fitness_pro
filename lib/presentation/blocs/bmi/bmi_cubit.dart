import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/network/api_exception.dart';
import '../../../domain/entities/bmi_record_entity.dart';
import '../../../domain/usecases/get_bmi_usecase.dart';
import '../../../domain/usecases/save_bmi_usecase.dart';

enum BmiStatus { loading, ready, saving, failure }

class BmiState {
  final BmiStatus status;
  final BmiOverviewEntity? overview;
  final String? message;

  const BmiState({this.status = BmiStatus.loading, this.overview, this.message});
}

/// The signed-in user's saved BMI readings for the dashboard BMI card.
class BmiCubit extends Cubit<BmiState> {
  final GetBmiUseCase _get;
  final SaveBmiUseCase _save;

  BmiCubit(this._get, this._save) : super(const BmiState());

  Future<void> load() async {
    emit(const BmiState());
    try {
      emit(BmiState(status: BmiStatus.ready, overview: await _get()));
    } catch (e) {
      emit(BmiState(status: BmiStatus.failure, message: ApiException.messageOf(e)));
    }
  }

  /// Saves a reading; returns an error message, or null on success.
  Future<String?> save({
    required double heightCm,
    required double weightKg,
    required String gender,
  }) async {
    final previous = state.overview;
    emit(BmiState(status: BmiStatus.saving, overview: previous));
    try {
      final overview = await _save(
          heightCm: heightCm, weightKg: weightKg, gender: gender);
      emit(BmiState(status: BmiStatus.ready, overview: overview));
      return null;
    } catch (e) {
      final message = ApiException.messageOf(e);
      emit(BmiState(status: BmiStatus.ready, overview: previous, message: message));
      return message;
    }
  }
}
