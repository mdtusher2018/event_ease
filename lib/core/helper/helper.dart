import 'dart:convert';

String decodeJwtField(String token, String field) {
  try {
    final parts = token.split('.');
    if (parts.length != 3) {
      throw Exception("Invalid JWT token");
    }

    final payload = parts[1];

    // Normalize Base64
    final normalized = base64Url.normalize(payload);
    final decoded = utf8.decode(base64Url.decode(normalized));

    final Map<String, dynamic> payloadMap = json.decode(decoded);

    return payloadMap[field] ?? "";
  } catch (e) {
    return "";
  }
}
