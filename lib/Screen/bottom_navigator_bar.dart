import 'package:flutter/material.dart';
import 'package:markers_project/Screen/message/message_screen.dart';
import 'package:markers_project/Screen/publish/publish.dart';
import 'home/home_screen.dart';

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
            items: const [
              BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  label: 'home'
              ),
              BottomNavigationBarItem(
                  icon: Icon(Icons.message),
                  label: 'message'
              ),
              BottomNavigationBarItem(
                  icon: Icon(Icons.add),
                  label: 'add'
              ),
              BottomNavigationBarItem(
                  icon: Icon(Icons.notifications),
                  label: 'notice'
              ),

              BottomNavigationBarItem(
                  icon: Icon(Icons.person),
                  label: 'profile'
              ),
            ],
            // 선택된 index 색상
            selectedItemColor: Theme.of(context).colorScheme.primary,
            // 미선택된 index 색상
            unselectedItemColor: Colors.grey,
            showUnselectedLabels: true,
            type: BottomNavigationBarType.shifting
          //BottomNavigationBarType.shifting : selected 된 item 확대
        ),
        body: Center(
          child: body_item[current_index],
        )
    );
  }

  List body_item = [
    HomeScreen(),
    MessageScreen(),
    Publish(),
    Text("message page"),
    Text("settings")
  ];
}