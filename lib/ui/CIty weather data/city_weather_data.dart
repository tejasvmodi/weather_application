import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:weather_application/models/constant.dart';
import 'package:weather_application/ui/CIty%20weather%20data/detail_page_city.dart';
import 'package:weather_application/ui/widgets/setting.dart';
import 'package:weather_application/ui/widgets/weather_item.dart';

class Cityweatherdata extends StatefulWidget {
  const Cityweatherdata({super.key});

  @override
  State<Cityweatherdata> createState() => _CityweatherdataState();
}

class _CityweatherdataState extends State<Cityweatherdata> {
  final TextEditingController _citycontroller = TextEditingController();

  CityConstant constant = CityConstant();
  String location = 'Patan';
  String weatherIcon = '';
  int temperature = 0;
  int windspeed = 0;
  int humidity = 0;
  int cloud = 0;
  String currentDate = '';

  List hourlyweatherforcast = [];
  List dailyweatherForcast = [];

  String currentWeatherStatus = '';

  //API call
  String searchWeatherAPI =
      "https://api.weatherapi.com/v1/forecast.json?key=${Constant.apiKey}&days=7&q=";

  void fetchweatherData(String searchText) async {
    try {
      var searchResult =
          await http.get(Uri.parse(searchWeatherAPI + searchText));
      final weatherData = Map<String, dynamic>.from(
          json.decode(searchResult.body) ?? 'No data');

      var locationData = weatherData['location'];
      var currentWeather = weatherData['current'];

      setState(() {
        location = getShortLocationName(locationData['name']);

        var parsedDate =
            DateTime.parse(locationData['localtime'].substring(0, 10));
        var newDate = DateFormat('MMMMEEEEd').format(parsedDate);
        currentDate = newDate;

        currentWeatherStatus = currentWeather['condition']['text'];
        weatherIcon = currentWeather['condition']['icon'];
        weatherIcon = weatherIcon.startsWith('http')
            ? weatherIcon
            : 'https:$weatherIcon'; // Ensure the full URL
        temperature = currentWeather['temp_c'].toInt();
        windspeed = currentWeather['wind_kph'].toInt();
        humidity = currentWeather['humidity'].toInt();
        cloud = currentWeather['cloud'].toInt();

        dailyweatherForcast = weatherData['forecast']['forecastday'];
        hourlyweatherforcast = dailyweatherForcast[0]['hour'];
        // print(dailyweatherForcast);
      });
    } catch (e) {
      log(e.toString());
    }
  }

  static String getShortLocationName(String s) {
    List<String> wordList = s.split(" ");

    if (wordList.isNotEmpty) {
      if (wordList.length > 1) {
        return "${wordList[0]} ${wordList[1]}";
      } else {
        return wordList[0];
      }
    } else {
      return " ";
    }
  }

