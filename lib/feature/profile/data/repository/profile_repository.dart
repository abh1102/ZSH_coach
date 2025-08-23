import 'package:dio/dio.dart';
import 'package:zanadu_coach/core/api.dart';
import 'package:zanadu_coach/core/constants.dart';
import 'package:zanadu_coach/feature/profile/data/model/about_us_model.dart';
import 'package:zanadu_coach/feature/profile/data/model/coach_session_hours.dart';
import 'package:zanadu_coach/feature/profile/data/model/notification_model.dart';
import 'package:zanadu_coach/feature/profile/data/model/payout_transaction_model.dart';

class ProfileRepository {
  final _api = Api();

  Future<CoachSessionHours> getCoachSession() async {
    try {
      Response response = await _api.sendRequest
          .get("/coach/get-session-hours", options: ApiUtils.getAuthOptions());

      ApiResponse apiResponse = ApiResponse.fromResponse(response);

      if (!apiResponse.status) {
        throw apiResponse.message.toString();
      }

      return CoachSessionHours.fromJson(
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

  // payout transaction

  Future<List<PayoutTransactionModel>> getPayoutTransaction() async {
    try {
      Response response = await _api.sendRequest.get(
        "/coach/get-payouts",
        options: ApiUtils.getAuthOptions(),
      );

      ApiResponse apiResponse = ApiResponse.fromResponse(response);

      if (!apiResponse.status) {
        throw apiResponse.message.toString();
      }

      List<dynamic> data = apiResponse.data as List<dynamic>;

      List<PayoutTransactionModel> userList = data
          .map((userData) => PayoutTransactionModel.fromJson(userData))
          .toList();

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

  Future<String> switchProfile() async {
    try {
      Response response = await _api.sendRequest.get(
        "/coach/switch-profile",
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

  Future<List<NotificationModel>> fetchNotification() async {
    try {
      Response response = await _api.sendRequest.get(
        "/notify/get",
        options: Options(
          headers: {'Authorization': 'Bearer $accessToken'},
        ),
      );

      ApiResponse apiResponse = ApiResponse.fromResponse(response);

      if (!apiResponse.status) {
        throw apiResponse.message.toString();
      }

      List<dynamic> data = apiResponse.data as List<dynamic>;
      return data.map((e) => NotificationModel.fromJson(e)).toList();
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



 Future<List<NotificationModel>> fetchUnreadNotification() async {
    try {
      Response response = await _api.sendRequest.get(
        "/notify/get?type=unread",
        options: Options(
          headers: {'Authorization': 'Bearer $accessToken'},
        ),
      );

      ApiResponse apiResponse = ApiResponse.fromResponse(response);

      if (!apiResponse.status) {
        throw apiResponse.message.toString();
      }

      List<dynamic> data = apiResponse.data as List<dynamic>;
      return data.map((e) => NotificationModel.fromJson(e)).toList();
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


  Future<void> markNotificationAsRead(String notificationId) async {
  try {
    Response response = await _api.sendRequest.patch(
      "/notify/read/$notificationId",
      options: Options(
        headers: {'Authorization': 'Bearer $accessToken'},
      ),
    );

    ApiResponse apiResponse = ApiResponse.fromResponse(response);

    if (!apiResponse.status) {
      throw apiResponse.message.toString();
    }
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

  Future<List<AboutUsModel>> fetchAboutUs() async {
    try {
      Response response = await _api.sendRequest.get(
        "/common/get-about-us",
        options: Options(
          headers: {'Authorization': 'Bearer $accessToken'},
        ),
      );

      ApiResponse apiResponse = ApiResponse.fromResponse(response);

      if (!apiResponse.status) {
        throw apiResponse.message.toString();
      }

      List<dynamic> data = apiResponse.data as List<dynamic>;
      return data.map((e) => AboutUsModel.fromJson(e)).toList();
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
