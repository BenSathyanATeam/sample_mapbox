import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:mapbox/main.dart';
import 'package:mapbox/ui/prepare_ride.dart';
import 'package:mapbox_gl/mapbox_gl.dart';


class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    super.initState();
    initializeLocationAndSave();
  }

  void initializeLocationAndSave() async{
    /// Ensure all permissions are collected for Locations
    Location location = Location();
    bool serviceEnabled =  await location.serviceEnabled();
    PermissionStatus permissionStatus;
    if(!serviceEnabled){
      serviceEnabled = await location.requestService();
    }
    permissionStatus = await location.hasPermission();
    if(permissionStatus == PermissionStatus.denied){
      permissionStatus = await location.requestPermission();
    }

    /// Get capture the current user location
    LocationData locationData = await location.getLocation();
    LatLng currentLatLng = LatLng(locationData.latitude!, locationData.longitude!);
    /// Store the user location in sharedPreferences
    sharedPreferences.setDouble("latitude", currentLatLng.latitude);
    sharedPreferences.setDouble("longitude", currentLatLng.longitude);
    /// Get and store the directions API response in sharedPreferences
    Future.delayed(
        const Duration(seconds: 0),
            () => Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => const PrepareRide()),
                (route) => false));
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: Center(child: Image.asset('assets/splash_icon.png')),
    );
  }
}