import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather_application/models/constant.dart';
import 'package:weather_application/ui/welcome.dart';

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
        widget.consolidatedweatherList[selectedIndex]['weather_state_name'];

    imageUrl = widget.imageUrl;

    return Scaffold(
      backgroundColor: myconstant.secondaryColor,
      appBar: AppBar(
        elevation: 8.0,
        centerTitle: true,
        backgroundColor: myconstant.secondaryColor,
        title: Text(widget.location),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: IconButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const Welcome(),
                      ));
                },
                icon: const Icon(Icons.settings)),
          ),
        ],
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

                  var weatherUrl= widget.imageUrl;
                  var parsedDate= DateTime.parse(widget.consolidatedweatherList[index]['application_date']);
                  var newDate = DateFormat('EEEE').format(parsedDate).substring(0,3);

                  return Container(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    margin: const EdgeInsets.only(right: 20),
                    width: 80,
                    decoration: BoxDecoration(
                      color: index == selectedIndex ?
                      Colors.white : Color(0xff9ebcf9),
                      borderRadius: const BorderRadius.all(Radius.circular(10),),
                      boxShadow: [
                        BoxShadow(
                          offset: const Offset(0, 1),
                          blurRadius: 5,
                          color: Colors.blue.withOpacity(0.3)
                        )
                      ]
                    ),


                  );


                },),
            ),

          )
        ],
      ),
    );
  }
}
