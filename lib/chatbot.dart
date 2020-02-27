import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:login_app/setting_manager.dart';
import 'package:vibrate/vibrate.dart';

class ChatBot extends StatefulWidget {
  ChatBot({Key key}) : super(key: key);
  @override
  _ChatBotState createState() => _ChatBotState();
}

class _ChatBotState extends State<ChatBot> {
  void _addMessage(String message, bool user) {
    Widget w = ListView.builder(itemBuilder: (BuildContext context, int index) {
      return Text("HAHA");
    });
  }

  void _onSendMessage() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return (Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black87,
        title: Text("Assistance Chat"),
      ),
      body: Container(
        color: Colors.transparent,
        height: MediaQuery.of(context).size.height,
        child: Column(
          children: <Widget>[
            Expanded(
              child: ListView(
                children: <Widget>[
                  Container(height: 15),
                  Messages(
                      message: "Bonjour,\nLa vie est belle", reader: false),
                  Messages(message: "Intéressant"),
                  Messages(),
                  Messages(),
                  Messages(
                    reader: false,
                  ),
                  Messages(),
                  Messages(
                    message: "Bonjour",
                  ),
                  Messages(),
                  Messages(
                    reader: false,
                  ),
                  Messages(),
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
            Container(
              color: Colors.grey[100],
              child: Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Row(
                    children: <Widget>[
                      Flexible(
                        child: TextFormField(
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
                        onPressed: _onSendMessage,
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
                  child: SelectableText(
                    this.message,
                    style: TextStyle(color: this.textColor),
                    toolbarOptions: ToolbarOptions(
                      copy: true,
                      selectAll: true,
                    ),
                    scrollPhysics: ClampingScrollPhysics(),
                    onTap: () => {Vibrate.feedback(FeedbackType.error)},
                  )),
            )));
  }
}
