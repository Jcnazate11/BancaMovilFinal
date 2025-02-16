import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import '../services/auth_service.dart';
import 'login_screen.dart';
import 'pantalla_pagos.dart';
import 'pantalla_tarjetas.dart';
import 'pantalla_historial.dart';

class PantallaInicio extends StatelessWidget {
  final User user;
  final double saldoDisponible = 1250.75; // Saldo ficticio
  final String numeroCuenta = "1234 5678 9012 3456"; // Número ficticio

  const PantallaInicio({Key? key, required this.user}) : super(key: key);

  Future<void> _signOut(BuildContext context) async {
    await AuthService().signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );
  }

  String _obtenerFechaHoraActual() {
    return DateFormat("yyyy-MM-dd HH:mm:ss").format(DateTime.now());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlueAccent,
        elevation: 0,
        title: Text("Inicio", style: TextStyle(color: Colors.white)),
      ),
      drawer: _buildMenuLateral(context), // Menú lateral
      body: Container(
        color: Colors.white,
        width: double.infinity,
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // 📌 Mensaje de bienvenida y último acceso
            Column(
              children: [
                Text(
                  "Bienvenido/a, ${user.displayName ?? "Usuario"}!",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black87),
                ),
                SizedBox(height: 5),
                Text(
                  "Último acceso: ${_obtenerFechaHoraActual()}",
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
                SizedBox(height: 20),
              ],
            ),

            // 📌 Tarjeta centrada con saldo y número de cuenta
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              color: Colors.lightBlueAccent,
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Número de cuenta",
                      style: TextStyle(fontSize: 16, color: Colors.white70),
                    ),
                    SizedBox(height: 5),
                    Text(
                      numeroCuenta,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 15),
                    Text(
                      "Saldo Disponible",
                      style: TextStyle(fontSize: 16, color: Colors.white70),
                    ),
                    SizedBox(height: 5),
                    Text(
                      "\$${saldoDisponible.toStringAsFixed(2)}",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // 📌 Accesos rápidos en la parte inferior (footer)
            Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildShortcutButton(
                    icon: Icons.payment,
                    label: "Pagos",
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => PantallaPagos()),
                    ),
                  ),
                  _buildShortcutButton(
                    icon: Icons.history,
                    label: "Historial",
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => PantallaHistorial()),
                    ),
                  ),
                  _buildShortcutButton(
                    icon: Icons.credit_card,
                    label: "Tarjetas",
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => PantallaTarjetas()),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ✅ Menú lateral (Drawer)
  Widget _buildMenuLateral(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            decoration: BoxDecoration(color: Colors.lightBlueAccent),
            accountName: Text(
              user.displayName ?? "Usuario",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            accountEmail: Text(
              user.email ?? "",
              style: TextStyle(fontSize: 14),
            ),
            currentAccountPicture: CircleAvatar(
              radius: 40,
              backgroundImage: user.photoURL != null
                  ? NetworkImage(user.photoURL!)
                  : AssetImage('assets/default_avatar.png') as ImageProvider,
            ),
          ),
          ListTile(
            leading: Icon(Icons.exit_to_app, color: Colors.red),
            title: Text("Cerrar sesión"),
            onTap: () => _signOut(context),
          ),
        ],
      ),
    );
  }

  // ✅ Widget de accesos directos
  Widget _buildShortcutButton({required IconData icon, required String label, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: Colors.lightBlueAccent.withOpacity(0.1),
            child: Icon(icon, size: 30, color: Colors.lightBlueAccent),
          ),
          SizedBox(height: 8),
          Text(label, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
