import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationPicker extends StatefulWidget {
  final void Function(LatLng) onLocationSelected;

  const LocationPicker({Key? key, required this.onLocationSelected}) : super(key: key);

  @override
  _LocationPickerState createState() => _LocationPickerState();
}

class _LocationPickerState extends State<LocationPicker> {
  LatLng selectedLocation = LatLng(0, 0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('위치 선택'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('선택한 위치: ${selectedLocation.latitude}, ${selectedLocation.longitude}'),
            ElevatedButton(
              onPressed: () {
                // 위치 설정 완료
                widget.onLocationSelected(selectedLocation);
                Navigator.pop(context);
              },
              child: Text('선택 완료'),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // 위치 설정
          selectLocation();
        },
        child: Icon(Icons.add_location),
      ),
    );
  }

  void selectLocation() async {
    // 위치 선택 로직 구현
    // GoogleMap을 사용하여 위치를 선택하고, 해당 좌표를 selectedLocation에 업데이트

    // 가상의 좌표값을 설정하는 예시 코드
    final LatLng newLocation = LatLng(37.123, -122.456);
    setState(() {
      selectedLocation = newLocation;
    });
  }
}
