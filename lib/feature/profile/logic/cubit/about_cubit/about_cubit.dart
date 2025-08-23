import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zanadu_coach/feature/profile/data/model/about_us_model.dart';
import 'package:zanadu_coach/feature/profile/data/repository/profile_repository.dart';

part 'about_state.dart';

class AboutCubit extends Cubit<AboutState> {
  AboutCubit() : super(AboutInitialState()) {
    getAboutData();
  }

  final ProfileRepository _repository = ProfileRepository();

  Future<void> getAboutData() async {
    emit(AboutLoadingState());
    try {
      List<AboutUsModel> abouts = await _repository.fetchAboutUs();

      emit(AboutLoadedState(abouts));
    } catch (e) {
      emit(AboutErrorState(e.toString()));
    }
  }
}
