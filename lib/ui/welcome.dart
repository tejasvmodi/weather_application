import 'package:flutter/material.dart';
import 'package:weather_application/models/city.dart';
import 'package:weather_application/models/constant.dart';
import 'package:weather_application/ui/home.dart';

class Welcome extends StatefulWidget {
  const Welcome({super.key});

  @override
  State<Welcome> createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  @override
  Widget build(BuildContext context) {
    List<City> cities = City.citiesList.where((city) => city.isDefault == false).toList();
    List<City> selectedCities = City.getSelectedCities();

    Constant myconstant = Constant();
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: myconstant.secondaryColor,
        title: Text('${selectedCities.length} selected'),
      ),
      body: ListView.builder(
        itemCount: cities.length,
        itemBuilder: (context, index) {
          return Container(
            margin: const EdgeInsets.only(left: 10, top: 20, right: 10),
            padding: const EdgeInsets.symmetric(horizontal: 20),
            height: size.height * 0.08,
            width: size.width,
            decoration: BoxDecoration(
              border: cities[index].isSelected
                  ? Border.all(
                      color: myconstant.secondaryColor.withOpacity(0.8),
                      width: 2,
                    )
                  : Border.all(color: Colors.white),
              borderRadius: const BorderRadius.all(
                Radius.circular(10),
              ),
              boxShadow: [
                BoxShadow(
                  color: myconstant.primaryColor.withOpacity(0.2),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      cities[index].isSelected = !cities[index].isSelected;
                    });
                  },
                  child: Image.asset(
                    cities[index].isSelected
                        ? 'assets/checked.png'
                        : 'assets/unchecked.png',
                    width: 30,
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  cities[index].city,
                  style: TextStyle(
                    fontSize: 24,
                    color: cities[index].isSelected
                        ? myconstant.primaryColor
                        : Colors.black45,
                  ),
                )
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: myconstant.secondaryColor,
        child: const Icon(Icons.pin_drop),
        onPressed: () {
          List<City> selectedCities = cities.where((city) => city.isSelected).toList();
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => Home(selectedCities: selectedCities),
            ),
          );
        },
      ),
    );
  }
}
