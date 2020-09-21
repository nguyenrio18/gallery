import 'package:gallery/constants.dart';
import 'package:gallery/models/province.dart';
import 'package:gallery/services/auth.dart';
import 'package:gallery/utils/api_exception.dart';
import 'package:http/http.dart' as http;

class ProvinceService {
  static Future<List<Province>> getProvinces() async {
    final response = await http.get(
      '${Constants.urlApi}/provinces',
      headers: await AuthService.getHeaders(true),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return Province.fromJsonList(response.bodyBytes);
    } else {
      throw ApiException.fromJson(response.body);
    }
  }
}
