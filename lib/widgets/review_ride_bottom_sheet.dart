import 'package:flutter/material.dart';
import '../utils/shared_prefs.dart';

Widget reviewRideBottomSheet(
    BuildContext context, String distance, String dropOffTime) {
  String sourceAddress = getSourceAndDestinationPlaceText('source');
  String destinationAddress = getSourceAndDestinationPlaceText('destination');

  return Positioned(
    bottom: 0,
    child: SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('$sourceAddress ➡ $destinationAddress',
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(color: Colors.indigo)),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: ListTile(
                    tileColor: Colors.grey[200],
                    leading: const Image(
                        image: AssetImage('assets/splash_icon.png'),
                        height: 50,
                        width: 50),
                    title: const Text('Start Ride',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    subtitle: Text('$distance km, $dropOffTime'),
                    trailing: const Text("",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18)),
                  ),
                ),
             /*   ElevatedButton(
                    onPressed: () => Navigator.push(context,
                        MaterialPageRoute(builder: (_) => const TurnByTurn())),
                    style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(20)),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Text('Start your premier ride now'),
                        ])),*/
              ]),
        ),
      ),
    ),
  );
}