  @override
  void initState() {
    fetchweatherData(location);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: SystemUiOverlay.values);

    Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        width: size.width,
        height: size.height,
        padding: const EdgeInsets.only(top: 70, left: 10, right: 10),
        color: constant.primaryColor.withOpacity(0.1),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              height: size.height * 0.7,
              decoration: BoxDecoration(
                gradient: constant.linearGredientBlue,
                boxShadow: [
                  BoxShadow(
                    color: constant.primaryColor.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: const Offset(0, 3),
                  ),
                ],
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const SettingWeathericon(),
                              ));
                        },
                        child: Image.asset(
                          'assets/menu.png',
                          width: 40,
                          height: 40,
                        ),
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image.asset('assets/pin.png', width: 20),
                          const SizedBox(width: 2),
                          Text(
                            location,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16.0,
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              _citycontroller.clear();
                              showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                builder: (context) => Padding(
                                  padding: MediaQuery.of(context).viewInsets,
                                  child: SingleChildScrollView(
                                    child: Container(
                                      height: size.height * 0.17,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 10),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          SizedBox(
                                            width: 70,
                                            child: Divider(
                                              thickness: 3.5,
                                              color: constant.primaryColor,
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          TextField(
                                            onChanged: (value) {
                                              fetchweatherData(value);
                                            },
                                            controller: _citycontroller,
                                            autofocus: true,
                                            decoration: InputDecoration(
                                              prefixIcon: Icon(
                                                Icons.search,
                                                color: constant.primaryColor,
                                              ),
                                              suffixIcon: GestureDetector(
                                                onTap: () =>
                                                    _citycontroller.clear(),
                                                child: Icon(
                                                  Icons.close,
                                                  color: constant.primaryColor,
                                                ),
                                              ),
                                              hintText: 'search city ',
                                              focusedBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: constant.primaryColor,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                            icon: const Icon(Icons.keyboard_arrow_down,
                                color: Colors.white),
                          ),
                        ],
                      ),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.asset(
                          'assets/profile.png',
                          width: 40,
                          height: 40,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 160,
                    child: weatherIcon.isNotEmpty
                        ? Image.network(
                            weatherIcon.startsWith('https://')
                                ? weatherIcon
                                : 'https:$weatherIcon',
                            fit: BoxFit.cover,
                          )
                        : Image.asset(
                            'assets/clear.png',
                            width: 20,
                          ),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        temperature.toString(),
                        style: TextStyle(
                          fontSize: 80,
                          fontWeight: FontWeight.bold,
                          foreground: Paint()..shader = constant.shader,
                        ),
                      ),
                      Text(
                        'o',
                        style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                          foreground: Paint()..shader = constant.shader,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    currentWeatherStatus,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 20.0,
                    ),
                  ),
                  Text(
                    currentDate,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 20.0,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: const Divider(
                      color: Colors.white70,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        WeatherItem(
                          value: windspeed.toDouble(),
                          unit: 'km/h',
                          imageUrl: 'assets/windspeed.png',
                        ),
                        WeatherItem(
                          value: humidity.toDouble(),
                          unit: '%',
                          imageUrl: 'assets/humidity.png',
                        ),
                        WeatherItem(
                          value: cloud.toDouble(),
                          unit: '%',
                          imageUrl: 'assets/cloud.png',
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.only(top: 10),
              height: size.height * 0.20,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Today',
                        style: TextStyle(
                          color: constant.primaryColor,
                          fontSize: 20.0,
                        ),
                      ),
                      GestureDetector(
                        onTap: () => showModalBottomSheet(
                          context: context,
                          builder: (context) => SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            child: Container(
                              height: size.height * 0.35,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              child: Column(
                                children: [
                                  SizedBox(
                                    width: 70,
                                    child: Divider(
                                      thickness: 3.5,
                                      color: constant.primaryColor,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  SizedBox(
                                    height: 210,
                                    child: ListView.builder(
                                      itemCount: dailyweatherForcast.length,
                                      scrollDirection: Axis.vertical,
                                      physics: const BouncingScrollPhysics(),
                                      itemBuilder: (context, index) {
                                        String currentDay = DateFormat('EEEE')
                                            .format(DateTime.parse(
                                                dailyweatherForcast[index]
                                                        ['date']
                                                    .toString()));

                                        String weatherCondition =
                                            dailyweatherForcast[index]['day']
                                                ['condition']['text'];
                                        String weatherIcon =
                                            dailyweatherForcast[index]['day']
                                                ['condition']['icon'];
                                        weatherIcon = weatherIcon
                                                .startsWith('http')
                                            ? weatherIcon
                                            : 'https:$weatherIcon'; // Ensure the full URL

                                        String maxTemp =
                                            dailyweatherForcast[index]['day']
                                                    ['maxtemp_c']
                                                .round()
                                                .toString();
                                        String minTemp =
                                            dailyweatherForcast[index]['day']
                                                    ['mintemp_c']
                                                .round()
                                                .toString();

                                        return Padding(
                                          padding: const EdgeInsets.only(
                                              bottom: 8.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  currentDay,
                                                  style: TextStyle(
                                                    color:
                                                        constant.primaryColor,
                                                    fontSize: 14.0,
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                child: Row(
                                                  children: [
                                                    Image.network(
                                                      weatherIcon,
                                                      width: 20,
                                                    ),
                                                    // const SizedBox(width: 5),
                                                    Text(
                                                      weatherCondition,
                                                      style: TextStyle(
                                                        color: constant
                                                            .primaryColor,
                                                        fontSize: 14.0,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Row(
                                                children: [
                                                  Text(
                                                    '$maxTemp° / ',
                                                    style: TextStyle(
                                                      color:
                                                          constant.primaryColor,
                                                      fontSize: 14.0,
                                                    ),
                                                  ),
                                                  Text(
                                                    '$minTemp°',
                                                    style: const TextStyle(
                                                      color: Colors.grey,
                                                      fontSize: 14.0,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        child: Text(
                          'Next 7 Days',
                          style: TextStyle(
                            color: constant.primaryColor,
                            fontSize: 20.0,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DetailPagecity(
                                daliyforcastwether: dailyweatherForcast,
                              ),
                            ));
                      },
                      child: ListView.builder(
                        itemCount: hourlyweatherforcast.length,
                        scrollDirection: Axis.horizontal,
                        physics: const BouncingScrollPhysics(),
                        itemBuilder: (context, index) {
                          String currentTime =
                              DateFormat('HH:mm:ss').format(DateTime.now());
                          String currentHour = currentTime.substring(0, 2);
                          String forecastTime = hourlyweatherforcast[index]
                                  ['time']
                              .substring(11, 16);
                          String forecastHour = hourlyweatherforcast[index]
                                  ['time']
                              .substring(11, 13);

                          String weatherIcon =
                              hourlyweatherforcast[index]['condition']['icon'];
                          weatherIcon = weatherIcon.startsWith('http')
                              ? weatherIcon
                              : 'https:$weatherIcon'; // Ensure the full URL

                          String currentTemp = hourlyweatherforcast[index]
                                  ['temp_c']
                              .round()
                              .toString();

                          return Container(
                            padding: const EdgeInsets.symmetric(vertical: 15.0),
                            margin: const EdgeInsets.only(right: 20),
                            width: 65,
                            decoration: BoxDecoration(
                              color: currentHour.trim() == forecastHour.trim()
                                  ? Colors.white
                                  : constant.primaryColor,
                              borderRadius: const BorderRadius.all(
                                Radius.circular(50),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  offset: const Offset(0, 1),
                                  blurRadius: 5,
                                  color:
                                      currentHour.trim() == forecastHour.trim()
                                          ? Colors.black.withOpacity(0.2)
                                          : constant.primaryColor,
                                ),
                              ],
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  forecastTime,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 17.0,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Image.network(weatherIcon, width: 35),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      currentTemp,
                                      style: TextStyle(
                                        color: constant.greyColor,
                                        fontSize: 17.0,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    Text(
                                      '°',
                                      style: TextStyle(
                                        color: constant.greyColor,
                                        fontSize: 17.0,
                                        fontWeight: FontWeight.w600,
                                        fontFeatures: const [
                                          FontFeature.enable('sups')
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
