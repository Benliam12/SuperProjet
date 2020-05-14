import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:login_app/paquet.dart';
import 'package:login_app/question.dart';
import 'package:login_app/termine.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'statistiques.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

void main() {
  runApp(QuizzDart());
}

class QuizzDart extends StatefulWidget {
  final Paquet paquet;
  final int index;

  const QuizzDart({this.paquet, this.index});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return QuizzDartState(paquet: this.paquet, index: index);
  }
}

class QuizzDartState extends State<QuizzDart> {
  TextEditingController _controller = new TextEditingController();

  Paquet paquet;
  int index;

  List<Question> questions = [];

  int indexZero = 0;
  int compteurTemps = 0;

  int nbQuestion = 0;

  int nbEssai = 0;
  int nbReussi = 0;

  bool reussi = false;
  bool fini = false;
  bool quizzTermine = false;
  bool arrowShown = true;
  String reponse;

  double moyenneTemps = 0;

  QuizzDartState({this.paquet, this.index});

  void generateQuestions() {
    if (questions.length == 0) {
      for (int i = 0; i < 2; i++) {
        for (int j = 0; j < paquet.listCartes.length; j++) {
          if (i == 0) {
            questions.add(Question(
                paquet.listCartes[j].devant, paquet.listCartes[j].derriere));
          } else {
            questions.add(Question(
                paquet.listCartes[j].derriere, paquet.listCartes[j].devant));
          }
        }
      }
      questions.shuffle();
      nbQuestion = questions.length;
    }
  }

  Future<String> _randyPostRequest(double data1, double data2) async {
    String url = "http://vps.benliam12.net:8000";
    Map<String, String> headers = {"Content-type": "application/json"};
    List<double> datas = List<double>();
    datas.add(data1); // data 1
    datas.add(data2); // data 2
    String json = jsonEncode(datas);
    http.Response response = await http.post(url, headers: headers, body: json);
    int statusCode = response.statusCode;
    String body = response.body;
    print('$body - $statusCode');
    return body;
  }

  List<Widget> _createChildren() {
    return new List<Widget>.generate(2, (int i) {
      if (i == 0) {
        return Expanded(flex: 2, child: Text(questions[indexZero].question));
      } else {
        if (fini == true) {
          //compteurTemps=0;
          if (reussi == true) {
            return Expanded(
                flex: 6,
                child: Container(
                    child: Icon(
                  Icons.check,
                  size: 100,
                  color: Colors.green,
                )));
          } else {
            return Expanded(
                flex: 6,
                child: Container(
                    child: Icon(
                  Icons.close,
                  size: 100,
                  color: Colors.red,
                )));
          }
        } else {
          Timer(Duration(seconds: 1), () {
            if (compteurTemps < 25) {
              setState(() {
                compteurTemps++;
              });
            }
          });

          return Expanded(
              flex: 6,
              child: Container(
                  child: Text(compteurTemps.toString()),
                  alignment: Alignment.center));
        }
      }
    });
  }

