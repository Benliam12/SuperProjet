import 'package:flutter/cupertino.dart';

class Atome {
  static bool isNumeric(String s) {
    if (s == null) {
      return false;
    }
    return double.parse(s, (e) => null) != null;
  }

  static void fonctionTest(List atome, List nb, var text) {
    for (int i = 0; i < text.length; i++) {
      if (isNumeric(text[i]) == false) {
        //si pas un chiffre

        if (text[i] == "(") {
          if (text[i + 1] == text[i + 1].toUpperCase()) {
            //si maj
            if (text[i + 2] == text[i + 2].toUpperCase()) {
              //si prochain maj
              atome.add(text[i + 1]);
              atome.add(text[i + 2]);
              if (text.length > i + 4) {
                nb.add(int.parse(text[i + 4]));
                nb.add(int.parse(text[i + 4]));
              } else {
                nb.add(1);
              }
            } else {
              //si maj et min
              atome.add(text[i + 1] + text[i + 2]);
              if (text.length > i + 4) {
                nb.add(int.parse(text[i + 4]));
              } else {
                nb.add(1);
              }
            }
          }
        }

        if (text[i] == text[i].toUpperCase()) {
          //si maj
          if (text.length > i + 1) {
            //si prochain existe
            if (isNumeric(text[i + 1])) {
              //si prochain est chiffre
              atome.add(text[i]);
              nb.add(int.parse(text[i + 1]));
            } else if (text[i + 1] == text[i + 1].toUpperCase()) {
              //si prochain est maj
              atome.add(text[i]);
              nb.add(1);
            } else if (text[i + 1] != text[i + 1].toUpperCase()) {
              //si prochain pas maj
              if (text.length > i + 2) {
                //si 2 prochain existe
                if (isNumeric(text[i + 2])) {
                  //si 2 prochain est chiffre
                  atome.add(text[i] + text[i + 1]);
                  nb.add(int.parse(text[i + 2]));
                } else {
                  //si 2 prochain pas un chiffre
                  atome.add(text[i] + text[i + 1]);
                  nb.add(1);
                }
              } else {
                //si 2 prochain existe pas
                atome.add(text[i] + text[i + 1]);
                nb.add(1);
              }
            } else if (text[i + 1] == text[i + 1].toUpperCase()) {
              //si prochain maj
              atome.add(text[i]);
              nb.add(1);
            }
          } else {
            //si prochain existe pas
            atome.add(text[i]);
            nb.add(1);
          }
        }
      }
    }
  }

  static int NbElements(List list) {
    List diffAtomes = new List();

    for (int i = 0; i < list.length; i++) {
      for (int j = 0; j < list[i].length; j++) {
        if (!diffAtomes.contains(list[i][j])) {
          diffAtomes.add(list[i][j]);
        }
      }
    }
    return diffAtomes.length;
  }

  static void CreerMatrice(atomesReactifsTotal, nbReactifsTotal,
      atomesProduitsTotal, nbProduitsTotal, matrix) {
    List diffAtomes = new List();
    //List<List<int>> matrix = new List<List<int>>();

    for (int i = 0; i < atomesReactifsTotal.length; i++) {
      //on commence par la première molécule

      for (int j = 0; j < atomesReactifsTotal[i].length; j++) {
        List<double> list = new List<double>();
        //on regarde la première lettre
        if (!diffAtomes.contains(atomesReactifsTotal[i][j])) {
          //si pas encore fait atome on l'ajoute
          diffAtomes.add(atomesReactifsTotal[i][j]);

          for (int k = 0; k < atomesReactifsTotal.length; k++) {
            if (atomesReactifsTotal[k].contains(atomesReactifsTotal[i][j])) {
              int position =
                  atomesReactifsTotal[k].indexOf(atomesReactifsTotal[i][j]);
              var indice =
                  double.parse(nbReactifsTotal[k][position].toString());
              list.add(indice);
            } else {
              list.add(0);
            }
          }

          for (int k = 0; k < atomesProduitsTotal.length; k++) {
            if (atomesProduitsTotal[k].contains(atomesReactifsTotal[i][j])) {
              int position =
                  atomesProduitsTotal[k].indexOf(atomesReactifsTotal[i][j]);
              var indice =
                  double.parse(nbProduitsTotal[k][position].toString());
              list.add(indice);
            } else {
              list.add(0);
            }
          }
          matrix.add(list);
        }
      }
    }
    //print(matrix);
  }

