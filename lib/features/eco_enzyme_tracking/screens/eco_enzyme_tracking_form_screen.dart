import 'package:ecozyne_mobile/core/widgets/app_background.dart';
import 'package:ecozyne_mobile/core/widgets/build_form_field.dart';
import 'package:ecozyne_mobile/core/widgets/custom_text.dart';
import 'package:ecozyne_mobile/core/widgets/top_snackbar.dart';
import 'package:ecozyne_mobile/data/models/eco_enzyme_tracking.dart';
import 'package:ecozyne_mobile/data/providers/eco_enzyme_tracking_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class EcoEnzymeTrackingFormScreen extends StatefulWidget {
  const EcoEnzymeTrackingFormScreen({super.key});

  @override
  State<EcoEnzymeTrackingFormScreen> createState() => _EcoEnzymeTrackingFormScreenState();
}

class _EcoEnzymeTrackingFormScreenState extends State<EcoEnzymeTrackingFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _dueDateController = TextEditingController();

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
          _startDateController.text = _dateFormat.format(picked);

          if (_dueDate != null && _dueDate!.isBefore(_startDate!)) {
            _dueDate = null;
            _dueDateController.text = "";
          }
        } else {
          _dueDate = picked;
          _dueDateController.text = _dateFormat.format(picked);
        }
      });
    }
  }

  Future<void> _saveForm() async {
    if (_formKey.currentState!.validate()) {
      if (_startDate == null || _dueDate == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Silakan pilih tanggal mulai dan tanggal selesai")),
        );
        return;
      }

      if (_dueDate!.isBefore(_startDate!)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Tanggal selesai tidak boleh lebih awal dari tanggal mulai")),
        );
        return;
      }

      final batch = EcoEnzymeTracking(
        batchName: _nameController.text,
        startDate: _startDate!,
        dueDate: _dueDate!,
        notes: _notesController.text,
      );

      final provider = context.read<EcoEnzymeTrackingProvider>();

      final success = await provider.addBatchTracking(batch);

      if (success) {
        showSuccessTopSnackBar(context, "Batch Eco Enzyme berhasil dibuat!");
        Navigator.pop(context);
      } else {
        showErrorTopSnackBar(context, provider.message);
      }
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
      body: AppBackground(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                BuildFormField(
                  label: "Nama Batch",
                  controller: _nameController,
                  validator: (value) => value == null || value.isEmpty ? "Nama wajib diisi" : null,
                ),

                BuildFormField(
                  label: "Tanggal Mulai",
                  controller: _startDateController,
                  validator: (_) => null,
                  isDate: true,
                  hintText: "Pilih tanggal mulai",
                  onTap: () => _selectDate(context, true),
                ),

                BuildFormField(
                  label: "Tanggal Selesai",
                  controller: _dueDateController,
                  validator: (_) => null,
                  isDate: true,
                  hintText: "Pilih tanggal selesai",
                  onTap: () => _selectDate(context, false),
                ),

                BuildFormField(
                  label: "Catatan",
                  controller: _notesController,
                  validator: (_) => null,
                  maxLines: 3,
                  hintText: "Tambahkan catatan",
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
      ),
    );
  }
}
