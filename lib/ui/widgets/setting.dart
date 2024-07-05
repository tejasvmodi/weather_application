import 'package:flutter/material.dart';
import 'package:weather_application/models/constant.dart';
import 'package:weather_application/ui/CIty%20weather%20data/city_weather_data.dart';
import 'package:weather_application/ui/Country%20weather%20data/welcome.dart';

class SettingWeathericon extends StatefulWidget {
  const SettingWeathericon({super.key});

  @override
  State<SettingWeathericon> createState() => _SettingWeathericonState();
}

class _SettingWeathericonState extends State<SettingWeathericon> {
  CityConstant constant = CityConstant();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: constant.secondaryColor,
      appBar: AppBar(
          title: Text(
            'Setting',
            style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: constant.blackColor),
          ),
          centerTitle: true,
          backgroundColor: constant.secondaryColor,
          elevation: 0,
          bottom: const PreferredSize(
              preferredSize: Size(0, 0),
              child: Divider(
                color: Colors.black,
              ))),
      body: Center(
        child: Container(
          height: MediaQuery.of(context).size.height * 0.3,
          width: MediaQuery.of(context).size.width * 0.8,
          decoration: BoxDecoration(
              border: Border.all(color: Colors.black),
              borderRadius: const BorderRadius.all(
                Radius.elliptical(10, 10),
              ),
              color: constant.greyColor),
          child: Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * .06,
              ),
              Container(
                height: 50,
                width: MediaQuery.of(context).size.width * 0.65,
                decoration: BoxDecoration(
                  color: constant.primaryColor,
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                ),
                child: Center(
                  child: TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const Welcome(),
                            ));
                      },
                      child: const Text(
                        'Change the Country Name',
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      )),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * .06,
              ),
              Container(
                height: 50,
                width: MediaQuery.of(context).size.width * 0.65,
                decoration: BoxDecoration(
                  color: constant.primaryColor,
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                ),
                child: Center(
                  child: TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const Cityweatherdata(),
                            ));
                      },
                      child: const Text(
                        'City wise Weather',
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      )),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
