import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

Widget customMyLocation(GoogleMapController? mapController) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 30, left: 10),
    child: Align(
        alignment: Alignment.bottomLeft,
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
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9),
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(2),
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
                color: Colors.grey,
              )
          ),
        )
    ),
  );
}