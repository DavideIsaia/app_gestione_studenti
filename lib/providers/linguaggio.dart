import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

class Linguaggio with ChangeNotifier {
  final String id;
  final String nome;
  final String descrizione;
  final String logo;
  final int progresso;
  // final Video video;
  // final Documento documenti;
  // final Collegamento collegamenti;

  Linguaggio({
    @required this.id,
    @required this.nome,
    @required this.descrizione,
    @required this.logo,
    @required this.progresso,
    // @required this.video,
    // @required this.documenti,
    // @required this.collegamenti,
  });
}

class Video with ChangeNotifier {
  final String link;
  final String nome;
  Video({
    @required this.link,
    @required this.nome,
  });
}

class Documento with ChangeNotifier {
  final String percorso;
  final String nome;
  final String nomeMostrato;
  Documento({
    @required this.percorso,
    @required this.nome,
    @required this.nomeMostrato,
  });
}

class Collegamento with ChangeNotifier {
  final String percorso;
  final String nome;
  Collegamento({
    @required this.percorso,
    @required this.nome,
  });
}
