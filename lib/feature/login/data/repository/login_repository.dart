import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:zanadu_coach/core/api.dart';
import 'package:zanadu_coach/core/constants.dart';
import 'package:zanadu_coach/feature/login/data/model/coach_model.dart';
import 'package:zanadu_coach/feature/login/data/model/login_model.dart';
import 'package:zanadu_coach/feature/login/data/model/offering_model.dart';
import 'package:zanadu_coach/feature/login/data/model/signed_url_model.dart';
import 'package:zanadu_coach/widgets/contain_emoji.dart';

class LoginRepository {
  final _api = Api();

  //

  Future<LoginModel> logIn({
    required String email,
    required String password,
  }) async {
    try {
      Response response = await _api.sendRequest.post(
        "/login",
        data: jsonEncode({"email": email, "password": password}),
      );

      ApiResponse apiResponse = ApiResponse.fromResponse(response);

      if (!apiResponse.status) {
        throw apiResponse.message.toString();
      }

      return LoginModel.fromJson(apiResponse.data as Map<String, dynamic>);
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

  //signed url function

  Future<SignedUrlModel> getSignedUrl({required String fileName}) async {
    try {
      Response response = await _api.sendRequest.post(
        "/common/get-signed-url",
        data: {"fileName": fileName},
        options: ApiUtils.getAuthOptions(),
      );

      ApiResponse apiResponse = ApiResponse.fromResponse(response);

      if (!apiResponse.status) {
        throw apiResponse.message.toString();
      }

      return SignedUrlModel.fromJson(apiResponse.data as Map<String, dynamic>);
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

  Future<SignedUrlModel> getSignedUrlDocument() async {
    try {
      Response response = await _api.sendRequest.get(
        "/common/get-signed-url-of-profile-document",
      );

      ApiResponse apiResponse = ApiResponse.fromResponse(response);

      if (!apiResponse.status) {
        throw apiResponse.message.toString();
      }

      return SignedUrlModel.fromJson(apiResponse.data as Map<String, dynamic>);
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

  Future<SignedUrlModel> getSignedUrlSignUp() async {
    try {
      Response response = await _api.sendRequest.get(
        "/common/get-signed-url-of-signup-video",
      );

      ApiResponse apiResponse = ApiResponse.fromResponse(response);

      if (!apiResponse.status) {
        throw apiResponse.message.toString();
      }

      return SignedUrlModel.fromJson(apiResponse.data as Map<String, dynamic>);
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

  // sign up for user

  Future<ApiResponse> signUp({
    required String pdfFile,
    required String govrnmentIssuedId,
    required String email,
    String? password,
    required String phoneNumber,
    required String fullName,
    required String certificate,
    required String dob,
    required String gender,
    required String state,
    required String country,
    required List<String> specialityCoachId,
    required List<String> areaOfSpecialization,
    String? healthCoachId,
  }) async {
    try {
      FormData formData = FormData.fromMap({
        'pdfFile':
            await MultipartFile.fromFile(pdfFile, filename: 'profile.pdf'),
        'email': email,
        'password': password,
        'phone': phoneNumber,
        'fullName': fullName,
        'DOB': dob,
        'govrnmentIssuedId': await MultipartFile.fromFile(govrnmentIssuedId,
            filename: 'govermentId.pdf'),
        'gender': gender,
        'certificate': await MultipartFile.fromFile(certificate,
            filename: 'certificate.pdf'),
        'country': country,
        'state': state,
        'specalityCoatchId': json.encode(specialityCoachId),
        if (areaOfSpecialization.contains('Health') && healthCoachId != null)
          'healthCoachId': healthCoachId,
      });

      Response response = await _api.sendRequest.post(
        "/coach-signup",
        data: formData,
        options: ApiUtils.getAuthOptions(),
      );

      ApiResponse apiResponse = ApiResponse.fromResponse(response);

      if (!apiResponse.status) {
        throw apiResponse.message.toString();
      }

      return apiResponse;
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

  Future<CoachModel> fetchUserInfo({required String token}) async {
    try {
      Response response = await _api.sendRequest.get(
        "/user/profile",
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );

      ApiResponse apiResponse = ApiResponse.fromResponse(response);

      if (!apiResponse.status) {
        throw apiResponse.message.toString();
      }

      return CoachModel.fromJson(apiResponse.data as Map<String, dynamic>);
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

  Future<String> changePassword({
    required String oldPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    try {
      Response response = await _api.sendRequest.patch(
        "/user/change-password",
        data: {
          "oldPassword": oldPassword,
          "newPassword": newPassword,
          "confirmPassword": confirmPassword,
        },
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

  Future<bool> editProfile({
    String? fullName,
    String? dob,
    String? gender,
    List<String>? topHealthChallenges,
    String? state,
    String? experience,
    String? bio,
    String? designation,
    String? image,
    String? country,
    // Add this parameter
  }) async {
    try {
      FormData formData = FormData();

      if (fullName != null) {
        if (containsEmoji(fullName) == true) {
        //  showSnackBar("Do not use emoji in name text field");
          throw "Do no use emoji in name field";
        } else {
          formData.fields.add(MapEntry('fullName', fullName));
        }
      }

      if (dob != null) {
        formData.fields.add(MapEntry('DOB', dob));
      }

      if (gender != null) {
        formData.fields.add(MapEntry('gender', gender));
      }

      if (country != null) {
        formData.fields.add(MapEntry('country', country));
      }

      if (topHealthChallenges != null) {
        formData.fields.add(
            MapEntry('topHealthChallenges', topHealthChallenges.join(',')));
      }

      if (state != null) {
        formData.fields.add(MapEntry('state', state));
      }
      if (bio != null) {
        formData.fields.add(MapEntry('bio', bio));
      }
      if (designation != null) {
        formData.fields.add(MapEntry('designation', designation));
      }
      if (experience != null) {
        formData.fields.add(MapEntry('experience', experience));
      }

      if (image != null) {
        formData.files.add(MapEntry(
          'image',
          await MultipartFile.fromFile(
            image,
            filename: 'profile_image.jpg', // Provide a filename for the image
          ),
        ));
      }

      Response response = await _api.sendRequest.patch(
        "/coach/edit-profile",
        data: formData,
        options: ApiUtils.getAuthOptions(),
      );

      ApiResponse apiResponse = ApiResponse.fromResponse(response);

      if (!apiResponse.status) {
        throw apiResponse.message.toString();
      }

      return apiResponse.status;
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

  // remove image

  Future<String> removeProfilePhoto() async {
    try {
      Response response = await _api.sendRequest.patch(
        "/common/remove-profile-photo",
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

  Future<ApiResponse> logOut() async {
    try {
      Response response = await _api.sendRequest
          .post("/logout", options: ApiUtils.getAuthOptions());

      ApiResponse apiResponse = ApiResponse.fromResponse(response);

      if (!apiResponse.status) {
        throw apiResponse.message.toString();
      }

      return apiResponse;
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

  // fetch offering

  Future<List<OfferingsModel>> fetchAllOffering() async {
    try {
      Response response = await _api.sendRequest.get(
        "/common/get-offerings",
      );

      ApiResponse apiResponse = ApiResponse.fromResponse(response);

      if (!apiResponse.status) {
        throw apiResponse.message.toString();
      }

      List<dynamic> data = apiResponse.data as List<dynamic>;
      return data.map((e) => OfferingsModel.fromJson(e)).toList();
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

  // delete password

  Future<String> deleteUser(String status) async {
    try {
      Response response = await _api.sendRequest.delete(
        '/enterprise/delete-user/${myCoach?.userId}',
        data: jsonEncode({"status": status}),
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

  Future<String> forgotPassword({required String email}) async {
    try {
      Response response = await _api.sendRequest.post(
        "/forgot-password",
        data: jsonEncode({"email": email}),
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

  Future<String> verifyForgotPasswordOTP({
    required String email,
    required int otp,
  }) async {
    try {
      Response response = await _api.sendRequest.post(
        "/forgot-password/verify-otp",
        data: jsonEncode({"email": email, "otp": otp}),
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

  Future<String> changeForgottenPassword({
    required String email,
    required String newPassword,
    required String confirmPassword,
  }) async {
    try {
      Response response = await _api.sendRequest.post(
        "/forgot-password/change-password",
        data: {
          "email": email,
          "newPassword": newPassword,
          "confirmPassword": confirmPassword,
        },
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

  Future<String> getChangePhoneOtp() async {
    try {
      // Call the API endpoint to get OTP for changing the phone number
      Response response = await _api.sendRequest.get(
        "/user/change-phone-otp",
        options: ApiUtils.getAuthOptions(),
      );

      ApiResponse apiResponse = ApiResponse.fromResponse(response);

      if (!apiResponse.status) {
        throw apiResponse.message.toString();
      }

      // Return the OTP as a string
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

  Future<String> verifyChangePhoneOtp({
    required int otp,
  }) async {
    try {
      Response response = await _api.sendRequest.post(
        "/user/change-phone-otp-verify",
        data: jsonEncode({"otp": otp}),
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

  Future<String> changePhoneNumber({required String phone}) async {
    try {
      Response response = await _api.sendRequest.patch(
        "/user/change-phone",
        data: {"phone": phone},
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

// get device token

  Future<void> updateDeviceInfo({
    required String deviceId,
    required String firebaseToken,
    required String type,
  }) async {
    try {
      // Assuming that the endpoint is correct, adjust it if needed
      Response response = await _api.sendRequest.post(
        "/user/deviceinfo-update",
        data: jsonEncode({
          "deviceId": deviceId,
          "firebaseToken": firebaseToken,
          "type": type,
        }),
        options: ApiUtils
            .getAuthOptions(), // Add this line if authentication is required
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

  // third party signup
  Future<ApiResponse> thirdPatryUserCheck(String email) async {
    try {
      // Call the API endpoint to get OTP for changing the phone number
      Response response = await _api.sendRequest.post(
        "/login/third-party?email=$email",
        options: ApiUtils.getAuthOptions(),
      );

      ApiResponse apiResponse = ApiResponse.fromResponse(response);

      return apiResponse;
      // Return the OTP as a string
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
