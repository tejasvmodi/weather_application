import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather_application/models/constant.dart';
import 'package:weather_application/ui/widgets/weather_item.dart';

class DetailPagecity extends StatefulWidget {
  const DetailPagecity({super.key, this.daliyforcastwether});
  // ignore: prefer_typing_uninitialized_variables
  final daliyforcastwether;

  @override
  State<DetailPagecity> createState() => _DetailPagecityState();
}

class _DetailPagecityState extends State<DetailPagecity> {
  CityConstant constant = CityConstant();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    var weatherData = widget.daliyforcastwether;

    Map getforecastweather(int index) {
      int maxwindspeed = weatherData[index]['day']['maxwind_kph'].toInt();
      int avgHumidity = weatherData[index]['day']['avghumidity'].toInt();
      int chanceofrain =
          weatherData[index]['day']['daily_chance_of_rain'].toInt();

      var parsedDate = DateTime.parse(weatherData[index]['date']);
      var forcastDate = DateFormat('EEEE, d MMMM').format(parsedDate);

      String weatherName = weatherData[index]['day']['condition']['text'];
      String weathericon = weatherData[index]['day']['condition']['icon'];

      int minTemperature = weatherData[index]['day']['mintemp_c'].toInt();

      int maxTemperature = weatherData[index]['day']['maxtemp_c'].toInt();

      var forecastdata = {
        'maxWindSpeed': maxwindspeed,
        'avgHumidity': avgHumidity,
        'chanceofRain': chanceofrain,
        'forecastDate': forcastDate,
        'weathername': weatherName,
        'weatherIcon': weathericon,
        'mintemperature': minTemperature,
        'maxtemperature': maxTemperature,
      };
      return forecastdata;
    }

