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
                      "numero":
                      "**** **** **** ${numeroTarjeta.substring(12)}", // Muestra solo los últimos 4 dígitos
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
      body: ListView.builder(
        itemCount: tarjetas.length,
        itemBuilder: (context, index) {
          return Card(
            child: ListTile(
              leading: Icon(Icons.credit_card, color: Colors.indigo),
              title: Text(tarjetas[index]["numero"]),
              subtitle: Text(
                tarjetas[index]["congelada"] ? "Estado: Congelada" : "Estado: Activa",
                style: TextStyle(color: tarjetas[index]["congelada"] ? Colors.red : Colors.green),
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(Icons.ac_unit, color: Colors.blue),
                    onPressed: () => _congelarTarjeta(index),
                  ),
                  IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _eliminarTarjeta(index),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _mostrarDialogoAgregarTarjeta,
        backgroundColor: Colors.indigo,
        child: Icon(Icons.add),
      ),
    );
  }
}
