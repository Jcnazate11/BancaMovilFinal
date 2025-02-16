import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PantallaHistorial extends StatefulWidget {
  @override
  _PantallaHistorialState createState() => _PantallaHistorialState();
}

class _PantallaHistorialState extends State<PantallaHistorial> {
  List<Map<String, dynamic>> transacciones = [
    {"fecha": "2024-02-10", "tipo": "Pago", "monto": 100.50},
    {"fecha": "2024-02-11", "tipo": "Transferencia", "monto": 200.00},
    {"fecha": "2024-02-12", "tipo": "Pago", "monto": 75.00},
    {"fecha": "2024-02-13", "tipo": "Transferencia", "monto": 50.00},
    {"fecha": "2024-02-14", "tipo": "Pago", "monto": 30.00},
  ];

  List<Map<String, dynamic>> transaccionesFiltradas = [];
  String? tipoSeleccionado;
  DateTime? fechaInicio;
  DateTime? fechaFin;

  @override
  void initState() {
    super.initState();
    transaccionesFiltradas = List.from(transacciones);
  }

  void _filtrarTransacciones() {
    setState(() {
      transaccionesFiltradas = transacciones.where((transaccion) {
        DateTime fecha = DateTime.parse(transaccion["fecha"]);

        bool cumpleFecha = true;
        if (fechaInicio != null && fechaFin != null) {
          cumpleFecha = fecha.isAfter(fechaInicio!.subtract(Duration(days: 1))) &&
              fecha.isBefore(fechaFin!.add(Duration(days: 1)));
        }

        bool cumpleTipo = tipoSeleccionado == null || transaccion["tipo"] == tipoSeleccionado;

        return cumpleFecha && cumpleTipo;
      }).toList();
    });
  }

  Future<void> _seleccionarFechaInicio(BuildContext context) async {
    final DateTime? seleccionada = await showDatePicker(
      context: context,
      initialDate: fechaInicio ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (seleccionada != null) {
      setState(() {
        fechaInicio = seleccionada;
      });
      _filtrarTransacciones();
    }
  }

  Future<void> _seleccionarFechaFin(BuildContext context) async {
    final DateTime? seleccionada = await showDatePicker(
      context: context,
      initialDate: fechaFin ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (seleccionada != null) {
      setState(() {
        fechaFin = seleccionada;
      });
      _filtrarTransacciones();
    }
  }

  void _descargarResumenPDF() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Función de descarga en construcción")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Historial de Transacciones"),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                // Selector de fecha
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton.icon(
                      icon: Icon(Icons.date_range, color: Colors.indigo),
                      label: Text(
                        fechaInicio == null
                            ? "Desde"
                            : DateFormat("yyyy-MM-dd").format(fechaInicio!),
                      ),
                      onPressed: () => _seleccionarFechaInicio(context),
                    ),
                    TextButton.icon(
                      icon: Icon(Icons.date_range, color: Colors.indigo),
                      label: Text(
                        fechaFin == null ? "Hasta" : DateFormat("yyyy-MM-dd").format(fechaFin!),
                      ),
                      onPressed: () => _seleccionarFechaFin(context),
                    ),
                  ],
                ),

                // Selector de tipo de transacción
                DropdownButton<String>(
                  value: tipoSeleccionado,
                  hint: Text("Seleccionar tipo"),
                  isExpanded: true,
                  items: ["Pago", "Transferencia"].map((String tipo) {
                    return DropdownMenuItem<String>(
                      value: tipo,
                      child: Text(tipo),
                    );
                  }).toList(),
                  onChanged: (nuevoTipo) {
                    setState(() {
                      tipoSeleccionado = nuevoTipo;
                    });
                    _filtrarTransacciones();
                  },
                ),
                SizedBox(height: 10),

                // Botón para descargar PDF
                ElevatedButton.icon(
                  onPressed: _descargarResumenPDF,
                  icon: Icon(Icons.download, color: Colors.white),
                  label: Text("Descargar Resumen PDF", style: TextStyle(color: Colors.white),),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.indigo),
                ),
              ],
            ),
          ),

          // Lista de transacciones filtradas
          Expanded(
            child: transaccionesFiltradas.isEmpty
                ? Center(child: Text("No hay transacciones en este periodo"))
                : ListView.builder(
              itemCount: transaccionesFiltradas.length,
              itemBuilder: (context, index) {
                return Card(
                  child: ListTile(
                    leading: Icon(
                      transaccionesFiltradas[index]["tipo"] == "Pago"
                          ? Icons.payment
                          : Icons.compare_arrows,
                      color: transaccionesFiltradas[index]["tipo"] == "Pago"
                          ? Colors.red
                          : Colors.green,
                    ),
                    title: Text(
                        "Monto: \$${transaccionesFiltradas[index]["monto"].toStringAsFixed(2)}"),
                    subtitle: Text("Fecha: ${transaccionesFiltradas[index]["fecha"]}"),
                    trailing: Text(transaccionesFiltradas[index]["tipo"]),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
