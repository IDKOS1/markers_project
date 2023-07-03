import 'package:flutter/material.dart';

import 'Screen/bottom_navigator_bar.dart';

void main() {
  runApp(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
                seedColor: Colors.deepPurple,
                brightness: Brightness.light,
            ),
          useMaterial3: true
        ),
        home: NaviswipeState(),
      )
  );
}