import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather_application/models/city.dart';
import 'package:weather_application/models/constant.dart';
import 'package:http/http.dart' as http;
import 'package:weather_application/ui/detailpage.dart';
import 'package:weather_application/ui/widgets/weather_item.dart';

class Home extends StatefulWidget {
  final List<City> selectedCities;
  const Home({super.key, required this.selectedCities});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  City? selectedCity;

  @override
  void initState() {
    selectedCity = widget.selectedCities.first;
    fetchiWeatherData(selectedCity!.city);
    fetch7dayweathedata(selectedCity!.city);
    super.initState();
  }

  Constant myconstant = Constant();

  double temperature = 0;
  int maxtemp = 0;
  String weatherStateName = 'Loading..';
  int humidity = 0;
  double windSpeed = 0;

  var currentDate = 'Loading ..';
  String imageUrl = '';
  double woeid = 44418; // This is the default city ID for London
  String location = 'London';
  String icon = '';

  List<Map<String, dynamic>> consolidatedWeatherList = [];

  String searchWeatherUrl =
      "https://api.weatherapi.com/v1/current.json?key=${Constant.apiKey}&q=";

 void fetch7dayweathedata(String location) async {
  try {
    String weatherday =
        "https://api.weatherapi.com/v1/forecast.json?key=${Constant.apiKey}&q=$location&days=7";
    var daysresult = await http.get(Uri.parse(weatherday));
    var result = json.decode(daysresult.body);
    // log(result.toString());

    if (result != null && result['forecast'] != null && result['forecast']['forecastday'] != null) {
      setState(() {
        consolidatedWeatherList = List<Map<String, dynamic>>.from(
            result['forecast']['forecastday'].map((day) {
          String date = day['date'];
          try {
            DateTime parsedDate = DateTime.parse(date);
            date = DateFormat('yyyy-MM-dd').format(parsedDate);
          } catch (e) {
            log('Error parsing date: $date, error: $e');
          }

          var dayData = day['day'];
          return {
            'date': date,
            'condition': dayData['condition']['text'],
            'icon': dayData['condition']['icon'],
            'max_temp': dayData['maxtemp_c'],
            'min_temp': dayData['mintemp_c'],
            'humidity': dayData['avghumidity'], // Assuming 'avghumidity' is the correct field name for humidity
            'temperature': dayData['avgtemp_c'], // Assuming 'avgtemp_c' is the correct field name for temperature
            'windSpeed': dayData['maxwind_kph'], // Assuming 'maxwind_kph' is the correct field name for wind speed
          };
        }));
      });
    }
  } catch (e) {
    log('Error fetching weather data: $e');
  }
}



  void fetchiWeatherData(String location) async {
    try {
      var searchResult = await http.get(Uri.parse(searchWeatherUrl + location));
      var result = json.decode(searchResult.body);

      if (result != null) {
        setState(() {
          temperature = result['current']['temp_c'];
          weatherStateName = result['current']['condition']['text'];
          humidity = result['current']['humidity'];
          windSpeed = result['current']['wind_kph'];
          icon = result['current']['condition']['icon'];

          if (!icon.startsWith('https://') && !icon.startsWith('http://')) {
            icon = 'https:$icon';
          }

          location = result['location']['name'];
          var mydate = DateTime.parse(result['location']['localtime']);
          currentDate = DateFormat('EEEE , dd MMMM').format(mydate);
          imageUrl = icon;
          maxtemp = temperature.toInt();
          this.location = result['location']['name'];
        });
      }
    } catch (e) {
      log('Error fetching weather data: $e');
    }
  }

