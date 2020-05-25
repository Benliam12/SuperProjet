/*============================================
Auteur:       Ariel Fontau
Laboratoire:  Projet intégrateur de SIM
Nom fichier:  main.dart
Date:         2020-03-01
But:          Permet de faire rouler l'application
==============================================*/
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
