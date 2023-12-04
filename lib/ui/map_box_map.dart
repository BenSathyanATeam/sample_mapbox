import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
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
    TextEditingController searchController = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        title:  Row(
          children: [
            const Text('Where to',style: TextStyle(fontSize: 18),),
            LocationField(textEditingController: searchController),
          ],
        ),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            MapboxMap(
              accessToken: dotenv.env['PUBLIC_ACCESS_TOKEN'],
              initialCameraPosition: _initialCameraPosition,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          controller.animateCamera(CameraUpdate.newCameraPosition(_initialCameraPosition));
        },
        child: const Icon(Icons.my_location),
      ),
    );
  }
}
