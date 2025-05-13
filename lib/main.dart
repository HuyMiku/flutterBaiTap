import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'weather_service.dart';

void main() {
  runApp(WeatherApp());
}

class WeatherApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dự báo thời tiết',
      theme: ThemeData(fontFamily: 'Roboto', brightness: Brightness.light),
      home: WeatherHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class WeatherHomePage extends StatefulWidget {
  @override
  _WeatherHomePageState createState() => _WeatherHomePageState();
}

class _WeatherHomePageState extends State<WeatherHomePage> {
  final WeatherService _weatherService = WeatherService();
  late Future<List<dynamic>> _weatherFuture;

  @override
  void initState() {
    super.initState();
    _weatherFuture = _weatherService.fetchWeatherData();
  }

  String formatDateTime(String dtTxt) {
    final dt = DateTime.parse(dtTxt);
    return DateFormat('EEE, HH:mm').format(dt); // Ví dụ: Mon, 15:00
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF74ABE2), Color(0xFFA3D8F4)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        padding: const EdgeInsets.only(top: 50, left: 16, right: 16, bottom: 16),
        child: Column(
          children: [
            const Text(
              '🌤 Hà Nội - 5 ngày tới',
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: FutureBuilder<List<dynamic>>(
                future: _weatherFuture,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final weatherList = snapshot.data!;
                    return ListView.builder(
                      itemCount: weatherList.length,
                      itemBuilder: (context, index) {
                        final item = weatherList[index];
                        final main = item['main'];
                        final weather = item['weather'][0];
                        final dtTxt = item['dt_txt'];

                        return Card(
                          elevation: 5,
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15)),
                          child: ListTile(
                            leading: Image.network(
                              'https://openweathermap.org/img/wn/${weather['icon']}@2x.png',
                              width: 50,
                              height: 50,
                            ),
                            title: Text(
                              '${formatDateTime(dtTxt)} - ${weather['main']}',
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            subtitle: Text(
                              '🌡 ${main['temp']}°C   💧 ${main['humidity']}%',
                              style: const TextStyle(fontSize: 14),
                            ),
                          ),
                        );
                      },
                    );
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Lỗi: ${snapshot.error}'));
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
