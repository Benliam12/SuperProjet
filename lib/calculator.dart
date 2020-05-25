/*
Auteur du fichier : Marc-Antoine
*/
import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/rendering.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:login_app/chatbot.dart';
import 'package:login_app/main.dart';
import 'package:math_expressions/math_expressions.dart';
import 'package:extended_math/extended_math.dart';

class Calculator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var routes = <String, WidgetBuilder>{
      QuadratiqueWIdget.routeName: (BuildContext context) =>
          new QuadratiqueWIdget(),
      DeriveeWidget.routeNameDerivee: (BuildContext context) =>
          new DeriveeWidget(),
      InconnuWidget.routeNameInconnu: (BuildContext context) =>
          new InconnuWidget(),
      Balancement3VariablesWidget.routeName3Variables: (BuildContext context) =>
          new Balancement3VariablesWidget(),
      Balancement2VariablesWidget.routeName2Variables: (BuildContext context) =>
          new Balancement2VariablesWidget(),
    };
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyCalculatorApp(),
      routes: routes,
    );
  }
}

class Constants {
  static const String quadratique = "Équation quadratique";
  static const String balancement = "Balancement d'équation";
  static const String derivee = "Calcul de dérivée";

  static const List<String> choices = <String>[
    quadratique,
    balancement,
    derivee,
  ];
}

class MyCalculatorApp extends StatefulWidget {
  @override
  _MyCalculatorAppState createState() => _MyCalculatorAppState();
}

class QuadratiqueWIdget extends StatefulWidget {
  static const String routeName = "/Quadratique";
  @override
  Quadratique createState() => Quadratique();
}

class DeriveeWidget extends StatefulWidget {
  static const String routeNameDerivee = "/Derivee";
  @override
  Derivee createState() => Derivee();
}

class InconnuWidget extends StatefulWidget {
  static const String routeNameInconnu = "/Inconnu";
  @override
  Inconnu createState() => Inconnu();
}

class Balancement3VariablesWidget extends StatefulWidget {
  static const String routeName3Variables = "/3Variables";
  @override
  Balancement3Variables createState() => Balancement3Variables();
}

class Balancement2VariablesWidget extends StatefulWidget {
  static const String routeName2Variables = "/2Variables";
  @override
  Balancement2Variables createState() => Balancement2Variables();
}

class _MyCalculatorAppState extends State<MyCalculatorApp> {
  File pickedImage;

  final TextEditingController _controller = TextEditingController();

  bool isImageLoaded = false;

  String previewText = '';
  String resultText = '';
  String resutlQuad1 = '';
  String resutlQuad2 = '';

  Future pickImage() async {
    var tempStore = await ImagePicker.pickImage(source: ImageSource.camera);

    setState(() {
      pickedImage = tempStore;
      isImageLoaded = true;
      cropImage();
    });
  }

  Future<void> cropImage() async {
    File cropped = await ImageCropper.cropImage(
        sourcePath: pickedImage.path,
        androidUiSettings: AndroidUiSettings(
            toolbarTitle: 'Selection du texte',
            toolbarColor: Color.fromRGBO(255, 0, 0, 1),
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false));
    setState(() {
      pickedImage = cropped ?? pickedImage;
      readText();
    });
  }

  Future readText() async {
    FirebaseVisionImage ourImage = FirebaseVisionImage.fromFile(pickedImage);
    TextRecognizer recognizeText = FirebaseVision.instance.textRecognizer();
    VisionText readText = await recognizeText.processImage(ourImage);

    for (TextBlock block in readText.blocks) {
      setState(() {
        _controller.text = block.text;
      });
    }
  }

  Future calculerResultat() async {
    FocusScope.of(context).requestFocus(FocusNode());

    try {
      if (_controller.text == '') {
        throw ChampVide();
      }

      Parser parser = new Parser();

      Expression expression = parser.parse(_controller.text
          .replaceAll(new RegExp(r"÷"), "/")
          .replaceAll(new RegExp(r"×"), '*'));

      setState(() {
        resultText =
            expression.evaluate(EvaluationType.REAL, null).toStringAsFixed(4);
      });
    } on FormatException catch (e) {
      Fluttertoast.showToast(
          msg: e.toString(),
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 18.0,
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM);
    } on ChampVide {
      Fluttertoast.showToast(
          msg: 'Veuillez entrer un calcul.',
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 18.0,
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM);
    } catch (error) {
      Fluttertoast.showToast(
          msg: "Élément invalide.",
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 18.0,
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM);
    }
  }

