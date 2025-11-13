import 'dart:convert';
import 'package:http/http.dart' as http;

// class ZendeskService {
//   static const String subdomain = "https://zanaduhealthhelp.zendesk.com";
//   static const String email = "support@zanaduhealthhelp.zendesk.com";
//   static const String apiToken = "GCEJnVxVaFzibFmMMNrLxIKpQGpIXVSaz8olV5Ss";
//
//   static String _authHeader() {
//     final auth = base64Encode(utf8.encode("$email:$apiToken"));
//     return "Basic $auth";
//   }
//
//   /// ✅ Create Ticket in Zendesk
//   static Future<bool> createTicket({
//     required String userName,
//     required String userEmail,
//     required String category,
//     required String description,
//   }) async {
//     final uri = Uri.https(subdomain, "/api/v2/requests.json");
//
//     final body = jsonEncode({
//       "request": {
//         "requester": {
//           "name": userName,
//           "email": userEmail,
//         },
//         "subject": "Payment Issue - $category",
//         "comment": {"body": description},
//       }
//     });
//
//     final response = await http.post(
//       uri,
//       headers: {
//         "Authorization": _authHeader(),
//         "Content-Type": "application/json",
//       },
//       body: body,
//     );
//
//     return response.statusCode == 201; // 201 = Ticket Created
//   }
// }
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class ZendeskService {
  static const String subdomain = "zanaduhealthhelp.zendesk.com";
  static const String email = "support@zanaduhealthhelp.zendesk.com";
  static const String apiToken = "GCEJnVxVaFzibFmMMNrLxIKpQGpIXVSaz8olV5Ss";
  static String get _authHeader {
    String auth = base64Encode(utf8.encode("$email:$apiToken"));
    return "Basic $auth";
  }

  /// -------------------------------------------
  /// 1️⃣ Upload File → Get upload_token
  /// -------------------------------------------
  static Future<String?> uploadAttachment(String filePath) async {
    final file = File(filePath);
    final fileName = file.path.split('/').last;

    final uri = Uri.https(subdomain, "/api/v2/uploads.json", {"filename": fileName});

    final request = http.MultipartRequest("POST", uri)
      ..headers["Authorization"] = _authHeader
      ..files.add(
        await http.MultipartFile.fromPath("file", file.path),
      );

    final response = await request.send();
    final responseBody = await response.stream.bytesToString();

    if (response.statusCode == 201) {
      final json = jsonDecode(responseBody);
      return json["upload"]["token"]; // upload_token
    } else {
      print("Upload error: ${response.statusCode}");
      print("Response: $responseBody");
      return null;
    }
  }

  /// -------------------------------------------
  /// 2️⃣ Create Ticket with Attachment
  /// -------------------------------------------
  static Future<bool> createTicket({
    required String userName,
    required String userEmail,
    required String category,
    required String description,
    String? uploadToken,
  }) async {
    final uri = Uri.https(subdomain, "/api/v2/requests.json");

    final body = {
      "request": {
        "requester": {
          "name": userName,
          "email": userEmail,
        },
        "subject": "Payment Issue - $category",
        "comment": {"body": description},
      }
    };

    /// if attachment exists → add uploads
    if (uploadToken != null) {
      body["request"]!["uploads"] = [uploadToken];
    }

    final response = await http.post(
      uri,
      headers: {
        "Authorization": _authHeader,
        "Content-Type": "application/json",
      },
      body: jsonEncode(body),
    );

    return response.statusCode == 201;
  }
}
