import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zanadu_coach/core/constants.dart';
import 'package:zanadu_coach/feature/login/data/model/coach_model.dart';
import 'package:zanadu_coach/feature/login/data/repository/login_repository.dart';
import 'package:zanadu_coach/feature/profile/data/repository/profile_repository.dart';

part 'switch_profile_state.dart';

class SwitchProfileCubit extends Cubit<SwitchProfileState> {
  SwitchProfileCubit() : super(SwitchProfileInitialState());

  final ProfileRepository _repository = ProfileRepository();
  final LoginRepository loginrepository = LoginRepository();

  Future<void> getSwitchProfileData() async {
    emit(SwitchProfileLoadingState());
    try {
      String message = await _repository.switchProfile();

      CoachModel userModel =
          await loginrepository.fetchUserInfo(token: accessToken);

      myCoach = userModel;

      emit(SwitchProfileLoadedState(message));
    } catch (e) {
      emit(SwitchProfileErrorState(e.toString()));
    }
  }
}
