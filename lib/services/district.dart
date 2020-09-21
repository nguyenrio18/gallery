import 'package:gallery/constants.dart';
import 'package:gallery/models/district.dart';
import 'package:gallery/services/auth.dart';
import 'package:gallery/utils/api_exception.dart';
import 'package:http/http.dart' as http;

class DistrictService {
  static Future<List<District>> getDistricts() async {
    final response = await http.get(
      '${Constants.urlApi}/districts',
      headers: await AuthService.getHeaders(true),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return District.fromJsonList(response.bodyBytes);
    } else {
      throw ApiException.fromJson(response.body);
    }
  }
}
