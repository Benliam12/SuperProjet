/*============================================
Auteur:       Ariel Fontau
Laboratoire:  Projet intégrateur de SIM
Nom fichier:  home.dart
Date:         2020-03-19
But:          Instancie les valeurs de base de l'application
==============================================*/
import 'dart:async';

import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:login_app/chatbot.dart';
import 'package:login_app/main.dart';

import 'MyPainter.dart';

class HomeContent extends StatefulWidget {
  @override
  _HomeContentState createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent>
    with TickerProviderStateMixin {
  TextEditingController nouveauTemps =
      new TextEditingController(); //Prend la réponse de l'utilisateur sur le temps où il sohaite regarder les étoiles
  TextEditingController etoile =
      new TextEditingController(); //Prend la réponse de l'utilisateur sur le nom de l'étoile que souhaite regarder l'utilisateur

  bool bonneHeure = false; // Booléenne qui permet de changer le temps affiché

  int facteurMultiplicatif =
      9; // Facteur multiplicatif permettant d'afficher les étoiles avec un plus grand espace entre elles
  int textX; // Texte qui affiche la rapidité de progression des étoiles

  double
      fractionDeTour; //Permet de savoir le décalage créé par le temps entre l'an 2000 et le temps sohaité
  double percentage = 0.0; // Valeur de l'angle créé par le décalage du temps
  double newPercentage =
      0; // Valeur de l'angle créé par le décalage du temps incrémentée
  double nbDeFoisBouton =
      0; //Nombre de fois que le bouton plus et moins on été appuyés
  double rateSpeed = 1; //rapidité de progression des étoiles

  var valeurBaseX =
      List(); //Array ayant les valeurs d'ascension droite en degrés
  var valeurBaseY = List(); //Array ayant les valeurs de déclinaisons en degrés
  var positionXEtoile =
      List(); //Position brute de l'étoile en x selon l'algorithme 2
  var positionYEtoile =
      List(); //Position brute de l'étoile en y selon l'algorithme 2
  var positionXCanevas = List(); //Position sur l'écran de l'étoile en x
  var positionYCanevas = List(); //Position sur l'écran de l'étoile en y
  var nomEtoile = List(); //Array ayant le nom des étoiles
  var rayon = List(); //Array des rayons pour chaque étoile
  DateTime now =
      DateTime.now(); //Valeur du temps auquel on souhaite regarder les étoiles
  DateTime j2000 = DateTime.parse(
      "2000-01-01 00:00:00"); // Valeur qui contient le temps auquel ont été prises les valeurs des étoile
  AnimationController percentageAnimationController;
  String _timeString; // String qui contient le temps affiché en bas à droite
  String xFois = "";

  Timer t;
  @override
  void dispose() {
    t.cancel();
    super.dispose();
  }

  //Instancie le valeur de base du programme
  @override
  void initState() {
    super.initState();
    int difference = j2000.difference(now).inSeconds;
    fractionDeTour = difference / (1 / ((1 / 86164) + (1 / 31970760)));
    fractionDeTour = fractionDeTour - fractionDeTour.floor();
    newPercentage = fractionDeTour * 2 * pi;

    valeurBaseX.length = 46;
    valeurBaseY.length = 46;
    positionXEtoile.length = 46;
    positionYEtoile.length = 46;
    positionXCanevas.length = 46;
    positionYCanevas.length = 46;
    rayon.length = 46;
    nomEtoile.length = 46;
    textX = rateSpeed.toInt();

    //Arcturus
    valeurBaseX[0] = 213.9147875;
    valeurBaseY[0] = 19.18152833;
    nomEtoile[0] = "Arcturus";

    //Véga
    valeurBaseX[1] = 279.2348458;
    valeurBaseY[1] = 38.78381833;
    nomEtoile[1] = "Vega";

    //Capella
    valeurBaseX[2] = 79.172375;
    valeurBaseY[2] = 45.99780167;
    nomEtoile[2] = "Capella";

    //Procyon
    valeurBaseX[3] = 114.825175;
    valeurBaseY[3] = 5.224535;
    nomEtoile[3] = "Procyon";

    //Beltegeuse
    valeurBaseX[4] = 88.79295;
    valeurBaseY[4] = 7.407066666;
    nomEtoile[4] = "Beltegeuse";

    //Altair
    valeurBaseX[5] = 297.6960667;
    valeurBaseY[5] = 8.868491667;
    nomEtoile[5] = "Altair";

    //Aldébaran
    valeurBaseX[6] = 68.9801875;
    valeurBaseY[6] = 16.5092833;
    nomEtoile[6] = "Aldébaran";

    //Pollux
    valeurBaseX[7] = 116.3286458;
    valeurBaseY[7] = 28.02618;
    nomEtoile[7] = "Pollux";

    //Deneb
    valeurBaseX[8] = 310.3579792;
    valeurBaseY[8] = 45.28033833;
    nomEtoile[8] = "Deneb";

    //Régulus
    valeurBaseX[9] = 152.09285;
    valeurBaseY[9] = 11.96720833;
    nomEtoile[9] = "Regulus";

    //Castor
    valeurBaseX[10] = 113.6493417;
    valeurBaseY[10] = 31.88817;
    nomEtoile[10] = "Castor";

    //Bellatrix
    valeurBaseX[11] = 81.28275833;
    valeurBaseY[11] = 6.349695;
    nomEtoile[11] = "Bellatrix";

    //El Nath
    valeurBaseX[12] = 81.57298333;
    valeurBaseY[12] = 28.60737167;
    nomEtoile[12] = "El Nath";

    //Alioth
    valeurBaseX[13] = 193.507375;
    valeurBaseY[13] = 55.959816667;
    nomEtoile[13] = "Alioth";

    //Mirfak
    valeurBaseX[14] = 51.080725;
    valeurBaseY[14] = 49.86116833;
    nomEtoile[14] = "Mirfak";

    //Dubhe
    valeurBaseX[15] = 165.9318;
    valeurBaseY[15] = 61.75101833;
    nomEtoile[15] = "Dubhe";

    //Alkaid
    valeurBaseX[16] = 206.885075;
    valeurBaseY[16] = 49.31325833;
    nomEtoile[16] = "Alkaid";

    //Menkalinan
    valeurBaseX[17] = 89.88214167;
    valeurBaseY[17] = 44.944743167;
    nomEtoile[17] = "Menkalinan";

    //Alhena
    valeurBaseX[18] = 99.42791667;
    valeurBaseY[18] = 16.39922167;
    nomEtoile[18] = "Alhena";

    //Polaire
    valeurBaseX[19] = 37.76373667;
    valeurBaseY[19] = 89.264105;
    nomEtoile[19] = "Polaire";

    //Hamal
    valeurBaseX[20] = 37.763736667;
    valeurBaseY[20] = 23.46235833;
    nomEtoile[20] = "Hamal";

    //Algiebia
    valeurBaseX[21] = 154.993175;
    valeurBaseY[21] = 19.8441485;
    nomEtoile[21] = "Algiebia";

    //Sirrah
    valeurBaseX[22] = 2.096975;
    valeurBaseY[22] = 29.09036;
    nomEtoile[22] = "Sirrah";

    //Kochab
    valeurBaseX[23] = 222.6763042;
    valeurBaseY[23] = 74.15551;
    nomEtoile[23] = "Kochab";

    //Mirach
    valeurBaseX[24] = 17.43310833;
    valeurBaseY[24] = 35.62050833;
    nomEtoile[24] = "Mirach";

    //Rasalhague
    valeurBaseX[25] = 263.733675;
    valeurBaseY[25] = 12.55993667;
    nomEtoile[25] = "Rasalhague";

    //Algol
    valeurBaseX[26] = 47.0422125;
    valeurBaseY[26] = 40.573389;
    nomEtoile[26] = "Algol";

    //Almach
    valeurBaseX[27] = 30.974825;
    valeurBaseY[27] = 42.32970333;
    nomEtoile[27] = "Almach";

    //Denebola
    valeurBaseX[28] = 177.264675;
    valeurBaseY[28] = 14.57201;
    nomEtoile[28] = "Denebola";

    //Cih
    valeurBaseX[29] = 14.01181583;
    valeurBaseY[29] = 60.71673833;
    nomEtoile[29] = "Cih";

    //Alphecca
    valeurBaseX[30] = 233.6720083;
    valeurBaseY[30] = 26.71465333;
    nomEtoile[30] = "Alphecca";

    //Mizar
    valeurBaseX[31] = 200.9815208;
    valeurBaseY[31] = 54.925355167;
    nomEtoile[31] = "Mizar";

    //Sadir
    valeurBaseX[32] = 305.5570917;
    valeurBaseY[32] = 40.25668;
    nomEtoile[32] = "Sadir";

    //Eltanin
    valeurBaseX[33] = 269.1515333;
    valeurBaseY[33] = 51.48885;
    nomEtoile[33] = "Eltanin";

    //Shedar
    valeurBaseX[34] = 10.126875;
    valeurBaseY[34] = 56.537316666;
    nomEtoile[34] = "Shedar";

    //Caph
    valeurBaseX[35] = 2.294970833;
    valeurBaseY[35] = 59.1497;
    nomEtoile[35] = "Caph";

    //Merak
    valeurBaseX[36] = 165.4603833;
    valeurBaseY[36] = 56.38294167;
    nomEtoile[36] = "Merak";

    //Izar
    valeurBaseX[37] = 221.2467167;
    valeurBaseY[37] = 27.07423333;
    nomEtoile[37] = "Izar";

    //Enif
    valeurBaseX[38] = 326.0465042;
    valeurBaseY[38] = 9.875011667;
    nomEtoile[38] = "Enif";

    //Phecda
    valeurBaseX[39] = 178.4577792;
    valeurBaseY[39] = 53.694765;
    nomEtoile[39] = "Phecda";

    //Scheat
    valeurBaseX[40] = 345.943667;
    valeurBaseY[40] = 28.08285;
    nomEtoile[40] = "Scheat";

    //Alderamin
    valeurBaseX[41] = 419.645025;
    valeurBaseY[41] = 62.58559333;
    nomEtoile[41] = "Alderamin";

    //Gienah
    valeurBaseX[42] = 311.5530333;
    valeurBaseY[42] = 33.97040167;
    nomEtoile[42] = "Gienah";

    //Markab
    valeurBaseX[43] = 376.19025;
    valeurBaseY[43] = 15.20524667;
    nomEtoile[43] = "Markab";

    //Menkab
    valeurBaseX[44] = 45.56987917;
    valeurBaseY[44] = 4.0897;
    nomEtoile[44] = "Menkab";

    //Zosma
    valeurBaseX[45] = 168.5271542;
    valeurBaseY[45] = 20.52365833;
    nomEtoile[45] = "Zosma";

    for (int i = 0; i < 46; i++) {
      positionXEtoile[i] = (facteurMultiplicatif *
          (-2) *
          ((sin((pi * valeurBaseY[i] / 180)) * cos(pi / 2)) -
              (cos((pi * valeurBaseY[i] / 180)) *
                  sin(pi / 2) *
                  cos((pi * valeurBaseX[i] / 180)))) /
          ((sin((pi * valeurBaseY[i] / 180)) * sin(pi / 2)) +
              (cos((pi * valeurBaseY[i] / 180)) *
                  cos(pi / 2) *
                  cos((pi * valeurBaseX[i] / 180))) +
              1));

      positionYEtoile[i] = (facteurMultiplicatif *
          (2 *
              cos((pi * valeurBaseY[i] / 180)) *
              sin((pi * valeurBaseX[i] / 180))) /
          ((sin((pi * valeurBaseY[i] / 180)) * sin(pi / 2)) +
              (cos((pi * valeurBaseY[i] / 180)) *
                  cos(pi / 2) *
                  cos((pi * valeurBaseX[i] / 180))) +
              1));

      rayon[i] = sqrt(pow(positionXEtoile[i], 2) + pow(positionYEtoile[i], 2));
    }
    for (int i = 0; i < 46; i++) {
      if (positionXEtoile[i] < 0) {
        positionXCanevas[i] = 125 +
            (facteurMultiplicatif *
                rayon[i] *
                cos(pi +
                    newPercentage +
                    atan(positionYEtoile[i] / positionXEtoile[i])));
        positionYCanevas[i] = 250 +
            (facteurMultiplicatif *
                rayon[i] *
                sin(pi +
                    newPercentage +
                    atan(positionYEtoile[i] / positionXEtoile[i])));
      } else {
        positionXCanevas[i] = 125 +
            (facteurMultiplicatif *
                rayon[i] *
                cos(newPercentage +
                    atan(positionYEtoile[i] / positionXEtoile[i])));
        positionYCanevas[i] = 250 +
            (facteurMultiplicatif *
                rayon[i] *
                sin(newPercentage +
                    atan(positionYEtoile[i] / positionXEtoile[i])));
      }
    }

    _timeString = now.toString();

//Modifie le temps de l'horloge affichée en bas à droite de l'écran
    Timer.periodic(Duration(seconds: 1), (Timer t) {
      _getCurrentTime();
      this.t = t;
    });
    setState(() {
      percentage = 0.0;
    });
    percentageAnimationController = new AnimationController(
        vsync: this, duration: new Duration(milliseconds: 1000))
      ..addListener(() {
        setState(() {
          percentage = lerpDouble(
              percentage, newPercentage, percentageAnimationController.value);
        });
      });
  }

//UI de l'application
  @override
  Widget build(BuildContext context) {
    final scaffold = Scaffold.of(context);
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => MyApp()));
            },
          ),
          backgroundColor: Colors.black,
          title: Text("Astronomie"),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.live_help),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => ChatBot()));
              },
            )
          ],
        ),
        body: new Container(
            color: Colors.black,
            height: 1000,
            width: 500,
            child: SingleChildScrollView(
                child: new Column(children: [
              new Row(mainAxisSize: MainAxisSize.max, children: [
                new Container(
                  height: 500,
                  width: 50,
                  child: new Column(children: [
                    //Bouton avec le signe plus qui permet d'augmenter le rythme de progression des étoiles

                    new IconButton(
                      icon: Icon(Icons.add),
                      iconSize: 20.0,
                      color: Colors.white,
                      tooltip: 'Increase value of star rate',
                      onPressed: () {
                        setState(() {
                          if (nbDeFoisBouton < 4) {
                            nbDeFoisBouton++;
                            rateSpeed = pow(10, nbDeFoisBouton);
                            textX = rateSpeed.toInt();
                          } else {
                            scaffold.showSnackBar(SnackBar(
                                duration: const Duration(seconds: 1),
                                content: const Text(
                                    'Le nombre maximum est atteint ')));
                          }
                        });
                      },
                    ),
                    new Text(
                      //Texte indiquant le rythme de progression des étoiles
                      "x$textX",
                      style: TextStyle(color: Colors.white),
                      textDirection: TextDirection.ltr,
                    ),
                    //Bouton avec le signe moins permettant de diminuer le rythme de progression des étoiles
                    new IconButton(
                      icon: Icon(Icons.minimize),
                      iconSize: 20.0,
                      color: Colors.white,
                      tooltip: 'Decrease value of star rate',
                      onPressed: () {
                        setState(() {
                          if (nbDeFoisBouton > 0) {
                            nbDeFoisBouton--;
                            rateSpeed = pow(10, nbDeFoisBouton);
                            textX = rateSpeed.toInt();
                          } else {
                            scaffold.showSnackBar(SnackBar(
                                duration: const Duration(seconds: 1),
                                content: const Text(
                                    'Le nombre minimum est atteint')));
                          }
                        });
                      },
                    ),
                  ]),
                ),
                new Container(
                  height: 500,
                  //Permet de montrer les étoiles
                  child: CustomPaint(
                    foregroundPainter: new MyPainter(
                        lineColor: Colors.black,
                        completeColor: Colors.white,
                        completex: positionXCanevas,
                        completey: positionYCanevas,
                        width: 8.0,
                        text: _timeString,
                        nomListe: nomEtoile,
                        nom: etoile.text),
                  ),
                ),
              ]),
              //Texte servant à demander quelle date l'utilisateur souhaite rentrer
              new Text(
                "Entrer la date désirée",
                textAlign: TextAlign.left,
                style: TextStyle(color: Colors.white),
                textDirection: TextDirection.ltr,
              ),
              // Prend la date de l'utilisateur
              new TextField(
                  controller: nouveauTemps,
                  style:
                      TextStyle(color: Colors.white, height: 1.0, fontSize: 12),
                  decoration: InputDecoration(
                      enabledBorder: new OutlineInputBorder(
                          borderSide: new BorderSide(color: Colors.white)),
                      hintText: "AAAA-MM-JJ HH:MM:SS",
                      hintStyle: TextStyle(color: Colors.white))),
              //Demande quelle étoile l'utilisateur veut entrer
              new Text(
                "Entrer le nom de l'étoile",
                textAlign: TextAlign.left,
                style: TextStyle(color: Colors.white),
                textDirection: TextDirection.ltr,
              ),
              new TextField(
                  controller: etoile,
                  style:
                      TextStyle(color: Colors.white, height: 1.0, fontSize: 12),
                  decoration: InputDecoration(
                      enabledBorder: new OutlineInputBorder(
                          borderSide: new BorderSide(color: Colors.white)),
                      hintText: "Nom Etoile",
                      hintStyle: TextStyle(color: Colors.white))),
              new IconButton(
                  icon: Icon(Icons.refresh),
                  iconSize: 20.0,
                  color: Colors.white,
                  //tooltip: 'Les valeurs sont réinitialisées',
                  onPressed: () {
                    scaffold.showSnackBar(SnackBar(
                        duration: const Duration(seconds: 1),
                        content:
                            const Text('Les valeurs sont réinitialisées')));

                    setState(() {
                      now = DateTime.now();
                      nouveauTemps.clear();
                      etoile.clear();
                    });
                  })
            ]))));
  }

