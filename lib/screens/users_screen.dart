// ignore_for_file: prefer_const_constructors, missing_return

import 'package:app_gestione_studenti/providers/users.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/app_drawer.dart';
import '../providers/user.dart';
import '../providers/users.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class UsersScreen extends StatefulWidget {
  static const routeName = '/utenti';

  @override
  State<UsersScreen> createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
  var _isLoading = false;
  List<User> _students = [];

  List<DropdownMenuItem<String>> get dropdownItems {
    List<DropdownMenuItem<String>> menuItems = [
      DropdownMenuItem(child: Text("FRADM"), value: "FRADM"),
      DropdownMenuItem(child: Text("FRUSR"), value: "FRUSR"),
    ];
    return menuItems;
  }

  String selectedValue = "Ruolo";

  List<User> get students {
    return [..._students];
  }

  // @override
  // void initState() {
  //   Future.delayed(Duration.zero).then((_) async {
  //     setState(() {
  //       _isLoading = true;
  //     });
  //     await Provider.of<_UsersScreenState>(context, listen: false)
  //         .fetchAndSetUsers();
  //     setState(() {
  //       _isLoading = false;
  //     });
  //   });
  //   super.initState();
  // }

  Future<void> fetchAndSetUsers() async {
    var url = 'https://formazione-reactive-api-rest.herokuapp.com/utenti';
    // mancantiLibreria/{user}
    // assegnaLinguaggi POST
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body);
      // print(extractedData);
      if (extractedData == null) {
        return;
      }
      final List<User> loadedUsers = [];
      extractedData.forEach((userData) {
        loadedUsers.add(User(
          username: userData["username"],
          ruolo: userData["ruolo"],
          nome: userData["nome"],
          cognome: userData["cognome"],
        ));
      });
      _students = loadedUsers;
      // print(_students[0].username);
    } catch (e) {
      throw e;
    }
  }

  void _submitData() {
    //per far chiudere da solo il foglio di input dopo che premiamo invio
    Navigator.of(context).pop();
  }

  void _startAddUser(BuildContext ctx) {
    showModalBottomSheet(
        context: ctx,
        builder: (_) {
          return GestureDetector(
            onTap: () {},
            behavior: HitTestBehavior.opaque,
            child: Card(
              elevation: 5,
              child: Container(
                padding: EdgeInsets.all(30),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      TextField(
                          decoration: InputDecoration(labelText: 'Nome'),
                          onSubmitted: (_) => _submitData),
                      TextField(
                          decoration: InputDecoration(labelText: 'Cognome'),
                          onSubmitted: (_) => _submitData),
                      TextField(
                          decoration: InputDecoration(labelText: 'Username'),
                          onSubmitted: (_) => _submitData),
                      TextField(
                          decoration: InputDecoration(labelText: 'Password'),
                          onSubmitted: (_) => _submitData),
                      DropdownButtonFormField(
                          validator: (value) =>
                              value == null ? "Selezionare un ruolo" : null,
                          value: selectedValue,
                          onChanged: (String newValue) {
                            setState(() {
                              selectedValue = newValue;
                            });
                          },
                          items: dropdownItems),
                      ElevatedButton(
                          onPressed: _submitData, child: Text('Crea'))
                    ]),
              ),
            ),
          );
        });
  }

  Future<void> addUser(User user) async {
    const url = '';
    try {
      final response = await http.post(url,
          body: json.encode({
            "nome": user.nome,
            "cognome": user.cognome,
            "username": user.username,
            "password": user.password,
            "ruolo": user.ruolo,
          }));
      final newUser = User(
        nome: user.nome,
        cognome: user.cognome,
        username: user.username,
        password: user.password,
        ruolo: user.ruolo,
      );
      _students.add(newUser);
      // _students.insert(0, newUser); // lo inserisce all'inizio della lista
      // notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  @override
  Widget build(BuildContext context) {
    // con questo metodo darebbe loop infinito, quindi uso un Consumer
    // final orderData = Provider.of<Users>(context);
    fetchAndSetUsers();
    return Scaffold(
      appBar: AppBar(
        title: Text('Utenti'),
      ),
      drawer: AppDrawer(),
      body: ListView.builder(
        itemCount: _students.length,
        itemBuilder: (context, i) {
          return ListTile(
            title: Text(_students[i].cognome),
            subtitle: Text(_students[i].nome),
          );
        },
      ),

      // body: FutureBuilder(
      //     future: Provider.of<_UsersScreenState>(context, listen: false)
      //         .fetchAndSetUsers(),
      //     builder: ((context, snapshot) {
      //       if (snapshot.connectionState == ConnectionState.waiting) {
      //         return Center(child: CircularProgressIndicator());
      //       } else {
      //         if (snapshot.error != null) {
      //           return Center(child: Text('Errore!'));
      //         } else {
      //           return Consumer<_UsersScreenState>(
      //               builder: (ctx, userData, child) => ListView.builder(
      //                   itemBuilder: ((ctx, i) => ListTile(
      //                         title: Text(_students[i].cognome),
      //                         subtitle: Text(_students[i].nome),
      //                         trailing: Text(_students[i].ruolo),
      //                       ))));
      //         }
      //       }
      //     }))

      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: ElevatedButton(
        style: ElevatedButton.styleFrom(

            //internal content margin
            ),
        child: Text("Crea utente"),
        onPressed: () => _startAddUser(context),
      ),
    );
  }
}