  Widget build(BuildContext context) {
    void handleClick(String choice) {
      if (choice == Constants.quadratique) {
        Navigator.pushNamed(context, QuadratiqueWIdget.routeName);
      } else if (choice == Constants.balancement) {
        Navigator.pushNamed(context, InconnuWidget.routeNameInconnu);
      } else if (choice == Constants.derivee) {
        Navigator.pushNamed(context, DeriveeWidget.routeNameDerivee);
      }
    }

    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MyApp()),
              );
            },
          ),
          title: Text('Photo Calcul'),
          backgroundColor: Color.fromRGBO(255, 0, 0, 1),
          actions: <Widget>[
            PopupMenuButton<String>(
                onSelected: handleClick,
                icon: Icon(Icons.more_vert),
                itemBuilder: (BuildContext context) {
                  return Constants.choices.map((String choice) {
                    return PopupMenuItem<String>(
                      value: choice,
                      child: Text(choice),
                    );
                  }).toList();
                })
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.red,
          child: const Icon(Icons.camera),
          onPressed: () {
            pickImage();
          },
        ),
        bottomNavigationBar: BottomAppBar(
          shape: CircularNotchedRectangle(),
          notchMargin: 4.0,
          child: new Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.live_help),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ChatBot()),
                  );
                },
              ),
              IconButton(
                icon: Icon(Icons.info_outline),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => InfoPagePrincipale()));
                },
              ),
            ],
          ),
        ),
        body: Padding(
          padding: EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              new TextField(
                controller: _controller,
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                    hintText: 'Entrez une équation ou prenez une photo'),
              ),
              RaisedButton(
                  child: Text(
                    'Calculer',
                    style: TextStyle(fontSize: 25),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  color: Colors.red,
                  textColor: Colors.white,
                  onPressed: () {
                    calculerResultat();
                  }),
              new Text("Réponse :", style: TextStyle(fontSize: 20)),
              new Text(
                resultText,
                style: TextStyle(fontSize: 20),
                textAlign: TextAlign.center,
              )
            ],
          ),
        ));
  }
}

class Quadratique extends State<QuadratiqueWIdget> {
  final TextEditingController _controller2 = TextEditingController();
  final TextEditingController _controller3 = TextEditingController();
  final TextEditingController _controller4 = TextEditingController();

  String resultquad1Solution = '';
  String resultquad2Solution = '';

  Future triageNombreSolution() async {
    Parser parser = new Parser();
    FocusScope.of(context).requestFocus(FocusNode());

    try {
      if (_controller2.text == '0') {
        throw CoefficientZero();
      }
      if (_controller2.text == null ||
          _controller3.text == null ||
          _controller4.text == null) {
        throw ChampVide();
      }
      Expression discriminant = parser.parse('sqrt(' +
          _controller3.text +
          '*' +
          _controller3.text +
          '- 4 *' +
          _controller2.text +
          '*' +
          _controller4.text +
          ')');

      double resultDiscriminant =
          discriminant.evaluate(EvaluationType.REAL, null);

      if (resultDiscriminant == 0) {
        calculQuad1Solution();
      } else if (resultDiscriminant > 0) {
        calculQuad2Solutions();
      } else {
        setState(() {
          resultquad1Solution = 'X1 = Aucune solution';
          resultquad2Solution = 'X2 = Aucune solution';
        });
      }
    } on CoefficientZero catch (e) {
      Fluttertoast.showToast(
          msg: e.toString(),
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 18.0,
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM);
    } on FormatException catch (e) {
      Fluttertoast.showToast(
          msg: e.toString(),
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 18.0,
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM);
    } on ChampVide catch (e) {
      Fluttertoast.showToast(
          msg: e.toString(),
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 18.0,
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM);
    } catch (error) {
      Fluttertoast.showToast(
          msg: "Élément invalide ou nul dans un des champs.",
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 18.0,
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM);
    }
  }

  Future calculQuad1Solution() async {
    Parser parser = new Parser();

    Expression calculQuad = parser.parse('-' +
        _controller3.text +
        '+ sqrt(' +
        _controller3.text +
        '*' +
        _controller3.text +
        '- 4 *' +
        _controller2.text +
        '*' +
        _controller4.text +
        ')/2*' +
        _controller2.text);
    setState(() {
      resultquad1Solution = 'X = ' +
          calculQuad
              .simplify()
              .evaluate(EvaluationType.REAL, null)
              .toStringAsFixed(4);
      resultquad2Solution = '';
    });
  }

  Future calculQuad2Solutions() async {
    Parser parser = new Parser();

    Expression calculQuad1 = parser.parse('(-' +
        _controller3.text +
        '+ sqrt(' +
        _controller3.text +
        '*' +
        _controller3.text +
        '- 4 *' +
        _controller2.text +
        '*' +
        _controller4.text +
        ')) / 2 *' +
        _controller2.text);
    setState(() {
      resultquad1Solution = 'X1 = ' +
          calculQuad1
              .simplify()
              .evaluate(EvaluationType.REAL, null)
              .toStringAsFixed(4);
    });

    Expression calculQuad2 = parser.parse('(-' +
        _controller3.text +
        '- sqrt(' +
        _controller3.text +
        '*' +
        _controller3.text +
        '- 4 *' +
        _controller2.text +
        '*' +
        _controller4.text +
        '))/2*' +
        _controller2.text);

    setState(() {
      resultquad2Solution = 'X1 = ' +
          calculQuad2
              .simplify()
              .evaluate(EvaluationType.REAL, null)
              .toStringAsFixed(4);
    });
  }

