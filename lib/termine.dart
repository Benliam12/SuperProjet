/*
Auteur du fichier : Randy
*/
import 'dart:ui';

import 'package:login_app/flashcard.dart';
import 'package:login_app/statistiques.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(Termine());
}

class Termine extends StatefulWidget {
  Statistiques stats;
  int index;

  Termine({this.stats, this.index});

  @override
  _TermineState createState() => _TermineState();
}

class _TermineState extends State<Termine> {
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
          title: Text("Quizz terminé"),
        ),
        body: Column(
          children: <Widget>[
            Container(
              height: 50,
              width: 100,
              child: Text("Sommaire"),
            ),
            Column(
              children: <Widget>[
                Container(
                  height: 75,
                  width: 250,
                  child: Text("Vous aviez une bonne réponse environ \n" +
                      widget.stats.proportionReussiUneFois.toStringAsFixed(2) +
                      "%\n de vos tours "),
                ),
                Container(
                  height: 75,
                  width: 200,
                  child: Text("Vous avez pris en moyenne\n " +
                      (widget.stats.tempsMoyen * 25).toStringAsFixed(2) +
                      " secondes par questions"),
                ),
                Container(
                  height: 75,
                  width: 200,
                  child: Text(
                      "L'algorithme intelligent vous suggère de refaire le quizz dans " +
                          widget.stats.tempsAChanger.toStringAsFixed(2) +
                          " jours"),
                )
              ],
            ),
            Expanded(
              child: Container(
                height: 400,
                child: Image.asset("images/stacks.png"),
              ),
              flex: 10,
            ),
            Expanded(
                child: Card(
                  color: Colors.blue,
                  child: InkWell(
                    child: Container(
                      width: 500,
                      child: Text("Poursuivre"),
                      alignment: Alignment.center,
                    ),
                    onTap: () {
                      Navigator.of(context).push(new MaterialPageRoute(
                          builder: (_) => new FlashCard(
                                index: widget.index,
                              )));
                    },
                  ),
                ),
                flex: 2)
          ],
        ),
      ),
    );
  }
}
