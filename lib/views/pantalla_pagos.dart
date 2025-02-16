import 'package:flutter/material.dart';

class PantallaPagos extends StatefulWidget {
  @override
  _PantallaPagosState createState() => _PantallaPagosState();
}

class _PantallaPagosState extends State<PantallaPagos> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _montoController = TextEditingController();
  TextEditingController _tarjetaController = TextEditingController();

  void _confirmarPago() {
    if (_formKey.currentState!.validate()) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Confirmar Pago"),
          content: Text(
              "¿Deseas realizar el pago de \$${_montoController.text} a la tarjeta ${_tarjetaController.text}?"),
          actions: [
            TextButton(
              child: Text("Cancelar"),
              onPressed: () => Navigator.pop(context),
            ),
            ElevatedButton(
              child: Text("Confirmar"),
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Pago realizado con éxito")),
                );
              },
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Pagos y Transferencias"),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.lightBlueAccent.shade100, Colors.white, Colors.lightBlueAccent],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(height: 20),

            // 📌 Cuadro centrado con el formulario
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "Ingresa los detalles del pago",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.indigo),
                      ),
                      SizedBox(height: 20),
                      TextFormField(
                        controller: _montoController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: "Monto a pagar (\$)",
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) => value!.isEmpty ? "Ingresa un monto válido" : null,
                      ),
                      SizedBox(height: 15),
                      TextFormField(
                        controller: _tarjetaController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: "Número de tarjeta",
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) => value!.isEmpty ? "Ingresa un número de tarjeta" : null,
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // 📌 Botón en la parte inferior
            Padding(
              padding: const EdgeInsets.only(bottom: 30.0),
              child: ElevatedButton(
                onPressed: _confirmarPago,
                child: Text("Realizar Pago", style: TextStyle(color: Colors.white, fontSize: 18)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigo,
                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 100),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
