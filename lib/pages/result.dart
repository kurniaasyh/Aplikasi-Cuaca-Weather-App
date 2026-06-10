import 'package:flutter/material.dart';
import '../services/api_service.dart';

class Result extends StatefulWidget {
  final String city;

  const Result({super.key, required this.city});

  @override
  State<Result> createState() => _ResultState();
}

class _ResultState extends State<Result> {
  late Future<Map<String, dynamic>> weatherData;

  @override
  void initState() {
    super.initState();
    weatherData = ApiService.getWeather(widget.city);
  }

  IconData getWeatherIcon(String condition) {
    if (condition.contains("cloud")) {
      return Icons.cloud;
    } else if (condition.contains("rain")) {
      return Icons.grain;
    } else if (condition.contains("clear")) {
      return Icons.wb_sunny;
    } else {
      return Icons.wb_cloudy;
    }
  }

  String translateWeather(String weather) {
    weather = weather.toLowerCase();

    if (weather.contains("clear")) {
      return "Cerah";
    } else if (weather.contains("cloud")) {
      return "Berawan";
    } else if (weather.contains("rain")) {
      return "Hujan";
    } else if (weather.contains("thunderstorm")) {
      return "Badai Petir";
    } else if (weather.contains("mist")) {
      return "Berkabut";
    } else {
      return weather;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Cuaca ${widget.city}"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue, Colors.lightBlueAccent],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: FutureBuilder(
          future: weatherData,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(color: Colors.white),
              );
            } else if (snapshot.hasError) {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error, size: 80, color: Colors.red),
                    SizedBox(height: 20),
                    Text(
                      "Gagal mengambil data",
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              );
            } else {
              final data = snapshot.data!;
              final temp = (data['main']['temp'] - 273.15).toStringAsFixed(1);

              final weather =
                  data['weather'][0]['description'].toString().toLowerCase();

              final humidity = data['main']['humidity'];

              final wind = data['wind']['speed'];

              final feelsLike =
                  (data['main']['feels_like'] - 273.15).toStringAsFixed(1);

              return Center(
                child: Card(
                  elevation: 10,
                  margin: const EdgeInsets.symmetric(horizontal: 30),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          getWeatherIcon(weather),
                          size: 80,
                          color: Colors.blue,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          data['name'],
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          "$temp °C",
                          style: const TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          translateWeather(weather),
                          style: const TextStyle(
                            fontSize: 18,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Column(
                              children: [
                                const Icon(Icons.water_drop,
                                    color: Colors.blue),
                                const SizedBox(height: 5),
                                Text("$humidity%"),
                                const Text("Kelembapan"),
                              ],
                            ),
                            Column(
                              children: [
                                const Icon(Icons.air, color: Colors.grey),
                                const SizedBox(height: 5),
                                Text("$wind m/s"),
                                const Text("Angin"),
                              ],
                            ),
                            Column(
                              children: [
                                const Icon(Icons.thermostat,
                                    color: Colors.orange),
                                const SizedBox(height: 5),
                                Text("$feelsLike°C"),
                                const Text("Terasa"),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
