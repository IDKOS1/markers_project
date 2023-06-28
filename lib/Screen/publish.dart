import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../Widget/customMyLocation.dart';

class Publish extends StatefulWidget {
  const Publish({Key? key}) : super(key: key);

  @override
  State<Publish> createState() => _PublishState();
}

class _PublishState extends State<Publish> {
  String titleValue = '';
  LatLng myLocation = LatLng(0,0);
  GoogleMapController? mapController;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
          appBar: AppBar(
            title: Text('마커 남기기'),
          ),
          body: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                TextField(
                  onChanged: (value) {
                    titleValue = value;
                  },
                  decoration: InputDecoration(
                    labelText: '제목을 입력하세요'
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: TextButton(
                      onPressed: () {
                        _LocationSelectScreen();
                      },
                      child: Row(
                        children: [
                          Icon(Icons.location_on),
                          Text('설정위치 위도:${myLocation.latitude} 경도:${myLocation.longitude}'),
                        ],
                      )
                  ),
                ),
                SizedBox(height: 30,),
                TextField(
                  maxLines: null,
                  keyboardType: TextInputType.multiline,
                  onChanged: (value) {
                    titleValue = value;
                  },
                  decoration: InputDecoration(
                      labelText: '내용을 입력하세요'
                  ),
                )
              ],
            ),
          )
      ),
    );
  }

  void _LocationSelectScreen() async {
    final LatLng selectedLocation = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => _SetLocation(),
      ),
    );

    if (selectedLocation != null) {
      setState(() {
        myLocation = selectedLocation;
      });
    }
  }

  onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }
}



class _SetLocation extends StatefulWidget {

  const _SetLocation({
    Key? key}) : super(key: key);

  @override
  State<_SetLocation> createState() => _SetLocationState();
}

class _SetLocationState extends State<_SetLocation> {
  late Circle circle;
  late LatLng myLatLng;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  void _getCurrentLocation() {
    Geolocator.getPositionStream().listen((pos) {
      setState(() {
        myLatLng = LatLng(pos.latitude, pos.longitude);
        circle = Circle(
          circleId: CircleId('myLocation'),
          center: myLatLng,
          fillColor: Colors.blue.withOpacity(0.3),
          radius: 300,
          strokeColor: Colors.blue,
          strokeWidth: 2,
        );
        isLoading = false; // 위치 정보가 설정되었으므로 로딩 상태 종료
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      body: Center(
        child: Expanded(
          child: Stack(
            children: [
              GoogleMap(
                mapType: MapType.normal,
                initialCameraPosition: CameraPosition(
                  target: myLatLng,
                  zoom: 15,
                ),
                myLocationEnabled: true,
                myLocationButtonEnabled: false,
                circles: Set.from([circle]),
                onCameraIdle: () {
                  // Handle onCameraIdle event
                },
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  margin: EdgeInsets.only(bottom: 20),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context, circle.center);
                    },
                    child: Text('위치 설정'),
                  ),
                ),
              ),
              customMyLocation(null),
            ],
          ),
        ),
      ),
    );
  }
}
