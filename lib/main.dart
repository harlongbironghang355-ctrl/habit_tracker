import 'package:flutter/material.dart';

import 'features/auth/screens/login_screen.dart';
import 'features/auth/screens/register_screen.dart';


void main() {

  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    const HabittApp(),
  );

}



class HabittApp extends StatelessWidget {

  const HabittApp({
    super.key,
  });


  @override
  Widget build(BuildContext context) {

    return MaterialApp(

      debugShowCheckedModeBanner: false,

      title: 'Habitt',


      theme: ThemeData(

        primarySwatch: Colors.blue,

        scaffoldBackgroundColor:
            Colors.white,

      ),



      home:
          const LoginScreen(),



      routes: {


        '/login':
            (context) =>
                const LoginScreen(),



        '/register':
            (context) =>
                const RegisterScreen(),


      },


    );

  }

}