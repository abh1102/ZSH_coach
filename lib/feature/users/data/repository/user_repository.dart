import 'package:dio/dio.dart';
import 'package:zanadu_coach/core/api.dart';
import 'package:zanadu_coach/core/constants.dart';
import 'package:zanadu_coach/feature/users/data/model/all_user_list_model.dart';
import 'package:zanadu_coach/feature/users/data/model/get_answer_model.dart';
import 'package:zanadu_coach/feature/users/data/model/get_over_all_health.dart';
import 'package:zanadu_coach/feature/users/data/model/get_user_detail_model.dart';
import 'package:zanadu_coach/feature/users/data/model/notes_model.dart';
import 'package:zanadu_coach/feature/users/data/model/recommended_offering_model.dart';

class UserRepository {
  final _api = Api();

// get user list

  Future<List<AllUserListModel>> getUserListByCoach() async {
    try {
      Response response = await _api.sendRequest.get(
        "/coach/get-userlist-by-coach",
        options: ApiUtils.getAuthOptions(),
      );

      ApiResponse apiResponse = ApiResponse.fromResponse(response);

      if (!apiResponse.status) {
        throw apiResponse.message.toString();
      }

      List<dynamic> data = apiResponse.data as List<dynamic>;

      List<AllUserListModel> userList =
          data.map((userData) => AllUserListModel.fromJson(userData)).toList();

      return userList;
    } on DioException catch (ex) {
      if (ex.response != null) {
        ApiResponse apiResponse = ApiResponse.fromResponse(ex.response!);
        throw apiResponse.message.toString();
      } else {
        throw "An error occurred while processing the request.";
      }
    } catch (ex) {
      rethrow;
    }
  }

  Future<GetUserDetailModel> getUserDetail(String id) async {
    try {
      Response response = await _api.sendRequest.get(
          "/coach/get-user-details/$id",
          options: ApiUtils.getAuthOptions());

      ApiResponse apiResponse = ApiResponse.fromResponse(response);

      if (!apiResponse.status) {
        throw apiResponse.message.toString();
      }

      return GetUserDetailModel.fromJson(
          apiResponse.data as Map<String, dynamic>);
    } on DioException catch (ex) {
      if (ex.response != null) {
        ApiResponse apiResponse = ApiResponse.fromResponse(ex.response!);
        throw apiResponse.message.toString();
      } else {
        throw "An error occurred while processing the request.";
      }
    } catch (ex) {
      rethrow;
    }
  }

// get answer of user
  Future<List<Result>> getAnswersOfUser(String id) async {
    try {
      Response response = await _api.sendRequest.get(
        "/user/get-input-answer-healthIntake/$id",
        options: ApiUtils.getAuthOptions(),
      );

      ApiResponse apiResponse = ApiResponse.fromResponse(response);

      if (!apiResponse.status) {
        throw apiResponse.message.toString();
      }

      List<dynamic> data = apiResponse.data as List<dynamic>;

      if (data.isEmpty) {
        // Return an empty list when the data is empty
        return [];
      }

      // Extracting the first index data from the array
      Map<String, dynamic> firstIndexData = data.first;

      // Creating a list of Result from the extracted data
      List<Result> resultList = (firstIndexData['result'] as List<dynamic>)
          .map((resultData) => Result.fromJson(resultData))
          .toList();

      return resultList;
    } on DioException catch (ex) {
      if (ex.response != null) {
        ApiResponse apiResponse = ApiResponse.fromResponse(ex.response!);
        throw apiResponse.message.toString();
      } else {
        throw "An error occurred while processing the request.";
      }
    } catch (ex) {
      rethrow;
    }
  }

// get over all health of user

  Future<GetOverAllHealthModel> getOverAllHealth(String id) async {
    try {
      Response response = await _api.sendRequest.get(
          "/user/get-overall-health-score/$id",
          options: ApiUtils.getAuthOptions());

      ApiResponse apiResponse = ApiResponse.fromResponse(response);

      if (!apiResponse.status) {
        throw apiResponse.message.toString();
      }

      return GetOverAllHealthModel.fromJson(
          apiResponse.data as Map<String, dynamic>);
    } on DioException catch (ex) {
      if (ex.response != null) {
        ApiResponse apiResponse = ApiResponse.fromResponse(ex.response!);
        throw apiResponse.message.toString();
      } else {
        throw "An error occurred while processing the request.";
      }
    } catch (ex) {
      rethrow;
    }
  }

// get user notes

  Future<List<NotesModel>> getPersonalNotes(String userId) async {
    try {
      Response response = await _api.sendRequest.get(
        "/coach/get-personal-note/$userId",
        options: ApiUtils.getAuthOptions(),
      );

      ApiResponse apiResponse = ApiResponse.fromResponse(response);

      if (!apiResponse.status) {
        throw apiResponse.message.toString();
      }

      List<dynamic> data = apiResponse.data as List<dynamic>;

      if (data.isEmpty) {
        // Return an empty list when the data is empty
        return [];
      }

      // Create a list of NotesModel from the data
      List<NotesModel> notesList =
          data.map((notesData) => NotesModel.fromJson(notesData)).toList();

      return notesList;
    } on DioException catch (ex) {
      if (ex.response != null) {
        ApiResponse apiResponse = ApiResponse.fromResponse(ex.response!);
        throw apiResponse.message.toString();
      } else {
        throw "An error occurred while processing the request.";
      }
    } catch (ex) {
      rethrow;
    }
  }

