import 'dart:math';
import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/prediction_model.dart';

import '../widgets/input_field.dart';
import '../widgets/section_card.dart';
import '../widgets/primary_button.dart';
import '../widgets/loading_widget.dart';
import '../widgets/risk_gauge.dart';
import '../widgets/banks_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  final edad = TextEditingController();
  final ingresos = TextEditingController();
  final empleo = TextEditingController();
  final monto = TextEditingController();
  final tasa = TextEditingController();
  final historial = TextEditingController();
  final plazo = TextEditingController();

  int vivienda = 0;
  int tipoPrestamo = 0;
  int grado = 0;
  int defaultHist = 0;

  String mensaje = "";
  String riesgo = "";
  String explicacion = "";
  double prob = 0;

  bool loading = false;

  double cuotaCalculada = 0;
  double totalPagar = 0;
  double interesTotal = 0;

  // =========================
  // VALIDACIÓN
  // =========================
  bool validarCampos() {
    if (edad.text.isEmpty ||
        ingresos.text.isEmpty ||
        empleo.text.isEmpty ||
        monto.text.isEmpty ||
        tasa.text.isEmpty ||
        historial.text.isEmpty ||
        plazo.text.isEmpty) {
      setState(() => mensaje = "⚠️ Complete todos los campos");
      return false;
    }
    return true;
  }

  // =========================
  // RIESGO
  // =========================
  String getRisk(double p) {
    if (p < 0.3) return "RIESGO BAJO";
    if (p < 0.6) return "RIESGO MEDIO";
    return "RIESGO ALTO";
  }

  Color getColor(double p) {
    if (p < 0.3) return Colors.green;
    if (p < 0.6) return Colors.orange;
    return Colors.red;
  }

  // =========================
  // CUOTA REAL (AMORTIZACIÓN)
  // =========================
  void calcularCredito(double monto, double tasaAnual, int meses) {

    double r = (tasaAnual / 100) / 12;

    if (r == 0) {
      cuotaCalculada = monto / meses;
    } else {
      cuotaCalculada = (monto * r) / (1 - pow(1 + r, -meses));
    }

    totalPagar = cuotaCalculada * meses;
    interesTotal = totalPagar - monto;
  }

  // =========================
  // EVALUACIÓN
  // =========================
  Future<void> evaluar() async {

    if (!validarCampos()) return;

    setState(() {
      loading = true;
      mensaje = "";
    });

    try {

      double montoVal = double.parse(monto.text);
      double ingresosVal = double.parse(ingresos.text);
      int plazoVal = int.parse(plazo.text);

      calcularCredito(
        montoVal,
        double.parse(tasa.text),
        plazoVal,
      );

      final data = {
        "person_age": int.parse(edad.text),
        "person_income": ingresosVal,
        "person_home_ownership": vivienda,
        "person_emp_length": int.parse(empleo.text),
        "loan_intent": tipoPrestamo,
        "loan_grade": grado,
        "loan_amnt": montoVal,
        "loan_int_rate": double.parse(tasa.text),
        "loan_percent_income": cuotaCalculada / ingresosVal,
        "cb_person_default_on_file": defaultHist,
        "cb_person_cred_hist_length": int.parse(historial.text)
      };

      final PredictionModel? res = await ApiService.predict(data);

      setState(() {
        loading = false;

        if (res != null) {
          prob = res.probability;
          riesgo = getRisk(prob);
          explicacion = "Análisis basado en modelo de riesgo crediticio pre entrenado";
        } else {
          mensaje = "❌ Error en predicción";
        }
      });

    } catch (e) {
      setState(() {
        loading = false;
        mensaje = "❌ Error en datos ingresados";
      });
    }
  }

  // =========================
  // UI
  // =========================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FA),
      appBar: AppBar(
        title: const Text("Analisis de Riesgo Crediticio"),
        backgroundColor: const Color(0xFF1E3A8A),
      ),

      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [

          SectionCard(
            title: "Datos del cliente",
            child: Column(
              children: [
                InputField(controller: edad, label: "Edad", hint: "30", icon: Icons.person),
                InputField(controller: ingresos, label: "Ingresos", hint: "5000", icon: Icons.attach_money),
                InputField(controller: empleo, label: "Años trabajo", hint: "5", icon: Icons.work),
              ],
            ),
          ),

          SectionCard(
            title: "Crédito",
            child: Column(
              children: [
                InputField(controller: monto, label: "Monto", hint: "2000", icon: Icons.money),
                InputField(controller: plazo, label: "Plazo", hint: "24", icon: Icons.timelapse),
                InputField(controller: tasa, label: "Tasa %", hint: "10.5", icon: Icons.percent),
                InputField(controller: historial, label: "Historial", hint: "3", icon: Icons.history),
              ],
            ),
          ),

          PrimaryButton(
            text: "Evaluar",
            loading: loading,
            onPressed: evaluar,
          ),

          const SizedBox(height: 15),

          if (loading) const LoadingWidget(),

          if (mensaje.isNotEmpty && !loading)
            Text(mensaje, style: const TextStyle(color: Colors.red)),

          if (riesgo.isNotEmpty && !loading)
            SectionCard(
              title: "Resultado",
              child: Column(
                children: [

                  RiskGauge(value: prob),

                  const SizedBox(height: 10),

                  Text(
                    riesgo,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: getColor(prob),
                    ),
                  ),

                  Text("${(prob * 100).toStringAsFixed(2)}% riesgo de default"),

                  const SizedBox(height: 10),

                  Text("💰 Cuota mensual: ${cuotaCalculada.toStringAsFixed(2)}"),
                  Text("💵 Total a pagar: ${totalPagar.toStringAsFixed(2)}"),
                  Text("📉 Interés total: ${interesTotal.toStringAsFixed(2)}"),

                  const SizedBox(height: 10),

                  Text(
                    explicacion,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),

          if (riesgo.isNotEmpty && !loading)
            SectionCard(
              title: "Recomendación bancaria",
              child: BanksWidget(prob: prob),
            ),
        ],
      ),
    );
  }
}