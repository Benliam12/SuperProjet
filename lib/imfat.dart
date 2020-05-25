/*
Auteur du fichier : Éloïse
*/
import 'package:flutter/material.dart';
import 'package:login_app/imstoopid.dart';

class Modeles extends StatefulWidget {
  Modeles({Key key}) : super(key: key);
  @override
  _ModelesState createState() => _ModelesState();
}

class _ModelesState extends State<Modeles> {
  var nom = [
    "Plum Pudding",
    "Magnésium",
    "Orbitales",
  ];
  @override
  Widget build(BuildContext context) {
    return (Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlue[200],
        title: Text("Modèles atomiques"),
      ),
      body: Container(
          child: ListView.separated(
        separatorBuilder: (context, index) => Divider(
          color: Colors.white,
        ),
        itemCount: 3,
        itemBuilder: (context, index) {
          return SuperBouton(title: nom[index], id: index);
        },
      )),
    ));
  }
}

class SuperBouton extends StatelessWidget {
  final String title;
  final int id;
  SuperBouton({Key key, this.title, this.id}) : super(key: key);

  void changePage(BuildContext context, int id) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => GrosModeles(id: id)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 238,
        child: RaisedButton(
          child: Text(
            title,
            style: TextStyle(
              color: Colors.white,
              fontSize: 26,
            ),
          ),
          color: Colors.pink,
          onPressed: () => changePage(context, this.id),
        ));
  }
}
