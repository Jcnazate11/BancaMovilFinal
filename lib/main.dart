import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'views/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializa Firebase con las opciones específicas para Web
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyCzmTZBkDX5oNAMZS9-aG2eM4N7sl4KyOM", // Clave de API web
      authDomain: "banca-movil-e373a.firebaseapp.com", // authDomain del proyecto
      projectId: "banca-movil-e373a", // ID del proyecto
      storageBucket: "banca-movil-e373a.appspot.com", // Storage bucket
      messagingSenderId: "50656624356", // Sender ID del proyecto
      appId: "1:50656624356:android:a5c9ba17ac8fc5471836f1", // App ID del proyecto
    ),
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Banca Móvil App',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      home: LoginScreen(),
    );
  }
}