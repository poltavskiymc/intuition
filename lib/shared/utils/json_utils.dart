import 'dart:convert';

class JsonUtils {
  static String listToString(List<String> list) {
    return jsonEncode(list);
  }

  static List<String> stringToList(String jsonString) {
    if (jsonString.isEmpty || jsonString == '[]') {
      return [];
    }
    try {
      final dynamic decoded = jsonDecode(jsonString);
      if (decoded is List) {
        return decoded.cast<String>();
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  static String addToList(String jsonString, String item) {
    final list = stringToList(jsonString);
    if (!list.contains(item)) {
      list.add(item);
    }
    return listToString(list);
  }

  static String removeFromList(String jsonString, String item) {
    final list = stringToList(jsonString);
    list.remove(item);
    return listToString(list);
  }
}
