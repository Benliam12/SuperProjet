import 'dart:convert';
import 'dart:io';

/*
Auteur du fichier : Randy
*/
import 'package:login_app/carte.dart';
import 'package:login_app/flashcard.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

import 'paquet.dart';

class AjoutDart extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return StateAjoutDart();
  }
}

class StateAjoutDart extends State<AjoutDart> {
  bool isbackbuttonActivated = false;
  int numberOfCard = 0;
  List<DynamicCard> listDynamic = [];

  String titre;
  String description;

  Paquet paquetCree;

  File jsonFile;
  Directory dir;
  String fileName = "listePaquet.json";
  bool fileExists = false;
  Map<String, dynamic> paquet = Map();

  @override
  void initState() {
    super.initState();
    getApplicationDocumentsDirectory().then((Directory directory) {
      dir = directory;
      jsonFile = new File(dir.path + "/" + fileName);
    });
  }

  void createFile(Map<String, dynamic> value, Directory dir, String fileName) {
    print("creating file");

    File file = File(dir.path + "/" + fileName);
    Map<String, dynamic> content = {"0": value};

    if (file.existsSync()) {
      writeToFile("0", value);
    } else {
      file.createSync();
      fileExists = true;
      file.writeAsStringSync(json.encode(content));
    }
  }

  void writeToFile(String key, dynamic value) {
    print("Writing to file");
    print(dir.path);

    //Map<String, dynamic> content = {key: value};
    if (jsonFile.existsSync()) {
      print("File exists");
      paquet = jsonDecode(jsonFile.readAsStringSync());
      int nb = paquet.length;
      Map<String, dynamic> content = {"$nb": value};

      paquet.addAll(content);
      jsonFile.writeAsStringSync(json.encode(paquet));
    } else {
      print("file does not exist");
      createFile(value, dir, fileName);
    }

    this.setState(() => paquet = json.decode(jsonFile.readAsStringSync()));
  }

  addDynamic() {
    print("Card:$numberOfCard");
    setState(() {
      var _carte = Carte();
      listDynamic.add(DynamicCard(
          indexRemover: () => onDelete(_carte),
          carte: _carte,
          index: numberOfCard));
      numberOfCard++;
    });
  }

  void onDelete(Carte _carte) {
    setState(() {
      var find = listDynamic.firstWhere(
        (it) => it.carte == _carte,
        orElse: () => null,
      );
      if (find != null) listDynamic.removeAt(listDynamic.indexOf(find));

      numberOfCard--;
    });
  }

  bool onSave(BuildContext context) {
    var data = listDynamic.map((it) => it.carte).toList();
    paquetCree = Paquet(this.titre, this.description, data);

    if (this.titre == null ||
        this.description == null ||
        data.isEmpty ||
        !paquetCree.isLegit()) {
      showDialog(
          context: context,
          builder: (BuildContext context) => AlertDialog(
                title: Text("Vous devez configurer correctement le paquet!"),
                actions: <Widget>[
                  FlatButton(
                    child: Text("Ok"),
                    onPressed: () {
                      Navigator.pop(context, true);
                    },
                  )
                ],
              ));
      return false;
    }
    writeToFile("0", paquetCree.toJson());

    return true;
  }

  Future<bool> _onbackpressed() {
    return showDialog(
        context: this.context,
        builder: (context) => AlertDialog(
              title: Text("Voulez-vous vraiment quitter ?"),
              actions: <Widget>[
                FlatButton(
                  child: Text("Non"),
                  onPressed: () {
                    Navigator.pop(context, false);
                  },
                ),
                FlatButton(
                    child: Text("Oui"),
                    onPressed: () {
                      Navigator.pop(context, true);
                    })
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onbackpressed,
      child: Scaffold(
          appBar: AppBar(
            title: Text("Création paquet"),
          ),
          body: Column(children: <Widget>[
            Expanded(
                flex: 1,
                child: Container(
                  width: 300,
                  alignment: Alignment.center,
                  child: TextFormField(
                    maxLength: 8,
                    decoration: InputDecoration(
                      labelText: "Titre",
                      border: OutlineInputBorder(borderSide: BorderSide()),
                    ),
                    onChanged: (_text) {
                      titre = _text;
                    },
                  ),
                )),
            Expanded(
                flex: 1,
                child: Container(
                  width: 300,
                  alignment: Alignment.center,
                  child: TextFormField(
                    maxLength: 50,
                    decoration: InputDecoration(
                      labelText: "Description",
                      border: OutlineInputBorder(borderSide: BorderSide()),
                    ),
                    onChanged: (_text) {
                      description = _text;
                    },
                  ),
                )),
            Expanded(
                flex: 3,
                child: ListView.builder(
                    itemCount: listDynamic.length,
                    itemBuilder: (context, index) => listDynamic[index])),
            Expanded(
                flex: 1,
                child: Row(children: <Widget>[
                  Expanded(
                    child: Card(
                      color: Colors.blue,
                      child: InkWell(
                        child: Container(
                          alignment: Alignment.center,
                          child: Text("Ajouter une carte+"),
                        ),
                        onTap: () {
                          addDynamic();
                        },
                      ),
                    ),
                  ),
                  Expanded(
                    child: Card(
                      color: Colors.green,
                      child: InkWell(
                        child: Container(
                          alignment: Alignment.center,
                          child: Text("Terminer"),
                        ),
                        onTap: () {
                          if (!onSave(context)) return;
                          /* Navigator.push(context, MaterialPageRoute(builder: (context) {
                            return MyApp();
                            
                        }));
                        */
                          Navigator.pop(this.context, true);
                          Navigator.of(context).push(new MaterialPageRoute(
                              builder: (_) => FlashCard()));
                        },
                      ),
                    ),
                  )
                ]))
          ])),
    );
  }
}

typedef OnDelete();

class DynamicCard extends StatefulWidget {
  final int index;
  final OnDelete indexRemover;
  final Carte carte;
  const DynamicCard({this.indexRemover, Key key, this.carte, this.index})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _DynamicCardState();
}

class _DynamicCardState extends State<DynamicCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
        //color: Colors.white54,
        color: Colors.blue[200],
        child: Container(
          height: 50,
          child: Row(
            children: <Widget>[
              Expanded(
                  flex: 5,
                  child: Container(
                    child: TextFormField(
                      style: TextStyle(fontSize: 12),
                      decoration: InputDecoration(labelText: "Devant"),
                      onChanged: (_text) {
                        widget.carte.devant = _text;
                      },
                    ),
                  )),
              Expanded(
                  flex: 5,
                  child: Container(
                    child: TextFormField(
                        style: TextStyle(fontSize: 12),
                        decoration: InputDecoration(labelText: "Dos"),
                        onChanged: (_text) {
                          widget.carte.derriere = _text;
                        }),
                  )),
              InkWell(
                child: Icon(Icons.clear),
                onTap: () {
                  widget.indexRemover();
                },
              )
            ],
          ),
        ));
  }
}
