import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:intl/intl.dart';
import 'package:zanadu_coach/common/utils/dialog_utils.dart';
import 'package:zanadu_coach/core/api.dart';
import 'package:zanadu_coach/core/constants.dart';
import 'package:zanadu_coach/feature/session/data/model/accept_one_session_model.dart';
import 'package:zanadu_coach/feature/session/data/model/all_session_model.dart';
import 'package:zanadu_coach/feature/session/data/model/calendar_available_model.dart';
import 'package:zanadu_coach/feature/session/data/model/get_feedback_model.dart';
import 'package:zanadu_coach/feature/session/data/model/weekly_schedule_model.dart';

class AllSessionRepository {
  final _api = Api();

  Future<AllSessionModel> getSessionByCoach() async {
    try {
      Response response = await _api.sendRequest.get(
          "/coach/get-session-by-coach-all",
          options: ApiUtils.getAuthOptions());

      ApiResponse apiResponse = ApiResponse.fromResponse(response);

      if (!apiResponse.status) {
        throw apiResponse.message.toString();
      }

      return AllSessionModel.fromJson(apiResponse.data as Map<String, dynamic>);
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
// create  group sessions

  Future<String> createSession({
    required String sessionType,
    required String offeringId,
    required String title,
    required String description,
    required String startDate,
    required int noOfSlots,
    required String coachId,
  }) async {
    try {
      Map<String, dynamic> requestData = {
        "sessionType": sessionType,
        "title": title,
        "description": description,
        "startDate": startDate,
        "noOfSlots": noOfSlots,
        "coachId": coachId,
        "offeringId": offeringId,
      };

      Response response = await _api.sendRequest.post(
        "/coach/create-session",
        data: requestData,
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

  Future<String> createOneOnOneSession({
    required String sessionType,
    required String title,
    required String description,
    required String offeringId,
    required String startDate,
    required int noOfSlots,
    required String coachId,
    required String userId,
  }) async {
    try {
      Map<String, dynamic> requestData = {
        "sessionType": sessionType,
        "title": title,
        "description": description,
        "startDate": startDate,
        "noOfSlots": noOfSlots,
        "coachId": coachId,
        "offeringId": offeringId,
        "userId": [userId]
      };

      Response response = await _api.sendRequest.post(
        "/coach/create-session",
        data: requestData,
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

  // fetch one session accept list

  Future<AcceptModel> getOneSessionAccep() async {
    try {
      Response response = await _api.sendRequest.get(
          "/coach/get-sessions-for-accept-all",
          options: ApiUtils.getAuthOptions());

      ApiResponse apiResponse = ApiResponse.fromResponse(response);

      if (!apiResponse.status) {
        throw apiResponse.message.toString();
      }
      return AcceptModel.fromJson(apiResponse.data as Map<String, dynamic>);
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

  // reschedule session function

  Future<String> rescheduleSession(
      String sessionId, String startDate, String reasonMessage) async {
    try {
      Map<String, dynamic> requestData = {
        "startDate": startDate,
        "reasonMessage": reasonMessage,
      };

      Response response = await _api.sendRequest.patch(
        "/coach/edit-session/$sessionId",
        data: requestData,
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

  // cancel session function
  Future<String> cancelSession(String sessionId, String reasonMessage) async {
    try {
      Map<String, dynamic> requestData = {
        "reasonMessage": reasonMessage,
      };

      Response response = await _api.sendRequest.patch(
        "/coach/cancel-session/$sessionId",
        data: requestData,
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

  // calendar repository
  Future<List<CalendarAvailableModel>> getAvailableDates(
      [DateTime? date]) async {
    try {
      // If date is not provided, default to the current date
      date ??= DateTime.now();

      // Format the date as 'yyyy-MM-dd'
      String formattedDate = DateFormat('yyyy-MM-dd').format(date);

      Response response = await _api.sendRequest.get(
        "/coach/calender/get-available",
        options: ApiUtils.getAuthOptions(),
        queryParameters: {'date': formattedDate},
      );

      ApiResponse apiResponse = ApiResponse.fromResponse(response);

      if (!apiResponse.status) {
        throw apiResponse.message.toString();
      }

      List<dynamic> data = apiResponse.data as List<dynamic>;
      return data.map((e) => CalendarAvailableModel.fromJson(e)).toList();
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

  Future<String> createCalendarDate({
    required String type,
    List<int>? days,
    required String startDate,
    required String endDate,
    required List<Map<String, dynamic>> timeSlots,
  }) async {
    try {
      Map<String, dynamic> requestData = {
        "type": type,
        "startDate": startDate,
        "endDate": endDate,
        "timeSlots": timeSlots,
      };

      if (type == "WEEKLY") {
        requestData["days"] = days;
      }

      Response response = await _api.sendRequest.post(
        "/coach/calender/create-available",
        data: jsonEncode(requestData),
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

  Future<List<Sessions>> getScheduleSessions(String date) async {
    try {
      Response response = await _api.sendRequest.get(
          "/coach/calender/get-all-sessions-of-the-day?date=$date",
          options: ApiUtils.getAuthOptions());

      ApiResponse apiResponse = ApiResponse.fromResponse(response);

      if (!apiResponse.status) {
        throw apiResponse.message.toString();
      }

      List<dynamic> data = apiResponse.data as List<dynamic>;
      return data.map((e) => Sessions.fromJson(e)).toList();
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

  Future<String> createFeedback({
    required String sessionId,
    required String rateOfExperience,
    required String coachRate,
    required String callQualityRate,
    required String easyToUseRate,
    required String privacySecurityRate,
  }) async {
    try {
      Map<String, dynamic> requestData = {
        "sessionId": sessionId,
        "rateOfExperience": rateOfExperience,
        "coachRate": coachRate,
        "callQualityRate": callQualityRate,
        "easyToUseRate": easyToUseRate,
        "privacySecurityRate": privacySecurityRate,
      };

      Response response = await _api.sendRequest.post(
        "/user/feedback/create",
        data: requestData,
        options: ApiUtils.getAuthOptions(),
      );

      ApiResponse apiResponse = ApiResponse.fromResponse(response);

      if (!apiResponse.status) {
        throw apiResponse.message.toString();
      }

      return apiResponse.message.toString();
      // You may return additional data from the response if needed
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

  // get feedback repository

  Future<GetFeedBackModel> getFeedbackModel() async {
    try {
      Response response = await _api.sendRequest.get(
        "/user/feedback/check-by-user-recent",
        options: Options(
          headers: {'Authorization': 'Bearer $accessToken'},
        ),
      );

      ApiResponse apiResponse = ApiResponse.fromResponse(response);

      if (!apiResponse.status) {
        throw apiResponse.message.toString();
      }

      return GetFeedBackModel.fromJson(
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

  // get available of the week

  Future<List<WeeklyScheduleModel>> getScheduleWeek(String date) async {
    try {
      Response response = await _api.sendRequest.get(
          "/coach/calender/get-time-slot-of-the-day?date=$date",
          options: ApiUtils.getAuthOptions());

      ApiResponse apiResponse = ApiResponse.fromResponse(response);

      if (!apiResponse.status) {
        throw apiResponse.message.toString();
      }

      List<dynamic> data = apiResponse.data as List<dynamic>;
      return data.map((e) => WeeklyScheduleModel.fromJson(e)).toList();
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

  // remove time slot

  Future<String> removeTimeSlot({
    required String coachId,
    required String date,
    required String timeSlotId,
  }) async {
    try {
      Map<String, dynamic> requestData = {
        "coachId": coachId,
        "date": date,
        "timeSlotId": timeSlotId,
      };

      Response response = await _api.sendRequest.delete(
        "/coach/calender/remove-time-slot",
        data: requestData,
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

  // get session of the day
  
  Future<AllSessionModel> getScheduleSessionsByCoachId(String date) async {
    try {
      Response response = await _api.sendRequest.get(
        "/coach/get-session-of-the-day?coachId=${myCoach?.userId}&date=$date",
        options: ApiUtils.getAuthOptions(),
      );

      ApiResponse apiResponse = ApiResponse.fromResponse(response);

      if (!apiResponse.status) {
        throw apiResponse.message.toString();
      }

      return AllSessionModel.fromJson(apiResponse.data as Map<String, dynamic>);
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

  // attend session

  Future<String> attendSession(
    String sessionId,
  ) async {
    try {
      Response response = await _api.sendRequest.patch(
        "/coach/attend-session/$sessionId",
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

  // create google event api

  Future<String> createGoogleEventApi({
    required String googleToken,
    required String summary,
    required String description,
    required String eventDate,
    required int beforeTime,
  }) async {
    try {
      Map<String, dynamic> requestData = {
        "googleToken": googleToken,
        "summary": summary,
        "description": description,
        "eventDate": eventDate,
        "beforeTime": beforeTime,
      };

      Response response = await _api.sendRequest.post(
        "/common/google-token",
        data: requestData,
        options: ApiUtils.getAuthOptions(),
      );

      ApiResponse apiResponse = ApiResponse.fromResponse(response);

      if (!apiResponse.status) {
        showSnackBar(apiResponse.message.toString());
        throw apiResponse.message.toString();
      }

      showGreenSnackBar(apiResponse.message.toString());

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
}
