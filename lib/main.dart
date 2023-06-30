import 'package:flutter/material.dart';

import 'Screen/home_screen.dart';
import 'Screen/bottom_navigator_bar.dart';

void main() {
  runApp(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
                seedColor: Colors.blue,
                brightness: Brightness.light,
            ),
          useMaterial3: true
        ),
        home: NaviswipeState(),
      )
  );
}