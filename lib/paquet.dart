/*
Auteur du fichier : Randy
*/
import 'package:flutter/cupertino.dart';

import 'carte.dart';

class Paquet extends Object {
  String titre;
  String description;
  int nbFoisFait = 0;

  List<Carte> listCartes;

  Paquet(this.titre, this.description, this.listCartes, {ObjectKey key}) {}

  Paquet.fromJson(Map<String, dynamic> json, List<Carte> cartes) {
    titre = json['titre'];
    description = json['description'];
    listCartes = cartes;
    nbFoisFait = json['nbFoisFait'];
  }

  get paquet => null;

  Map<String, dynamic> toJson() => {
        'titre': titre,
        'description': description,
        'listCartes': listCartes,
        'nbFoisFait': nbFoisFait,
      };

  bool isLegit() {
    bool legit = true;
    for (int i = 0; i < this.listCartes.length; i++) {
      if (!this.listCartes.elementAt(i).isLegit()) return false;
    }

    return legit;
  }
}
