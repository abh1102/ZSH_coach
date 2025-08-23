import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zanadu_coach/core/constants.dart';
import 'package:zanadu_coach/feature/login/data/model/offering_model.dart';
import 'package:zanadu_coach/feature/login/data/repository/login_repository.dart';
import 'package:zanadu_coach/feature/users/data/model/all_user_list_model.dart';
import 'package:zanadu_coach/feature/users/data/model/get_answer_model.dart';
import 'package:zanadu_coach/feature/users/data/model/get_over_all_health.dart';
import 'package:zanadu_coach/feature/users/data/model/get_user_detail_model.dart';
import 'package:zanadu_coach/feature/users/data/model/notes_model.dart';
import 'package:zanadu_coach/feature/users/data/model/recommended_offering_model.dart';
import 'package:zanadu_coach/feature/users/data/repository/user_repository.dart';

part 'user_state.dart';

class UserCubit extends Cubit<UserState> {
  UserCubit() : super(UserInitialState());

  final UserRepository _repository = UserRepository();

  LoginRepository loginRepository = LoginRepository();

  Future<void> getUserListByCoach() async {
    emit(UserLoadingState());
    try {
      List<AllUserListModel> userList = await _repository.getUserListByCoach();

      emit(GetUserListState(userList: userList));
    } catch (e) {
      emit(UserErrorState(e.toString()));
    }
  }

  Future<void> getUserDetail({
    required String id,
  }) async {
    emit(UserLoadingState());
    try {
      GetUserDetailModel user = await _repository.getUserDetail(id);

      emit(UserInfoState(user: user));
    } catch (e) {
      emit(UserErrorState(e.toString()));
    }
  }

  Future<void> getUsersAnswer({
    required String id,
  }) async {
    emit(UserLoadingState());
    try {
      List<Result> results = await _repository.getAnswersOfUser(id);

      emit(GetUserAnswersState(result: results));
    } catch (e) {
      emit(UserErrorState(e.toString()));
    }
  }

  Future<void> getUsersSpecialAnswer({
    required String id,
    required String category,
  }) async {
    emit(UserLoadingState());
    try {
      List<Result> results =
          await _repository.fetchAllSpecialIntakeAnswer(id, category);

      emit(GetSpecialUserAnswersState(result: results));
    } catch (e) {
      emit(UserErrorState(e.toString()));
    }
  }

  // get over all health of user

  Future<void> fetchGetHealth(String id) async {
    emit(UserLoadingState());
    try {
      GetOverAllHealthModel health = await _repository.getOverAllHealth(id);

      emit(GetUserHealthLoadedState(health));
    } catch (e) {
      emit(UserErrorState(e.toString()));
    }
  }

  // get user notes

  Future<void> getUserNotes({
    required String userId,
  }) async {
    emit(UserLoadingState());
    try {
      List<NotesModel> notes = await _repository.getPersonalNotes(userId);

      emit(GetUserNotesState(notes: notes));
    } catch (e) {
      emit(UserErrorState(e.toString()));
    }
  }

  /// post user note

  Future<void> postPersonalNote({
    required String userId,
    required String notes,
  }) async {
    emit(UserLoadingState());
    try {
      String message =
          await _repository.postPersonalNote(userId: userId, notes: notes);

      emit(CreateNoteState(message: message));
    } catch (e) {
      emit(UserErrorState(e.toString()));
    }
  }

// edit session function

  Future<void> editSession({
    required String sessionId,
    required bool isApproved,
    required String reasonMessage,
  }) async {
    emit(UserLoadingState());
    try {
      String message =
          await _repository.editSession(sessionId, isApproved, reasonMessage);
      emit(EditSessionState(message));
    } catch (e) {
      emit(UserErrorState(e.toString()));
    }
  }

  Future<void> fetchRecommendedOfferings(String userId, String coachId) async {
    emit(UserLoadingState());
    try {
      List<RecommendedOfferingModel> offerings =
          await _repository.getRecommendedOfferings(userId, coachId);
      emit(GetRecommendedOfferingsState(offerings));
    } catch (e) {
      emit(UserErrorState(e.toString()));
    }
  }

  Future<void> fetchAllAndRecommendedOfferings(
      String userId, String coachId) async {
    emit(UserLoadingState());

    try {
      // Fetch all offerings
      List<OfferingsModel> allOfferings =
          await loginRepository.fetchAllOffering();

      // Filter out the "Health" offering
      allOfferings =
          allOfferings.where((offering) => offering.title != "Health").toList();

      // Fetch recommended offerings
      List<RecommendedOfferingModel> recommendedOfferings =
          await _repository.getRecommendedOfferings(userId, coachId);

      emit(GetAllAndRecommendedOfferingsState(
          allOfferings, recommendedOfferings));
    } catch (e) {
      emit(UserErrorState(e.toString()));
    }
  }

  Future<void> createRecommendedOfferings(
    String userId,
    List<String> offeringIds,
  ) async {
    emit(UserLoadingState());

    try {
      String message =
          await _repository.createRecommendedOfferings(userId, offeringIds);
      emit(CreateRecommendedOfferingsState(message));
      fetchAllAndRecommendedOfferings(userId, myCoach?.userId ?? "");
    } catch (e) {
      emit(UserErrorState(e.toString()));
    }
  }
}
