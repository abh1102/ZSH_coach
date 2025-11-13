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

import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:image/image.dart' as img;
import 'package:http_parser/http_parser.dart';

class ZendeskService {
  // ✔ Your correct subdomain and credentials
  static const String subdomain = "zanaduhealthhelp.zendesk.com";
  static const String email = "support@zanaduhealthhelp.zendesk.com";
  static const String apiToken = "GCEJnVxVaFzibFmMMNrLxIKpQGpIXVSaz8olV5Ss";

  // -----------------------------------------
  // 🔐 Authentication Header
  // -----------------------------------------
  static String get _authHeader {
    // Format: email/token:apiToken
    String credentials = '${email.replaceAll('/token', '')}/token:${apiToken}';
    String encoded = base64Encode(utf8.encode(credentials));
    print("🔑 AUTH RAW: $credentials");
    print("🔑 AUTH ENCODED: $encoded");
    return "Basic $encoded";
  }

  // -----------------------------------------
  // 🖼 FIX XIAOMI / ANDROID JPEG MISMATCH
  // -----------------------------------------
  static Future<File> _forceConvertToRealJpeg(File file) async {
    try {
      print("🛠 Converting file to REAL JPEG: ${file.path}");

      final bytes = await file.readAsBytes();
      final decoded = img.decodeImage(bytes);

      if (decoded == null) {
        print("❌ decodeImage failed -> returning original file");
        return file;
      }

      final jpgBytes = img.encodeJpg(decoded, quality: 90);
      final newPath = file.path.replaceAll(".jpg", "_real.jpg");
      final newFile = File(newPath)..writeAsBytesSync(jpgBytes);

      print("✔ Conversion successful: $newPath");
      return newFile;

    } catch (e) {
      print("❌ JPEG Conversion ERROR: $e");
      return file;
    }
  }

  // -----------------------------------------
  // 1️⃣ Upload Attachment
  // -----------------------------------------
  static Future<String?> uploadAttachment(String filePath) async {
    try {
      print("📤 Uploading file: $filePath");

      File file = File(filePath);
      String ext = file.path.split('.').last.toLowerCase();

      // Xiaomi internal mismatch fix
      if (ext == "jpg" || ext == "jpeg") {
        file = await _forceConvertToRealJpeg(file);
      }

      // MIME
      MediaType contentType;
      if (ext == "jpg" || ext == "jpeg") {
        contentType = MediaType("image", "jpeg");
      } else if (ext == "png") {
        contentType = MediaType("image", "png");
      } else if (ext == "pdf") {
        contentType = MediaType("application", "pdf");
      } else {
        print("❌ Unsupported file type");
        return null;
      }

      final uri = Uri.https(subdomain, "/api/v2/uploads.json",
          {"filename": file.path.split('/').last});

      print("🌐 UPLOAD URI: $uri");

      final request = http.MultipartRequest("POST", uri)
        ..headers["Authorization"] = _authHeader
        ..files.add(
          await http.MultipartFile.fromPath(
            "file",
            file.path,
            contentType: contentType,
          ),
        );

      final response = await request.send();
      final body = await response.stream.bytesToString();

      print("📡 UPLOAD STATUS: ${response.statusCode}");
      print("📡 UPLOAD RESPONSE: $body");

      if (response.statusCode == 201) {
        final data = jsonDecode(body);
        final token = data["upload"]["token"];
        print("🎉 UPLOAD TOKEN: $token");
        return token;
      }

      print("❌ Upload failed → Returning null");
      return null;

    } catch (e) {
      print("❌ Upload ERROR: $e");
      return null;
    }
  }

  // -----------------------------------------
  // 2️⃣ Create Ticket
  // -----------------------------------------
  // Store requester ID
  static String? _requesterId;

  static Future<Map<String, dynamic>?> createTicket({
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
          "email": userEmail
        },
        "subject": "Payment Issue - $category",
        "comment": {"body": description},
      }
    };

    if (uploadToken != null) {
      body["request"]!["uploads"] = [uploadToken];
    }

    print("📨 Creating Ticket at: $uri");
    print("📤 BODY: ${jsonEncode(body)}");

    final response = await http.post(
      uri,
      headers: {
        "Authorization": _authHeader,
        "Content-Type": "application/json",
      },
      body: jsonEncode(body),
    );

    print("📡 TICKET STATUS: ${response.statusCode}");
    print("📡 TICKET RESPONSE: ${response.body}");

    if (response.statusCode == 201) {
      final data = jsonDecode(response.body);
      final request = data["request"];
      _requesterId = request["requester_id"]?.toString();
      print("🔑 Saved Requester ID: $_requesterId");
      return request;
    }

    return null;
  }


  static Future<List<dynamic>> fetchTickets() async {
    if (_requesterId == null) {
      print("⚠️ No requester ID found. Cannot fetch tickets.");
      return [];
    }

    print("🔍 Fetching tickets for requester ID: $_requesterId");
    
    final uri = Uri.https(
      subdomain,
      "/api/v2/requests.json",
      {
        "sort_by": "created_at",
        "sort_order": "desc",
        "requester_id": _requesterId,
      },
    );

    print("📥 Fetching tickets from → ${uri.toString()}");
    print("🔑 AUTH HEADER: ${_authHeader}");

    try {
      final response = await http.get(
        uri,
        headers: {
          "Authorization": _authHeader,
          "Content-Type": "application/json",
        },
      );

      print("📡 FETCH STATUS: ${response.statusCode}");
      print("📡 FETCH RESPONSE: ${response.body}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data["requests"] ?? [];
      } else {
        print("❌ Failed to fetch tickets: ${response.statusCode}");
        return [];
      }
    } catch (e) {
      print("❌ Error fetching tickets: $e");
      return [];
    }
  }
}
