import 'package:flutter/material.dart';
import '../models/patient.dart';
import '../services/patient_service.dart';
import '../services/sensor_service.dart';

class PatientDashboardScreen extends StatefulWidget {
  final PatientData? patientData;

  const PatientDashboardScreen({super.key, this.patientData});

  @override
  State<PatientDashboardScreen> createState() =>
      _PatientDashboardScreenState();
}

class _PatientDashboardScreenState extends State<PatientDashboardScreen> {
  late PatientData _currentPatient;
  final PatientService _patientService = PatientService();
  final SensorService _sensorService = SensorService();

  // List of available doctors
  final List<Map<String, String>> doctors = [
    {
      'id': 'D001',
      'name': 'Dr. Sarah Johnson',
      'specialty': 'Cardiologist',
      'experience': '12 years'
    },
    {
      'id': 'D002',
      'name': 'Dr. Michael Chen',
      'specialty': 'General Physician',
      'experience': '8 years'
    },
    {
      'id': 'D003',
      'name': 'Dr. Emily Rodriguez',
      'specialty': 'Pulmonologist',
      'experience': '10 years'
    },
    {
      'id': 'D004',
      'name': 'Dr. James Wilson',
      'specialty': 'Internal Medicine',
      'experience': '15 years'
    },
  ];

  @override
  void initState() {
    super.initState();
    // Get the current logged-in patient from PatientService
    if (_patientService.currentPatient != null) {
      _currentPatient = _patientService.currentPatient!;
    } else if (widget.patientData != null) {
      // Fallback to provided patient data
      _currentPatient = widget.patientData!;
    } else {
      // Fallback to first mock patient if no data provided
      _currentPatient = mockPatients[0];
    }
    
    // Start the mock sensor simulation
    _sensorService.startSimulation();
  }

