import 'package:ecozyne_mobile/core/widgets/custom_text.dart';
import 'package:flutter/material.dart';

class EcoEnzymeCalculatorScreen extends StatefulWidget {
  const EcoEnzymeCalculatorScreen({super.key});

  @override
  State<EcoEnzymeCalculatorScreen> createState() =>
      _EcoEnzymeCalculatorScreenState();
}

class _EcoEnzymeCalculatorScreenState extends State<EcoEnzymeCalculatorScreen> {
  late TextEditingController _controller;
  double _kapasitasWadah = 0;
  double _molaseGulaMerah = 0;
  double _bahanOrganik = 0;
  double _air = 0;

  final double _molaseGulaMerahPerLiterKapasitasWadah = 60;
  final double _bahanOrganikPerLiterKapasitasWadah = 180;
  final double _airPerLiterKapasitasWadah = 0.6;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _hitungEcoEnzyme() {
    final kapasitas = double.tryParse(_controller.text);
    if (kapasitas == null) return;

    setState(() {
      _kapasitasWadah = kapasitas;
      _molaseGulaMerah = kapasitas * _molaseGulaMerahPerLiterKapasitasWadah;
      _bahanOrganik = kapasitas * _bahanOrganikPerLiterKapasitasWadah;
      _air = kapasitas * _airPerLiterKapasitasWadah;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: const Color(0xFF55C173),
        title: const CustomText(
          "Kalkulator Eco Enzyme",
          fontWeight: FontWeight.bold,
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              clipBehavior: Clip.antiAlias,
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: const CustomText(
                "Masukkan kapasitas wadah Anda untuk menghitung takaran bahan pembuatan Eco Enzyme.",
                textAlign: TextAlign.center,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 25),
            CustomText(
              "Kapasitas Wadah (Liter)",
              fontSize: 14,
              fontWeight: FontWeight.bold,
              textAlign: TextAlign.start,
            ),
            const SizedBox(height: 15),
            TextField(
              controller: _controller,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: "Masukkan kapasitas wadah",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onSubmitted: (_) => _hitungEcoEnzyme(),
            ),
            const SizedBox(height: 28),
            Center(
              child: ElevatedButton(
                onPressed: _hitungEcoEnzyme,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF55C173),
                  padding: const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 24,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const CustomText(
                  "Hitung Takaran",
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 25),
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              margin: const EdgeInsets.symmetric(horizontal: 8),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    const CustomText(
                      "Hasil Perhitungan",
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                    ),
                    const Divider(),
                    _buildResultRow(
                      "Kapasitas Wadah",
                      "$_kapasitasWadah Liter",
                    ),
                    _buildResultRow(
                      "Molase / Gula Merah",
                      "${_molaseGulaMerah.toStringAsFixed(1)} gram",
                    ),
                    _buildResultRow(
                      "Bahan Organik",
                      "${_bahanOrganik.toStringAsFixed(1)} gram",
                    ),
                    _buildResultRow("Air", "${_air.toStringAsFixed(1)} Liter"),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CustomText(label, fontWeight: FontWeight.w500),
          CustomText(
            value,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF55C173),
          ),
        ],
      ),
    );
  }
}
