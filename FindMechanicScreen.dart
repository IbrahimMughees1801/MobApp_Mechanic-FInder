import 'package:flutter/material.dart';

class FindMechanicScreen extends StatefulWidget {
  const FindMechanicScreen({super.key});

  @override
  State<FindMechanicScreen> createState() => _FindMechanicScreenState();
}

class _FindMechanicScreenState extends State<FindMechanicScreen> {
  String? selectedJobType;
  String? selectedCarModel;
  String? selectedMileage;
  bool needTowing = false;
  final notesController = TextEditingController();

  final List<String> jobTypes = [
    'Oil Change',
    'Engine Repair',
    'Tire Replacement',
    'Battery Issue',
    'Brake Repair',
    'AC Service',
  ];

  final List<String> carModels = [
    'Toyota Corolla',
    'Honda Civic',
    'Suzuki Alto',
    'Kia Sportage',
    'Hyundai Tucson',
    'Other',
  ];

  final List<String> mileageRanges = [
    '0 - 10,000 km',
    '10,001 - 50,000 km',
    '50,001 - 100,000 km',
    '100,000+ km',
  ];

  void _findMechanic() {
    if (selectedJobType == null || selectedCarModel == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please fill out all required fields."),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Finding available mechanics near you..."),
        backgroundColor: Colors.blueAccent,
      ),
    );

    // Simulate navigation or backend call
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pop(context); // Goes back to HomeScreen for now
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Find a Mechanic"),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 1,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Tell us what you need 🚗",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),

            // Job Type Dropdown
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: "Job Type *",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              value: selectedJobType,
              items: jobTypes
                  .map((type) => DropdownMenuItem(
                        value: type,
                        child: Text(type),
                      ))
                  .toList(),
              onChanged: (value) => setState(() => selectedJobType = value),
            ),
            const SizedBox(height: 16),

            // Car Model Dropdown
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: "Car Model *",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              value: selectedCarModel,
              items: carModels
                  .map((model) => DropdownMenuItem(
                        value: model,
                        child: Text(model),
                      ))
                  .toList(),
              onChanged: (value) => setState(() => selectedCarModel = value),
            ),
            const SizedBox(height: 16),

            // Mileage Dropdown
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: "Mileage Range",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              value: selectedMileage,
              items: mileageRanges
                  .map((range) => DropdownMenuItem(
                        value: range,
                        child: Text(range),
                      ))
                  .toList(),
              onChanged: (value) => setState(() => selectedMileage = value),
            ),
            const SizedBox(height: 16),

            // Need Towing Checkbox
            Row(
              children: [
                Checkbox(
                  value: needTowing,
                  onChanged: (value) =>
                      setState(() => needTowing = value ?? false),
                ),
                const Text(
                  "Need towing service?",
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Additional Notes
            TextField(
              controller: notesController,
              decoration: InputDecoration(
                labelText: "Additional Notes (optional)",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 30),

            // Find Mechanic Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _findMechanic,
                icon: const Icon(Icons.search),
                label: const Text(
                  "Find Mechanic",
                  style: TextStyle(fontSize: 18),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
