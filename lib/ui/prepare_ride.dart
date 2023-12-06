import 'package:flutter/material.dart';
import 'package:mapbox/ui/review_ride.dart';
import 'package:mapbox_gl/mapbox_gl.dart';

import '../utils/mapbox_handler.dart';
import '../utils/shared_prefs.dart';
import '../widgets/endpoints_card.dart';
import '../widgets/search_listview.dart';


class PrepareRide extends StatefulWidget {
  const PrepareRide({Key? key}) : super(key: key);

  @override
  State<PrepareRide> createState() => _PrepareRideState();

  // Declare a static function to reference setters from children
  // ignore: library_private_types_in_public_api
  static _PrepareRideState? of(BuildContext context) =>
      context.findAncestorStateOfType<_PrepareRideState>();
}

class _PrepareRideState extends State<PrepareRide> {
  bool isLoading = false;
  bool isEmptyResponse = true;
  bool hasResponded = false;
  bool isResponseForDestination = false;

  String noRequest = 'Please enter an address, a place or a location to search';
  String noResponse = 'No results found for the search';

  List responses = [];
  TextEditingController sourceController = TextEditingController();
  TextEditingController destinationController = TextEditingController();

  // Define setters to be used by children widgets
  set responsesState(List responses) {
    setState(() {
      this.responses = responses;
      hasResponded = true;
      isEmptyResponse = responses.isEmpty;
    });
    Future.delayed(
      const Duration(milliseconds: 500),
          () => setState(() {
        isLoading = false;
      }),
    );
  }

  set isLoadingState(bool isLoading) {
    setState(() {
      this.isLoading = isLoading;
    });
  }

  set isResponseForDestinationState(bool isResponseForDestination) {
    setState(() {
      this.isResponseForDestination = isResponseForDestination;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
       /* leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back)),*/
        title: const Text('Cabs'),
        actions: const [
          CircleAvatar(backgroundImage: AssetImage('assets/splash_icon.png'),backgroundColor: Colors.white,),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const ScrollPhysics(),
          child: Column(
            children: [
               endpointsCard(sourceController, destinationController),
              isLoading
                  ? const LinearProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white))
                  : Container(),
              isEmptyResponse
                  ? Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Center(
                      child: Text(hasResponded ? noResponse : noRequest)))
                  : Container(),
              searchListView(responses, isResponseForDestination,
                  destinationController, sourceController),
            ],
          ),
        ),
      ),
      floatingActionButton: GestureDetector(
        onTap: () async{
          LatLng sourceLatLng = getTripLatLngFromSharedPrefs('source');
          LatLng destinationLatLng = getTripLatLngFromSharedPrefs('destination');
          Map modifiedResponse = await getDirectionsAPIResponse(sourceLatLng, destinationLatLng);
          // ignore: use_build_context_synchronously
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) =>
                      ReviewRide(modifiedResponse: modifiedResponse)));
          },
        child: Container(
            decoration: const BoxDecoration(
              color: Colors.black,
                borderRadius: BorderRadius.all(Radius.circular(20))
            ),
            child: const Padding(
              padding: EdgeInsets.all(10.0),
              child: Text("Review your ride",style: TextStyle(color: Colors.white),),
            )),
      ),
    );
  }
}