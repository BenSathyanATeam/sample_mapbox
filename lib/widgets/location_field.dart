import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import '../main.dart';
import '../ui/prepare_ride.dart';
import '../utils/mapbox_handler.dart';
import '../utils/shared_prefs.dart';

class LocationField extends StatefulWidget {
  final bool isDestination;
  final TextEditingController textEditingController;

  const LocationField({
    Key? key,
    required this.isDestination,
    required this.textEditingController,
  }) : super(key: key);

  @override
  State<LocationField> createState() => _LocationFieldState();
}

class _LocationFieldState extends State<LocationField> {
  Timer? searchOnStoppedTyping;
  String query = '';

  _onChangeHandler(value) {
    // Set isLoading = true in parent
    PrepareRide.of(context)?.isLoading = true;

    // Make sure that requests are not made
    // until 1 second after the typing stops
    if (searchOnStoppedTyping != null) {
      setState(() => searchOnStoppedTyping?.cancel());
    }
    setState(() => searchOnStoppedTyping =
        Timer(const Duration(seconds: 1), () => _searchHandler(value)));
  }

  _searchHandler(String value) async {
    var prepareRide = PrepareRide.of(context);
    // Get response using Mapbox Search API
    List response = await getParsedResponseForQuery(value);

    // Set responses and isDestination in parent
    prepareRide?.responsesState = response;
    prepareRide?.isResponseForDestinationState =
        widget.isDestination;
    setState(() => query = value);
  }

  _useCurrentLocationButtonHandler() async {
    if (!widget.isDestination) {
      LatLng currentLocation = getCurrentLatLngFromSharedPrefs();

      // Get the response of reverse geocoding and do 2 things:
      // 1. Store encoded response in shared preferences
      // 2. Set the text editing controller to the address
      var response = await getParsedReverseGeocoding(currentLocation);
      sharedPreferences.setString('source', json.encode(response));
      String place = response['place'];
      widget.textEditingController.text = place;
    }
  }

  @override
  Widget build(BuildContext context) {
    String placeholderText = widget.isDestination ? 'Where to?' : 'Where from?';
    IconData? iconData = !widget.isDestination ? Icons.my_location : Icons.directions;
    return Padding(
      padding: const EdgeInsets.only(top: 5, bottom: 5, left: 10),
      child: CupertinoTextField(
          controller: widget.textEditingController,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          placeholder: placeholderText,
          placeholderStyle: const TextStyle(color: Colors.white),
          decoration: BoxDecoration(
            color: Colors.grey.withOpacity(.5),
            borderRadius: const BorderRadius.all(Radius.circular(5)),
          ),
          onChanged: _onChangeHandler,
          style: const TextStyle(color: Colors.white),
          suffix: IconButton(
              onPressed: () => _useCurrentLocationButtonHandler(),
              padding: const EdgeInsets.all(10),
              constraints: const BoxConstraints(),
              icon: Icon(iconData, size: 16,color: Colors.white,))),
    );
  }
}