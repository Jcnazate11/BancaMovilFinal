import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'pantalla_inicio.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<void> _signInWithGoogle() async {
    try {
      await GoogleSignIn().signOut();
      await _firebaseAuth.signOut();

      final GoogleSignIn googleSignIn = GoogleSignIn(
        scopes: ['email'],
        signInOption: SignInOption.standard,
      );

      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      if (googleUser != null) {
        final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        final UserCredential userCredential =
        await _firebaseAuth.signInWithCredential(credential);
        final user = userCredential.user;

        if (user != null) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => PantallaInicio(user: user),
            ),
          );
        }
      }
    } catch (e) {
      print('Error al iniciar sesión con Google: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al iniciar sesión: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // 📌 Imagen de fondo
          Image.asset(
            'assests/fondo_banco.jpg', // Asegúrate de colocar la imagen en assets
            fit: BoxFit.cover,
          ),

          // 📌 Capa de color semitransparente para mejorar la legibilidad
          Container(
            color: Colors.black.withOpacity(0.3), // Oscurece la imagen de fondo
          ),

          // 📌 Contenido centrado
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // 📌 Recuadro para el logo del banco
              Card(
                color: Colors.white.withOpacity(0.9),
                elevation: 6,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                margin: EdgeInsets.symmetric(horizontal: 40),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      Image.asset(
                        'assests/logo_banco.png', // Asegúrate de tener esta imagen en assets
                        height: 100,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 30),

              // 📌 Recuadro para el login
              Card(
                color: Colors.white.withOpacity(0.9),
                elevation: 6,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                margin: EdgeInsets.symmetric(horizontal: 270),
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Bienvenido',
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: Colors.indigo,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Accede a tu cuenta de manera segura con Google',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black54,
                        ),
                      ),
                      SizedBox(height: 25),

                      // 📌 Botón de inicio de sesión con Google
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black,
                          side: BorderSide(color: Colors.indigo),
                          elevation: 3,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                        ),
                        icon: Image.asset(
                          'assests/google_logo.png', // Asegúrate de tener esta imagen en assets
                          height: 24,
                        ),
                        label: Text(
                          'Iniciar sesión con Google',
                          style: TextStyle(fontSize: 16),
                        ),
                        onPressed: _signInWithGoogle,
                      ),
                      SizedBox(height: 10),

                      Divider(thickness: 1, color: Colors.grey[300]),
                      SizedBox(height: 10),

                      Text(
                        "Capital Bank S.A.",
                        style: TextStyle(fontSize: 14, color: Colors.black54),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
