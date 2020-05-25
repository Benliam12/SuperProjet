/*
Auteur du fichier : Ariel
*/
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Star extends StatelessWidget {
  Widget build(BuildContext context) {
    return new Container(
      width: 10,
      height: 10,
      decoration: new BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
      ),
    );
  }
}
