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

  String _test = "Login";  
  MaterialColor _color = Colors.blue;
  MaterialColor _mainColor = Colors.purple;
  String defaultImg = "\/images\/yR2rPnIczBCSEG1vJ6HfjyMRM3TtYX.jpg";

  Color hexToColor(String code) {
      return new Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
    }

  void _openSettings()
  {
    setState(() {
      _mainColor = Colors.blue;
      defaultImg = "\/images\/yR2rPnIczBCSEG1vJ6HfjyMRM3TtY.jpg";
    });
  }

  void _openProfile()
  {
    setState(() {
      _mainColor = Colors.purple;
    });
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    return MaterialApp(
      title: 'Flutter Demo',
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
        primaryColor: _mainColor,
      ),
      home: DefaultTabController
      (
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            leading: IconButton(
              icon: Icon(Icons.account_circle),
              onPressed: _openProfile,
            ),
            title: Text('Rate this =)'),
            actions: <Widget>[
              Padding(
                padding: EdgeInsets.only(right: 0),
                child: IconButton(
                  icon: Icon(Icons.settings),
                  onPressed: _openSettings,
                )
              )
            ],
            bottom: TabBar(
              indicatorColor: _mainColor,
              tabs: <Widget>[
                Tab(icon: Icon(Icons.thumb_up),),
                Tab(icon: Icon(Icons.assessment),),
              ],
            ),
          ),
          body: TabBarView(
            children: <Widget>[
              TopListViewWidget(),
              Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(50),
                  ),
                  SizedBox(
                    height: 125,
                    width: 125,
                    child: DecoratedBox(
                      decoration: BoxDecoration(color: Colors.transparent),
                      child: CachedNetworkImage(
                        imageUrl: MainApp.url + defaultImg,
                        placeholder: (context, url) => new CircularProgressIndicator(),
                        errorWidget: (context, url, error) => new Icon(Icons.error),
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
        )
      ),
    );
  }
}

class TopListViewWidget extends StatelessWidget
{
  void _topRequests()
  {


  }

   @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Card(
      color: Colors.transparent,
      elevation: 4.0,
      child: Container(
         width: screenWidth / 1.2,
         height: screenHeight / 1.7,
         decoration: BoxDecoration(
           color: Colors.white,
           borderRadius: BorderRadius.circular(8.0)
         ), 

         child: Column(
           children: <Widget>[
             Container(
               width: screenWidth / 1.2,
               height: screenWidth / 2.2,
               decoration: BoxDecoration(
                 borderRadius: BorderRadius.only(
                   topLeft: Radius.circular(8.0),
                   topRight: Radius.circular(8.0),
                 ),
               ),
             )
           ],
         ),
      ),
    );  
  }
}