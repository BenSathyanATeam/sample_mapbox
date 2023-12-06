import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../network/mapbox_request.dart';
import '../utils/shared_prefs.dart';

class MapViewScreen extends StatefulWidget {
  const MapViewScreen({super.key});

  @override
  State<MapViewScreen> createState() => _MapViewScreenState();
}

class _MapViewScreenState extends State<MapViewScreen> {
  LatLng sourceLatLng = LatLng(getTripLatLngFromSharedPrefs('source').latitude, getTripLatLngFromSharedPrefs('source').longitude);
  LatLng destinationLatLng = LatLng(getTripLatLngFromSharedPrefs('destination').latitude, getTripLatLngFromSharedPrefs('destination').longitude);
  List<LatLng> points = [];
@override
  void initState() {
    // TODO: implement initState
  getPolyLine();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return  FlutterMap(
      options: MapOptions(
        bounds: LatLngBounds(sourceLatLng, destinationLatLng),
        boundsOptions: const FitBoundsOptions(padding: EdgeInsets.all(70.0)),
      ),
      layers: [
        TileLayerOptions(
          urlTemplate: "https://api.mapbox.com/styles/v1/mapbox/streets-v11/tiles/"
              "{z}/{x}/{y}?access_token=${dotenv.env['PUBLIC_ACCESS_TOKEN']}",
          subdomains: ['a', 'b', 'c'],
        ),
        PolylineLayerOptions(
          // Will only render visible polylines, increasing performance
          polylines: [
            Polyline(
              // An optional tag to distinguish polylines in callback
              points: points,
              color: Colors.black,
              strokeWidth: 3.0,
            ),
          ],
        ),
        MarkerLayerOptions(
          markers: [
            Marker(
              width: 15.0,
              height: 15.0,
              point: sourceLatLng,
              builder: (ctx) =>
               Image.asset('assets/circle.png'),
            ),
            Marker(
              width: 15.0,
              height: 15.0,
              point: destinationLatLng,
              builder: (ctx) =>
               Image.asset('assets/square.png'),
            ),
          ],
        ),
      ],
    );
  }

  Future<void> getPolyLine() async{
     final responseData = await getRouteListUsingMapbox(sourceLatLng, destinationLatLng);
     Map geometry = responseData['routes'][0]['geometry'];
     var coordinates =geometry['coordinates'];
      for (var coordinate in coordinates) {
        points.add(LatLng(coordinate[1], coordinate[0]));
      }
   setState(() {});
   }
}
