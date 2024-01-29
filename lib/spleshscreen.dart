import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:goevent2/Bottombar.dart';
import 'package:goevent2/Controller/AuthController.dart';
import 'package:goevent2/home/home.dart';
import 'package:goevent2/login_signup/Login.dart';
import 'package:goevent2/utils/AppWidget.dart';
import 'package:goevent2/utils/media.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'AppModel/Homedata/HomedataController.dart';
import 'utils/colornotifire.dart';

String long = "", lat = "";

class Spleshscreen extends StatefulWidget {
  const Spleshscreen({Key? key}) : super(key: key);

  @override
  _SpleshscreenState createState() => _SpleshscreenState();
}

class _SpleshscreenState extends State<Spleshscreen>
    with SingleTickerProviderStateMixin {
  final hData = Get.put(HomeController());
  late AnimationController _controller;
  late Animation<double> _animation;

  final x = Get.put(AuthController());
  bool servicestatus = false;
  bool haspermission = false;
  late LocationPermission permission;
  late Position position;
  double imageHeight = 10;
  bool isFull = false;

  late StreamSubscription<Position> positionStream;
  @override
  void initState() {
    super.initState();
    checkGps();

    getdarkmodepreviousstate();
    Timer(
        const Duration(milliseconds: 2000),
        () => getData.read("UserLogin") == null
            ? Get.to(() => const Login(), duration: Duration.zero)
            : Get.to(() => const Bottombar(), duration: Duration.zero));
    super.initState();

    Timer(
      ///Change the size in every 1 seconds if full
      const Duration(microseconds: 0),
      () => setState(() {
        isFull = !isFull;
        imageHeight = 300;
      }),
    );

    // Create an animation controller with a duration of 1 second
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
      reverseDuration: Duration(seconds: 1),
    );

    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
    // Repeat the animation indefinitely
    _controller.repeat(reverse: true);
  }

  late ColorNotifire notifire;

  getdarkmodepreviousstate() async {
    x.cCodeApi();
    final prefs = await SharedPreferences.getInstance();
    bool? previusstate = prefs.getBool("setIsDark");
    if (previusstate == null) {
      notifire.setIsDark = false;
    } else {
      notifire.setIsDark = previusstate;
    }
  }

  //! permission handel
  checkGps() async {
    servicestatus = await Geolocator.isLocationServiceEnabled();
    if (servicestatus) {
      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
        } else if (permission == LocationPermission.deniedForever) {
        } else {
          haspermission = true;
        }
      } else {
        haspermission = true;
      }
      if (haspermission) {
        setState(() {});
        getLocation();
      }
    } else {
      print("GPS Service is not enabled, turn on GPS location");
    }
    setState(() {
      //refresh the UI
    });
  }

  //! get lat long
  getLocation() async {
    position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    print(position.longitude); //Output: 80.24599079
    print(position.latitude); //Output: 29.6593457

    long = position.longitude.toString();
    lat = position.latitude.toString();
    var latlong = LatLng(position.latitude, position.longitude);
    getAddressFromLatLong(latlong);

    setState(() {});
  }

  Future<void> getAddressFromLatLong(LatLng latLng) async {
    List<Placemark> placemarks =
        await placemarkFromCoordinates(latLng.latitude, latLng.longitude);
    if (placemarks.isNotEmpty) {
      Placemark place = placemarks[0];
      String city = place.locality.toString();
      String country = place.country.toString();

      var currentAddress = city + ((city.isNotEmpty) ? ", " : "") + country;
      save("CurentAdd", currentAddress);
      print(currentAddress);
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    notifire = Provider.of<ColorNotifire>(context, listen: true);
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: notifire.backgrounde,
      body: Center(
        child: AnimatedContainer(
          duration: Duration(milliseconds: 500), // Provide the duration
          height: imageHeight,
          width: imageHeight,
          // Use the properties stored in the State class.
          color: notifire.backgrounde,
          child: Center(
            child: Image.asset(
              "image/getevent.png",
            ),
          ),
        ),
      ),
    );
  }
}
