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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Cuaca ${widget.city}"),
      ),
      body: FutureBuilder(
        future: weatherData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text("Error mengambil data"));
          } else {
            final data = snapshot.data!;

            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Kota: ${data['name']}"),
                  Text("Suhu: ${data['main']['temp']} °C"),
                  Text("Cuaca: ${data['weather'][0]['description']}"),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
