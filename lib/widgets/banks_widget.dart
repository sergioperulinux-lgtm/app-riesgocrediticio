import 'package:flutter/material.dart';

class BanksWidget extends StatelessWidget {
  final double prob;

  const BanksWidget({super.key, required this.prob});

  Color getColor(double p) {
    if (p < 0.3) return Colors.green;
    if (p < 0.6) return Colors.orange;
    return Colors.red;
  }

  String getEstado(double p) {
    if (p < 0.3) return "APROBADO";
    if (p < 0.6) return "EN EVALUACIÓN";
    return "RECHAZADO";
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Entidades financieras",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),

        banco(
          nombre: "BCP",
          logo:
          "https://iconape.com/wp-content/files/re/208512/svg/208512.svg",
          estado: getEstado(prob),
          color: getColor(prob),
        ),

        banco(
          nombre: "BBVA",
          logo:
          "https://upload.wikimedia.org/wikipedia/commons/thumb/0/05/BBVA_2019.svg/960px-BBVA_2019.svg.png",
          estado: getEstado(prob),
          color: getColor(prob),
        ),

        banco(
          nombre: "Interbank",
          logo:
          "https://static.wikia.nocookie.net/logopedia/images/1/12/Interbank_logo_2009_apilado.svg/revision/latest/scale-to-width-down/250?cb=20200919141902&path-prefix=es",
          estado: getEstado(prob),
          color: getColor(prob),
        ),

        /// 🔥 GOTA A GOTA (siempre aprobado)
        banco(
          nombre: "Gota a Gota",
          logo:
          "https://cdn-icons-png.freepik.com/512/2473/2473058.png",
          estado: "APROBADO",
          color: Colors.green,
        ),
      ],
    );
  }

  Widget banco({
    required String nombre,
    required String logo,
    required String estado,
    required Color color,
  }) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          vertical: 12,
          horizontal: 14,
        ),

        /// 🧠 LOGO MEJORADO (GRANDE + CENTRADO)
        leading: Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Image.network(
                logo,
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),

        title: Text(
          nombre,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),

        subtitle: Text(
          estado,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: color,
          ),
        ),

        trailing: Icon(
          Icons.circle,
          color: color,
          size: 14,
        ),
      ),
    );
  }
}