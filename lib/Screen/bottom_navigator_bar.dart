import 'package:flutter/material.dart';
import 'home_screen.dart';

class NaviswipeState extends StatefulWidget {
  const NaviswipeState({Key? key}) : super(key: key);

  @override
  State<NaviswipeState> createState() => _NaviswipeStateState();
}

class _NaviswipeStateState extends State<NaviswipeState> {
  int current_index = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: BottomNavigationBar(
            currentIndex: current_index,
            onTap: (index){
              print('index test : ${index}');

              //상태 변화 감지
              setState(() {
                current_index = index;
              });
            },
            items: [
              BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  label: 'home'
              ),
              BottomNavigationBarItem(
                  icon: Icon(Icons.music_note),
                  label: 'Music'
              ),
              BottomNavigationBarItem(
                  icon: Icon(Icons.apps),
                  label: 'Apps'
              ),
              BottomNavigationBarItem(
                  icon: Icon(Icons.settings),
                  label: 'settings'
              ),
            ],
            // 선택된 index 색상
            selectedItemColor: Colors.cyan[600],
            // 미선택된 index 색상
            unselectedItemColor: Colors.grey,
            showUnselectedLabels: true,
            type: BottomNavigationBarType.shifting
          //BottomNavigationBarType.shifting : selected 된 item 확대
        ),
        body: Center(
          child: body_item.elementAt(current_index),
        )
    );
  }

  List body_item = [
    HomeScreen(),
    Text("music"),
    Text("apps"),
    Text("settings")
  ];
}