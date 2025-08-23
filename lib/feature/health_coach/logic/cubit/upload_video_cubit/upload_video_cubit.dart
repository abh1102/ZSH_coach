import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zanadu_coach/feature/health_coach/data/repository/health_coach_repository.dart';

part 'upload_video_state.dart';

class UploadVideoCubit extends Cubit<UploadVideoState> {
  UploadVideoCubit() : super(UploadVideoInitialState());

  final HealthCoachRepository _repository = HealthCoachRepository();

  Future<void> uploadCoachVideo(
      {required File videoFile,
      required String title,
      required String videoType,
      required String description,
       File? thumbnailImage}) async {
    emit(UploadVideoLoadingState());
    try {
      String message = await _repository.uploadCoachVideo(
          videoType: videoType,
          videoFile: videoFile,
          title: title,
          description: description,
          thumbnailImage: thumbnailImage);

      // After successful upload, fetch updated data
      emit(CoachVideoUploadedState(message));
    } catch (e) {
      emit(UploadVideoErrorState(e.toString()));
    }
  }
}
