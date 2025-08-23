import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zanadu_coach/feature/health_coach/data/model/all_health_coach_model.dart';
import 'package:zanadu_coach/feature/health_coach/data/repository/health_coach_repository.dart';

part 'health_coach_state.dart';

class FiveHealthCoachCubit extends Cubit<FiveHealthCoachState> {
  FiveHealthCoachCubit() : super(FiveHealthCoachInitialState()) {
    _initialize();
  }
  Future<void> _initialize() async {
    await fetchFiveHealthCoach();
  }

  final HealthCoachRepository _repository = HealthCoachRepository();

  Future<void> fetchFiveHealthCoach() async {
    emit(FiveHealthCoachLoadingState());
    try {
      List<AllHealthCoachesModel> fiveHealthCoach =
          await _repository.fetchTopFiveCoach();

      emit(FiveHealthCoachLoadedState(fiveHealthCoach));
    } catch (e) {
      emit(FiveHealthCoachErrorState(e.toString()));
    }
  }
}
