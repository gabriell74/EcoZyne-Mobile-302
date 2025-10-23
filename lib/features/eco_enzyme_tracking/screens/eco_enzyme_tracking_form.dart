import 'package:ecozyne_mobile/core/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EcoEnzymeTrackingFormScreen extends StatefulWidget {
  const EcoEnzymeTrackingFormScreen({super.key});

  @override
  State<EcoEnzymeTrackingFormScreen> createState() => _EcoEnzymeTrackingFormScreenState();
}

class _EcoEnzymeTrackingFormScreenState extends State<EcoEnzymeTrackingFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  DateTime? _startDate;
  DateTime? _dueDate;

  final DateFormat _dateFormat = DateFormat('dd MMM yyyy');

  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() {
        if (isStartDate) {
          _startDate = picked;
          // Kalau tanggal selesai lebih kecil, reset
          if (_dueDate != null && _dueDate!.isBefore(_startDate!)) {
            _dueDate = null;
          }
        } else {
          _dueDate = picked;
        }
      });
    }
  }

  void _saveForm() {
    if (_formKey.currentState!.validate()) {
      if (_startDate == null || _dueDate == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text("Silakan pilih tanggal mulai dan tanggal selesai")),
        );
        return;
      }

      if (_dueDate!.isBefore(_startDate!)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content:
              Text("Tanggal selesai tidak boleh lebih awal dari tanggal mulai")),
        );
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Eco Enzyme '${_nameController.text}' berhasil divalidasi!",
          ),
        ),
      );

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: const Color(0xFF55C173),
        title: const CustomText("Pembuatan Eco Enzyme", fontWeight: FontWeight.bold),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: "Nama Batch",
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                value == null || value.isEmpty ? "Nama wajib diisi" : null,
              ),
              const SizedBox(height: 16),

              InkWell(
                onTap: () => _selectDate(context, true),
                child: InputDecorator(
                  decoration: const InputDecoration(
                    labelText: "Tanggal Mulai",
                    border: OutlineInputBorder(),
                  ),
                  child: Text(
                    _startDate != null
                        ? _dateFormat.format(_startDate!)
                        : "Pilih tanggal mulai",
                    style: TextStyle(
                      color: _startDate != null ? Colors.black : Colors.grey[600],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              InkWell(
                onTap: () => _selectDate(context, false),
                child: InputDecorator(
                  decoration: const InputDecoration(
                    labelText: "Tanggal Selesai",
                    border: OutlineInputBorder(),
                  ),
                  child: Text(
                    _dueDate != null
                        ? _dateFormat.format(_dueDate!)
                        : "Pilih tanggal selesai",
                    style: TextStyle(
                      color: _dueDate != null ? Colors.black : Colors.grey[600],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _notesController,
                decoration: const InputDecoration(
                  labelText: "Catatan",
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _saveForm,
                  icon: const Icon(Icons.save),
                  label: const Text("Simpan"),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
