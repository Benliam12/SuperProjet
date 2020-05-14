import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'home.dart';

class Astro extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return new MaterialApp(
      home: new Home(),
    );
  }
}
