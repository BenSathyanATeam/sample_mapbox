import 'package:flutter/material.dart';

import 'location_field.dart';

Widget endpointsCard(TextEditingController sourceController,
    TextEditingController destinationController) {
  return Card(
    elevation: 5,
    color: Colors.black,
    clipBehavior: Clip.antiAlias,
    margin: const EdgeInsets.all(0),
    child: Container(
      padding: const EdgeInsets.all(15),
      child: Row(
        children: [
          Column(
            children: [
              const Icon(Icons.brightness_1,color: Colors.white, size: 8),
              Container(
                margin: const EdgeInsets.only(top: 3),
                color: Colors.white,
                width: 1,
                height: 40,
              ),
              const Icon(Icons.stop,color: Colors.white, size: 12),
            ],
          ),
          Expanded(
            child: Column(
              children: [
                LocationField(
                    isDestination: false,
                    textEditingController: sourceController),
                LocationField(
                    isDestination: true,
                    textEditingController: destinationController),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
