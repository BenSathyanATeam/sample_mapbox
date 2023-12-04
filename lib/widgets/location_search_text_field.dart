import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import '../main.dart';
import '../utils/mapbox_handler.dart';
import '../utils/shared_prefs.dart';

class LocationField extends StatefulWidget {
  final TextEditingController textEditingController;

  const LocationField({
    Key? key,
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
   // PrepareRide.of(context)?.isLoading = true;

    // Make sure that requests are not made
    // until 1 second after the typing stops
    if (searchOnStoppedTyping != null) {
      setState(() => searchOnStoppedTyping?.cancel());
    }
    setState(() => searchOnStoppedTyping =
        Timer(const Duration(seconds: 1), () => _searchHandler(value)));
  }

  _searchHandler(String value) async {
    // Get response using Mapbox Search API
    List response = await getParsedResponseForQuery(value);

    // Set responses and isDestination in parent
   // PrepareRide.of(context)?.responsesState = response;
    setState(() => query = value);
  }

  _useCurrentLocationButtonHandler() async {
      LatLng currentLocation = getCurrentLatLngFromSharedPrefs();

      // Get the response of reverse geocoding and do 2 things:
      // 1. Store encoded response in shared preferences
      // 2. Set the text editing controller to the address
      var response = await getParsedReverseGeocoding(currentLocation);
      sharedPreferences.setString('source', json.encode(response));
      String place = response['place'];
      widget.textEditingController.text = place;
  }

  @override
  Widget build(BuildContext context) {
    List<String> kOptions = <String>[
      'aardvark',
      'bobcat',
      'chameleon',
    ];

    return Padding(
      padding: const EdgeInsets.only(left: 10),
      child: Expanded(
        child: Autocomplete<String>(
          optionsBuilder: (TextEditingValue textEditingValue) {
            if (textEditingValue.text == '') {
              return const Iterable<String>.empty();
            }
            return kOptions.where((String option) {
              return option.contains(textEditingValue.text.toLowerCase());
            });
          },
          onSelected: (String selection) {
            debugPrint('You just selected $selection');
          },
        ),
      ),
    );
  }
}