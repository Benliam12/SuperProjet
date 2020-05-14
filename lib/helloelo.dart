import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:math_expressions/math_expressions.dart';
import 'dart:math' as math;
import 'package:http/http.dart' as http;
import 'package:convert/convert.dart';

class HelloElo extends StatefulWidget {
  HelloElo({Key key}) : super(key: key);
  @override
  _HelloEloState createState() => _HelloEloState();
}

class _HelloEloState extends State<HelloElo> {
  Future<http.Response> sendData(String data) {
    return http.post('http://vps.benliam12.net:8000',
        headers: <String, String>{
          'Content-type': 'application/json; charset=UTF-8',
        },
        body: toJson());
  }

  Map<String, dynamic> toJson() => {};

  void _test() {
    _makePostRequest();
  }

  _randyPostRequest() async {
    String url = "http://vps.benliam12.net:8000";
    Map<String, String> headers = {"Content-type": "application/json"};

    List<double> datas = List<double>();
    datas.add(0.8); // data 1
    datas.add(0.8); // data 2
    String json = jsonEncode(datas);
    http.Response response = await http.post(url, headers: headers, body: json);
    int statusCode = response.statusCode;
    String body = response.body;
    print('$body - $statusCode'); // Body est la valeur de retour.
  }

  _makePostRequest() async {
    String url = "http://vps.benliam12.net:8000";
    Map<String, String> headers = {"Content-type": "application/json"};

    var matrix = [
      [1.0, 0.0, 1.0, 0.0],
      [3.0, 0.0, 0.0, 2.0],
      [0.0, 2.0, 1.0, 1.0]
    ];

    String json2 = jsonEncode(matrix);

    http.Response response =
        await http.post(url, headers: headers, body: json2);
    int statusCode = response.statusCode;
    String body = response.body;
    print('$body - $statusCode');

    String newbody = body.replaceAll('{', '').replaceAll('}', '');

    var firstSplit = newbody.split(', ');
    var secondsplit = {};

    for (var i = 0; i < firstSplit.length; i++) {
      var t = firstSplit[i].split(':');
      var letter = t[0].replaceAll('\"', '');
      var answer = t[1].replaceAll('"', '');
      secondsplit[letter] = answer;
    }

    var alp = "a".codeUnitAt(0);
    var alp2 = "a".codeUnitAt(0);
    var alp_end = "z".codeUnitAt(0);

    var listValeurs = {};

    while (alp <= alp_end) {
      var letter = new String.fromCharCode(alp);
      if (!secondsplit.containsKey(letter)) {
        break;
      }
      alp++;
    }

    for (alp2 = "a".codeUnitAt(0); alp2 < alp; alp2++) {
      var let = new String.fromCharCode(alp);
      var curLet = new String.fromCharCode(alp2);
      listValeurs[curLet] = secondsplit[curLet].replaceAll("*$let", '');
    }

    print(new String.fromCharCode(alp));

    print(json.encode(listValeurs));
  }

  void _testingEloShit() {
    String output = "{c: 2.0*d, b: d, a: d}";

    Map jsonTest = jsonDecode(output);

    print(jsonTest.containsKey("a"));
  }

  @override
  Widget build(BuildContext context) {
    return (Scaffold(
      appBar: AppBar(
        title: Text("Elo script"),
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.system_update),
              onPressed: _testingEloShit,
            )
          ],
        ),
      ),
    ));
  }
}
