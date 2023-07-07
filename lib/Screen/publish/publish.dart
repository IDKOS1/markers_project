import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:markers_project/Widget/TagWidget.dart';
import 'Set Location.dart';

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
        builder: (context) => SetLocation(),
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



