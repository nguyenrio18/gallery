class JsonUtil {
  static Map<String, dynamic> removeFieldWithNullValue(
      Map<String, dynamic> map) {
    map.removeWhere((key, dynamic value) => value == null);
    return map;
  }
}
