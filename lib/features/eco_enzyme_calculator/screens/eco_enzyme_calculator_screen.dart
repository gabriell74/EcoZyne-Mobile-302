import 'package:ecozyne_mobile/core/widgets/custom_text.dart';
import 'package:flutter/material.dart';

class EcoEnzymeCalculatorScreen extends StatefulWidget {
  const EcoEnzymeCalculatorScreen({super.key});

  @override
  State<EcoEnzymeCalculatorScreen> createState() => _EcoEnzymeCalculatorScreenState();
}

class _EcoEnzymeCalculatorScreenState extends State<EcoEnzymeCalculatorScreen> {
  late TextEditingController _controller;
  double? _kapasitasWadah = 0;
  double? _molaseGulaMerah = 0;
  double? _bahanOrganik = 0;
  double? _air = 0;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF55C173),
        title: CustomText("Kalkulator Eco Enzyme", fontWeight: FontWeight.bold),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              TextField(
                controller: _controller,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: "Masukkan Kapasitas Wadah Anda (Liter)",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onSubmitted: (value) {
                  if (_controller.text.isEmpty) return;

                  final kapasitas = double.tryParse(_controller.text);
                  if (kapasitas == null) return;

                  setState(() {
                    _kapasitasWadah = kapasitas;

                    print(_molaseGulaMerah = _kapasitasWadah! * _molaseGulaMerahPerLiterKapasitasWadah);
                    print(_bahanOrganik = _kapasitasWadah! * _bahanOrganikPerLiterKapasitasWadah);
                    print(_air = _kapasitasWadah! * _airPerLiterKapasitasWadah);
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
