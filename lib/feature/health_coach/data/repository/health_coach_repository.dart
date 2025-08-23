import 'dart:io';

import 'package:dio/dio.dart';
import 'package:zanadu_coach/core/api.dart';
import 'package:zanadu_coach/core/constants.dart';
import 'package:zanadu_coach/feature/health_coach/data/model/all_health_coach_model.dart';
import 'package:zanadu_coach/feature/login/data/model/coach_model.dart';

class HealthCoachRepository {
  final _api = Api();

  // top 5 health coach

  Future<List<AllHealthCoachesModel>> fetchTopFiveCoach() async {
    try {
      Response response = await _api.sendRequest.get(
        "/coach/get-best-health-coaches",
        options: Options(
          headers: {'Authorization': 'Bearer $accessToken'},
        ),
      );

      ApiResponse apiResponse = ApiResponse.fromResponse(response);

      if (!apiResponse.status) {
        throw apiResponse.message.toString();
      }

      List<dynamic> data = apiResponse.data as List<dynamic>;
      return data.map((e) => AllHealthCoachesModel.fromJson(e)).toList();
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

  Future<String> uploadCoachVideo({
    required File videoFile,
    File? thumbnailImage,
    required String videoType,
    required String title,
    required String description,
  }) async {
    try {
      // Create FormData
      FormData formData = FormData();

      // Add video file to FormData
      formData.files.add(
        MapEntry(
          'file',
          await MultipartFile.fromFile(
            videoFile.path,
            filename: 'video.mp4',
          ),
        ),
      );

      // Add title, description, and videoType to FormData
      formData.fields.addAll({
        'title': title,
        'description': description,
        'videoType': videoType,
      }.entries);

      // Add thumbnailImage to FormData if provided
      if (thumbnailImage != null) {
        formData.files.add(
          MapEntry(
            'thumbnailImage',
            await MultipartFile.fromFile(
              thumbnailImage.path,
              filename: 'thumbnail.png',
            ),
          ),
        );
      }

      // Make the request
      Response response = await _api.sendRequest.patch(
        "/coach/upload-video/${myCoach?.profile?.primaryOfferingId}",
        data: formData,
        options: Options(
          headers: {'Authorization': 'Bearer $accessToken'},
        ),
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

  Future<List<MyVideos>> getAllCoachVideos(
      String coachId, String offeringId) async {
    try {
      Response response = await _api.sendRequest.get(
        "/coach/get-videos?coachId=$coachId&offeringId=${myCoach?.profile?.primaryOfferingId}",
        options: Options(
          headers: {'Authorization': 'Bearer $accessToken'},
        ),
      );

      ApiResponse apiResponse = ApiResponse.fromResponse(response);

      if (!apiResponse.status) {
        throw apiResponse.message.toString();
      }

      List<dynamic> data = apiResponse.data as List<dynamic>;
      return data.map((e) => MyVideos.fromJson(e)).toList();
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

  Future<List<MyVideos>> getAllWOCoachVideos(
      String coachId, String offeringId) async {
    try {
      Response response = await _api.sendRequest.get(
        "/coach/get-videos?coachId=$coachId",
        options: Options(
          headers: {'Authorization': 'Bearer $accessToken'},
        ),
      );

      ApiResponse apiResponse = ApiResponse.fromResponse(response);

      if (!apiResponse.status) {
        throw apiResponse.message.toString();
      }

      List<dynamic> data = apiResponse.data as List<dynamic>;
      return data.map((e) => MyVideos.fromJson(e)).toList();
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

  Future<MyVideos> getCoachVideoById() async {
    try {
      Response response = await _api.sendRequest.get(
        "/coach/get-videos",
        options: Options(
          headers: {'Authorization': 'Bearer $accessToken'},
        ),
      );

      ApiResponse apiResponse = ApiResponse.fromResponse(response);

      if (!apiResponse.status) {
        throw apiResponse.message.toString();
      }

      return MyVideos.fromJson(apiResponse.data as Map<String, dynamic>);
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

  //post health score

  Future<String> updateHealthScore(
      {required String userId,
      required int physicalHealth,
      required int mentalHealth,
      required int energy,
      required int nutrition,
      required int generalHealth}) async {
    try {
      Map<String, dynamic> requestData = {
        "physicalHealth": physicalHealth,
        "mentalHealth": mentalHealth,
        "energy": energy,
        "nutrition": nutrition,
        "generalHealth": generalHealth,
      };

      Response response = await _api.sendRequest.get(
        "/user/health-score-create/$userId",
        data: requestData,
        options: Options(
          headers: {'Authorization': 'Bearer $accessToken'},
        ),
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
}
