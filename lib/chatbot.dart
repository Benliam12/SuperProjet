import 'dart:developer';
import 'dart:async';
import 'dart:io';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:login_app/setting_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class ChatBot extends StatefulWidget {
  ChatBot({Key key}) : super(key: key);
  @override
  _ChatBotState createState() => _ChatBotState();
}

class _ChatBotState extends State<ChatBot> {
  final myController = TextEditingController();
  final _scrollController = ScrollController();
  List<Future<Messages>> messages2 = List<Future<Messages>>();
  List<FutureBuilder<Messages>> messageBuilders =
      List<FutureBuilder<Messages>>();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myController.dispose();
    super.dispose();
  }

  //Clear messages
  void _clearMessage() {
    setState(() {
      messageBuilders.clear();
    });

    SettingsManager.getInstance().testRead();
  }

  void makeControllers() {
    String message = myController.text;
    if (message.trim().length == 0) {
      return;
    }

    setState(() {
      FutureBuilder<Messages> builder1 = FutureBuilder<Messages>(
          future: userQuestion(message),
          builder: (context, snapshot) {
            return new Messages(
              message: message,
              reader: true,
            );
          });

      FutureBuilder<Messages> builder2 = FutureBuilder<Messages>(
          future: serverQuestion(message),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return new Messages(
                message: snapshot.data.message,
                reader: false,
              );
            }

            return new Messages(message: "...", reader: false);
          });
      messageBuilders.add(builder1);
      setState(() {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent + 100,
          curve: Curves.easeOut,
          duration: const Duration(milliseconds: 300),
        );
      });
      myController.clear();
      sleep(new Duration(milliseconds: 300));
      messageBuilders.add(builder2);
    });
  }

  Future<Messages> userQuestion(String message) async {
    setState(() {});
    return new Messages(
      message: message,
      reader: true,
    );
  }

  Future<Messages> serverQuestion(String message) async {
    String url = "http://vps.benliam12.net:8000";
    Map<String, String> headers = {"Content-type": "application/json"};
    List<String> datas = new List<String>();
    datas.add(message);
    String jsonString = jsonEncode(datas);

    http.Response response =
        await http.post(url, headers: headers, body: jsonString);
    int statusCode = response.statusCode;
    String body = response.body;

    List<dynamic> responses = jsonDecode(body);
    String answer = "Il y a eu une erreur de traitement!";
    if (statusCode == 200) {
      answer = responses[0];
      try {
        // if this is custom answer
        int indexCode = int.parse(answer);
        url = "http://dev.benliam12.net/chatbot/process.php";
        datas.clear();
        datas.add(indexCode.toString());
        jsonString = jsonEncode(datas);
        response = await http.post(url, headers: headers, body: jsonString);
        if (response.statusCode == 200) {
          answer = response.body;
          // answer = jsonDecode(response.body)[0];
        }
      } catch (e) {}
    }
    setState(() {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent + 100,
        curve: Curves.easeOut,
        duration: const Duration(milliseconds: 300),
      );
    });

    return new Messages(
      message: answer,
      reader: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return (Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightGreenAccent[700],
        title: Text("Assistance Chat"),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: _clearMessage,
          ),
        ],
      ),
      body: Container(
        color: Colors.transparent,
        height: MediaQuery.of(context).size.height,
        child: Column(
          children: <Widget>[
            Container(height: 15),
            Expanded(
                child: new ListView.builder(
                    controller: _scrollController,
                    itemCount: messageBuilders.length,
                    itemBuilder: (BuildContext ctxt, int index) {
                      return messageBuilders[index];
                    })),
            Container(
              color: Colors.grey[100],
              child: Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Row(
                    children: <Widget>[
                      Flexible(
                        child: TextFormField(
                          controller: myController,
                          validator: (value) {
                            if (value == null) {
                              return 'Please enter some text';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.green, width: 1.0)),
                              enabledBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.black, width: 1.0),
                              ),
                              labelStyle: TextStyle(color: Colors.black),
                              labelText: SettingsManager.getInstance()
                                  .getString("enter_message")),
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.send,
                          color: Colors.green,
                        ),
                        onPressed: makeControllers,
                      ),
                    ],
                  )),
            ),
          ],
        ),
      ),
    ));
  }
}

//Message Bubles
class Messages extends StatelessWidget {
  final String message;
  final bool reader;

  double readerReader = 20;
  double senderReader = 0;
  Color color = Colors.grey[300];
  Color textColor = Colors.black;
  Alignment alignment = Alignment.topLeft;

  Messages({
    Key key,
    this.message = "A Simple Message",
    this.reader = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (reader) {
      this.senderReader = 20;
      this.readerReader = 0;
      this.color = Colors.green;
      this.textColor = Colors.white;
      this.alignment = Alignment.topRight;
    }

    return Container(
        width: MediaQuery.of(context).size.width * 0.50,
        margin: EdgeInsets.only(bottom: 10.0, right: 10.0, left: 10.0),
        child: Align(
            alignment: this.alignment,
            child: FittedBox(
              //fit: BoxFit.fill, // otherwise the logo will be tiny
              child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                          bottomLeft: Radius.circular(this.senderReader),
                          bottomRight: Radius.circular(this.readerReader)),
                      color: this.color),
                  padding: EdgeInsets.all(10.0),
                  child: LimitedBox(
                      maxWidth: 205,
                      child: SelectableText(
                        this.message,
                        style: TextStyle(color: this.textColor),
                        toolbarOptions: ToolbarOptions(
                          copy: true,
                          selectAll: true,
                        ),
                        scrollPhysics: ClampingScrollPhysics(),
                        onTap: () => {},
                      ))),
            )));
  }
}
