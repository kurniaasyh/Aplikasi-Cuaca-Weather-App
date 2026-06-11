import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String apiKey = "65d0b96734199aa2491aecd49e8c3111";

  // ================= WEATHER =================

  static Future<Map<String, dynamic>> getWeather(
    String city,
  ) async {
    late Uri url;

    if (city.contains(",")) {
      final lat = city.split(",")[0];
      final lon = city.split(",")[1];

      url = Uri.parse(
        "https://api.openweathermap.org/data/2.5/weather"
        "?lat=$lat"
        "&lon=$lon"
        "&appid=$apiKey"
        "&units=metric",
      );
    } else {
      url = Uri.parse(
        "https://api.openweathermap.org/data/2.5/weather"
        "?q=$city"
        "&appid=$apiKey"
        "&units=metric",
      );
    }

    final response = await http.get(
      url,
    );

    if (response.statusCode == 200) {
      return json.decode(
        response.body,
      );
    }

    throw Exception(
      "Gagal mengambil data cuaca",
    );
  }

  // ================= FORECAST =================

  static Future<Map<String, dynamic>> getForecast(
    String city,
  ) async {
    late Uri url;

    if (city.contains(",")) {
      final lat = city.split(",")[0];
      final lon = city.split(",")[1];

      url = Uri.parse(
        "https://api.openweathermap.org/data/2.5/forecast"
        "?lat=$lat"
        "&lon=$lon"
        "&appid=$apiKey"
        "&units=metric",
      );
    } else {
      url = Uri.parse(
        "https://api.openweathermap.org/data/2.5/forecast"
        "?q=$city"
        "&appid=$apiKey"
        "&units=metric",
      );
    }

    final response = await http.get(
      url,
    );

    if (response.statusCode == 200) {
      return json.decode(
        response.body,
      );
    }

    throw Exception(
      "Gagal mengambil forecast",
    );
  }
}
