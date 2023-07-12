import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

Widget customMyLocation(GoogleMapController? mapController, BuildContext context) {
  return Align(
    alignment: Alignment.bottomRight,
    child: Padding(
      padding: const EdgeInsets.only(bottom: 20, right: 30),
      child: InkWell(
        onTap: () async {
          if (mapController == null) {
            return;
          }

          final location = await Geolocator.getCurrentPosition();

          mapController!.animateCamera(
            CameraUpdate.newLatLngZoom(
              LatLng(
                location.latitude,
                location.longitude,
              ),
              16  //zoomlevel
            ),
          );
        },
        child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.9),
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(50),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.5),
                    offset: Offset(0, 0.5),
                    blurRadius: 5,
                    spreadRadius: 0,
                  )
                ]
            ),
            child: Icon(
              Icons.my_location_outlined,
              size: 22,
              color: Theme.of(context).colorScheme.primary,
            )
        ),
      ),
    ),
  );
}