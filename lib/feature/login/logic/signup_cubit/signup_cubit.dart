import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zanadu_coach/core/api.dart';
import 'package:zanadu_coach/feature/login/data/model/offering_model.dart';
import 'package:zanadu_coach/feature/login/data/repository/login_repository.dart';

part 'signup_state.dart';

class SignUpCubit extends Cubit<SignUpState> {
  SignUpCubit() : super(SignUpInitialState()) {
    fetchAllOffering();
  }

  final LoginRepository _repository = LoginRepository();

  /// signup function
  Future<void> signUp({
    required String pdfFile,
    required String email,
     String? password,
    required String phoneNumber,
    required String fullName,
    required String govrnmentIssuedId,
    required String certificate,
    required String country,
    required String dob,
    required String gender,
    required String state,
    required List<String> areaOfSpecialization,
    String? healthCoachId,
    required List<String> specialityCoachId,
  }) async {
    emit(SignUpLoadingState());
    try {
      ApiResponse signUpResponse = await _repository.signUp(
        certificate: certificate,
        country: country,
        govrnmentIssuedId: govrnmentIssuedId,
        pdfFile: pdfFile,
        email: email,
        password: password,
        phoneNumber: phoneNumber,
        fullName: fullName,
        dob: dob,
        gender: gender,
        state: state,
        areaOfSpecialization: areaOfSpecialization,
        healthCoachId: healthCoachId,
        specialityCoachId: specialityCoachId,
      );

      // Check if the signup was successful
      if (signUpResponse.status) {
        // If successful, show the message and navigate to the login page
        emit(SignUpLoadedState(signUpResponse.message));
      } else {
        // If signup fails, emit an error state
        emit(SignUpErrorState(signUpResponse.message));
      }
    } catch (e) {
      emit(SignUpErrorState(e.toString()));
    }
  }

//function for fetching offering

  Future<void> fetchAllOffering() async {
    emit((OfferingLoadingState()));
    try {
      List<OfferingsModel> allOffering = await _repository.fetchAllOffering();

      emit(AllOfferingLoadedState(allOffering));
    } catch (e) {
      emit(OfferErrorState(e.toString()));
    }
  }
}
