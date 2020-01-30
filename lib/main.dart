import 'package:flutter/material.dart';
import 'package:login_app/setting_manager.dart';

import 'chatbot.dart';

void main() {
  ///Setting up required datas.
  SettingsManager.getInstance().setup();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Student tool kit',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.purple,
      ),
      home: MyHomePage(title: "Student Tool kit"),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Activities> items = null;

  var colors = [
    Colors.blue,
    Colors.red,
    Colors.purple,
    Colors.green,
    Colors.pink
  ];
  var title = [
    "Flash Card",
    "Calendar",
    "Chimistry Calculator",
    "Assistant Chat",
    "Stats"
  ];

  void _settings() {
    setState(() {
      colors = [
        Colors.blue,
        Colors.red,
        Colors.purple,
        Colors.green,
        Colors.pink
      ];
      title = [
        "Flash Card",
        "Calendar",
        "Chimistry Calculator",
        "Assistant Chat",
        "Stats"
      ];
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
        appBar: PreferredSize(
            preferredSize: Size.fromHeight(100.0),
            child: Container(
              color: Colors.blue.shade200,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(15.0),
                  ),
                  Text(
                    widget.title,
                    style: TextStyle(
                      fontSize: 30.0,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            )),
        body: ListView.builder(
          itemCount: 5,
          itemBuilder: (context, index) {
            return Activities(
                color: colors[index], title: title[index], id: index);
          },
        ));
  }
}

class Activities extends StatelessWidget {
  final Color color;
  final String title;
  final int id;
  Activities({Key key, this.color, this.title, @required this.id})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 160,
        child: RaisedButton(
          child: Text(
            title,
            style: TextStyle(
              color: Colors.white,
              fontSize: 26,
            ),
          ),
          color: this.color,
          onPressed: () => test(context),
        ));
  }

  void test(BuildContext context) {
    if (this.id == 3) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ChatBot()),
      );

      return;
    }

    final scaffold = Scaffold.of(context);
    Scaffold.of(context).showSnackBar(SnackBar(
      backgroundColor: Colors.white,
      duration: Duration(milliseconds: 600),
      content: Container(
        height: 60,
        child: Text(
          this.title,
          style: TextStyle(
              color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
      ),
      action: SnackBarAction(
          textColor: Colors.black54,
          label: 'HIDE',
          onPressed: scaffold.hideCurrentSnackBar),
    ));
  }
}
