import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:markers_project/Widget/TagWidget.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'set_Location.dart';

class Publish extends StatefulWidget {
  const Publish({Key? key}) : super(key: key);

  @override
  State<Publish> createState() => _PublishState();
}

class _PublishState extends State<Publish> {
  String titleValue = '';
  String contentsValue = '';
  String setTag = '';
  LatLng setLocation = LatLng(0,0);
  GoogleMapController? mapController;
  bool isLocationSet = false;
  bool showSpinner = false;
  bool isUpload = false;
  Color locationColor = Colors.grey;
  final _formKey = GlobalKey<FormState>();

  void _tryValidation() {
    final isValid = _formKey.currentState!.validate();
    if (isValid) {
      _formKey.currentState!.save();
    }
  }

  final _titleController = TextEditingController();
  final _contentController = TextEditingController();

  void _upload() {
    FocusScope.of(context).unfocus();
    FirebaseFirestore.instance.collection('markers').add({
      'tag' : setTag,
      'title' : titleValue,
      'content': contentsValue,
      'location' : GeoPoint(setLocation.latitude, setLocation.longitude),
      'time' : Timestamp.now(),
      //'userID' : user!.uid,
      //'userName' : userData.data()!['userName'],
    });
    _titleController.clear();
    _contentController.clear();
  }
  
  @override
  Widget build(BuildContext context) {
    if(setLocation != LatLng(0,0)){
      isLocationSet = true;
    }
    if(isLocationSet){
      locationColor = Theme.of(context).colorScheme.primary;
    } else {
      locationColor = Colors.grey;
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
          body: ModalProgressHUD(
            inAsyncCall: showSpinner,
            child: GestureDetector(
              onTap: () {
                FocusScope.of(context).unfocus();
              },
              child: Column(
                children: [
                  SizedBox(height: 20),
                  TagList(
                    onTagSelected: (tag) {
                      setState(() {
                        setTag = tag;
                      });
                      print(setTag);
                    },
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                      child: Container(
                        child: Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              Column(
                                children: [
                                  TextFormField(
                                      key: ValueKey(1),
                                      controller: _titleController,
                                    decoration: InputDecoration(
                                        hintText: '제목을 입력하세요',
                                      contentPadding: EdgeInsets.all(10)
                                    ),
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return '제목을 입력해 주세요';
                                      }
                                      return null;
                                    },
                                    onSaved: (value) {
                                      titleValue = value!;
                                    },
                                    onChanged: (value) {
                                      titleValue = value;
                                    },

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
                                            Text('설정위치 위도:${setLocation.latitude} 경도:${setLocation.longitude}',
                                              style: TextStyle(
                                                  color: locationColor
                                              ),
                                            ),
                                          ],
                                        )
                                    ),
                                  ),
                                  SizedBox(height: 30,),
                                  TextFormField(
                                    maxLines: null,
                                    keyboardType: TextInputType.multiline,
                                    key: ValueKey(2),
                                      controller: _contentController,
                                    decoration: InputDecoration(
                                        hintText: '내용을 입력하세요',
                                    ),
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return '내용을 입력해 주세요';
                                        }
                                        return null;
                                      },
                                    onSaved: (value) {
                                      contentsValue = value!;
                                    },
                                    onChanged: (value) {
                                      contentsValue = value;
                                    },
                                  )
                                ],
                              ),
                              Spacer(),
                              Align(
                                alignment: Alignment.bottomCenter,
                                child: Padding(
                                  padding: EdgeInsets.only(bottom: 20),
                                  child: ElevatedButton(
                                    onPressed: () {
                                      if(!isLocationSet) {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(
                                              content: Text('위치를 지정해주세요'),
                                              backgroundColor: Colors.blue,
                                            ),
                                        );
                                        return;
                                      }

                                      _tryValidation();

                                      if(titleValue != '' && contentsValue != '' && isLocationSet) {
                                        _upload();
                                        setState(() {
                                          isUpload = true;
                                        });
                                      } else {
                                        return;
                                      }
                                      if(isUpload) {
                                        Fluttertoast.showToast(
                                            msg: '업로드 완료!',
                                            gravity: ToastGravity.BOTTOM,
                                            backgroundColor: Colors.grey[700],
                                            fontSize: 20.0,
                                            textColor: Colors.white,
                                            toastLength: Toast.LENGTH_SHORT);
                                        setState(() {
                                          isUpload = false;
                                          isLocationSet = false;
                                          setLocation = LatLng(0,0);
                                          titleValue = '';
                                          contentsValue = '';
                                        });
                                      }
                                    },
                                    child: Text('등록하기'),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
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
        setLocation = LatLng(roundedLatitude, roundedLongitude);
      });
    }
  }

  onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }
}