  @override
  Widget build(BuildContext context) {
    void handleClick(String choice) {
      if (choice == Constants.quadratique) {
        Navigator.pop(context);
        Navigator.pushNamed(context, QuadratiqueWIdget.routeName);
      } else if (choice == Constants.balancement) {
        Navigator.pop(context);
        Navigator.pushNamed(context, InconnuWidget.routeNameInconnu);
      } else if (choice == Constants.derivee) {
        Navigator.pop(context);
        Navigator.pushNamed(context, DeriveeWidget.routeNameDerivee);
      }
    }

    return Scaffold(
        resizeToAvoidBottomPadding: false,
        appBar: AppBar(
          title: Text("Calcul d'équation quadratique"),
          backgroundColor: Color.fromRGBO(255, 0, 0, 1),
          actions: <Widget>[
            PopupMenuButton<String>(
                onSelected: handleClick,
                icon: Icon(Icons.more_vert),
                itemBuilder: (BuildContext context) {
                  return Constants.choices.map((String choice) {
                    return PopupMenuItem<String>(
                      value: choice,
                      child: Text(choice),
                    );
                  }).toList();
                }),
          ],
        ),
        body: Padding(
            padding: EdgeInsets.only(
                top: 130.0, left: 20.0, right: 20.0, bottom: 20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    new Flexible(
                        child: new TextField(
                      controller: _controller2,
                      style: TextStyle(fontSize: 20),
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(10), hintText: 'a'),
                    )),
                    Text(
                      'x^2 +',
                      style: TextStyle(fontSize: 20),
                    ),
                    SizedBox(width: 20),
                    new Flexible(
                        child: new TextField(
                      controller: _controller3,
                      style: TextStyle(fontSize: 20),
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(10), hintText: 'b'),
                    )),
                    Text('x +', style: TextStyle(fontSize: 20)),
                    SizedBox(width: 20),
                    new Flexible(
                        child: new TextField(
                      controller: _controller4,
                      style: TextStyle(fontSize: 20),
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(10), hintText: 'c'),
                    )),
                    Text(
                      '= 0',
                      style: TextStyle(fontSize: 20),
                    ),
                    SizedBox(width: 20),
                  ],
                ),
                RaisedButton(
                    child: Text(
                      "Calculer X1 et X2",
                      style: TextStyle(fontSize: 20),
                    ),
                    color: Colors.red,
                    textColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    onPressed: () {
                      triageNombreSolution();
                    }),
                new Text(
                  "Réponse :\n",
                  style: TextStyle(fontSize: 20),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    new Text(resultquad1Solution),
                    new Text(resultquad2Solution)
                  ],
                ),
                Align(
                    alignment: Alignment.bottomRight,
                    child: FloatingActionButton(
                      child: Icon(Icons.arrow_back),
                      backgroundColor: Colors.red,
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    )),
              ],
            )));
  }
}

class Derivee extends State<DeriveeWidget> {
  final TextEditingController _controller1 = TextEditingController();

  String resultDerivee = '';
  String text1 = '';
  String text2 = '';

  Future calculDerivee() async {
    Parser parser = new Parser();
    FocusScope.of(context).requestFocus(FocusNode());

    try {
      Expression deriveEquation = parser.parse(_controller1.text);
      Expression simplifyEquation = deriveEquation.derive('x').simplify();

      Expression deriveFinale = parser.parse(simplifyEquation.toString());

      setState(() {
        try {
          text1 = 'd ( ' + _controller1.text + ' )/dx';
          text2 = '=\n';
          resultDerivee = deriveFinale
              .simplify()
              .evaluate(EvaluationType.REAL, null)
              .replaceAll(new RegExp(r"pi"), "3.1415")
              .toStringAsFixed(4);
        } catch (error) {
          resultDerivee = simplifyEquation.toString();
        }
      });
    } catch (e) {
      Fluttertoast.showToast(
          msg: e.message,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 18.0,
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM);
    }
  }

