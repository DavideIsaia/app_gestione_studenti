import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/overview_screen.dart';
import './providers/auth.dart';
import './screens/auth_screen.dart';
import './screens/users_screen.dart';
import './screens/user_detail_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // solo il widget col notifier provider viene ricostruito quando qualcosa cambia nei dati, e non l'intera app
    return MultiProvider(
        // con multiprovider nel main, tutto ciò che è all'interno viene reso visibile a tutta l'app
        providers: [
          // create e update(con proxy) se versione provider > 3, altrimenti builder
          ChangeNotifierProvider(
            create: (ctx) => Auth(),
          ),
        ],
        child: Consumer<Auth>(
          builder: (context, authValue, _) => MaterialApp(
            title: "Gestione studenti",
            theme: ThemeData(
              primarySwatch: Colors.deepPurple,
              accentColor: Colors.teal,
              fontFamily: 'Lato',
            ),
            // se l'user è loggato mostra la schermata principale, altrimenti la login screen
            home: authValue.isAuth ? UsersScreen() : AuthScreen(),
            routes: {
              UsersScreen.routeName: (context) => UsersScreen(),
              UserDetailScreen.routeName: (context) => UserDetailScreen(),
            },
          ),
        ));
  }
}