  @override
  void dispose() {
    _sensorService.stopSimulation();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green.shade600,
        elevation: 0,
        title: const Text('Patient Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              Navigator.pushNamedAndRemoveUntil(
                context,
                '/login-selection',
                (route) => false,
              );
            },
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.green.shade50,
              Colors.green.shade100,
            ],
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Patient Info Card
              Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.green.shade100,
                            ),
                            child: Icon(
                              Icons.person,
                              size: 30,
                              color: Colors.green.shade600,
                            ),
                          ),
                          const SizedBox(width: 15),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _currentPatient.name,
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  _currentPatient.email,
                                  style: const TextStyle(
                                    color: Colors.grey,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildInfoChip('Age', _currentPatient.age.toString()),
                          _buildInfoChip(
                              'Phone', _currentPatient.phoneNumber),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Doctor Selection Card
              const Text(
                'Your Doctors',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
              const SizedBox(height: 10),
              
              // Display selected doctors
              if (_currentPatient.selectedDoctorIds.isEmpty)
                Card(
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Text(
                          'No doctors selected yet',
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 12),
                        ElevatedButton.icon(
                          onPressed: () => _showAddDoctorDialog(context),
                          icon: const Icon(Icons.add),
                          label: const Text('Add Your First Doctor'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              else
                Column(
                  children: [
                    ..._currentPatient.selectedDoctorIds.map((doctorId) {
                      final doctor = doctors.firstWhere(
                        (d) => d['id'] == doctorId,
                        orElse: () => {'id': '', 'name': '', 'specialty': '', 'experience': ''},
                      );
                      return Card(
                        elevation: 3,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        margin: const EdgeInsets.only(bottom: 12),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.orange.shade100,
                                ),
                                child: Icon(
                                  Icons.local_hospital,
                                  size: 24,
                                  color: Colors.orange.shade600,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      doctor['name'] ?? '',
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      doctor['specialty'] ?? '',
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              IconButton(
                                icon: Icon(Icons.close, color: Colors.red.shade400),
                                onPressed: () => _removeDoctor(doctorId),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                    const SizedBox(height: 8),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () => _showAddDoctorDialog(context),
                        icon: const Icon(Icons.add),
                        label: const Text('Add Another Doctor'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green.shade600,
                        ),
                      ),
                    ),
                  ],
                ),
              
              const SizedBox(height: 20),
              const Text(
                'Vital Signs',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
              const SizedBox(height: 15),

              // AQI, Body Temp, Room Temp Cards
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisSpacing: 15,
                mainAxisSpacing: 15,
                children: [
                  _buildVitalCard(
                    icon: Icons.air,
                    title: 'AQI',
                    value: _currentPatient.aqi.toString(),
                    unit: 'µg/m³',
                    color: Colors.blue,
                  ),
                  _buildVitalCard(
                    icon: Icons.thermostat,
                    title: 'Body Temp',
                    value: _currentPatient.bodyTemperature.toStringAsFixed(1),
                    unit: '°F',
                    color: Colors.red,
                  ),
                  _buildVitalCard(
                    icon: Icons.thermostat_auto,
                    title: 'Room Temp',
                    value: _currentPatient.roomTemperature.toStringAsFixed(1),
                    unit: '°F',
                    color: Colors.orange,
                  ),
                  _buildVitalCard(
                    icon: Icons.favorite,
                    title: 'Heart Rate',
                    value: '72',
                    unit: 'bpm',
                    color: Colors.pink,
                  ),
                ],
              ),
              const SizedBox(height: 25),

              // ECG Chart
              const Text(
                'ECG Chart (Real-time)',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
              const SizedBox(height: 15),
              Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 250,
                        child: StreamBuilder<List<ECGDataPoint>>(
                          stream: _sensorService.ecgStream,
                          initialData: _currentPatient.ecgData,
                          builder: (context, snapshot) {
                            return CustomPaint(
                              painter: ECGChartPainter(
                                dataPoints: snapshot.data ?? [],
                              ),
                              size: const Size(double.infinity, 250),
                            );
                          }
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'Live Sensor Data (250Hz)',
                        style: TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  void _showAddDoctorDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Doctor'),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: doctors.length,
            itemBuilder: (context, index) {
              final doctor = doctors[index];
              final isSelected =
                  _currentPatient.selectedDoctorIds.contains(doctor['id']);
              return ListTile(
                enabled: !isSelected,
                title: Text(doctor['name'] ?? ''),
                subtitle: Text(doctor['specialty'] ?? ''),
                trailing: isSelected ? const Icon(Icons.check) : null,
                onTap: isSelected
                    ? null
                    : () {
                        setState(() {
                          final updatedIds = [
                            ..._currentPatient.selectedDoctorIds,
                            doctor['id']!,
                          ];
                          _currentPatient =
                              _currentPatient.copyWith(
                            selectedDoctorIds: updatedIds,
                          );
                          // Update in service
                          _patientService.updateSelectedDoctors(updatedIds);
                        });
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                                '${doctor['name']} added successfully'),
                            duration: const Duration(seconds: 2),
                          ),
                        );
                      },
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _removeDoctor(String doctorId) {
    setState(() {
      final updatedIds = _currentPatient.selectedDoctorIds
          .where((id) => id != doctorId)
          .toList();
      _currentPatient = _currentPatient.copyWith(
        selectedDoctorIds: updatedIds,
      );
      // Update in service
      _patientService.updateSelectedDoctors(updatedIds);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Doctor removed'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  Widget _buildInfoChip(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.green.shade50,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.green.shade200),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.grey,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVitalCard({
    required IconData icon,
    required String title,
    required String value,
    required String unit,
    required Color color,
  }) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          gradient: LinearGradient(
            colors: [color.withOpacity(0.1), color.withOpacity(0.05)],
          ),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 35, color: color),
            const SizedBox(height: 10),
            Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 8),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: value,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                  TextSpan(
                    text: ' $unit',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ECG Chart Painter
class ECGChartPainter extends CustomPainter {
  final List<ECGDataPoint> dataPoints;

  ECGChartPainter({required this.dataPoints});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.green.shade600
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final gridPaint = Paint()
      ..color = Colors.grey.shade300
      ..strokeWidth = 0.5;

    // Draw grid
    for (int i = 0; i <= 10; i++) {
      final x = (size.width / 10) * i;
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), gridPaint);
    }

    if (dataPoints.isEmpty) return;

    final minValue = dataPoints.map((p) => p.value).reduce(
        (a, b) => a < b ? a : b);
    final maxValue = dataPoints.map((p) => p.value).reduce(
        (a, b) => a > b ? a : b);
    final range = maxValue - minValue;

    Path path = Path();

    for (int i = 0; i < dataPoints.length; i++) {
      final x = (size.width / (dataPoints.length - 1)) * i;
      final normalizedValue =
          (dataPoints[i].value - minValue) / (range == 0 ? 1 : range);
      final y = size.height - (normalizedValue * size.height);

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }

    canvas.drawPath(path, paint);

    // Draw axis
    canvas.drawLine(Offset(0, size.height), Offset(size.width, size.height),
        Paint()..strokeWidth = 1.5..color = Colors.black);
    canvas.drawLine(
        Offset(0, 0), Offset(0, size.height),
        Paint()..strokeWidth = 1.5..color = Colors.black);
  }

  @override
  bool shouldRepaint(ECGChartPainter oldDelegate) => true;
}