  @override
  Widget build(BuildContext context) {
    void handleClick(String choice) {
      if (choice == Constants.quadratique) {
        Navigator.pop(context);
        Navigator.pushNamed(context, QuadratiqueWIdget.routeName);
      } else if (choice == Constants.balancement) {
        Navigator.pop(context);
        Navigator.pushNamed(context, InconnuWidget.routeNameInconnu);
      } else if (choice == Constants.derivee) {
        Navigator.pop(context);
        Navigator.pushNamed(context, DeriveeWidget.routeNameDerivee);
      }
    }

    return Scaffold(
        resizeToAvoidBottomPadding: false,
        appBar: AppBar(
          title: Text("Calcul de dérivée"),
          backgroundColor: Color.fromRGBO(255, 0, 0, 1),
          actions: <Widget>[
            PopupMenuButton<String>(
                onSelected: handleClick,
                icon: Icon(Icons.more_vert),
                itemBuilder: (BuildContext context) {
                  return Constants.choices.map((String choice) {
                    return PopupMenuItem<String>(
                      value: choice,
                      child: Text(choice),
                    );
                  }).toList();
                })
          ],
        ),
        body: Padding(
            padding: EdgeInsets.only(
                top: 100.0, left: 20.0, right: 20.0, bottom: 20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    new TextField(
                      controller: _controller1,
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(
                          hintText: "Veuillez entrer l'équation désirée"),
                      keyboardType: TextInputType.text,
                    ),
                  ],
                ),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      RaisedButton(
                          child: Text("Dériver l'équation",
                              style: TextStyle(fontSize: 20)),
                          textColor: Colors.white,
                          color: Colors.red,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          onPressed: () {
                            calculDerivee();
                          }),
                    ]),
                new Text(
                  'Réponse :',
                  style: TextStyle(fontSize: 20),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    new Text(text1, style: TextStyle(fontSize: 20)),
                    new Text(text2, style: TextStyle(fontSize: 20)),
                    new Text(resultDerivee, style: TextStyle(fontSize: 20)),
                  ],
                ),
                Align(
                    alignment: Alignment.bottomRight,
                    child: FloatingActionButton(
                      child: Icon(Icons.arrow_back),
                      backgroundColor: Colors.red,
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    )),
              ],
            )));
  }
}

class Inconnu extends State<InconnuWidget> {
  @override
  Widget build(BuildContext context) {
    void handleClick(String choice) {
      if (choice == Constants.quadratique) {
        Navigator.pop(context);
        Navigator.pushNamed(context, QuadratiqueWIdget.routeName);
      } else if (choice == Constants.balancement) {
        Navigator.pop(context);

        Navigator.pushNamed(context, InconnuWidget.routeNameInconnu);
      } else if (choice == Constants.derivee) {
        Navigator.pop(context);

        Navigator.pushNamed(context, DeriveeWidget.routeNameDerivee);
      }
    }

    return Scaffold(
        appBar: AppBar(
          title: Text("Balancement d'équation"),
          backgroundColor: Color.fromRGBO(255, 0, 0, 1),
          actions: <Widget>[
            PopupMenuButton<String>(
                onSelected: handleClick,
                icon: Icon(Icons.more_vert),
                itemBuilder: (BuildContext context) {
                  return Constants.choices.map((String choice) {
                    return PopupMenuItem<String>(
                      value: choice,
                      child: Text(choice),
                    );
                  }).toList();
                })
          ],
        ),
        body: Padding(
            padding: EdgeInsets.only(
                top: 300.0, left: 20.0, right: 20.0, bottom: 20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    new Text(
                      "Sélectionnez les variables à calculer\n\n",
                      style: TextStyle(fontSize: 20),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        RaisedButton(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text("X, Y", style: TextStyle(fontSize: 20)),
                            textColor: Colors.white,
                            color: Colors.red,
                            onPressed: () {
                              Navigator.pushNamed(
                                  context,
                                  Balancement2VariablesWidget
                                      .routeName2Variables);
                            }),
                        RaisedButton(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child:
                                Text("X, Y, Z", style: TextStyle(fontSize: 20)),
                            textColor: Colors.white,
                            color: Colors.red,
                            onPressed: () {
                              Navigator.pushNamed(
                                  context,
                                  Balancement3VariablesWidget
                                      .routeName3Variables);
                            }),
                      ],
                    ),
                  ],
                ),
                Align(
                    alignment: Alignment.bottomRight,
                    child: FloatingActionButton(
                      child: Icon(Icons.arrow_back),
                      backgroundColor: Colors.red,
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    )),
              ],
            )));
  }
}

class Balancement3Variables extends State<Balancement3VariablesWidget> {
  final TextEditingController _controllerX1 = TextEditingController();
  final TextEditingController _controllerX2 = TextEditingController();
  final TextEditingController _controllerX3 = TextEditingController();
  final TextEditingController _controllerY1 = TextEditingController();
  final TextEditingController _controllerY2 = TextEditingController();
  final TextEditingController _controllerY3 = TextEditingController();
  final TextEditingController _controllerZ1 = TextEditingController();
  final TextEditingController _controllerZ2 = TextEditingController();
  final TextEditingController _controllerZ3 = TextEditingController();
  final TextEditingController _controller1 = TextEditingController();
  final TextEditingController _controller2 = TextEditingController();
  final TextEditingController _controller3 = TextEditingController();

  String resultX = '';
  String resultY = '';
  String resultZ = '';
  String ou = '';
  String resultPrecisX = '';
  String resultPrecisY = '';
  String resultPrecisZ = '';
  String otherSolution = '';

