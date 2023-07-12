import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../Widget/customMyLocation.dart';

class SetLocation extends StatefulWidget {

  const SetLocation({
    Key? key}) : super(key: key);

  @override
  State<SetLocation> createState() => _SetLocationState();
}

class _SetLocationState extends State<SetLocation> with SingleTickerProviderStateMixin {
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
      if(mounted){
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
    };
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

    double bottomPadding = MediaQuery.of(context).padding.bottom;

    return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(bottom: bottomPadding),
        child: Center(
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
      ),
    );
  }
}