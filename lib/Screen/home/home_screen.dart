import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/services.dart';

import '../../Widget/TagWidget.dart';
import '../../Widget/customMyLocation.dart';
import 'bottom_post.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String selectedTag = '';
  String searchValue = '';
  bool choolCheckDone = false;
  GoogleMapController? mapController;
  bool isLocationOk = false;
  CameraPosition? currentLocation;


  // latitude - 위도, longitude - 경도
  static final LatLng companyLatLng = LatLng(37.5233273, 126.921252);

  static final double okDistance = 100;



  static final Circle checkDoneCircle = Circle(
    circleId: CircleId('checkDoneCircle'),
    center: companyLatLng,
    fillColor: Colors.green.withOpacity(0.5),
    // 투명도
    radius: okDistance,
    strokeColor: Colors.green,
    strokeWidth: 1,
  );

  static final Marker marker = Marker(
    markerId: MarkerId('marker'),
    position: companyLatLng,

  );


  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);  // 상단 상태바
    double topPadding = MediaQuery.of(context).padding.top + 10;
    return Scaffold(
        body: FutureBuilder(
          future: checkPermission(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }

            if (snapshot.data == '위치 권한이 허가되었습니다.') {
              return StreamBuilder<Position>(
                  stream: Geolocator.getPositionStream(),
                  builder: (context, snapshot) {
                    if(!isLocationOk){
                      if(snapshot.hasData){
                        currentLocation =
                            CameraPosition(
                                target: LatLng(
                                    snapshot.data!.latitude,
                                    snapshot.data!.longitude),
                                zoom: 15);
                        isLocationOk = true;
                      }
                      return const Scaffold(
                        body: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircularProgressIndicator(),
                              SizedBox(height: 10),
                              Text('현재위치를 불러오는중')
                            ],
                          ),
                        ),
                      );
                    }


                    return Stack(
                      alignment: Alignment.topCenter,
                      children: [
                        _CustomGoogleMap(
                          initialPosition: currentLocation!,
                          marker: marker,
                          onMapCreated: onMapCreated,
                          mapController: mapController,
                        ),
                        Column(
                          children: [
                            // 검색창
                            Padding(
                              padding: EdgeInsets.fromLTRB(
                                  20, topPadding, 20, 0),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(15),
                                child: BackdropFilter(
                                  filter: ImageFilter.blur(
                                    sigmaX: 10,
                                    sigmaY: 10,
                                  ),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(15),
                                      border: Border.all(color: Colors.black.withOpacity(0.3))
                                    ),
                                    child: TextField(
                                      maxLines: 1,
                                      keyboardType: TextInputType.multiline,
                                      onChanged: (value) {
                                        searchValue = value;
                                      },
                                      decoration: InputDecoration(
                                        hintText: '검색',
                                        icon: Padding(
                                          padding: EdgeInsets.only(left: 15),
                                          child: Icon(Icons.search),
                                        ),
                                        border: InputBorder.none,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 10,),
                            TagList(
                              onTagSelected: (tag) {
                                setState(() {
                                  selectedTag = tag;
                                });
                              },
                            ),
                            Spacer(),
                            customMyLocation(mapController, context),
                            bottom_post(),
                          ],
                        ),
                      ],
                    );
                  }
              );
            }

            return Center(
              child: Text(snapshot.data),
            );
          },
        )
    );
  }

  onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  Future<String> checkPermission() async {
    final isLocationEnabled = await Geolocator.isLocationServiceEnabled();

    if (!isLocationEnabled) {
      return '위치 서비스를 활성화 해주세요.';
    }

    LocationPermission checkedPermission = await Geolocator.checkPermission();

    if (checkedPermission == LocationPermission.denied) {
      checkedPermission = await Geolocator.requestPermission();

      if (checkedPermission == LocationPermission.denied) {
        return '앱의 위치 권한을 설정에서 허가해주세요.';
      }
    }

    if (checkedPermission == LocationPermission.deniedForever) {
      return '앱의 위치 권한을 설정에서 허가해주세요.';
    }

    return '위치 권한이 허가되었습니다.';
  }
}


class _CustomGoogleMap extends StatelessWidget {
  final CameraPosition initialPosition;
  final Marker marker;
  final MapCreatedCallback onMapCreated;
  final GoogleMapController? mapController;

  const _CustomGoogleMap({
    required this.initialPosition,
    required this.marker,
    required this.onMapCreated,
    required this.mapController,
    Key? key
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      tiltGesturesEnabled: false,
      rotateGesturesEnabled: false,
      mapType: MapType.normal,
      initialCameraPosition: initialPosition,
      myLocationEnabled: true,
      myLocationButtonEnabled: false,
      zoomControlsEnabled: false,
      markers: Set.from([marker]),
      onMapCreated: onMapCreated,
    );
  }
}


