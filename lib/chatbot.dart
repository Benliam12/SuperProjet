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
  List<Messages> messages = [];
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
      messages.clear();
    });

    SettingsManager.getInstance().testRead();
  }

  Future<Messages> userQuestion(String message) async {
    message = myController.text;
    if (message.trim().length > 0) {
      return new Messages(
        message: message,
        reader: true,
      );
    } else {
      return null;
    }
  }

  Future<Messages> serverQuestion(String message) async {
    String url = "http://vps.benliam12.net:8000";
    Map<String, String> headers = {"Content-type": "application/json"};
    List<String> datas = new List<String>();
    datas.add(message);
    String json = jsonEncode(datas);

    http.Response response = await http.post(url, headers: headers, body: json);
    int statusCode = response.statusCode;
    String body = response.body;

    List<dynamic> responses = jsonDecode(body);
    String answer = "Il y a eu une erreur de traitement!";
    if (statusCode == 200) {
      answer = responses[0];
    }

    return new Messages(
      message: answer,
      reader: false,
    );
  }

  void serverQuestionRequest(String message) async {
    String url = "http://vps.benliam12.net:8000";
    Map<String, String> headers = {"Content-type": "application/json"};
    List<String> datas = new List<String>();
    datas.add(message);
    String json = jsonEncode(datas);

    http.Response response = await http.post(url, headers: headers, body: json);
    int statusCode = response.statusCode;
    String body = response.body;

    List<dynamic> responses = jsonDecode(body);
    setState(() {
      messages.add(new Messages(
        message: responses[0],
        reader: false,
      ));
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent +
            146, // Random value to make sure the scrolling is done to the end for average lenth messages.
        curve: Curves.easeOut,
        duration: const Duration(milliseconds: 300),
      );
    });
  }

  // When user sends message
  void _onSendMessage(BuildContext context,
      {bool user = true, String message = ""}) async {
    setState(() {
      message = myController.text;
      if (message.trim().length > 0) {
        List<String> splitString = message.split('');

        messages.add(new Messages(
          message: message,
          reader: true,
        ));

        serverQuestionRequest(message);

        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent +
              146, // Random value to make sure the scrolling is done to the end for average lenth messages.
          curve: Curves.easeOut,
          duration: const Duration(milliseconds: 300),
        );
      }
      myController.clear();
    });

    SettingsManager.getInstance().testWrite();
  }

  @override
  Widget build(BuildContext context) {
    return (Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black87,
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
                    itemCount: messages.length,
                    itemBuilder: (BuildContext ctxt, int index) {
                      return messages[index];
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
                                      color: Colors.blue, width: 1.0)),
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
                          color: Colors.blue[900],
                        ),
                        onPressed: () => {_onSendMessage(context)},
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
      this.color = Colors.blue;
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
