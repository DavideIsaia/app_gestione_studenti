// ignore_for_file: prefer_const_constructors, missing_return

import 'package:app_gestione_studenti/providers/users.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/app_drawer.dart';
import '../providers/user.dart';
import '../providers/users.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import './user_detail_screen.dart';
import 'package:email_validator/email_validator.dart';

class UsersScreen extends StatefulWidget {
  static const routeName = '/utenti';

  @override
  State<UsersScreen> createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
  var _isLoading = false;
  List<User> _students = [];

  final _form = GlobalKey<FormState>();
  final _cognomeFocusNode = FocusNode();
  final _usernameFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();
  final _emailFocusNode = FocusNode();
  final _ruoloFocusNode = FocusNode();
  var _editedUser = User(
    nome: "",
    cognome: "",
    username: "",
    password: "",
    email: "",
    ruolo: "",
  );

  List<DropdownMenuItem<String>> get dropdownItems {
    List<DropdownMenuItem<String>> menuItems = [
      DropdownMenuItem(child: Text("FRADM"), value: "FRADM"),
      DropdownMenuItem(child: Text("FRUSR"), value: "FRUSR"),
    ];
    return menuItems;
  }

  String selectedValue = "FRUSR";

  List<User> get students {
    return [..._students];
  }

  @override
  void dispose() {
    // aggiungere sempre i dispose per liberare spazio in memoria
    //quando si usano i form
    _cognomeFocusNode.dispose();
    _usernameFocusNode.dispose();
    _passwordFocusNode.dispose();
    _emailFocusNode.dispose();
    _ruoloFocusNode.dispose();
    super.dispose();
  }

