class SolarPanel {
  SolarPanel({
    this.date,
    this.energy,
    this.co2Avoidance,
    this.payment,
  });

  final String? date;
  final String? energy;
  final String? co2Avoidance;
  final String? payment;

  factory SolarPanel.fromJson(Map<String, dynamic> json) => SolarPanel(
        date: json["date"],
        energy: json["energy"],
        co2Avoidance: json["co2avoidance"],
        payment: json["payment"],
      );

  Map<String, dynamic> toJson() => {
        "date": date,
        "energy": energy,
        "co2avoidance": co2Avoidance,
        "payment": payment,
      };
}