  Future calculMatrices() async {
    FocusScope.of(context).requestFocus(FocusNode());

    try {
      if (_controller1.text == '' ||
          _controller2.text == '' ||
          _controller3.text == '' ||
          _controllerX1.text == '' ||
          _controllerX2.text == '' ||
          _controllerX3.text == '' ||
          _controllerY1.text == '' ||
          _controllerY2.text == '' ||
          _controllerY3.text == '' ||
          _controllerZ1.text == '' ||
          _controllerZ2.text == '' ||
          _controllerZ3.text == '') {
        throw ChampVide();
      }
      final denominateur = SquareMatrix(<List<double>>[
        <double>[
          double.parse(_controllerX1.text),
          double.parse(_controllerY1.text),
          double.parse(_controllerZ1.text)
        ],
        <double>[
          double.parse(_controllerX2.text),
          double.parse(_controllerY2.text),
          double.parse(_controllerZ2.text)
        ],
        <double>[
          double.parse(_controllerX3.text),
          double.parse(_controllerY3.text),
          double.parse(_controllerZ3.text)
        ]
      ]);

      final numerateurX = SquareMatrix(<List<double>>[
        <double>[
          double.parse(_controller1.text),
          double.parse(_controllerY1.text),
          double.parse(_controllerZ1.text)
        ],
        <double>[
          double.parse(_controller2.text),
          double.parse(_controllerY2.text),
          double.parse(_controllerZ1.text)
        ],
        <double>[
          double.parse(_controller3.text),
          double.parse(_controllerY3.text),
          double.parse(_controllerZ3.text)
        ]
      ]);

      final numerateurY = SquareMatrix(<List<double>>[
        <double>[
          double.parse(_controllerX1.text),
          double.parse(_controller1.text),
          double.parse(_controllerZ1.text)
        ],
        <double>[
          double.parse(_controllerX2.text),
          double.parse(_controller2.text),
          double.parse(_controllerZ2.text)
        ],
        <double>[
          double.parse(_controllerX3.text),
          double.parse(_controller3.text),
          double.parse(_controllerZ3.text)
        ]
      ]);

      final numerateurZ = SquareMatrix(<List<double>>[
        <double>[
          double.parse(_controllerX1.text),
          double.parse(_controllerY1.text),
          double.parse(_controller1.text)
        ],
        <double>[
          double.parse(_controllerX2.text),
          double.parse(_controllerY2.text),
          double.parse(_controller2.text)
        ],
        <double>[
          double.parse(_controllerX3.text),
          double.parse(_controllerY3.text),
          double.parse(_controller3.text)
        ]
      ]);

      setState(() {
        if (denominateur.determinant() != 0 &&
            (numerateurX.determinant() != 0 ||
                numerateurY.determinant() != 0 ||
                numerateurZ.determinant() != 0)) {
          otherSolution = "";
          resultX = "x = " +
              (numerateurX.determinant() / denominateur.determinant())
                  .toStringAsFixed(4);
          resultY = "y = " +
              (numerateurY.determinant() / denominateur.determinant())
                  .toStringAsFixed(4);
          resultZ = "z = " +
              (numerateurZ.determinant() / denominateur.determinant())
                  .toStringAsFixed(4);
          ou = "ou plus précisément";
          resultPrecisX = "x = " +
              numerateurX.determinant().toStringAsFixed(0) +
              "/" +
              denominateur.determinant().toStringAsFixed(0);
          resultPrecisY = "y = " +
              numerateurY.determinant().toStringAsFixed(0) +
              "/" +
              denominateur.determinant().toStringAsFixed(0);
          resultPrecisZ = "z = " +
              numerateurZ.determinant().toStringAsFixed(0) +
              "/" +
              denominateur.determinant().toStringAsFixed(0);
        } else if (denominateur.determinant() == 0 &&
            (numerateurX.determinant() != 0 ||
                numerateurY.determinant() != 0 ||
                numerateurZ.determinant() != 0)) {
          resultX = '';
          resultY = '';
          resultZ = '';
          ou = '';
          resultPrecisX = '';
          resultPrecisY = '';
          resultPrecisZ = '';
          otherSolution = "Le système d'équation admet soit aucune solution";
        } else if (denominateur.determinant() == 0 &&
            (numerateurX.determinant() != 0 ||
                numerateurY.determinant() != 0 ||
                numerateurZ.determinant() != 0)) {
          resultX = '';
          resultY = '';
          resultZ = '';
          ou = '';
          resultPrecisX = '';
          resultPrecisY = '';
          resultPrecisZ = '';
          otherSolution = "Le système d'équation n'admet aucune solution";
        } else if (denominateur.determinant() == 0 &&
            numerateurX.determinant() == 0 &&
            numerateurY.determinant() == 0 &&
            numerateurZ.determinant() == 0) {
          resultX = '';
          resultY = '';
          resultZ = '';
          ou = '';
          resultPrecisX = '';
          resultPrecisY = '';
          resultPrecisZ = '';
          otherSolution =
              "Le système d'équation n'admet une infinité de solutions solution";
        }
      });
    } on ChampVide {
      Fluttertoast.showToast(
          msg: "Il y a un ou plusieurs champs vides.",
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 18.0,
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM);
    } catch (error) {
      Fluttertoast.showToast(
          msg: error.toString(),
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 18.0,
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomPadding: false,
        appBar: AppBar(
          title: Text("Balancement X, Y, Z"),
          backgroundColor: Color.fromRGBO(255, 0, 0, 1),
        ),
        body: Padding(
            padding: EdgeInsets.only(
                top: 15.0, left: 20.0, right: 20.0, bottom: 20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    new Flexible(
                      child: new TextField(
                        controller: _controllerX1,
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.number,
                        decoration:
                            InputDecoration(contentPadding: EdgeInsets.all(10)),
                      ),
                    ),
                    Text('X +'),
                    SizedBox(width: 20),
                    new Flexible(
                      child: new TextField(
                        controller: _controllerY1,
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.number,
                        decoration:
                            InputDecoration(contentPadding: EdgeInsets.all(10)),
                      ),
                    ),
                    Text('Y +'),
                    SizedBox(width: 20),
                    new Flexible(
                      child: new TextField(
                        controller: _controllerZ1,
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.number,
                        decoration:
                            InputDecoration(contentPadding: EdgeInsets.all(10)),
                      ),
                    ),
                    Text('Z ='),
                    SizedBox(width: 20),
                    new Flexible(
                      child: new TextField(
                        controller: _controller1,
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.number,
                        decoration:
                            InputDecoration(contentPadding: EdgeInsets.all(10)),
                      ),
                    ),
                    SizedBox(width: 20),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    new Flexible(
                      child: new TextField(
                        controller: _controllerX2,
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.number,
                        decoration:
                            InputDecoration(contentPadding: EdgeInsets.all(10)),
                      ),
                    ),
                    Text('X +'),
                    SizedBox(width: 20),
                    new Flexible(
                      child: new TextField(
                        controller: _controllerY2,
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.number,
                        decoration:
                            InputDecoration(contentPadding: EdgeInsets.all(10)),
                      ),
                    ),
                    Text('Y +'),
                    SizedBox(width: 20),
                    new Flexible(
                      child: new TextField(
                        controller: _controllerZ2,
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.number,
                        decoration:
                            InputDecoration(contentPadding: EdgeInsets.all(10)),
                      ),
                    ),
                    Text('Z ='),
                    SizedBox(width: 20),
                    new Flexible(
                      child: new TextField(
                        controller: _controller2,
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.number,
                        decoration:
                            InputDecoration(contentPadding: EdgeInsets.all(10)),
                      ),
                    ),
                    SizedBox(width: 20),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    new Flexible(
                      child: new TextField(
                        controller: _controllerX3,
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.number,
                        decoration:
                            InputDecoration(contentPadding: EdgeInsets.all(10)),
                      ),
                    ),
                    Text('X +'),
                    SizedBox(width: 20),
                    new Flexible(
                      child: new TextField(
                        controller: _controllerY3,
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.number,
                        decoration:
                            InputDecoration(contentPadding: EdgeInsets.all(10)),
                      ),
                    ),
                    Text('Y +'),
                    SizedBox(width: 20),
                    new Flexible(
                      child: new TextField(
                        controller: _controllerZ3,
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.number,
                        decoration:
                            InputDecoration(contentPadding: EdgeInsets.all(10)),
                      ),
                    ),
                    Text('Z ='),
                    SizedBox(width: 20),
                    new Flexible(
                      child: new TextField(
                        controller: _controller3,
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.number,
                        decoration:
                            InputDecoration(contentPadding: EdgeInsets.all(10)),
                      ),
                    ),
                    SizedBox(width: 20),
                  ],
                ),
                SizedBox(height: 20),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      RaisedButton(
                          child: Text(
                            "Isoler les variables",
                            style: TextStyle(fontSize: 20),
                          ),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          textColor: Colors.white,
                          color: Colors.red,
                          onPressed: () {
                            calculMatrices();
                          }),
                    ]),
                new Text('Réponse :\n', style: TextStyle(fontSize: 20)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    new Text(resultX),
                    new Text(resultY),
                    new Text(resultZ)
                  ],
                ),
                new Text(ou),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    new Text(resultPrecisX),
                    new Text(resultPrecisY),
                    new Text(resultPrecisZ)
                  ],
                ),
                new Text(otherSolution),
                Align(
                    alignment: Alignment.bottomRight,
                    child: FloatingActionButton(
                      child: Icon(Icons.arrow_back),
                      backgroundColor: Colors.red,
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    )),
              ],
            )));
  }
}

