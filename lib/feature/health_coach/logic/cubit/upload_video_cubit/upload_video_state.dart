part of 'upload_video_cubit.dart';

abstract class UploadVideoState {}

class UploadVideoInitialState extends UploadVideoState {}

class UploadVideoLoadingState extends UploadVideoState {}



class CoachVideoUploadedState extends UploadVideoState {
  final String message;
  CoachVideoUploadedState(this.message);
}

class UploadVideoErrorState extends UploadVideoState {
  final String error;
  UploadVideoErrorState(this.error);
}
