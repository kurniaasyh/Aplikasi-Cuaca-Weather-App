import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String apiKey = "65d0b96734199aa2491aecd49e8c3111";

  static Future<Map<String, dynamic>> getWeather(String city) async {
    final url = Uri.parse(
        "https://api.openweathermap.org/data/2.5/weather?q=$city&appid=$apiKey&units=metric");

    final response = await http.get(url);

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception("Gagal mengambil data cuaca");
    }
  }
}
