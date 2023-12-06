import 'package:flutter/material.dart';
import '../utils/shared_prefs.dart';

Widget reviewRideBottomSheet(BuildContext context, String distance, String dropOffTime) {
  String sourceAddress = getSourceAndDestinationPlaceText('source');
  String destinationAddress = getSourceAndDestinationPlaceText('destination');

  return SizedBox(
    width: 200,
    child: Card(
      color: Colors.black.withOpacity(.2),
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.only(left: 10,right: 10,top: 10),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
          Text('$sourceAddress ➡ $destinationAddress',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.white, fontSize: 10)),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: ListTile(
              tileColor: Colors.black.withOpacity(.1),
              leading: const Image(
                image: AssetImage(
                  'assets/splash_icon.png',
                ),
                height: 20,
                width: 20,
                color: Colors.white,
              ),
              title: const Text('Start Ride',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white)),
              subtitle: Text(
                '$distance km, $dropOffTime',
                style: const TextStyle(color: Colors.white,fontSize: 12),
              ),
              trailing: const Text("", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 0, color: Colors.white)),
            ),
          ),
        ]),
      ),
    ),
  );
}