  static void ResoudreMatrice(matrix) {
    print("resoudrematrice");

    int i = 0;
    int j = 0;
    int r = 0;
    int k = 0;
    int l = 0;

    for (j = 0; j < matrix[0].length; j++) {
      print(j);
      print(i);
      print(matrix);

      double max = 0;
      for (i = r; i < matrix.length; i++) {
        if (max <= matrix[i][j]) {
          max = matrix[i][j];
          k = i;
        }
      }
      print(max);

      if (max == 0) {
        return;
      }

      if (matrix[k][j] != 0) {
        r = r + 1;
        for (l = 0; l < matrix[k].length; l++) {
          matrix[k][l] /= max;
        }

        if (k != (r - 1)) {
          List<double> temp = new List<double>();
          for (l = 0; l < matrix[k].length; l++) {
            temp.add(matrix[k][l]);
            matrix[k][l] = matrix[r - 1][l];
            matrix[r - 1][l] = temp[l];
            print("allo");
          }
        }

        i = r;

        for (int b = 0; b < matrix.length; b++) {
          if (matrix[b][j] != 0 && b != (i - 1)) {
            for (l = 0; l < matrix[0].length; l++) {
              matrix[b][l] -= (matrix[(i - 1)][l]);
            }
          }
        }
      }
    }
  }

  //inutile
  static void fonctionTest2(List atome, List nb, var text) {
    for (int i = 0; i < text.length; i++) {
      if (isNumeric(text[i]) == false) {
        //si pas un chiffre
        if (text[i] == "(") {
          if (text[i + 1] == text[i + 1].toUpperCase()) {
            //si maj
            if (text[i + 2] == text[i + 2].toUpperCase()) {
              //si prochain maj
              atome.add(text[i + 1]);
              atome.add(text[i + 2]);
              if (text.length > i + 4) {
                nb.add(int.parse(text[i + 4]));
                nb.add(int.parse(text[i + 4]));
              } else {
                nb.add(1);
              }
            } else {
              //si maj et min
              atome.add(text[i + 1] + text[i + 2]);
              if (text.length > i + 4) {
                nb.add(int.parse(text[i + 4]));
              } else {
                nb.add(1);
              }
            }
          }
        }

        if (text[i] == text[i].toUpperCase()) {
          //si maj
          if (text.length > i + 1) {
            //si prochain existe
            if (isNumeric(text[i + 1])) {
              //si prochain est chiffre
              atome.add(text[i]);
              if (text.length > i + 2) {
                if (isNumeric(text[i + 2])) {
                  //si 2 prochains est chiffre
                  nb.add(int.parse(text[i + 1] + text[i + 2]));
                }
              } else {
                //sinon
                nb.add(int.parse(text[i + 1]));
              }
            } else if (text[i + 1] == text[i + 1].toUpperCase()) {
              //si prochain est maj
              atome.add(text[i]);
              nb.add(1);
            } else if (text[i + 1] != text[i + 1].toUpperCase()) {
              //si prochain pas maj
              if (text.length > i + 2) {
                //si 2 prochain existe
                if (isNumeric(text[i + 2])) {
                  //si 2 prochain est chiffre
                  atome.add(text[i] + text[i + 1]);
                  if (text.length > i + 3) {
                    if (isNumeric(text[i + 3])) {
                      //si 3 prochain est chiffre
                      nb.add(int.parse(text[i + 2] + text[i + 3]));
                    }
                  } else {
                    //sinon
                    nb.add(int.parse(text[i + 2]));
                  }

                  nb.add(int.parse(text[i + 2]));
                } else {
                  //si 2 prochain pas un chiffre
                  atome.add(text[i] + text[i + 1]);
                  nb.add(1);
                }
              } else {
                //si 2 prochain existe pas
                atome.add(text[i] + text[i + 1]);
                nb.add(1);
              }
            } else if (text[i + 1] == text[i + 1].toUpperCase()) {
              //si prochain maj
              atome.add(text[i]);
              nb.add(1);
            }
          } else {
            //si prochain existe pas
            atome.add(text[i]);
            nb.add(1);
          }
        }
      }
    }
  }
}
