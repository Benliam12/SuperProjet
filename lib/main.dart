import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:cached_network_image/cached_network_image.dart';

void main() => runApp(MainApp());


class MainApp extends StatelessWidget
{
  static String url = "http://ratethis.benliam12.net";
  Widget build(BuildContext context)
  {
     return MaterialApp(
       home: MyApp()
     );
  }
}

class MyApp extends StatefulWidget
{
  MyApp({Key key}) : super(key:key);
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends  State<MyApp> {

  void _btn()
  {

  }

  @override
  Widget build(BuildContext context)
  {
    return(
      Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.clear_all),
            onPressed: _btn,
          ),
          backgroundColor: Colors.black87,
          title: Text("Super App"),
        ),

        body: Container(
          color: Colors.white,
        ),
      )
    );
  }
}