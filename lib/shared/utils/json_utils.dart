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
      final List<dynamic> decoded = jsonDecode(jsonString);
      return decoded.cast<String>();
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