    return Scaffold(
      backgroundColor: constant.primaryColor,
      appBar: AppBar(
        title: const Text(
          'Forcasts',
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: constant.primaryColor,
        elevation: 0,
        actions: [
          IconButton(
              onPressed: () {
                // Navigator.push(context, r);
              },
              icon: const Icon(Icons.settings)),
        ],
      ),
      body: Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none,
        children: [
          Positioned(
            bottom: 0,
            left: 0,
            child: Container(
              height: size.height * 0.75,
              width: size.width,
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(50),
                      topRight: Radius.circular(50))),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Positioned(
                    top: -70,
                    right: 20,
                    left: 20,
                    child: Container(
                      height: 350,
                      width: size.width * 0.7,
                      decoration: BoxDecoration(
                          gradient: const LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.center,
                              colors: [Color(0xffa9c1f5), Color(0xff6696f5)]),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.blue.withOpacity(.1),
                              offset: const Offset(0, 25),
                              blurRadius: 5,
                              spreadRadius: -10,
                            ),
                          ],
                          borderRadius: BorderRadius.circular(15)),
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Positioned(
                            // ignore: prefer_interpolation_to_compose_strings
                            width: 150,
                            // ignore: prefer_interpolation_to_compose_strings
                            child: Image.network(
                              getforecastweather(0)['weatherIcon']
                                      .startsWith('http')
                                  ? getforecastweather(0)['weatherIcon']
                                  // ignore: prefer_interpolation_to_compose_strings
                                  : 'https:' +
                                      getforecastweather(0)['weatherIcon'],
                              fit: BoxFit.cover,
                            ),
                          ),
                          Positioned(
                            top: 160,
                            left: 30,
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 10.0),
                              child: Text(
                                getforecastweather(0)['weathername'],
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                              left: 20,
                              bottom: 20,
                              child: Container(
                                width: size.width * .8,
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    WeatherItem(
                                      imageUrl: 'assets/windspeed.png',
                                      unit: 'km/h',
                                      value:
                                          getforecastweather(0)['maxWindSpeed']
                                              .toDouble(),
                                    ),
                                    WeatherItem(
                                      imageUrl: 'assets/humidity.png',
                                      unit: '%',
                                      value:
                                          getforecastweather(0)['avgHumidity']
                                              .toDouble(),
                                    ),
                                    WeatherItem(
                                      imageUrl: 'assets/lightrain.png',
                                      unit: '%',
                                      value:
                                          getforecastweather(0)['chanceofRain']
                                              .toDouble(),
                                    )
                                  ],
                                ),
                              )),
                          Positioned(
                              top: 20,
                              right: 20,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    getforecastweather(0)['maxtemperature']
                                        .toString(),
                                    style: TextStyle(
                                      fontSize: 80,
                                      fontWeight: FontWeight.bold,
                                      foreground: Paint()
                                        ..shader = constant.shader,
                                    ),
                                  ),
                                  Text(
                                    'o',
                                    style: TextStyle(
                                      fontSize: 40,
                                      fontWeight: FontWeight.bold,
                                      foreground: Paint()
                                        ..shader = constant.shader,
                                    ),
                                  )
                                ],
                              ))
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                      top: 290,
                      left: 20,
                      child: SizedBox(
                        height: 312,
                        width: size.width * 0.9,
                        child: ListView(
                          physics: const BouncingScrollPhysics(),
                          children: [
                            Card(
                              elevation: 3.0,
                              margin: const EdgeInsets.only(bottom: 20),
                              child: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          getforecastweather(0)['forecastDate'],
                                          style: const TextStyle(
                                              color: Color(0xff6696f5),
                                              fontWeight: FontWeight.w600),
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            Row(
                                              children: [
                                                Text(
                                                  getforecastweather(
                                                          0)['mintemperature']
                                                      .toString(),
                                                  style: TextStyle(
                                                    color: constant.greyColor,
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 30,
                                                  ),
                                                ),
                                                Text(
                                                  '°',
                                                  style: TextStyle(
                                                    color: constant.greyColor,
                                                    fontWeight: FontWeight.w600,
                                                    fontFeatures: const [
                                                      FontFeature.enable(
                                                          'sups'),
                                                    ],
                                                    fontSize: 30,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              getforecastweather(
                                                      0)['maxtemperature']
                                                  .toString(),
                                              style: TextStyle(
                                                color: constant.blackColor,
                                                fontWeight: FontWeight.w600,
                                                fontSize: 30,
                                              ),
                                            ),
                                            Text(
                                              '°',
                                              style: TextStyle(
                                                color: constant.blackColor,
                                                fontWeight: FontWeight.w600,
                                                fontFeatures: const [
                                                  FontFeature.enable('sups'),
                                                ],
                                                fontSize: 30,
                                              ),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Image.network(
                                              getforecastweather(
                                                          0)['weatherIcon']
                                                      .startsWith('http')
                                                  ? getforecastweather(
                                                      0)['weatherIcon']
                                                  // ignore: prefer_interpolation_to_compose_strings
                                                  : 'https:' +
                                                      getforecastweather(
                                                          0)['weatherIcon'],
                                              fit: BoxFit.cover,
                                              width: 30,
                                            ),
                                            const SizedBox(
                                              width: 5,
                                            ),
                                            Text(
                                              getforecastweather(
                                                  0)['weathername'],
                                              style: const TextStyle(
                                                fontSize: 16,
                                                color: Colors.grey,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              '${getforecastweather(0)['chanceofRain']}%',
                                              style: const TextStyle(
                                                fontSize: 16,
                                                color: Colors.grey,
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 5,
                                            ),
                                            Image.asset(
                                              'assets/lightrain.png',
                                              width: 30,
                                            ),
                                          ],
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                            Card(
                              elevation: 3.0,
                              margin: const EdgeInsets.only(bottom: 20),
                              child: Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          getforecastweather(1)['forecastDate'],
                                          style: const TextStyle(
                                              color: Color(0xff6696f5),
                                              fontWeight: FontWeight.w600),
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            Row(
                                              children: [
                                                Text(
                                                  getforecastweather(
                                                          1)['mintemperature']
                                                      .toString(),
                                                  style: TextStyle(
                                                    color: constant.greyColor,
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 30,
                                                  ),
                                                ),
                                                Text(
                                                  '°',
                                                  style: TextStyle(
                                                    color: constant.greyColor,
                                                    fontWeight: FontWeight.w600,
                                                    fontFeatures: const [
                                                      FontFeature.enable(
                                                          'sups'),
                                                    ],
                                                    fontSize: 30,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              getforecastweather(
                                                      1)['maxtemperature']
                                                  .toString(),
                                              style: TextStyle(
                                                color: constant.blackColor,
                                                fontWeight: FontWeight.w600,
                                                fontSize: 30,
                                              ),
                                            ),
                                            Text(
                                              '°',
                                              style: TextStyle(
                                                color: constant.blackColor,
                                                fontWeight: FontWeight.w600,
                                                fontFeatures: const [
                                                  FontFeature.enable('sups'),
                                                ],
                                                fontSize: 30,
                                              ),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Image.network(
                                              getforecastweather(
                                                          1)['weatherIcon']
                                                      .startsWith('http')
                                                  ? getforecastweather(
                                                      1)['weatherIcon']
                                                  // ignore: prefer_interpolation_to_compose_strings
                                                  : 'https:' +
                                                      getforecastweather(
                                                          1)['weatherIcon'],
                                              fit: BoxFit.cover,
                                              width: 30,
                                            ),
                                            const SizedBox(
                                              width: 5,
                                            ),
                                            Text(
                                              getforecastweather(
                                                  1)['weathername'],
                                              style: const TextStyle(
                                                fontSize: 16,
                                                color: Colors.grey,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              '${getforecastweather(1)['chanceofRain']}%',
                                              style: const TextStyle(
                                                fontSize: 16,
                                                color: Colors.grey,
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 5,
                                            ),
                                            Image.asset(
                                              'assets/lightrain.png',
                                              width: 30,
                                            ),
                                          ],
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                            Card(
                              elevation: 3.0,
                              margin: const EdgeInsets.only(bottom: 20),
                              child: Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          getforecastweather(2)['forecastDate'],
                                          style: const TextStyle(
                                              color: Color(0xff6696f5),
                                              fontWeight: FontWeight.w600),
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            Row(
                                              children: [
                                                Text(
                                                  getforecastweather(
                                                          2)['mintemperature']
                                                      .toString(),
                                                  style: TextStyle(
                                                    color: constant.greyColor,
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 30,
                                                  ),
                                                ),
                                                Text(
                                                  '°',
                                                  style: TextStyle(
                                                    color: constant.greyColor,
                                                    fontWeight: FontWeight.w600,
                                                    fontFeatures: const [
                                                      FontFeature.enable(
                                                          'sups'),
                                                    ],
                                                    fontSize: 30,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              getforecastweather(
                                                      2)['maxtemperature']
                                                  .toString(),
                                              style: TextStyle(
                                                color: constant.blackColor,
                                                fontWeight: FontWeight.w600,
                                                fontSize: 30,
                                              ),
                                            ),
                                            Text(
                                              '°',
                                              style: TextStyle(
                                                color: constant.blackColor,
                                                fontWeight: FontWeight.w600,
                                                fontFeatures: const [
                                                  FontFeature.enable('sups'),
                                                ],
                                                fontSize: 30,
                                              ),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 05,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Image.network(
                                              getforecastweather(
                                                          2)['weatherIcon']
                                                      .startsWith('http')
                                                  ? getforecastweather(
                                                      2)['weatherIcon']
                                                  // ignore: prefer_interpolation_to_compose_strings
                                                  : 'https:' +
                                                      getforecastweather(
                                                          2)['weatherIcon'],
                                              fit: BoxFit.cover,
                                              width: 30,
                                            ),
                                            const SizedBox(
                                              width: 5,
                                            ),
                                            Text(
                                              getforecastweather(
                                                  2)['weathername'],
                                              style: const TextStyle(
                                                fontSize: 16,
                                                color: Colors.grey,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              '${getforecastweather(2)['chanceofRain']}%',
                                              style: const TextStyle(
                                                fontSize: 16,
                                                color: Colors.grey,
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 5,
                                            ),
                                            Image.asset(
                                              'assets/lightrain.png',
                                              width: 30,
                                            ),
                                          ],
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ))
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
