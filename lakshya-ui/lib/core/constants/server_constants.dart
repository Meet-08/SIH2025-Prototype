import 'package:flutter_dotenv/flutter_dotenv.dart';

class ServerConstants {
  static String get baseUrl =>
      dotenv.env['BASE_URL'] ?? "http://localhost:3000/v1/api";
}