  final Shader linearGradient = const LinearGradient(
    colors: <Color>[Color(0xffABCFF2), Color(0xff9AC6F3)],
  ).createShader(const Rect.fromLTWH(0.0, 0.0, 200.0, 70.0));

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: false,
        title: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          width: size.width,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.all(
                  Radius.circular(10),
                ),
                child: Image.asset(
                  'assets/profile.png',
                  width: 40,
                  height: 40,
                ),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                   Image.asset(
                    'assets/pin.png',
                    width: 20,
                  ),
                   const SizedBox(
                    width: 4,
                  ),
                  DropdownButton<City>(
                    value: selectedCity,
                    items: widget.selectedCities.map((City city) {
                      return DropdownMenuItem<City>(
                        value: city,
                        child: Text('${city.city}, ${city.country}'),
                      );
                    }).toList(),
                    onChanged: (City? value) {
                      setState(() {
                        selectedCity = value;
                        fetchiWeatherData(selectedCity!.city);
                        fetch7dayweathedata(selectedCity!.city);
                      });
                    },
                  ),
                 
                 
                ],
              ),
            ],
          ),
        ),
        titleSpacing: 0,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                location,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
              ),
              Text(
                currentDate,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                  fontSize: 16.9,
                ),
              ),
              const SizedBox(
                height: 50,
              ),
              Container(
                width: size.width,
                height: 200,
                decoration: BoxDecoration(
                  color: myconstant.primaryColor,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: myconstant.primaryColor.withOpacity(0.5),
                      offset: const Offset(0, 25),
                      blurRadius: 10,
                      spreadRadius: -12,
                    ),
                  ],
                ),
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Positioned(
                      top: -60,
                      left: 05,
                      child: imageUrl == ''
                          ? const Text('')
                          : Image.network(
                              imageUrl,
                              fit: BoxFit.cover,
                              width: 150,
                            ),
                    ),
                    Positioned(
                      bottom: 30,
                      left: 20,
                      child: Text(
                        weatherStateName,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                      ),
                    ),
                    Positioned(
                      top: 20,
                      right: 20,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 4.0),
                            child: Text(
                              temperature.toString(),
                              style: TextStyle(
                                fontSize: 80,
                                fontWeight: FontWeight.bold,
                                foreground: Paint()..shader = linearGradient,
                              ),
                            ),
                          ),
                          Text(
                            'o',
                            style: TextStyle(
                              fontSize: 40,
                              fontWeight: FontWeight.bold,
                              foreground: Paint()..shader = linearGradient,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 50.0,
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    WeatherItem(
                      text: 'Wind Speed',
                      value: windSpeed,
                      unit: 'km/h',
                      imageUrl: 'assets/windspeed.png',
                    ),
                    WeatherItem(
                      text: 'Humidity',
                      value: humidity.toDouble(),
                      unit: '%',
                      imageUrl: 'assets/humidity.png',
                    ),
                    WeatherItem(
                      text: 'Max Temp',
                      value: maxtemp.toDouble(),
                      unit: '°C',
                      imageUrl: 'assets/max-temp.png',
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 50,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Today',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                    ),
                  ),
                  Text(
                    'Next 7 days',
                    style: TextStyle(
                      color: myconstant.primaryColor.withOpacity(0.8),
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: size.height * 0.20,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: consolidatedWeatherList.length,
                  itemBuilder: (context, index) {
                    var datetoday = DateTime.now();
                    var today =
                        DateFormat('EEEE').format(datetoday).substring(0, 3);
                    var day = consolidatedWeatherList[index];
                    String date = day['date'];
                    var parsedDate = DateTime.parse(date);
                    var newDate =
                        DateFormat('EEEE').format(parsedDate).substring(0, 3);
                    var weatherIcon = day['icon'];
                    var maxTemp = day['max_temp'];
                    var minTemp = day['min_temp'];
                    double avg = double.parse(maxTemp.toString()) +
                        double.parse(minTemp.toString());

                    return GestureDetector(
                      onTap: () {
                        setState(() {});
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DetailPage(
                                consolidatedweatherList: consolidatedWeatherList,
                                selectedId: index,
                                location: location, imageUrl:  weatherIcon.startsWith('https://')
                                  ? weatherIcon
                                  : 'https:$weatherIcon',
                              ),
                            ));
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        margin: const EdgeInsets.only(
                            right: 20, bottom: 10, top: 10),
                        width: size.width * 0.30,
                        decoration: BoxDecoration(
                          color: newDate == today
                              ? myconstant.primaryColor
                              : Colors.white,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10)),
                          boxShadow: [
                            BoxShadow(
                              offset: const Offset(0, 1),
                              blurRadius: 5,
                              color: newDate == today
                                  ? myconstant.primaryColor
                                  : Colors.black54.withOpacity(0.2),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${avg.toInt()}C',
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                                color: newDate == today
                                    ? Colors.white
                                    : myconstant.primaryColor,
                              ),
                            ),
                            Image.network(
                              weatherIcon.startsWith('https://')
                                  ? weatherIcon
                                  : 'https:$weatherIcon',
                              fit: BoxFit.cover,
                              width: 60,
                              height: 50,
                            ),
                            Text(
                              newDate,
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                                color: newDate == today
                                    ? Colors.white
                                    : myconstant.primaryColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