//Fonction qui incrémente le temps
  void _getCurrentTime() {
    setState(() {
      if (nouveauTemps.text.isNotEmpty == true && bonneHeure == false) {
        try {
          now = DateTime.parse(nouveauTemps.text);
          int difference = j2000.difference(now).inSeconds;
          fractionDeTour = difference / (1 / ((1 / 86164) + (1 / 31970760)));
          fractionDeTour = fractionDeTour - fractionDeTour.floor();
          newPercentage = fractionDeTour * 2 * pi;
          bonneHeure = true;
        } catch (e) {}
      }
      var duration = new Duration(seconds: rateSpeed.toInt());
      now = now.add(duration);
      _timeString = now.toString();

      for (int i = 0; i < 46; i++) {
        if (positionXEtoile[i] < 0) {
          positionXCanevas[i] = 125 +
              (facteurMultiplicatif *
                  rayon[i] *
                  cos(pi +
                      newPercentage +
                      atan(positionYEtoile[i] / positionXEtoile[i])));
          positionYCanevas[i] = 250 +
              (facteurMultiplicatif *
                  rayon[i] *
                  sin(pi +
                      newPercentage +
                      atan(positionYEtoile[i] / positionXEtoile[i])));
        } else {
          positionXCanevas[i] = 125 +
              (facteurMultiplicatif *
                  rayon[i] *
                  cos(newPercentage +
                      atan(positionYEtoile[i] / positionXEtoile[i])));
          positionYCanevas[i] = 250 +
              (facteurMultiplicatif *
                  rayon[i] *
                  sin(newPercentage +
                      atan(positionYEtoile[i] / positionXEtoile[i])));
        }
      }

      newPercentage += rateSpeed * ((2 * pi / 86164) + (2 * pi / 31970760));
    });
  }
}
