import 'dart:math';

class PatientData {
  final String id;
  final String name;
  final String email;
  final int age;
  final String phoneNumber;
  final double bodyTemperature;
  final double roomTemperature;
  final int aqi;
  final List<ECGDataPoint> ecgData;
  final List<String> selectedDoctorIds;

  PatientData({
    required this.id,
    required this.name,
    required this.email,
    required this.age,
    required this.phoneNumber,
    required this.bodyTemperature,
    required this.roomTemperature,
    required this.aqi,
    required this.ecgData,
    this.selectedDoctorIds = const [],
  });

  // Create a copy with modified selected doctors
  PatientData copyWith({
    List<String>? selectedDoctorIds,
  }) {
    return PatientData(
      id: id,
      name: name,
      email: email,
      age: age,
      phoneNumber: phoneNumber,
      bodyTemperature: bodyTemperature,
      roomTemperature: roomTemperature,
      aqi: aqi,
      ecgData: ecgData,
      selectedDoctorIds: selectedDoctorIds ?? this.selectedDoctorIds,
    );
  }
}

class ECGDataPoint {
  final DateTime time;
  final double value;

  ECGDataPoint({required this.time, required this.value});
}

// Mock data for demo
final List<PatientData> mockPatients = [
  PatientData(
    id: 'P001',
    name: 'John Doe',
    email: 'john@example.com',
    age: 35,
    phoneNumber: '+1-234-567-8900',
    bodyTemperature: 98.6,
    roomTemperature: 72.0,
    aqi: 45,
    ecgData: generateECGData(),
  ),
  PatientData(
    id: 'P002',
    name: 'Jane Smith',
    email: 'jane@example.com',
    age: 28,
    phoneNumber: '+1-234-567-8901',
    bodyTemperature: 98.2,
    roomTemperature: 71.5,
    aqi: 52,
    ecgData: generateECGData(),
  ),
  PatientData(
    id: 'P003',
    name: 'Robert Johnson',
    email: 'robert@example.com',
    age: 42,
    phoneNumber: '+1-234-567-8902',
    bodyTemperature: 99.1,
    roomTemperature: 70.0,
    aqi: 38,
    ecgData: generateECGData(),
  ),
];

List<ECGDataPoint> generateECGData() {
  final now = DateTime.now();
  return List.generate(
    100,
    (index) => ECGDataPoint(
      time: now.subtract(Duration(seconds: 100 - index)),
      value: 50 + (30 * sin(1 + 0.5 * index / 100)),
    ),
  );
}
