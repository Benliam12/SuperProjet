class Carte {
  String devant;
  String derriere;

  Carte();

  Carte.fromJson(Map<String, dynamic> json) {
    devant = json['devant'];
    derriere = json['derriere'];
  }

  Map<String, dynamic> toJson() => {
        'devant': devant,
        'derriere': derriere,
      };

  bool isLegit() {
    return (devant != null && derriere != null);
  }
}
