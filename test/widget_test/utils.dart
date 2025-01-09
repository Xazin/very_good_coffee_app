import 'package:flutter/material.dart';

Widget wrapWithMaterialApp(Widget child) {
  return MaterialApp(
    home: Scaffold(
      body: child,
    ),
  );
}