class Balancement2Variables extends State<Balancement2VariablesWidget> {
  final TextEditingController _controllerX1 = TextEditingController();
  final TextEditingController _controllerX2 = TextEditingController();
  final TextEditingController _controllerY1 = TextEditingController();
  final TextEditingController _controllerY2 = TextEditingController();
  final TextEditingController _controller1 = TextEditingController();
  final TextEditingController _controller2 = TextEditingController();

  String resultX = '';
  String resultY = '';
  String ou = '';
  String resultPrecisX = '';
  String resultPrecisY = '';
  String otherSolution = '';

  Future calculMatrices() async {
    FocusScope.of(context).requestFocus(FocusNode());
    try {
      if (_controller1.text == '' ||
          _controller2.text == '' ||
          _controllerX1.text == '' ||
          _controllerX2.text == '' ||
          _controllerY1.text == '' ||
          _controllerY2.text == '') {
        throw ChampVide();
      }
      final denominateur = SquareMatrix(<List<double>>[
        <double>[
          double.parse(_controllerX1.text),
          double.parse(_controllerY1.text)
        ],
        <double>[
          double.parse(_controllerX2.text),
          double.parse(_controllerY2.text)
        ]
      ]);

      final numerateurX = SquareMatrix(<List<double>>[
        <double>[
          double.parse(_controller1.text),
          double.parse(_controllerY1.text)
        ],
        <double>[
          double.parse(_controller2.text),
          double.parse(_controllerY2.text)
        ]
      ]);

      final numerateurY = SquareMatrix(<List<double>>[
        <double>[
          double.parse(_controllerX1.text),
          double.parse(_controller1.text)
        ],
        <double>[
          double.parse(_controllerX2.text),
          double.parse(_controller2.text)
        ]
      ]);

      setState(() {
        if (denominateur.determinant() != 0 &&
            (numerateurX.determinant() != 0 ||
                numerateurY.determinant() != 0)) {
          otherSolution = "";
          resultX = "x = " +
              (numerateurX.determinant() / denominateur.determinant())
                  .toStringAsFixed(4);
          resultY = "y = " +
              (numerateurY.determinant() / denominateur.determinant())
                  .toStringAsFixed(4);
          ou = "ou plus précisément";
          resultPrecisX = "x = " +
              numerateurX.determinant().toStringAsFixed(0) +
              "/" +
              denominateur.determinant().toStringAsFixed(0);
          resultPrecisY = "y = " +
              numerateurY.determinant().toStringAsFixed(0) +
              "/" +
              denominateur.determinant().toStringAsFixed(0);
        } else if (denominateur.determinant() == 0 &&
            (numerateurX.determinant() != 0 ||
                numerateurY.determinant() != 0)) {
          resultX = '';
          resultY = '';
          ou = '';
          resultPrecisX = '';
          resultPrecisY = '';
          otherSolution =
              "Les droites sont parallèles dintinctes,\n il n'y a donc aucune solution";
        } else if (denominateur.determinant() == 0 &&
            numerateurX.determinant() == 0 &&
            numerateurY.determinant() == 0) {
          resultX = '';
          resultY = '';
          ou = '';
          resultPrecisX = '';
          resultPrecisY = '';
          otherSolution =
              "Les droites sont parallèles confondues,\n il n'y a donc une infinité de solutions";
        }
      });
    } on ChampVide {
      Fluttertoast.showToast(
          msg: "Il a un ou plusieurs champs vides.",
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM);
    } catch (error) {
      Fluttertoast.showToast(
          msg: error.toString(),
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomPadding: false,
        appBar: AppBar(
          title: Text("Balancement X, Y"),
          backgroundColor: Color.fromRGBO(255, 0, 0, 1),
        ),
        body: Padding(
            padding: EdgeInsets.only(
                top: 80.0, left: 20.0, right: 20.0, bottom: 20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                new Text(
                    "Veuillez entrer les coefficients pour chaque équation."),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    new Flexible(
                      child: new TextField(
                        controller: _controllerX1,
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.number,
                        decoration:
                            InputDecoration(contentPadding: EdgeInsets.all(10)),
                      ),
                    ),
                    Text('X +'),
                    SizedBox(width: 20),
                    new Flexible(
                      child: new TextField(
                        controller: _controllerY1,
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.number,
                        decoration:
                            InputDecoration(contentPadding: EdgeInsets.all(10)),
                      ),
                    ),
                    Text('Y ='),
                    SizedBox(width: 20),
                    new Flexible(
                      child: new TextField(
                        controller: _controller1,
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.number,
                        decoration:
                            InputDecoration(contentPadding: EdgeInsets.all(10)),
                      ),
                    ),
                    SizedBox(width: 20),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    new Flexible(
                      child: new TextField(
                        controller: _controllerX2,
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.number,
                        decoration:
                            InputDecoration(contentPadding: EdgeInsets.all(10)),
                      ),
                    ),
                    Text('X +'),
                    SizedBox(width: 20),
                    new Flexible(
                      child: new TextField(
                        controller: _controllerY2,
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.number,
                        decoration:
                            InputDecoration(contentPadding: EdgeInsets.all(10)),
                      ),
                    ),
                    Text('Y ='),
                    SizedBox(width: 20),
                    new Flexible(
                      child: new TextField(
                        controller: _controller2,
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.number,
                        decoration:
                            InputDecoration(contentPadding: EdgeInsets.all(10)),
                      ),
                    ),
                    SizedBox(width: 20),
                  ],
                ),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      RaisedButton(
                          child: Text("Isoler les variables",
                              style: TextStyle(fontSize: 20)),
                          textColor: Colors.white,
                          color: Colors.red,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          onPressed: () {
                            calculMatrices();
                          }),
                    ]),
                new Text('Réponse :', style: TextStyle(fontSize: 20)),
                new Text(
                  otherSolution,
                  style: TextStyle(fontSize: 20),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    new Text(resultX),
                    new Text(resultY),
                  ],
                ),
                new Text(ou),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    new Text(resultPrecisX),
                    new Text(resultPrecisY),
                  ],
                ),
                Align(
                    alignment: Alignment.bottomRight,
                    child: FloatingActionButton(
                      child: Icon(Icons.arrow_back),
                      backgroundColor: Colors.red,
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    )),
              ],
            )));
  }
}

