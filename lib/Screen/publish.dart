import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:markers_project/Widget/TagWidget.dart';
import '../Widget/customMyLocation.dart';

class Publish extends StatefulWidget {
  const Publish({Key? key}) : super(key: key);

  @override
  State<Publish> createState() => _PublishState();
}

class _PublishState extends State<Publish> {
  String titleValue = '';
  String contentsValue = '';
  LatLng myLocation = LatLng(0,0);
  GoogleMapController? mapController;
  bool isLocationSet = false;
  Color locationColor = Colors.grey;
  @override
  Widget build(BuildContext context) {
    if(myLocation != LatLng(0,0)){
      isLocationSet = true;
    }
    if(isLocationSet){
      locationColor = Theme.of(context).colorScheme.primary;
    }
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: Theme.of(context).colorScheme.secondary,
            title: Text('마커 남기기',
              style: TextStyle(color: Colors.white),
            ),
          ),
          body: Column(
            children: [
              SizedBox(height: 20),
              TagList(),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                  child: Container(
                    child: Column(
                      children: [
                        Column(
                          children: [
                            TextField(
                              onChanged: (value) {
                                titleValue = value;
                              },
                              decoration: InputDecoration(
                                  hintText: '제목을 입력하세요'
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
                                      Icon(Icons.location_on,
                                      color: locationColor,
                                      ),
                                      Text('설정위치 위도:${myLocation.latitude} 경도:${myLocation.longitude}',
                                        style: TextStyle(
                                            color: locationColor
                                        ),
                                      ),
                                    ],
                                  )
                              ),
                            ),
                            SizedBox(height: 30,),
                            TextField(
                              maxLines: null,
                              keyboardType: TextInputType.multiline,
                              onChanged: (value) {
                                contentsValue = value;
                              },
                              decoration: InputDecoration(
                                  hintText: '내용을 입력하세요',
                              ),
                            )
                          ],
                        ),
                        Spacer(),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Padding(
                            padding: EdgeInsets.only(bottom: 20),
                            child: ElevatedButton(
                              onPressed: () {},
                              child: Text('등록하기'),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
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
      final double roundedLatitude = double.parse(selectedLocation.latitude.toStringAsFixed(5));
      final double roundedLongitude = double.parse(selectedLocation.longitude.toStringAsFixed(5));
      setState(() {
        myLocation = LatLng(roundedLatitude, roundedLongitude);
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

class _SetLocationState extends State<_SetLocation> with SingleTickerProviderStateMixin {
  late Circle circle;
  late LatLng myLatLng;
  late LatLng center;
  late double distance;
  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;
  late Animation<Color?> _markerColorAnimation;
  late Animation<Color?> _buttonColorAnimation;
  GoogleMapController? mapController;
  final double circleRadius = 300;
  bool isLoading = true;
  bool isincircle = false;



  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _offsetAnimation = Tween<Offset>(
      begin: Offset(0, 0),
      end: Offset(0, -0.3),
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
    _markerColorAnimation = ColorTween(
      begin: Colors.redAccent,
      end: Colors.grey,
    ).animate(_controller);
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      _buttonColorAnimation = ColorTween(
        begin: Theme.of(context).colorScheme.primary,
        end: Colors.grey,
      ).animate(_controller);
    });

  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _getCurrentLocation() {
    Geolocator.getPositionStream().listen((pos) {
      setState(() {
        myLatLng = LatLng(pos.latitude, pos.longitude);
        circle = Circle(
          circleId: CircleId('myLocation'),
          center: myLatLng,
          fillColor: Colors.blue.withOpacity(0.3),
          radius: circleRadius,
          strokeColor: Colors.blue,
          strokeWidth: 2,
        );
        isLoading = false;
      });
    });
  }

  onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  void getDistance() {
    distance = Geolocator.distanceBetween(
        myLatLng.latitude,
        myLatLng.longitude,
        center.latitude,
        center.longitude
    );
  }


  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      // Handle case when myLatLng is null or loading
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 10,),
              Text('현재위치를 불러오는중')
            ],
          ),
        ),
      );
    }

    return Scaffold(
      body: Center(
        child: Stack(
          children: [
            GoogleMap(
              zoomControlsEnabled: false,
              tiltGesturesEnabled: false,
              rotateGesturesEnabled: false,
              mapType: MapType.normal,
              initialCameraPosition: CameraPosition(
                target: myLatLng,
                zoom: 15,
              ),
              onMapCreated: onMapCreated,
              myLocationEnabled: true,
              myLocationButtonEnabled: false,
              circles: Set.from([circle]),
              onCameraIdle: () async {
                getDistance();
                if(distance < circleRadius) {
                  _controller.reverse();
                }
              },
              onCameraMoveStarted: () {
                _controller.forward();
              },
              onCameraMove: (CameraPosition cp){
                center = cp.target;
              },
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                margin: EdgeInsets.only(bottom: 20),
                child: AnimatedBuilder(
                  animation: _controller,
                  builder: (BuildContext context, Widget?child) {
                    return ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _buttonColorAnimation.value
                      ),
                      onPressed: () {
                        getDistance();
                        if(distance < circleRadius) {
                          Navigator.pop(context, center);
                        }
                      },
                      child: Text('위치 설정',
                      style: TextStyle(
                        color: Colors.white
                      ),),
                    );
                  }
                ),
              ),
            ),
            customMyLocation(mapController, context),
            IgnorePointer(
              child: Center(
                child: SlideTransition(
                  position: _offsetAnimation,
                  child: Container(
                    margin: EdgeInsets.only(bottom: 28),
                    child: AnimatedBuilder(
                      animation:_controller,
                      builder: (BuildContext context, Widget? child) {
                        return Icon(
                            Icons.location_on,
                            color: _markerColorAnimation.value,
                            size: 35
                        );
                      }
                    ),
                  ),
                ),
              ),
            ),
            IgnorePointer(
              child: Center(
                child: Container(
                  child: ColorFiltered(
                    colorFilter: ColorFilter.mode(
                      Colors.transparent.withOpacity(0.4),
                      BlendMode.srcIn,
                    ),
                    child: Image.asset('images/shadow.png'),
                  ),
                  width: 25,
                  height: 50,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}