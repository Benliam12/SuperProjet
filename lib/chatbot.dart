import 'package:flutter/material.dart';
import 'package:login_app/setting_manager.dart';

class ChatBot extends StatefulWidget {
  ChatBot({Key key}) : super(key: key);
  @override
  _ChatBotState createState() => _ChatBotState();
}

class _ChatBotState extends State<ChatBot> {
  @override
  Widget build(BuildContext context) {
    return (Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black87,
        title: Text("Super App"),
      ),
      body: Container(
        color: Colors.transparent,
        height: MediaQuery.of(context).size.height,
        child: Column(
          children: <Widget>[
            Expanded(
              child: ListView(
                children: <Widget>[
                  Messages(),
                  Messages(),
                  Messages(),
                  Messages(),
                  Messages(
                    reader: false,
                  ),
                  Messages(),
                  Messages(
                    message: "You're nice",
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
                  Messages(),
                  Messages(),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(10.0),
              child: TextFormField(
                validator: (value) {
                  if (value == null) {
                    return 'Please enter some text';
                  }
                  return null;
                },
                decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue, width: 1.0)),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black, width: 1.0),
                    ),
                    hintText: "HAHA",
                    labelText: SettingsManager.getInstance()
                        .getString("enter_message")),
              ),
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
              fit: BoxFit.fill, // otherwise the logo will be tiny
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
                    toolbarOptions: ToolbarOptions(copy: true),
                    scrollPhysics: ClampingScrollPhysics(),
                    maxLines: 1,
                  )),
            )));
  }
}
