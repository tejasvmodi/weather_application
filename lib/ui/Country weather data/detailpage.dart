import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather_application/models/constant.dart';
import 'package:weather_application/ui/widgets/weather_item.dart';

class DetailPage extends StatefulWidget {
  final List consolidatedweatherList;
  final int selectedId;
  final String location;
  final String imageUrl;
  const DetailPage(
      {super.key,
      required this.consolidatedweatherList,
      required this.selectedId,
      required this.location,
      required this.imageUrl});
 
  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  String imageUrl = '';

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    Constant myconstant = Constant();

    final Shader linearGradient = const LinearGradient(
      colors: <Color>[Color(0xffABCFF2), Color(0xff9AC6F3)],
    ).createShader(const Rect.fromLTWH(0.0, 0.0, 200.0, 70.0));

    int selectedIndex = widget.selectedId;
    var weatherstateName =
        widget.consolidatedweatherList[selectedIndex]['condition'];

    imageUrl = widget.imageUrl;

    return Scaffold(
      backgroundColor: myconstant.secondaryColor,
      appBar: AppBar(
        elevation: 8.0,
        centerTitle: true,
        backgroundColor: myconstant.secondaryColor,
        title: Text(widget.location),
      ),
      body: Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none,
        children: [
          Positioned(
            top: 10,
            left: 10,
            child: SizedBox(
              height: 150,
              width: 400,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: widget.consolidatedweatherList.length,
                itemBuilder: (context, index) {
                  var futureicon =
                      widget.consolidatedweatherList[index]['icon'];
                  var url = widget.consolidatedweatherList[index]['icon']
                          .startsWith('https://')
                      ? widget.consolidatedweatherList[index]['icon']
                      : 'https:$futureicon';
                  var parsedDate = DateTime.parse(
                      widget.consolidatedweatherList[index]['date']);
                  var newDate =
                      DateFormat('EEEE').format(parsedDate).substring(0, 3);

                  return Container(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    margin: const EdgeInsets.only(right: 20),
                    width: 80,
                    decoration: BoxDecoration(
                        color: index == selectedIndex
                            ? Colors.white
                            : const Color(0xff9ebcf9),
                        borderRadius: const BorderRadius.all(
                          Radius.circular(10),
                        ),
                        boxShadow: [
                          BoxShadow(
                              offset: const Offset(0, 1),
                              blurRadius: 5,
                              color: Colors.blue.withOpacity(0.3))
                        ]),
                    child: Column(
                      children: [
                        Text(
                          '${widget.consolidatedweatherList[index]['max_temp'].round()}C',
                          style: TextStyle(
                              fontSize: 17,
                              color: index == selectedIndex
                                  ? Colors.blue
                                  : Colors.white,
                              fontWeight: FontWeight.w500),
                        ),
                        Image.network(
                          url,
                          width: 40,
                        ),
                        Text(
                          newDate,
                          style: TextStyle(
                            fontSize: 17,
                            color: index == selectedIndex
                                ? Colors.blue
                                : Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            child: Container(
              height: size.height * 0.55,
              width: size.width,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(50),
                  topLeft: Radius.circular(50),
                ),
              ),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Positioned(
                    top: -50,
                    right: 20,
                    left: 20,
                    child: Container(
                      width: size.width * 0.7,
                      height: 300,
                      decoration: BoxDecoration(
                          gradient: const LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.center,
                              colors: [
                                Color(0xffa9c1f5),
                                Color(0xff6696f5),
                              ]),
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.blue.withOpacity(0.1),
                              offset: const Offset(0, 25),
                              blurRadius: 3,
                              spreadRadius: -10,
                            )
                          ]),
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Positioned(
                            top: -40,
                            left: 20,
                            child: Image.network(
                              imageUrl,
                              width: 130,
                              fit: BoxFit.cover,
                              filterQuality: FilterQuality.high,
                            ),
                          ),
                          Positioned(
                            top: 125,
                            left: 30,
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: Text(
                                weatherstateName,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 20,
                            left: 20,
                            child: Container(
                              width: size.width * 0.8,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  WeatherItem(
                                    text: 'Wind Speed',
                                    value: widget.consolidatedweatherList[
                                        selectedIndex]['windSpeed'],
                                    unit: 'km/h',
                                    imageUrl: 'assets/windspeed.png',
                                  ),
                                  WeatherItem(
                                    text: 'Humidity',
                                    value: widget
                                        .consolidatedweatherList[selectedIndex]
                                            ['humidity']
                                        .toDouble(),
                                    unit: '%',
                                    imageUrl: 'assets/humidity.png',
                                  ),
                                  WeatherItem(
                                    text: 'Max Temp',
                                    value: widget.consolidatedweatherList[
                                        selectedIndex]['max_temp'],
                                    unit: '°C',
                                    imageUrl: 'assets/max-temp.png',
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Positioned(
                            top: 20,
                            right: 20,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.consolidatedweatherList[selectedIndex]
                                          ['temperature']
                                      .toString(),
                                  style: TextStyle(
                                    fontSize: 80,
                                    fontWeight: FontWeight.bold,
                                    foreground: Paint()
                                      ..shader = linearGradient,
                                  ),
                                ),
                                Text(
                                  'o',
                                  style: TextStyle(
                                    fontSize: 40,
                                    fontWeight: FontWeight.bold,
                                    foreground: Paint()
                                      ..shader = linearGradient,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                      top: 300,
                      left: 20,
                      bottom: 10,
                      child: SizedBox(
                        height: 200,
                        width: size.width * 0.9,
                        child: ListView.builder(
                          scrollDirection: Axis.vertical,
                          itemCount: widget.consolidatedweatherList.length,
                          itemBuilder: (context, index) {
                            var futureicon =
                                widget.consolidatedweatherList[index]['icon'];
                            var futureurl = widget
                                    .consolidatedweatherList[index]['icon']
                                    .startsWith('https://')
                                ? widget.consolidatedweatherList[index]['icon']
                                : 'https:$futureicon';
                            var parsedDate = DateTime.parse(
                                widget.consolidatedweatherList[index]['date']);
                            var currentDate =
                                DateFormat('d,MMMM,EEEE').format(parsedDate);

                            return Container(
                              margin: const EdgeInsets.only(
                                  left: 10, right: 10, top: 10, bottom: 5),
                              height: 80,
                              width: size.width,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(10),
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                        color: myconstant.secondaryColor
                                            .withOpacity(0.1),
                                        spreadRadius: 6,
                                        blurRadius: 20,
                                        offset: const Offset(0, 3))
                                  ]),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      currentDate,
                                      style: const TextStyle(
                                        color: Color(0xff6696f5),
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          widget.consolidatedweatherList[index]
                                                  ['max_temp']
                                              .toString(),
                                          style: const TextStyle(
                                            color: Colors.grey,
                                            fontSize: 25,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        const Text(
                                          '/',
                                          style: TextStyle(
                                            color: Colors.grey,
                                            fontSize: 25,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        Text(
                                          widget.consolidatedweatherList[index]
                                                  ['min_temp']
                                              .toString(),
                                          style: const TextStyle(
                                            color: Colors.grey,
                                            fontSize: 20,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Image.network(
                                          futureurl,
                                          width: 30,
                                        ),
                                        Text(
                                          widget.consolidatedweatherList[index]
                                              ['condition'],
                                          style: const TextStyle(
                                            color: Colors.grey,
                                            fontSize: 10,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
