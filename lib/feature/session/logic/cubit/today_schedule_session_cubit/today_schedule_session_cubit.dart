import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zanadu_coach/feature/session/data/model/all_session_model.dart';
import 'package:zanadu_coach/feature/session/data/repository/all_session_repository.dart';

part 'today_schedule_session_state.dart';

class TodayScheduleSessionCubit extends Cubit<TodayScheduleSessionState> {
  TodayScheduleSessionCubit() : super(TodayScheduleSessionInitialState());

  final AllSessionRepository _repository = AllSessionRepository();

  Future<void> createTodayScheduleSession({
    required String date,
  }) async {
    emit(TodayScheduleSessionLoadingState());

    try {
      AllSessionModel data =
          await _repository.getScheduleSessionsByCoachId(date);

      emit(TodayScheduleSessionLoadedState(data));
    } catch (e) {
      emit(TodayScheduleSessionErrorState(e.toString()));
    }
  }
}
