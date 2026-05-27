import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class RiskGauge extends StatelessWidget {
  final double value;

  const RiskGauge({super.key, required this.value});

  Color getColor(double v) {
    if (v < 0.3) return Colors.green;
    if (v < 0.6) return Colors.orange;
    return Colors.red;
  }

  @override
  Widget build(BuildContext context) {
    return SfRadialGauge(
      axes: [
        RadialAxis(
          minimum: 0,
          maximum: 1,
          ranges: [
            GaugeRange(startValue: 0, endValue: 0.3, color: Colors.green),
            GaugeRange(startValue: 0.3, endValue: 0.6, color: Colors.orange),
            GaugeRange(startValue: 0.6, endValue: 1, color: Colors.red),
          ],
          pointers: [
            NeedlePointer(
              value: value,
              enableAnimation: true,
              animationDuration: 2000,
            )
          ],
          annotations: [
            GaugeAnnotation(
              widget: Text(
                "${(value * 100).toStringAsFixed(1)}%",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: getColor(value),
                ),
              ),
              angle: 90,
              positionFactor: 0.5,
            )
          ],
        )
      ],
    );
  }
}