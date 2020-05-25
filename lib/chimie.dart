/*
Auteur du fichier : Éloïse
*/
import 'package:flutter/material.dart';
import 'package:login_app/chatbot.dart';
import 'package:login_app/imdumb.dart';
import 'package:extended_math/extended_math.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:login_app/imfat.dart';
import 'package:login_app/main.dart';

class Chimie extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Chimie",
      theme: ThemeData(
        primaryColor: Colors.blue,
      ),
      home: MyPage(),
    );
  }
}

class MyPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MyPageState();
  }
}

class _MyPageState extends State<MyPage> {
  final reactifs = TextEditingController();
  final produits = TextEditingController();

  String solution_finale = "Solution:";

  @override
  void dispose() {
    reactifs.dispose();
    produits.dispose();
    super.dispose();
  }

  bool isNumeric(String s) {
    if (s == null) {
      return false;
    }
    return double.parse(s, (e) => null) != null;
  }

  void showMessageErreur(BuildContext context) async {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("ATTENTION... ERREUR !!!"),
            content: Text(
                "L'équation est n'est pas bonne. Révisez l'écriture. Si tout est bien écrit, l'équation n'a pas de solution."),
            actions: <Widget>[
              FlatButton(
                  onPressed: () => Navigator.pop(context), child: Text("ok"))
            ],
          );
        });
  }

  void solution(BuildContext context) async {
    List diffReactifs = new List();
    List diffProduits = new List();

    var textReactifs = reactifs.text;
    var textProduits = produits.text;

    //split text dans les cases
    diffReactifs = textReactifs.split('+');
    diffProduits = textProduits.split('+');

    var atomesReactifsTotal =
        new List.generate(diffReactifs.length, (_) => new List());
    var nbReactifsTotal =
        new List.generate(diffReactifs.length, (_) => new List<int>());

    var atomesProduitsTotal =
        new List.generate(diffProduits.length, (_) => new List());
    var nbProduitsTotal =
        new List.generate(diffProduits.length, (_) => new List<int>());

    //vefif pour texte vide et caractères autres
    RegExp exp = new RegExp(r"[^A-Za-z0-9\+()]");
    bool isLegit = !exp.hasMatch(textReactifs);
    bool isLegit2 = !exp.hasMatch(textProduits);
    if (!isLegit ||
        textReactifs.toString().isEmpty ||
        !isLegit2 ||
        textProduits.toString().isEmpty) {
      showMessageErreur(context);
      return;
    }

    try {
      //split les atomes
      for (int i = 0; i < diffReactifs.length; i++) {
        Atome.fonctionTest(
            atomesReactifsTotal[i], nbReactifsTotal[i], diffReactifs[i]);
      }

      for (int i = 0; i < diffProduits.length; i++) {
        Atome.fonctionTest(
            atomesProduitsTotal[i], nbProduitsTotal[i], diffProduits[i]);
      }
    } catch (e) {
      showMessageErreur(context);
      return;
    }

    for (int i = 0; i < atomesReactifsTotal.length; i++) {
      for (int j = 0; j < atomesReactifsTotal[i].length; j++) {
        print(atomesReactifsTotal[i][j]);
        print(nbReactifsTotal[i][j]);
      }
    }
    for (int i = 0; i < atomesProduitsTotal.length; i++) {
      for (int j = 0; j < atomesProduitsTotal[i].length; j++) {
        print(atomesProduitsTotal[i][j]);
        print(nbProduitsTotal[i][j]);
      }
    }

    //vérif si atomes réactifs sont dans les produits
    var list1 = List<String>();
    for (int i = 0; i < atomesReactifsTotal.length; i++) {
      for (int j = 0; j < atomesReactifsTotal[i].length; j++) {
        list1.add(atomesReactifsTotal[i][j]);
      }
    }
    var list2 = List<String>();
    for (int i = 0; i < atomesProduitsTotal.length; i++) {
      for (int j = 0; j < atomesProduitsTotal[i].length; j++) {
        list2.add(atomesProduitsTotal[i][j]);
      }
    }

    bool allo = true;
    for (int i = 0; i < list1.length; i++) {
      if (!list2.contains(list1[i])) {
        allo = false;
      }
    }

    if (!allo) {
      showMessageErreur(context);
      return;
    }

    //mettre atomes dans une matrice
    List<List<double>> matrix = new List<List<double>>();

    Atome.CreerMatrice(atomesReactifsTotal, nbReactifsTotal,
        atomesProduitsTotal, nbProduitsTotal, matrix);

    final mat = Matrix(matrix);
    print(mat);

    if (matrix.length == 1) {
      showMessageErreur(context);
      return;
    }

    //ajouter gauss-jordan

    if (atomesReactifsTotal.length == atomesProduitsTotal.length) {
      Atome.ResoudreMatrice(matrix);
    }

    List<double> imaho = new List<double>();
    imaho.add(diffReactifs.length.toDouble());
    matrix.add(imaho);

    //résoudre la matrice
    String url = "http://vps.benliam12.net:8000/";
    Map<String, String> headers = {"Content-type": "application/json"};

    String json = jsonEncode(matrix);

    http.Response response = await http.post(url, headers: headers, body: json);
    int statusCode = response.statusCode;
    String body = response.body;
    print('$body - $statusCode');

    //trouver les coefficients
    String newbody = body.replaceAll('{', '').replaceAll('}', '');

    var firstSplit = newbody.split(', ');
    var secondsplit = {};

    for (var i = 0; i < firstSplit.length; i++) {
      var t = firstSplit[i].split(':');
      var letter = t[0].replaceAll('"', '');
      var answer = t[1].replaceAll('"', '');
      secondsplit[letter] = answer;
    }

    var alp = "a".codeUnitAt(0);
    var alp_end = "z".codeUnitAt(0);

    while (alp <= alp_end) {
      var letter = new String.fromCharCode(alp);
      if (!secondsplit.containsKey(letter)) {
        break;
      }
      alp++;
    }

    var listValeurs = {};
    var alp2 = "a".codeUnitAt(0);

    try {
      for (alp2 = "a".codeUnitAt(0); alp2 < alp; alp2++) {
        var let = new String.fromCharCode(alp);
        var curLet = new String.fromCharCode(alp2);
        listValeurs[curLet] = double.parse(secondsplit[curLet]
            .replaceAll("*$let", '')
            .replaceAll(" $let", '1'));
      }
    } catch (e) {
      showMessageErreur(context);
      return;
    }

    print(new String.fromCharCode(alp));

    double valMin = 100.0;
    var let2 = new String.fromCharCode(alp);
    listValeurs[let2] = 1.0;

    for (alp2 = "a".codeUnitAt(0); alp2 <= alp; alp2++) {
      var curLet = new String.fromCharCode(alp2);
      if (listValeurs[curLet] < valMin) {
        valMin = listValeurs[curLet];
      }
    }

    for (alp2 = "a".codeUnitAt(0); alp2 <= alp; alp2++) {
      var curLet = new String.fromCharCode(alp2);
      if (valMin != 0) {
        listValeurs[curLet] *= (1 / valMin);
      }
      listValeurs[curLet] = listValeurs[curLet].round();
    }

    //afficher la solution
    setState(() {
      solution_finale = "Solution: ";
      var list = listValeurs.values.toList();
      for (int i = 0; i < diffReactifs.length; i++) {
        if (list[i] != 1) {
          solution_finale += list[i].toString();
        }
        solution_finale += diffReactifs[i];
        if ((i + 1) < diffReactifs.length) solution_finale += " + ";
      }
      solution_finale += " → ";
      for (int i = 0; i < diffProduits.length; i++) {
        if (list[i + diffReactifs.length] != 1) {
          solution_finale += list[i + diffReactifs.length].toString();
        }
        solution_finale += diffProduits[i];
        if ((i + 1) < diffProduits.length) solution_finale += " + ";
      }
    });
  }

  void killMe(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Modeles()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => MyApp()));
          },
        ),
        backgroundColor: Colors.pink,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.live_help),
            onPressed: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => ChatBot()));
            },
          ),
          IconButton(
            icon: Icon(Icons.arrow_right),
            onPressed: () => killMe(context),
          ),
        ],
        title: Text(
          "Balancement d'équation",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Container(
        height: MediaQuery.of(context).copyWith().size.height / 1,
        color: Colors.white,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Expanded(
              flex: 1,
              child: Padding(
                padding: EdgeInsets.all(25.0),
                child: Text('Entrez l\'équation à balancer',
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              ),
            ),
            Expanded(
              flex: 3,
              child: Padding(
                padding: EdgeInsets.all(20.0),
                child: Text(
                    "Sur la ligne de gauche, entrez les réactifs non-balancés. Sur la ligne de droite, faites de même avec les produits. Les molécules doivent commencer par une lettre majuscule et les indices sont entrés après les atomes. Les parenthèses sont acceptées. Le traitement des ions n'est pas disponible.",
                    textAlign: TextAlign.justify,
                    style: TextStyle(
                      fontSize: 15,
                      fontStyle: FontStyle.italic,
                    )),
              ),
            ),
            Expanded(
              flex: 2,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    child: TextFormField(
                      controller: reactifs,
                      textAlign: TextAlign.center,
                      decoration: const InputDecoration(
                        hintText: 'N2 + H2',
                      ),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Première case vide';
                        }
                        return null;
                      },
                    ),
                  ),
                  Expanded(
                    child: Icon(Icons.arrow_forward),
                  ),
                  Expanded(
                    child: TextFormField(
                      controller: produits,
                      textAlign: TextAlign.center,
                      decoration: const InputDecoration(
                        hintText: 'NH3',
                      ),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Deuxième case vide';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
                flex: 2,
                child: ButtonTheme(
                    minWidth: 400.0,
                    height: 50.0,
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: RaisedButton(
                          padding: new EdgeInsets.all(5.0),
                          child: Text('OK',
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.bold)),
                          color: Colors.pink,
                          onPressed: () {
                            solution(context);
                          }),
                    ))),
            Expanded(
              flex: 2,
              child: Padding(
                padding: EdgeInsets.all(15.0),
                child: Align(
                    alignment: Alignment.topLeft,
                    child: Text(solution_finale,
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold))),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
