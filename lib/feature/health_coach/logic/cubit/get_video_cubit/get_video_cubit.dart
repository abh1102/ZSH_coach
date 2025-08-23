import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zanadu_coach/core/constants.dart';
import 'package:zanadu_coach/feature/health_coach/data/repository/health_coach_repository.dart';
import 'package:zanadu_coach/feature/login/data/model/coach_model.dart';

part 'get_video_state.dart';

class GetVideoCubit extends Cubit<GetVideoState> {
  GetVideoCubit() : super(GetVideoInitialState());

  final HealthCoachRepository _repository = HealthCoachRepository();

  Future<void> fetchGetVideo() async {
    emit(GetVideoLoadingState());
    try {
      List<MyVideos> approvedVideos = [];
      List<MyVideos> unapprovedVideos = [];
      List<MyVideos> videos = await _repository.getAllWOCoachVideos(
          myCoach?.userId.toString() ?? "",
          myCoach?.profile?.primaryOfferingId ?? "");

      approvedVideos =
          videos.where((video) => video.isApproved == true).toList();
      unapprovedVideos =
          videos.where((video) => video.isApproved == false).toList();

      emit(GetVideoLoadedState(approvedVideos, unapprovedVideos));
    } catch (e) {
      emit(GetVideoErrorState(e.toString()));
    }
  }

  Future<void> fetchCoachGetVideo(String coachId) async {
    emit(GetVideoLoadingState());
    try {
      List<MyVideos> approvedVideos = [];
      List<MyVideos> unapprovedVideos = [];
      List<MyVideos> videos = await _repository.getAllWOCoachVideos(
          coachId, myCoach?.profile?.primaryOfferingId ?? "");

      approvedVideos =
          videos.where((video) => video.isApproved == true).toList();
      unapprovedVideos =
          videos.where((video) => video.isApproved == false).toList();

      emit(GetCoachVideoLoadedState(approvedVideos, unapprovedVideos));
    } catch (e) {
      emit(GetVideoErrorState(e.toString()));
    }
  }
}
