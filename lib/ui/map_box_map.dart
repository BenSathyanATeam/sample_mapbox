import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mapbox/ui/prepare_ride.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import '../utils/mapbox_handler.dart';
import '../utils/shared_prefs.dart';
import '../widgets/location_search_text_field.dart';

class MapBoxMap extends StatefulWidget {
  const MapBoxMap({super.key});

  @override
  State<MapBoxMap> createState() => _MapBoxMapState();
}

class _MapBoxMapState extends State<MapBoxMap> {
  /// Mapbox related
  LatLng latLng = getCurrentLatLngFromSharedPrefs();
  String title = 'Loading..';
  late CameraPosition _initialCameraPosition;
  late MapboxMapController controller;

  @override
  void initState() {
    super.initState();
    print("============ MY LOCATION ===================");
    print(latLng.latitude);
    print(latLng.longitude);
    _initialCameraPosition = CameraPosition(target: latLng, zoom: 15);

    // Calculate the distance and time from data in SharedPreferences
  }

  _onMapCreated(MapboxMapController controller) async {
    this.controller = controller;
    var response = await getParsedReverseGeocoding(latLng);
    setState(() {
      title = response['place'];
    });
  }

  _onStyleLoadedCallback() async {
    await controller.addSymbol(
      SymbolOptions(
        geometry: latLng,
        iconSize: 0.7,
        iconImage: "assets/splash_icon.png",
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title,style: const TextStyle(fontSize: 14),),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            MapboxMap(
              accessToken: dotenv.env['PUBLIC_ACCESS_TOKEN'],
              initialCameraPosition: _initialCameraPosition,
              onStyleLoadedCallback: _onStyleLoadedCallback,
              onMapCreated: _onMapCreated,
            ),
          ],
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(left:28.0,right: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            FloatingActionButton(
              backgroundColor: Colors.black,
              heroTag: "1",
              onPressed: () {
                controller.animateCamera(CameraUpdate.newCameraPosition(_initialCameraPosition));
              },
              child: const Icon(Icons.my_location,color: Colors.white,),
            ),FloatingActionButton(
              backgroundColor: Colors.black,
              heroTag: "2",
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context)=> const PrepareRide()));
              },
              child: const Icon(Icons.directions,color: Colors.white,),
            ),
          ],
        ),
      ),
    );
  }
}
