import 'package:flutter/material.dart';

import 'Screen/home_screen.dart';
import 'Screen/bottom_navigator_bar.dart';

void main() {
  runApp(
      MaterialApp(
        theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
                seedColor: Colors.red,
                brightness: Brightness.light
            )
        ),
        home: NaviswipeState(),
      )
  );
}