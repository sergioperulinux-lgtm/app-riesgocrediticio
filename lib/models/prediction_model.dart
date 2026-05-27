class PredictionModel {
  final String risk;
  final double probability;

  PredictionModel({
    required this.risk,
    required this.probability,
  });

  factory PredictionModel.fromJson(Map<String, dynamic> json) {
    return PredictionModel(
      risk: json['risk'],
      probability: (json['probability'] as num).toDouble(),
    );
  }
}