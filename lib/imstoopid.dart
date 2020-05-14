import 'package:flutter/material.dart';

class GrosModeles extends StatelessWidget {
  final int id;
  GrosModeles({Key key, this.id}) : super(key: key);
  var nom = [
    "Modèle du 'Plum Pudding' (Thompson)",
    "Modèle de Rutherford (Magnésium)",
    "Orbitales (Krypton, 1s2 2s2 2p6 3s2 3p6 3d10 4s2 4p6)",
  ];
  var nomModele = [
    "assets/plumpudding.gif",
    "assets/rutherford.gif",
    "assets/orbitales.gif",
  ];
  @override
  Widget build(BuildContext context) {
    return (Scaffold(
      appBar: AppBar(
        title: Text(this.nom[id]),
      ),
      body: new Center(child: new Image(image: AssetImage(this.nomModele[id]))),
    ));
  }
}
