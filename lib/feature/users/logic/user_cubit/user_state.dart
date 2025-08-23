part of 'user_cubit.dart';

abstract class UserState {}

class UserInitialState extends UserState {}

class UserLoadingState extends UserState {}

// Add this to user_state.dart
class GetUserListState extends UserState {
  final List<AllUserListModel> userList;

  GetUserListState({required this.userList});
}

class UserInfoState extends UserState {
  final GetUserDetailModel user;

  UserInfoState({required this.user});
}

class GetUserAnswersState extends UserState {
  final List<Result> result;

  GetUserAnswersState({required this.result});
}

class GetSpecialUserAnswersState extends UserState {
  final List<Result> result;

  GetSpecialUserAnswersState({required this.result});
}

class GetUserHealthLoadedState extends UserState {
  final GetOverAllHealthModel health;
  GetUserHealthLoadedState(this.health);
}

class GetUserNotesState extends UserState {
  final List<NotesModel> notes;

  GetUserNotesState({
    required this.notes,
  });
}

class CreateNoteState extends UserState {
  final String message;

  CreateNoteState({
    required this.message,
  });
}

class EditSessionState extends UserState {
  final String message;

  EditSessionState(this.message);
}

class GetRecommendedOfferingsState extends UserState {
  final List<RecommendedOfferingModel> offerings;

  GetRecommendedOfferingsState(this.offerings);
}

class GetAllAndRecommendedOfferingsState extends UserState {
  final List<OfferingsModel> allOfferings;
  final List<RecommendedOfferingModel> recommendedOfferings;

  GetAllAndRecommendedOfferingsState(
      this.allOfferings, this.recommendedOfferings);
}

class CreateRecommendedOfferingsState extends UserState {
  final String message;

  CreateRecommendedOfferingsState(this.message);
}

class UserErrorState extends UserState {
  final String error;
  UserErrorState(this.error);
}
