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

class _SetLocationState extends State<_SetLocation> with SingleTickerProviderStateMixin {
  late Circle circle;
  late LatLng myLatLng;
  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;
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
          radius: 300,
          strokeColor: Colors.blue,
          strokeWidth: 2,
        );
        isLoading = false;
      });
    });
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
                  _controller.reverse();
                  // Handle onCameraIdle event
                },
                onCameraMoveStarted: () {
                  _controller.forward();
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
              IgnorePointer(
                child: Center(
                  child: AnimatedPositioned(
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeInOut,
                    bottom: 35,
                    child: SlideTransition(
                      position: _offsetAnimation,
                      child: Container(
                        margin: EdgeInsets.only(bottom: 35),
                        child: Image.asset('images/marker.png'),
                        width: 25,
                        height: 50,
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