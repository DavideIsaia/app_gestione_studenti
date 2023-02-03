import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth.dart';
import '../screens/users_screen.dart';
import '../widgets/app_drawer.dart';
import '../providers/user.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../providers/linguaggio.dart';

class UserDetailScreen extends StatefulWidget {
  static const routeName = '/dettagli-user';

  @override
  State<UserDetailScreen> createState() => _UserDetailScreenState();
}

class _UserDetailScreenState extends State<UserDetailScreen> {
  List<Linguaggio> _linguaggi = [];

  List<Linguaggio> get linguaggi {
    return [..._linguaggi];
  }

  Future<void> linguaggiDaAssegnare() async {
    var url =
        'https://formazione-reactive-api-rest.herokuapp.com/mancantiLibreria/Davide';
    // assegnaLinguaggi POST
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body);
      print(extractedData);
      if (extractedData == null) {
        return;
      }
      final List<Linguaggio> loadedLangs = [];
      extractedData.forEach((langData) {
        loadedLangs.add(Linguaggio(
          id: langData["id"],
          nome: langData["nome"],
          descrizione: langData["descrizione"],
          logo: langData["logo"],
          progresso: langData["progresso"],
          // video: langData["video"],
          // documenti: langData["documenti"],
          // collegamenti: langData["collegamenti"],
        ));
      });
      _linguaggi = loadedLangs;
      // print(_linguaggi[0].nome);
    } catch (e) {
      throw e;
    }
  }

  @override
  Widget build(BuildContext context) {
    linguaggiDaAssegnare();
    return Scaffold(
      appBar: AppBar(
        title: Text("Assegna linguaggi"),
      ),
      drawer: AppDrawer(),
      body: ListView.builder(
        itemCount: _linguaggi.length,
        itemBuilder: (context, i) {
          return Card(
            child: ListTile(
              leading: SizedBox(
                height: 100.0,
                width: 200.0,
                child: Image.network(
                  "https://formazionereactive.herokuapp.com/assets/img/linguaggi/${_linguaggi[i].logo}",
                  fit: BoxFit.contain,
                ),
              ),
              title: Text(_linguaggi[i].nome),
              // subtitle: Text(_linguaggi[i].descrizione),
            ),
          );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: ElevatedButton(
        child: Text("Assegna"),
        onPressed: () => null,
      ),
    );
  }
}