  // create user note

  Future<String> postPersonalNote({
    required String userId,
    required String notes,
  }) async {
    try {
      Map<String, dynamic> data = {
        "userId": userId,
        "notes": notes,
      };

      Response response = await _api.sendRequest.post(
        "/coach/create-personal-note",
        data: data,
        options: ApiUtils.getAuthOptions(),
      );

      ApiResponse apiResponse = ApiResponse.fromResponse(response);

      if (!apiResponse.status) {
        throw apiResponse.message.toString();
      }

      return apiResponse.message.toString();
    } on DioException catch (ex) {
      if (ex.response != null) {
        ApiResponse apiResponse = ApiResponse.fromResponse(ex.response!);
        throw apiResponse.message.toString();
      } else {
        throw "An error occurred while processing the request.";
      }
    } catch (ex) {
      rethrow;
    }
  }

// accept or decline request of sessions

  Future<String> editSession(
      String sessionId, bool isApproved, String reasonMessage) async {
    try {
      // Create the request body
      Map<String, dynamic> requestBody = {
        "isApproved": isApproved,
        "reasonMessage": reasonMessage,
      };

      // Make the PATCH request
      Response response = await _api.sendRequest.patch(
        "/coach/edit-session/$sessionId",
        data: requestBody,
        options: ApiUtils.getAuthOptions(),
      );

      ApiResponse apiResponse = ApiResponse.fromResponse(response);

      if (!apiResponse.status) {
        throw apiResponse.message.toString();
      }

      // Return success message or any other relevant information
      return apiResponse.message.toString();
    } on DioException catch (ex) {
      if (ex.response != null) {
        ApiResponse apiResponse = ApiResponse.fromResponse(ex.response!);
        throw apiResponse.message.toString();
      } else {
        throw "An error occurred while processing the request.";
      }
    } catch (ex) {
      rethrow;
    }
  }

// function for get offering
  Future<List<RecommendedOfferingModel>> getRecommendedOfferings(
      String userId, String coachId) async {
    try {
      Response response = await _api.sendRequest.get(
        "/coach/get-recommended-offerings?userId=$userId&coachId=$coachId",
        options: ApiUtils.getAuthOptions(),
      );

      ApiResponse apiResponse = ApiResponse.fromResponse(response);

      if (!apiResponse.status) {
        throw apiResponse.message.toString();
      }

      List<dynamic> data = apiResponse.data as List<dynamic>;

      // Create a list of RecommendedOfferingModel from the data
      List<RecommendedOfferingModel> offeringsList = data
          .map(
              (offeringData) => RecommendedOfferingModel.fromJson(offeringData))
          .toList();

      return offeringsList;
    } on DioException catch (ex) {
      if (ex.response != null) {
        ApiResponse apiResponse = ApiResponse.fromResponse(ex.response!);
        throw apiResponse.message.toString();
      } else {
        throw "An error occurred while processing the request.";
      }
    } catch (ex) {
      rethrow;
    }
  }

  // create recommended offerings

  Future<String> createRecommendedOfferings(
      String userId, List<String> offeringIds) async {
    try {
      Response response = await _api.sendRequest.post(
        "/coach/create-recommended-offerings/$userId",
        data: offeringIds,
        options: ApiUtils.getAuthOptions(),
      );

      ApiResponse apiResponse = ApiResponse.fromResponse(response);

      if (!apiResponse.status) {
        throw apiResponse.message.toString();
      }

      return apiResponse.message.toString();
    } on DioException catch (ex) {
      if (ex.response != null) {
        ApiResponse apiResponse = ApiResponse.fromResponse(ex.response!);
        throw apiResponse.message.toString();
      } else {
        throw "An error occurred while processing the request.";
      }
    } catch (ex) {
      rethrow;
    }
  }

  ///

  Future<List<Result>> fetchAllSpecialIntakeAnswer(
      String userId, String category) async {
    try {
      Response response = await _api.sendRequest.get(
        "/user/get-input-answer-special-healthIntake/$userId?category=$category",
        options: Options(
          headers: {'Authorization': 'Bearer $accessToken'},
        ),
      );

      ApiResponse apiResponse = ApiResponse.fromResponse(response);

      if (!apiResponse.status) {
        throw apiResponse.message.toString();
      }

      List<dynamic> data = apiResponse.data as List<dynamic>;

      if (data.isEmpty) {
        // Return an empty list when the data is empty
        return [];
      }

      // Extracting the first index data from the array
      Map<String, dynamic> firstIndexData = data.first;

      // Creating a list of Result from the extracted data
      List<Result> resultList = (firstIndexData['result'] as List<dynamic>)
          .map((resultData) => Result.fromJson(resultData))
          .toList();

      return resultList;
    } on DioException catch (ex) {
      if (ex.response != null) {
        ApiResponse apiResponse = ApiResponse.fromResponse(ex.response!);
        throw apiResponse.message.toString();
      } else {
        throw "An error occurred while processing the request.";
      }
    } catch (ex) {
      rethrow;
    }
  }
}