import 'dart:io';

import 'package:login_app/carte.dart';
import 'package:login_app/chatbot.dart';
import 'package:login_app/exploration.dart';
import 'package:login_app/main.dart';
import 'package:login_app/paquet.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';

import 'quizz.dart';
import 'ajout.dart';

class FlashCard extends StatefulWidget {
  final Paquet paquetFini;
  int index;

  FlashCard({this.paquetFini, this.index});

  @override
  State<StatefulWidget> createState() {
    return _FlashCardState(paquetFini: paquetFini, index: index);
  }
}

class _FlashCardState extends State<FlashCard> {
  int numberOfDeck = 0;
  List<DynamicDeck> listDynamic = [];

  bool modeExploration = false;

  List<Paquet> paquets = [];
  List<dynamic> paquetADezip = [];

  Paquet paquetFini;
  int index;

  Directory dir;
  File jsonFile;
  String fileName = "listePaquet.json";
  bool fileExists = false;

  _FlashCardState({this.paquetFini, this.index});
  bool once = false;

  addDynamic() {
    for (int i = 0; i < paquets.length; i++) {
      listDynamic.add(DynamicDeck(
        removeDynamic,
        paquets[i],
        index: numberOfDeck,
        modeExploration: modeExploration,
      ));
      numberOfDeck++;
    }
  }

  updateDynamic() {
    for (int i = 0; i < paquets.length; i++) {
      listDynamic[i].modeExploration = modeExploration;
    }
    setState(() {});
  }

  removeDynamic(index) {
    setState(() {
      listDynamic.remove(index);
      removeFromFile(index);
      numberOfDeck--;
    });
  }

  List<Paquet> getJson() {
    List<Paquet> paquetsTemp = [];
    if (jsonFile.existsSync()) {
      Map<String, dynamic> collection =
          json.decode(jsonFile.readAsStringSync());

      for (int i = 0; i < collection.length; i++) {
        List<Carte> cartes = [];

        for (int j = 0; j < collection["$i"]["listCartes"].length; j++) {
          cartes.add(Carte.fromJson(collection["$i"]["listCartes"][j]));
        }

        paquetsTemp.add(Paquet.fromJson(collection["$i"], cartes));
      }
    }

    return paquetsTemp;
  }

  Future removeFromFile(DynamicDeck index) async {
    Map<String, dynamic> listARemettre = Map();
    List<Paquet> vraiPaquet = getJson();

    if (vraiPaquet.length == 1) {
      vraiPaquet.removeAt(0);
    } else {
      vraiPaquet.removeAt(index.index);
    }

    print("Writing to file");

    if (jsonFile.existsSync()) {
      print("File exists");

      for (int i = 0; i < vraiPaquet.length; i++) {
        Map<String, dynamic> paquetTemp = Map();
        paquetTemp = {"$i": vraiPaquet[i].toJson()};

        listARemettre.addAll(paquetTemp);
      }
      jsonFile.writeAsStringSync(json.encode(listARemettre));
    }
  }

  Future load(Directory directory) async {
    jsonFile = new File(directory.path + "/" + fileName);
    if (jsonFile.existsSync()) {
      setState(() {
        paquets = getJson();
        addDynamic();
      });
    }
    if (index != null) {
      updatePaquet(index);
    }
  }

  @override
  void initState() {
    print("object");
    super.initState();
    getApplicationDocumentsDirectory().then((Directory directory) {
      load(directory);
    });
  }

  void updatePaquet(int index) {
    Map<String, dynamic> listARemettre = Map();
    List<Paquet> vraiPaquets = getJson();
    vraiPaquets[index].nbFoisFait++;

    for (int i = 0; i < vraiPaquets.length; i++) {
      Map<String, dynamic> paquetTemp = Map();
      paquetTemp = {"$i": vraiPaquets[i].toJson()};

      listARemettre.addAll(paquetTemp);
    }
    jsonFile.writeAsStringSync(json.encode(listARemettre));
  }

  @override
  Widget build(BuildContext context) {
    // listDynamic.add(paquet);
    return MaterialApp(
        home: Builder(
      builder: (context) => Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => MyApp()));
              },
            ),
            title: Text('FlashCard'),
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.live_help),
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => ChatBot()));
                },
              ),
            ],
          ),
          body: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Expanded(
                      flex: 5,
                      child: Card(
                        margin: EdgeInsets.all(10),
                        color: Colors.green,
                        child: InkWell(
                          onTap: () {
                            Navigator.of(context).push(new MaterialPageRoute(
                                builder: (_) => new AjoutDart()));

                            // function(context);
                            //addDynamic();
                          },
                          child: Container(
                            height: 100,
                            alignment: Alignment.center,
                            child: Text("Ajouter"),
                          ),
                        ),
                      )),
                  Expanded(
                    flex: 5,
                    child: Card(
                      margin: EdgeInsets.all(10),
                      color: Colors.blue,
                      child: InkWell(
                        onTap: () {
                          print("Tapped");

                          setState(() {
                            if (modeExploration == false) {
                              modeExploration = true;
                              updateDynamic();
                            } else {
                              modeExploration = false;
                              updateDynamic();
                            }
                          });
                          if (modeExploration == true) {
                            return showDialog(
                                context: this.context,
                                builder: (context) => AlertDialog(
                                        title: Text(
                                            "La mode exploration est désormais activé "),
                                        actions: <Widget>[
                                          FlatButton(
                                              child: Text("ok"),
                                              onPressed: () {
                                                Navigator.pop(context);
                                              })
                                        ]));
                          } else {
                            return showDialog(
                                context: this.context,
                                builder: (context) => AlertDialog(
                                        title: Text(
                                            "La mode exploration est désormais désactivé "),
                                        actions: <Widget>[
                                          FlatButton(
                                              child: Text("ok"),
                                              onPressed: () {
                                                Navigator.pop(context);
                                              })
                                        ]));
                          }
                        },
                        child: Container(
                          height: 100,
                          alignment: Alignment.center,
                          child: Text("Mode exploration"),
                        ),
                      ),
                    ),
                  )
                ],
              ),
              Expanded(
                  child: ListView.builder(
                itemCount: listDynamic.length,
                itemBuilder: (context, index) => listDynamic[index],
              ))
            ],
          )),
    ));
  }
}

class DynamicDeck extends StatelessWidget {
  final int index;
  final Function(DynamicDeck) indexRemover;
  final Paquet paquet;
  bool modeExploration;

  DynamicDeck(this.indexRemover, this.paquet,
      {Key key, this.index, this.modeExploration})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
        //color: Colors.white54,
        color: Colors.white54,
        child: Container(
          height: 100,
          child: Row(
            children: <Widget>[
              Expanded(
                flex: 5,
                child: InkWell(
                  onTap: () {
                    if (modeExploration == false) {
                      Navigator.of(context).push(new MaterialPageRoute(
                          builder: (_) => new QuizzDart(
                                paquet: paquet,
                                index: index,
                              )));
                    } else {
                      Navigator.of(context).push(new MaterialPageRoute(
                          builder: (_) => new Exploration(paquet: paquet)));
                    }
                  },
                  child: Column(
                    children: <Widget>[
                      Container(
                          padding: EdgeInsets.all(8),
                          child: Text(paquet.titre)),
                      Container(child: Text(paquet.description))
                    ],
                  ),
                ),
              ),
              InkWell(
                child: Icon(Icons.clear),
                onTap: () {
                  //print("Index of card:$index");
                  indexRemover(this);
                },
              )
            ],
          ),
        ));
  }
}
