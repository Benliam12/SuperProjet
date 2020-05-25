/*============================================
Auteur:       Ariel Fontau
Laboratoire:  Projet intégrateur de SIM
Nom fichier:  home.dart
Date:         2020-03-01
But:          Crée le contexte de l'application
==============================================*/
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'HomeContext.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: Colors.black, body: new HomeContent());
  }
}