class InfoPagePrincipale extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Guide d'utilisation"),
          backgroundColor: Color.fromRGBO(255, 0, 0, 1),
        ),
        body: Padding(
          padding: EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              new Expanded(
                child: new SingleChildScrollView(
                  child: new Text(
                    "*Faites défiler la page.*\n\n"
                    "PAGE PRINCIPALE :\n\n"
                    "- Pour prendre une équation en photo, appuyez sur le bouton au centre en bas de l'image. "
                    "Lorsque la photo sera prise, vous serez redirigé vers la fonction de rognage "
                    "qui vous permettra d'isoler l'équation à calculer.\n\n"
                    "- Lorsque l'équation est entrée dans la zone désignée à cet effet, appuyez sur (Calculer) afin d'obtenir le résultat.\n\n"
                    "- Appuyez sur l'icône de maison en bas à gauche pour retourner à la liste des modules.\n\n"
                    "- Appuyez sur les trois points situés à droite dans le haut de l'écran afin d'accéder aux autres calculs.\n"
                    "_________________________________________\n\n"
                    "CALCUL D'ÉQUATION QUADRATIQUE :\n\n"
                    "- Assurez vous d'isoler l'équation afin qu'elle soit égale à 0.\n\n"
                    "- Insérez les coefficients aux endroits désignés et appuyez sur (Calculer X1 et X2) afin d'obtenir le résultat.\n\n"
                    "- Appuyez sur l'icône de retour en bas à droite pour retourner à la page principale.\n\n"
                    "  ou\n\n"
                    "- Appuyez sur les trois points situés à droite dans le haut de l'écran afin d'accéder aux autres calculs.\n"
                    "_________________________________________\n\n"
                    "BALANCEMENT D'ÉQUATION :\n\n"
                    "- Insérez les coefficients aux endroits désignés et appuyez sur (Isoler les variables) afin d'obtenir "
                    "les valeurs de x et y pour le balancement à deux équations et deux variables ou x, y et z pour le balancement à "
                    "trois équations et trois variables.\n\n"
                    "- Appuyez sur l'icône de retour en bas à droite pour retourner à la page de sélection des variables. "
                    "Appuyez une deuxième fois pour retourner à la page principale.\n"
                    "_________________________________________\n\n"
                    "CALCUL DE DÉRIVÉE :\n\n"
                    "- Faites attention de mettre (*) entre les coefficients et les variables x.\n\n"
                    "- Utilisez (^) entre le la base et l'exposant.\n\n"
                    "- Utilisez (/) pour les divisions.\n\n"
                    "- Utilisez (sqrt()) pour les racines carrées. Les racines supérieurs doivent êtres inscrites à l'aide d'un exposant.\n\n"
                    "- La réponse est valable, mais non simplifiée afin que vous puissiez avoir toutes les valeurs calculées, vous devrez donc la simplifier manuellement.\n\n"
                    "- Appuyez sur l'icône de retour en bas à droite pour retourner à la page principale.\n",
                    style: new TextStyle(
                      fontSize: 20.0,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              Align(
                  alignment: Alignment.bottomRight,
                  child: FloatingActionButton(
                    child: Icon(Icons.arrow_back),
                    backgroundColor: Colors.red,
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  )),
            ],
          ),
        ));
  }
}

class ChampVide implements Exception {
  @override
  String toString() {
    return 'Veuillez vous assurer que tous les champs sont remplis.';
  }
}

class CoefficientZero implements Exception {
  @override
  String toString() {
    return '"a" ne peut pas valoir 0.';
  }
}
