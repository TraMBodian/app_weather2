import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:carousel_slider/carousel_slider.dart';

import 'package:http/http.dart' as http;
import 'package:percent_indicator/linear_percent_indicator.dart';

class Progression extends StatefulWidget {
  @override
  _ProgressionState createState() => _ProgressionState();
}

class _ProgressionState extends State<Progression> {
  double _progress = 0.0;
  List<Map<String, dynamic>> allCitiesWeather = [];
  List<String> cities = ['Dakar', 'Paris', 'Londre', 'New York', 'Bamako'];
  List<String> messages = [
    "Nous téléchargeons les données...",
    "C'est presque fini...",
    "Plus que quelques secondes avant d'avoir le résultat..."
  ];

  int messageIndex = 0;
  Timer? timer;
  bool _downloadFinished = false;

  void initState() {
    super.initState();
    _updateProgress();
    startTimer();
  }

  void _updateProgress() async {
    for (var i = 0; i < 60; i++) {
      await Future.delayed(Duration(seconds: 1));
      setState(() {
        _progress = (i + 1) * (100 / 60);
      });
    }
    setState(() {
      _downloadFinished = true;
    });
  }

  Future<Map<String, dynamic>> fetchWeather(String city) async {
    String apiKey = '0b5b5cb255feb5ec8d8c9189964ac17b';
    final response = await http.get(Uri.parse(
        'https://api.openweathermap.org/data/2.5/weather?q=$city&appid=$apiKey&units=metric'));
    if (response.statusCode == 200) {
      Map<String, dynamic> data = jsonDecode(response.body);
      double lon = data['coord']['lon'];
      double lat = data['coord']['lat'];
      String description = data['weather'][0]['description'];
      print('$city: longitude=$lon, latitude=$lat, description=$description');
      return json.decode(response.body);
    } else {
      throw Exception('Failed to fetch weather data for $city');
    }
  }

  void printWeatherDataForOneCity(String cityName) async {
    final weatherData = await fetchWeather(cityName);
    final humidity = weatherData['main']['humidity'];

    setState(() {
      allCitiesWeather.add(weatherData);
    });
    print('$cityName: $weatherData');
    print('allCitiesWeather: $allCitiesWeather');
  }

  void startTimer() {
    int x = 0;
    timer = Timer.periodic(Duration(seconds: 6), (timer) {
      if (x == 4) timer.cancel();
      print('x:$x');
      printWeatherDataForOneCity(cities[x]);
      x = x + 1;
      setState(() {
        messageIndex = (messageIndex + 1) % messages.length;
      });
    });
  }

  void _restartDownload() {
    setState(() {
      _progress = 0.0;
      allCitiesWeather.clear();
      _downloadFinished = false;
    });
    _updateProgress();
    startTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromARGB(255, 89, 176, 220),
          title: Text('Les Prévisions Météorologiques'),
          centerTitle: true,
        ),
        body: Stack(children: [
          Positioned.fill(
            child: Image.asset(
              "assets/images/weather-icon-gif-22.jpg",
              fit: BoxFit.cover,
            ),
          ),
          Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 50),
                  SizedBox(height: 20),
                  SizedBox(
                    height: 20,
                  ),
                  Expanded(
                      child: ListView.builder(
                    itemCount: allCitiesWeather.length,
                    itemBuilder: (BuildContext context, int index) {
                      final cityName = allCitiesWeather[index]['name'];
                      final humidity =
                          allCitiesWeather[index]['main']['humidity'];
                      final temp = allCitiesWeather[index]['main']['temp'];
                      final iconCode =
                          allCitiesWeather[index]['weather'][0]['icon'];
                      final main =
                          allCitiesWeather[index]['weather'][0]['main'];
                      final clouds = allCitiesWeather[index]['clouds']['all'];
                      final description =
                          allCitiesWeather[index]['weather'][0]['description'];

                      return Container(
                        margin:
                            EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.4),
                          borderRadius: BorderRadius.circular(14),
                          backgroundBlendMode: BlendMode.multiply,
                          boxShadow: [
                            BoxShadow(
                              color: Color.fromARGB(255, 212, 230, 234)
                                  .withOpacity(0.5),
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: ListTile(
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 12, horizontal: 16),
                          title: Text(
                            '$cityName',
                            style: TextStyle(
                              color: Color.fromARGB(255, 73, 134, 232),
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          leading: Image.network(
                            'http://openweathermap.org/img/w/$iconCode.png',
                            width: 48,
                            height: 48,
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 4),
                              Text(
                                '${temp.round()}°C',
                                style: TextStyle(
                                  color: Color.fromARGB(255, 2, 25, 61),
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                '$main, $description\nHumidity: ${humidity}%\nCloudiness: ${clouds}%',
                                style: TextStyle(
                                  fontFamily: 'TimeNew',
                                  color: Color.fromARGB(255, 2, 25, 61),
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 4),
                              Row(
                                children: [
                                  SizedBox(width: 4),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  )),
                  Text(
                    messages[messageIndex],
                    style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 24,
                        color: Color.fromARGB(221, 216, 134, 20)),
                  ),
                  _progress < 100
                      ? LinearPercentIndicator(
                          width: MediaQuery.of(context).size.width - 50,
                          animation: true,
                          lineHeight: 20.0,
                          animationDuration: 2000,
                          percent: _progress / 100,
                          center: Text(
                            '${_progress.round()}%',
                            style: TextStyle(
                              color: Colors.black87,
                              fontSize: 14.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          linearStrokeCap: LinearStrokeCap.roundAll,
                          progressColor: Color.fromARGB(255, 35, 163, 232),
                          backgroundColor: Colors.grey[300],
                          alignment: MainAxisAlignment.center,
                          barRadius: const Radius.circular(20),
                        )
                      : SizedBox(height: 20),
                  if (_downloadFinished)
                    TextButton(
                        onPressed: () {
                          setState(() {
                            _progress = 0.0;
                            allCitiesWeather = [];
                            _downloadFinished = false;
                          });
                          startTimer();
                          _updateProgress();
                        },
                        child: ElevatedButton(
                            onPressed: _restartDownload,
                            child: Text('Recommencer'),
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                Color.fromARGB(221, 216, 134, 20),
                              ),
                            ))),
                ]),
          )
        ]));
  }
}
