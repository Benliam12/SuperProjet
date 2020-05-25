/*
Auteur du fichier : William
*/
import 'dart:async';
import 'dart:io';
import 'dart:convert';

import 'package:flutter/material.dart';
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
  }

  void makeControllers() {
    String message = myController.text;
    if (message.trim().length == 0) {
      return;
    }

    setState(() {
      //User's message
      FutureBuilder<Messages> builder1 = FutureBuilder<Messages>(
          future: userQuestion(message),
          builder: (context, snapshot) {
            return new Messages(
              message: message,
              reader: true,
            );
          });

      //System's message
      FutureBuilder<Messages> builder2 = FutureBuilder<Messages>(
          future: serverQuestion(message),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return new Messages(
                message: snapshot.data.message,
                reader: false,
              );
            }

            //Show when waiting for server response.
            return new Messages(message: "...", reader: false);
          });

      //Add to Message list
      messageBuilders.add(builder1);
      setState(() {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent + 100,
          curve: Curves.easeOut,
          duration: const Duration(milliseconds: 300),
        );
      });

      //Clear user inputs
      myController.clear();
      sleep(new Duration(milliseconds: 300)); //Smoothing animation

      //Add to Message list
      messageBuilders.add(builder2);
    });
  }

  Future<Messages> userQuestion(String message) async {
    return new Messages(
      message: message,
      reader: true,
    );
  }

  //Request to Server
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
        }
      } catch (e) {}
    }
    setState(() {
      //Animate the messages
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

  //Main stuff
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
                              return 'Veuillez enter du texte';
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
                          ),
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

//Message Bubbles
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
