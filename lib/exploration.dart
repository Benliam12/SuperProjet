import 'package:login_app/paquet.dart';
import 'package:flutter/material.dart';
import 'dart:async';

void main() {
  runApp(Exploration());
}

List<Cards> buildCards(Paquet paquet) {
  List<Cards> cartes = [];
  for (int i = 0; i < paquet.listCartes.length; i++) {
    cartes
        .add(Cards(paquet.listCartes[i].derriere, paquet.listCartes[i].devant));
  }
  return cartes;
}

class Exploration extends StatefulWidget {
  Paquet paquet;

  Exploration({this.paquet});

  @override
  _ExplorationState createState() => _ExplorationState();
}

class _ExplorationState extends State<Exploration> {
  List<Cards> cartesWidget;

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
    cartesWidget = buildCards(widget.paquet);
    return WillPopScope(
      onWillPop: _onbackpressed,
      child: Scaffold(
          appBar: AppBar(
            title: Text("Mode Exploration"),
          ),
          body: ListView.builder(
            itemCount: widget.paquet.listCartes.length,
            itemBuilder: (context, index) => cartesWidget[index],
          )),
    );
  }
}

class Cards extends StatelessWidget {
  final String devant;
  final String derriere;

  Cards(this.derriere, this.devant);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Card(
      color: Colors.lightBlue,
      child: Row(
        children: <Widget>[
          Expanded(
            child: Container(
              child: Text(devant),
              height: 50,
              alignment: Alignment.center,
            ),
            flex: 1,
          ),
          Expanded(
            child: Container(
                child: Text(derriere), height: 50, alignment: Alignment.center),
            flex: 1,
          )
        ],
      ),
    );
  }
}