  List<Widget> _createChildrenRow() {
    return new List<Widget>.generate(4, (int i) {
      if (i == 0) {
        return Expanded(
          flex: 2,
          child: Container(),
        );
      }
      if (i == 1) {
        return Expanded(
          flex: 3,
          child: Container(
              decoration: BoxDecoration(
                  border: Border.all(),
                  borderRadius: BorderRadius.all(Radius.circular(5.0))),
              child: Column(
                children: _createChildren(),
              )),
        );
      }
      if (i == 2) {
        if (fini == true) {
          return Container(
            child: IconButton(
                icon: Icon(Icons.arrow_forward, size: 50),
                onPressed: () {
                  moyenneTemps = moyenneTemps + compteurTemps - 1;
                  compteurTemps = 0;
                  arrowShown = true;
                  if (quizzTermine == false && reussi == true) {
                    setState(() {
                      questions.removeAt(indexZero);
                      fini = false;
                      reussi = false;
                      _controller.clear();
                      questions.shuffle();
                    });
                  } else if (quizzTermine == true) {
                    Future<String> tempBanane2 = _randyPostRequest(
                        ((nbEssai - nbReussi) / nbEssai + 0.01),
                        ((moyenneTemps / nbEssai) / 25));

                    tempBanane2.then((tempBanane) {
                      double exp = pow(e, (0.9085 * paquet.nbFoisFait));
                      Statistiques stats = Statistiques(
                          ((nbReussi / (nbEssai + 0.01)) * 100)
                              .ceil()
                              .roundToDouble(),
                          ((moyenneTemps / nbEssai) / 25),
                          (1 - double.parse(tempBanane)) * 0.4083 * exp);
                      Navigator.pop(this.context, true);

                      Navigator.of(context).push(new MaterialPageRoute(
                          builder: (_) => new Termine(
                                stats: stats,
                                index: index,
                              )));
                    });
                  } else {
                    setState(() {
                      fini = false;
                      reussi = false;
                      _controller.clear();
                      questions.shuffle();
                    });
                  }
                }),
          );
        } else {
          return Container();
        }
      }
      if (i == 3) {
        return Expanded(flex: 2, child: Container());
      }
    });
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

  //Reponses<String> reponses;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    generateQuestions();
    return WillPopScope(
      onWillPop: _onbackpressed,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Quizz"),
        ),
        body: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: Container(
                    height: 50,
                  ),
                  flex: 5,
                ),
                Expanded(
                  child: Container(
                    height: 50,
                    child: Row(
                      children: <Widget>[
                        Expanded(
                            child: Container(
                          child: Text((nbReussi / (nbEssai + 0.01) * 100)
                                  .ceil()
                                  .toString() +
                              "%"),
                          margin: EdgeInsets.all(10),
                          alignment: Alignment.center,
                        )),
                        Expanded(
                          child: Container(
                            child: Text(
                                "$nbReussi " + "/ " + nbQuestion.toString()),
                            margin: EdgeInsets.all(10),
                            alignment: Alignment.center,
                          ),
                        )
                      ],
                    ),
                  ),
                  flex: 3,
                )
              ],
            ),
            Expanded(
              flex: 5,
              child: Row(
                children: _createChildrenRow(),
              ),
            ),
            Expanded(
              flex: 2,
              child: Container(
                  child: Form(
                child: Column(
                  key: _formKey,
                  children: <Widget>[
                    Expanded(
                      flex: 5,
                      child: Container(
                        width: 300,
                        child: Stack(
                          alignment: Alignment.centerRight,
                          children: <Widget>[
                            TextField(
                              controller: _controller,
                              onChanged: (_text) {
                                reponse = _text;
                              },
                              keyboardType: TextInputType.text,
                              style: Theme.of(context).textTheme.body1,
                              decoration: InputDecoration(
                                labelText: "Entrez votre réponse",
                                contentPadding:
                                    const EdgeInsets.fromLTRB(6, 6, 48, 6),
                              ),
                            ),
                            Visibility(
                              visible: arrowShown,
                              child: IconButton(
                                icon: Icon(Icons.arrow_forward,
                                    color: Colors.black),
                                iconSize: 45,
                                onPressed: () {
                                  FocusScope.of(context)
                                      .requestFocus(FocusNode());

                                  nbEssai++;
                                  print("$nbEssai total");
                                  if (reponse ==
                                      questions[indexZero].reponseQuestion) {
                                    reussi = true;
                                    nbReussi++;
                                    print("$nbReussi reussi");
                                  } else {
                                    reussi = false;
                                  }
                                  if (questions.length != 1) {
                                    setState(() {
                                      arrowShown = false;
                                      fini = true;
                                    });
                                  } else {
                                    if (reussi == true) {
                                      setState(() {
                                        arrowShown = false;
                                        quizzTermine = true;
                                        fini = true;
                                      });
                                    } else {
                                      setState(() {
                                        arrowShown = false;
                                        fini = true;
                                      });
                                    }
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 5,
                      child: Container(
                        alignment: Alignment.center,
                        child: MaterialButton(
                          height: 40.0,
                          minWidth: 140.0,
                          color: Theme.of(context).primaryColor,
                          textColor: Colors.white,
                          child: new Text("Réponse"),
                          onPressed: () {
                            return showDialog(
                                context: this.context,
                                builder: (context) => AlertDialog(
                                        title: Text("La réponse est " +
                                            questions[indexZero]
                                                .reponseQuestion
                                                .toString()),
                                        actions: <Widget>[
                                          FlatButton(
                                              child: Text("Ok"),
                                              onPressed: () {
                                                Navigator.pop(context);
                                              })
                                        ]));
                          },
                          splashColor: Colors.redAccent,
                        ),
                      ),
                    )
                  ],
                ),
              )),
            )
          ],
        ),
      ),
    );
  }
}