  Future<void> fetchAndSetUsers() async {
    var url = 'https://formazione-reactive-api-rest.herokuapp.com/utenti';
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
          email: userData["email"],
        ));
      });
      _students = loadedUsers;
      // print(_students[0].username);
    } catch (e) {
      throw e;
    }
  }

  Future<void> _submitData(User user) async {
    const url = 'https://formazione-reactive-api-rest.herokuapp.com/creaUtente';
    var body = {
      "nome": user.nome,
      "cognome": user.cognome,
      "username": user.username,
      "password": user.password,
      "email": user.email,
      "ruolo": user.ruolo,
    };
    final response = await http.post(
      url,
      headers: {
        "content-type": "application/json",
        "accept": "application/json",
      },
      body: json.encode(body),
    );
    // print("REQUEST");
    // print(response.request);
    // print("Headers");
    // print(response.headers);
    print("BODY");
    print(json.encode(body));
    print("RESPONSE");
    print(response.body);
    final newUser = User(
      nome: user.nome,
      cognome: user.cognome,
      username: user.username,
      password: user.password,
      email: user.email,
      ruolo: user.ruolo,
    );
    // _students.insert(0, newUser); // lo inserisce all'inizio della lista
    _students.add(newUser);
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
              child: Form(
                key: _form,
                child: Container(
                  padding: EdgeInsets.all(10),
                  child: Column(children: [
                    Row(
                      children: [
                        Flexible(
                          child: Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: TextFormField(
                              decoration: InputDecoration(labelText: 'Nome'),
                              textInputAction: TextInputAction.next,
                              onFieldSubmitted: (_) {
                                FocusScope.of(context).requestFocus(
                                    _cognomeFocusNode); //premendo avanti passa il focus dal primo input al secondo (perchè l'input seguente ha la proprietà focusNode)
                              },
                              onSaved: ((userInputValue) {
                                _editedUser = User(
                                  nome: userInputValue,
                                  cognome: _editedUser.cognome,
                                  username: _editedUser.username,
                                  password: _editedUser.password,
                                  email: _editedUser.email,
                                  ruolo: _editedUser.ruolo,
                                );
                              }),
                            ),
                          ),
                        ),
                        Flexible(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: TextFormField(
                              decoration: InputDecoration(labelText: 'Cognome'),
                              textInputAction: TextInputAction.next,
                              focusNode: _cognomeFocusNode,
                              onSaved: ((userInputValue) {
                                _editedUser = User(
                                  nome: _editedUser.nome,
                                  cognome: userInputValue,
                                  username: _editedUser.username,
                                  password: _editedUser.password,
                                  email: _editedUser.email,
                                  ruolo: _editedUser.ruolo,
                                );
                              }),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(children: [
                      Flexible(
                        child: Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: TextFormField(
                            decoration: InputDecoration(labelText: 'Username'),
                            textInputAction: TextInputAction.next,
                            focusNode: _usernameFocusNode,
                            onSaved: ((userInputValue) {
                              _editedUser = User(
                                nome: _editedUser.nome,
                                cognome: _editedUser.cognome,
                                username: userInputValue,
                                password: _editedUser.password,
                                email: _editedUser.email,
                                ruolo: _editedUser.ruolo,
                              );
                            }),
                          ),
                        ),
                      ),
                      Flexible(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: TextFormField(
                            // obscureText: true,
                            decoration: InputDecoration(labelText: 'Password'),
                            textInputAction: TextInputAction.next,
                            focusNode: _passwordFocusNode,
                            onSaved: ((userInputValue) {
                              _editedUser = User(
                                nome: _editedUser.nome,
                                cognome: _editedUser.cognome,
                                username: _editedUser.username,
                                password: userInputValue,
                                email: _editedUser.email,
                                ruolo: _editedUser.ruolo,
                              );
                            }),
                          ),
                        ),
                      ),
                    ]),
                    Row(
                      children: [
                        Flexible(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(0, 5, 10, 0),
                            child: TextFormField(
                              validator: (value) =>
                                  EmailValidator.validate(value)
                                      ? null
                                      : "Inserire una email valida",
                              decoration: InputDecoration(labelText: 'Email'),
                              textInputAction: TextInputAction.next,
                              focusNode: _emailFocusNode,
                              keyboardType: TextInputType.emailAddress,
                              onSaved: ((userInputValue) {
                                _editedUser = User(
                                  nome: _editedUser.nome,
                                  cognome: _editedUser.cognome,
                                  username: _editedUser.username,
                                  password: _editedUser.password,
                                  email: userInputValue,
                                  ruolo: _editedUser.ruolo,
                                );
                              }),
                            ),
                          ),
                        ),
                        Flexible(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: DropdownButtonFormField(
                              decoration: InputDecoration(labelText: 'Ruolo'),
                              focusNode: _ruoloFocusNode,
                              validator: (value) =>
                                  value == null ? "Selezionare un ruolo" : null,
                              value: selectedValue,
                              onChanged: (String newValue) {
                                setState(() {
                                  selectedValue = newValue;
                                });
                              },
                              items: dropdownItems,
                              onSaved: ((userInputValue) {
                                _editedUser = User(
                                  nome: _editedUser.nome,
                                  cognome: _editedUser.cognome,
                                  username: _editedUser.username,
                                  password: _editedUser.password,
                                  email: _editedUser.email,
                                  ruolo: userInputValue,
                                );
                              }),
                            ),
                          ),
                        ),
                        Flexible(
                            child: Padding(
                          padding: const EdgeInsets.fromLTRB(35, 5, 0, 0),
                          child: ElevatedButton(
                              onPressed: () => _submitData(_editedUser),
                              child: Text('Crea')),
                        ))
                      ],
                    ),
                  ]),
                ),
              ),
            ),
          );
        });
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
          return Card(
            child: ListTile(
              title: Text(_students[i].cognome),
              subtitle: Text(_students[i].nome),
              trailing: Text(_students[i].username),
              onTap: () {
                Navigator.of(context).pushNamed(
                  UserDetailScreen.routeName,
                  arguments: _students[i].username,
                );
              },
            ),
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
