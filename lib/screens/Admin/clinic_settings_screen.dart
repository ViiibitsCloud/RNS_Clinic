import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:clinic_web/model/form_field_model.dart';
import 'package:clinic_web/widgets/custom_text_field.dart';
import '../../services/SlotService.dart';

class ManageClinicSettings extends StatefulWidget {
  const ManageClinicSettings({super.key});

  @override
  State<ManageClinicSettings> createState() => _ManageClinicSettingsState();
}

class _ManageClinicSettingsState extends State<ManageClinicSettings> {
  final _startCtrl = TextEditingController(text: '09:00');
  final _endCtrl = TextEditingController(text: '17:00');
  final _durationCtrl = TextEditingController(text: '20');
  final _daysCtrl = TextEditingController(text: '30');

  bool _loading = false;

  /// SAVE SETTINGS
  Future<void> save() async {
    if (_startCtrl.text == _endCtrl.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Start and End time cannot be same")),
      );
      return;
    }

    setState(() => _loading = true);

    try {
      await FirebaseFirestore.instance
          .collection('clinic_settings')
          .doc('main')
          .set({
        'startTime': _startCtrl.text.trim(),
        'endTime': _endCtrl.text.trim(),
        'slotDuration': int.tryParse(_durationCtrl.text) ?? 20,
        'generateDays': int.tryParse(_daysCtrl.text) ?? 30,
        'updatedAt': FieldValue.serverTimestamp(),
      });

      /// Regenerate slots
      await SlotService.applyClinicSettingsChange();

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Clinic settings applied successfully'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      debugPrint("Error: $e");

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  /// TIME PICKER
  Future<void> _pickTime(TextEditingController controller) async {
    final now = TimeOfDay.now();

    final picked = await showTimePicker(
      context: context,
      initialTime: now,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Colors.blue,
              onPrimary: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      final formatted =
          '${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}';

      setState(() {
        controller.text = formatted;
      });
    }
  }

  /// SLOT ESTIMATION
  int _calculateSlots() {
    try {
      final start = _startCtrl.text.split(':');
      final end = _endCtrl.text.split(':');

      final startMinutes =
          int.parse(start[0]) * 60 + int.parse(start[1]);
      final endMinutes =
          int.parse(end[0]) * 60 + int.parse(end[1]);

      final duration = int.tryParse(_durationCtrl.text) ?? 20;
      final days = int.tryParse(_daysCtrl.text) ?? 30;

      final slotsPerDay = ((endMinutes - startMinutes) / duration).floor();

      return slotsPerDay * days;
    } catch (_) {
      return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    final estimatedSlots = _calculateSlots();

    return Scaffold(
      appBar: AppBar(title: const Text('Clinic Settings')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [

            /// SECTION TITLE
            const Text(
              "Slot Configuration",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 16),

            /// START TIME
            CustomTextField(
              model: FormFieldModel(
                label: "Clinic Start Time",
                readOnly: true,
                prefixIcon: Icons.access_time,
                required: true,
                hint: "Select Time",
              ),
              controller: _startCtrl,
              onTap: () => _pickTime(_startCtrl),
            ),

            const SizedBox(height: 12),

            /// END TIME
            CustomTextField(
              model: FormFieldModel(
                label: "Clinic End Time",
                readOnly: true,
                prefixIcon: Icons.access_time,
                required: true,
                hint: "Select Time",
              ),
              controller: _endCtrl,
              onTap: () => _pickTime(_endCtrl),
            ),

            const SizedBox(height: 12),

            /// SLOT DURATION
            CustomTextField(
              model: FormFieldModel(
                label: "Slot Duration (minutes)",
                prefixIcon: Icons.timer,
                required: true,
                hint: "Enter Duration",
                keyboardType: TextInputType.number,
              ),
              controller: _durationCtrl,
              onChanged: (_) => setState(() {}),
            ),

            const SizedBox(height: 12),

            /// GENERATE DAYS
            CustomTextField(
              model: FormFieldModel(
                label: "Generate Slots For (Days)",
                prefixIcon: Icons.calendar_month,
                required: true,
                hint: "Example: 30",
                keyboardType: TextInputType.number,
              ),
              controller: _daysCtrl,
              onChanged: (_) => setState(() {}),
            ),

            const SizedBox(height: 12),

            /// ESTIMATED SLOT COUNT
            Text(
              "Estimated slots to generate: $estimatedSlots",
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 13,
              ),
            ),

            const SizedBox(height: 30),

            /// SAVE BUTTON
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _loading ? null : save,
                child: _loading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Text('Save & Regenerate Slots'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _startCtrl.dispose();
    _endCtrl.dispose();
    _durationCtrl.dispose();
    _daysCtrl.dispose();
    super.dispose();
  }
}   