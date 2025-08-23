import 'package:flutter/material.dart';
import 'package:zanadu_coach/feature/login/data/model/offering_model.dart';

class SignUpProvider with ChangeNotifier {
  final BuildContext context;
  SignUpProvider(this.context);

  DateTime? startDate;
  DateTime? endDate;
  List<OfferingsModel> allOfferings = [];
  OfferingsModel? selectedOfferingP; // Store the selected offering
  List<String> selectedHealthChallengesP = [];
  String selectedGenderP = 'Select Gender';
  String selectHealthChallengesP = '';
  String selectResidentStateP = '';
  String selectResidentCountryP = '';
  String? filePathP;
  String? govermentFileP;

  String? certificateFileP;

  final TextEditingController emailControllerP = TextEditingController();

  final TextEditingController countryCodeControllerP = TextEditingController();
  final TextEditingController passwordControllerP = TextEditingController();
  final TextEditingController phoneNumberControllerP = TextEditingController();
  final TextEditingController fullNameControllerP = TextEditingController();

  final TextEditingController stateControllerP = TextEditingController();

  final TextEditingController countryControllerP = TextEditingController();

  void pickStartDate() async {
    final currentDate = DateTime.now();
    final minimumDate =
        DateTime(currentDate.year - 21, currentDate.month, currentDate.day);

    final pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime(1920),
      firstDate: DateTime(1920),
      lastDate: minimumDate,
    );

    if (pickedDate != null) {
      setStartDate(pickedDate);
    }
    notifyListeners();
  }

  void setStartDate(DateTime start) {
    startDate = start;
    notifyListeners();
  }

  void updateselectedHealthChallengesP(List<String> values) {
    selectedHealthChallengesP = values;

    notifyListeners();
  }

  void updateGovermentFilePath(String filePath) {
    govermentFileP = filePathP;

    notifyListeners();
  }

  void updateCertificateFilePath(String filePath) {
    certificateFileP = filePathP;
    notifyListeners();
  }

  void updateProfileFilePath(String filePath) {
    filePathP = filePath;
    notifyListeners();
  }

  void updateGender(String gender) {
    selectedGenderP = gender;
    notifyListeners();
  }

  void clearAllValues() {
    startDate = null;
    endDate = null;
    selectedOfferingP = null;
    selectedHealthChallengesP = [];
    selectedGenderP = 'Select Gender';
    selectHealthChallengesP = '';
    selectResidentStateP = '';
    selectResidentCountryP = '';
    filePathP = null;
    govermentFileP = null;
    certificateFileP = null;
    allOfferings = [];
    emailControllerP.clear();
    countryCodeControllerP.clear();
    passwordControllerP.clear();
    phoneNumberControllerP.clear();
    fullNameControllerP.clear();
    stateControllerP.clear();
    countryControllerP.clear();

    notifyListeners();
    print("cleard");
  }
}
// remember to clear the values of provider