/*============================================
Auteur:       Ariel Fontau
Laboratoire:  Projet intégrateur de SIM
Nom fichier:  home.dart
Date:         2020-04-21
But:          Peint les étoiles sur l'écran
==============================================*/
import 'dart:ui';

import 'package:flutter/material.dart';

class MyPainter extends CustomPainter {
  Color lineColor;
  Color completeColor;

  int etoileRouge; //Position de l'étoile que l'utilisateur souhaite regarder

  bool isEtoileRouge =
      false; //Booléenne qui permet de savoir si l'utilsateur a rentré une étoile

  Color couleurEtoile; // Couleur des étoiles sur l'écran

  var nomListe = List(); // Array ayant les noms des étoiles
  var completex =
      List(); // Array ayant les valeurs des étoiles sur l'écran en x
  var completey = List(); //Array ayant les valeurs des étoiles sur l'écran en y
  var offsetMilieu; // Crée le point de l'étoile recherchée par l'utilisateur

  String
      text; //String ayant la valeur du temps affiché en bas à droite de l'écran
  String nom =
      ""; //String qui contient le nom de l'étoile souhiaté par l'utilisateur
  double width; //Grosseur de l'étoile
  MyPainter(
      {this.lineColor,
      this.completeColor,
      this.completex,
      this.completey,
      this.width,
      this.text,
      this.nomListe,
      this.nom});
  @override
  void paint(Canvas canvas, Size size) {
    nomListe.length = 46;
    Paint complete = new Paint();
    complete.color = completeColor;
    complete.strokeCap = StrokeCap.round;
    complete.strokeJoin = StrokeJoin.miter;
    complete.style = PaintingStyle.stroke;
    complete.strokeWidth = width;
    Paint milieu = new Paint();
    milieu.color = Colors.red;
    milieu.strokeCap = StrokeCap.round;
    milieu.strokeJoin = StrokeJoin.miter;
    milieu.style = PaintingStyle.stroke;
    milieu.strokeWidth = width;
    size = Size(200, 500);

    List<Offset> offsetList = new List();
    offsetList.length = 46;

    for (int i = 0; i < 46; i++) {
      offsetList[i] = new Offset(completex[i], completey[i]);
      if (nomListe[i].toString().toUpperCase().compareTo(nom.toUpperCase()) ==
          0) {
        etoileRouge = i;
        isEtoileRouge = true;
      }
    }

    TextSpan span =
        new TextSpan(style: new TextStyle(color: Colors.white), text: text);

    final textPainter = TextPainter(
      text: span,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    Offset textOffset = new Offset(size.width - 75, size.height - 75);

    textPainter.paint(canvas, textOffset);

    if (isEtoileRouge == true) {
      offsetMilieu = [
        new Offset(completex[etoileRouge], completey[etoileRouge])
      ];
      canvas.drawPoints(PointMode.points, offsetList, complete);
      canvas.drawPoints(PointMode.points, offsetMilieu, milieu);
    } else {
      canvas.drawPoints(PointMode.points, offsetList, complete);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
