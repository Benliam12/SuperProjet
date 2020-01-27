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
          color: Colors.transparent,
          child: Wrap(
            children: <Widget>[
              Container(height: 10,),
              Messages(),
              Messages(reader: false, message: "Bonjour",),
              Messages(),
              Messages(),
              Messages(message: "Salsssssssssssssssssssssssssssut",),
              Messages(),
              Messages(),
              Messages(),
              Messages(),
              Messages(),
              Messages(),
              Messages(),
              Messages(),
            ],
          ),
        ),
      )
    );
  }
}

class Messages extends StatelessWidget
{
  final String message;
  final bool reader;
  
  double readerReader = 20;
  double senderReader = 0;
  Color color = Colors.grey[300];
  Color textColor = Colors.black;
  Alignment alignment = Alignment.topLeft;

  Messages({Key key, 
    this.message = "A Simple Message",
    this.reader = true,
  }) : super(key:key);


  @override
  Widget build(BuildContext context)
  {
    if(reader)
    {
      this.senderReader = 20;
      this.readerReader = 0;
      this.color = Colors.blue;
      this.textColor = Colors.white;
      this.alignment = Alignment.topRight;
    }

    return Container(
      margin: EdgeInsets.only(bottom: 10.0, right:10.0, left: 10.0),
      child: Align(
        alignment: this.alignment,
        child: FittedBox(
          fit: BoxFit.fill, // otherwise the logo will be tiny
          child: Container(
              decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
                bottomLeft: Radius.circular(this.senderReader),
                bottomRight: Radius.circular(this.readerReader)
              ),
              color: this.color
            ),
            padding: EdgeInsets.all(10.0),
            child: Text(this.message, style:TextStyle(color: this.textColor)),
          ),
      )
      )
    );
  }
}