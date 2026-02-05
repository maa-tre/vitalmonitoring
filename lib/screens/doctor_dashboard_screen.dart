import 'package:flutter/material.dart';
import '../models/patient.dart';
import '../services/patient_service.dart';
import '../services/sensor_service.dart';

class DoctorDashboardScreen extends StatefulWidget {
  final String doctorId;

  const DoctorDashboardScreen({super.key, this.doctorId = 'D001'});

  @override
  State<DoctorDashboardScreen> createState() =>
      _DoctorDashboardScreenState();
}

class _DoctorDashboardScreenState extends State<DoctorDashboardScreen> {
  late String _doctorId;
  final PatientService _patientService = PatientService();
  final SensorService _sensorService = SensorService();

  @override
  void initState() {
    super.initState();
    _doctorId = widget.doctorId;
    
    // Ensure simulation is running
    _sensorService.startSimulation();
  }

  @override
  void dispose() {
    // Note: In a shared view, we might not want to stop it, 
    // but for this demo context, we manage it here.
    _sensorService.stopSimulation();
    super.dispose();
  }

  // Get patients who have selected this doctor from PatientService
  List<PatientData> _getMyPatients() {
    return _patientService.getPatientsByDoctor(_doctorId);
  }
  
  // Get doctor info by ID
  Map<String, String> _getDoctorInfo() {
    final doctorsList = [
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
    return doctorsList.firstWhere(
      (d) => d['id'] == _doctorId,
      orElse: () => doctorsList[0],
    );
  }

  @override
  Widget build(BuildContext context) {
    final myPatients = _getMyPatients();
    final doctorInfo = _getDoctorInfo();
    
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange.shade600,
        elevation: 0,
        title: const Text('Doctor Dashboard'),
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
              Colors.orange.shade50,
              Colors.orange.shade100,
            ],
          ),
        ),
        child: Column(
          children: [
            // Doctor Info Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.orange.shade600,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                        ),
                        child: Icon(
                          Icons.person,
                          size: 28,
                          color: Colors.orange.shade600,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              doctorInfo['name'] ?? 'Doctor',
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              doctorInfo['specialty'] ?? '',
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.white70,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Experience: ${doctorInfo['experience'] ?? ''}',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),
            
            // Summary Cards
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  _buildSummaryCard(
                    'My Patients',
                    myPatients.length.toString(),
                    Colors.blue,
                    Icons.people,
                  ),
                  const SizedBox(width: 15),
                  _buildSummaryCard(
                    'High Temp',
                    myPatients
                        .where((p) => p.bodyTemperature > 99.0)
                        .length
                        .toString(),
                    Colors.red,
                    Icons.warning,
                  ),
                  const SizedBox(width: 15),
                  _buildSummaryCard(
                    'Poor AQI',
                    myPatients.where((p) => p.aqi > 50).length.toString(),
                    Colors.amber,
                    Icons.air,
                  ),
                ],
              ),
            ),

            // Patients List
            Expanded(
              child: myPatients.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.people_outline,
                            size: 60,
                            color: Colors.grey.shade400,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No patients have selected you yet',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: myPatients.length,
                      itemBuilder: (context, index) {
                        final patient = myPatients[index];
                        return _buildPatientCard(context, patient);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCard(
    String title,
    String count,
    Color color,
    IconData icon,
  ) {
    return Container(
      width: 150,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 35, color: color),
          const SizedBox(height: 10),
          Text(
            count,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.grey,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildPatientCard(BuildContext context, PatientData patient) {
    final statusColor = patient.bodyTemperature > 99.0
        ? Colors.red
        : patient.bodyTemperature < 97.0
            ? Colors.blue
            : Colors.green;

    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      margin: const EdgeInsets.only(bottom: 15),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          gradient: LinearGradient(
            colors: [Colors.white, Colors.grey.shade50],
          ),
        ),
        child: Theme(
          data: Theme.of(context).copyWith(
            dividerColor: Colors.transparent,
          ),
          child: ExpansionTile(
            leading: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: statusColor.withOpacity(0.2),
              ),
              child: Icon(
                Icons.person,
                color: statusColor,
                size: 24,
              ),
            ),
            title: Text(
              patient.name,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            subtitle: Text(
              'ID: ${patient.id} | Age: ${patient.age}',
              style: const TextStyle(fontSize: 12),
            ),
            trailing: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: statusColor.withOpacity(0.2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                '${patient.bodyTemperature.toStringAsFixed(1)}°F',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: statusColor,
                  fontSize: 12,
                ),
              ),
            ),
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Divider(),
                    const SizedBox(height: 10),
                    // Contact Info
                    _buildDetailRow('Email', patient.email, Icons.email),
                    const SizedBox(height: 12),
                    _buildDetailRow(
                        'Phone', patient.phoneNumber, Icons.phone),
                    const SizedBox(height: 20),

                    // Vital Signs Grid
                    const Text(
                      'Current Vitals',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 12),
                    GridView.count(
                      crossAxisCount: 2,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 1.5,
                      children: [
                        _buildVitalTile(
                          'Body Temp',
                          '${patient.bodyTemperature.toStringAsFixed(1)}°F',
                          Colors.red,
                          Icons.thermostat,
                        ),
                        _buildVitalTile(
                          'Room Temp',
                          '${patient.roomTemperature.toStringAsFixed(1)}°F',
                          Colors.orange,
                          Icons.thermostat_auto,
                        ),
                        _buildVitalTile(
                          'AQI',
                          '${patient.aqi} µg/m³',
                          Colors.blue,
                          Icons.air,
                        ),
                        _buildVitalTile(
                          'Heart Rate',
                          '72 bpm',
                          Colors.pink,
                          Icons.favorite,
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Action Buttons
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () {
                              // View detailed chart
                              _showDetailedChart(context, patient);
                            },
                            icon: const Icon(Icons.analytics),
                            label: const Text('View Chart'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orange.shade600,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () {
                              // Send alert/message
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                      'Message sent to ${patient.name}'),
                                  duration: const Duration(seconds: 2),
                                ),
                              );
                            },
                            icon: const Icon(Icons.mail),
                            label: const Text('Send Alert'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue.shade600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.orange.shade600),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
      ],
    );
  }

  Widget _buildVitalTile(
    String label,
    String value,
    Color color,
    IconData icon,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      padding: const EdgeInsets.all(8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(fontSize: 11, color: Colors.grey),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 12,
              color: color,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  void _showDetailedChart(BuildContext context, PatientData patient) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('${patient.name} - ECG Chart'),
        content: SizedBox(
          width: 300,
          height: 250,
          child: StreamBuilder<List<ECGDataPoint>>(
            stream: _sensorService.ecgStream,
            initialData: patient.ecgData,
            builder: (context, snapshot) {
              return CustomPaint(
                painter: ECGChartPainter(dataPoints: snapshot.data ?? []),
                size: const Size(double.infinity, 250),
              );
            }
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
}

// ECG Chart Painter
class ECGChartPainter extends CustomPainter {
  final List<ECGDataPoint> dataPoints;

  ECGChartPainter({required this.dataPoints});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.orange.shade600
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
