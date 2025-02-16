import 'package:flutter/material.dart';

class PantallaTarjetas extends StatefulWidget {
  @override
  _PantallaTarjetasState createState() => _PantallaTarjetasState();
}

class _PantallaTarjetasState extends State<PantallaTarjetas> {
  List<Map<String, dynamic>> tarjetas = [
    {"numero": "**** **** **** 1234", "congelada": false},
    {"numero": "**** **** **** 5678", "congelada": false},
  ];

  final TextEditingController _tarjetaController = TextEditingController();

  void _mostrarDialogoAgregarTarjeta() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Agregar Tarjeta"),
          content: TextField(
            controller: _tarjetaController,
            keyboardType: TextInputType.number,
            maxLength: 16,
            decoration: InputDecoration(
              labelText: "Número de Tarjeta",
              hintText: "1234567812345678",
              counterText: "", // Oculta el contador de caracteres
            ),
          ),
          actions: [
            TextButton(
              child: Text("Cancelar"),
              onPressed: () {
                _tarjetaController.clear();
                Navigator.pop(context);
              },
            ),
            ElevatedButton(
              child: Text("Agregar"),
              onPressed: () {
                String numeroTarjeta = _tarjetaController.text.trim();
                if (numeroTarjeta.length == 16 && RegExp(r'^\d{16}$').hasMatch(numeroTarjeta)) {
                  setState(() {
                    tarjetas.add({
                      "numero": "**** **** **** ${numeroTarjeta.substring(12)}",
                      "congelada": false
                    });
                  });
                  _tarjetaController.clear();
                  Navigator.pop(context);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Ingrese un número de tarjeta válido (16 dígitos)")),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }

  void _eliminarTarjeta(int index) {
    setState(() {
      tarjetas.removeAt(index);
    });
  }

  void _congelarTarjeta(int index) {
    setState(() {
      tarjetas[index]["congelada"] = !tarjetas[index]["congelada"];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Mis Tarjetas"), backgroundColor: Colors.lightBlueAccent),
      body: Container(
        color: Colors.white, // 📌 Fondo blanco asegurado
        child: ListView.builder(
          itemCount: tarjetas.length,
          itemBuilder: (context, index) {
            return _buildTarjetaVisual(index);
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _mostrarDialogoAgregarTarjeta,
        backgroundColor: Colors.black,
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _buildTarjetaVisual(int index) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Center( // 📌 Centrar la tarjeta
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.6, // 📌 Ajusta el ancho aquí
          child: Container(
            height: 200,
            decoration: BoxDecoration(
              color: tarjetas[index]["congelada"] ? Colors.grey[400] : Colors.black,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(color: Colors.black26, blurRadius: 5, spreadRadius: 2),
              ],
            ),
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // 📌 Logo de VISA en la parte superior derecha
                Align(
                  alignment: Alignment.topRight,
                  child: Image.asset(
                    'assests/Mastercard-logo.png', // Asegúrate de que el logo esté en la carpeta assets
                    height: 40,
                  ),
                ),

                // 📌 Número de tarjeta en el centro
                Center(
                  child: Text(
                    tarjetas[index]["numero"],
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2.0,
                      color: Colors.white,
                    ),
                  ),
                ),

                // 📌 Estado de la tarjeta y botones de acción
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      tarjetas[index]["congelada"] ? "Tarjeta Congelada" : "Activa",
                      style: TextStyle(
                        fontSize: 16,
                        color: tarjetas[index]["congelada"] ? Colors.red : Colors.greenAccent,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      children: [
                        IconButton(
                          icon: Icon(Icons.ac_unit, color: Colors.white),
                          onPressed: () => _congelarTarjeta(index),
                        ),
                        IconButton(
                          icon: Icon(Icons.delete, color: Colors.white),
                          onPressed: () => _eliminarTarjeta(index),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
