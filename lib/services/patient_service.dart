import '../models/patient.dart';

class PatientService {
  static final PatientService _instance = PatientService._internal();
  
  PatientData? _currentPatient;
  
  // List to store all registered patients
  static final List<PatientData> _registeredPatients = [];
  
  factory PatientService() {
    return _instance;
  }
  
  PatientService._internal();
  
  // Get current logged-in patient
  PatientData? get currentPatient => _currentPatient;
  
  // Check if patient is logged in
  bool get isLoggedIn => _currentPatient != null;
  
  // Sign up a new patient
  PatientData signUpPatient({
    required String name,
    required String email,
    required String phone,
  }) {
    final newPatient = PatientData(
      id: 'P${DateTime.now().millisecondsSinceEpoch}',
      name: name,
      email: email,
      age: 30,
      phoneNumber: phone,
      bodyTemperature: 98.6,
      roomTemperature: 72.0,
      aqi: 45,
      ecgData: generateECGData(),
      selectedDoctorIds: [],
    );
    
    _registeredPatients.add(newPatient);
    _currentPatient = newPatient;
    return newPatient;
  }
  
  // Login patient by email
  bool loginPatient(String email, String password) {
    try {
      final patient = _registeredPatients.firstWhere(
        (p) => p.email == email,
      );
      _currentPatient = patient;
      return true;
    } catch (e) {
      return false;
    }
  }
  
  // Update current patient's selected doctors
  void updateSelectedDoctors(List<String> doctorIds) {
    if (_currentPatient != null) {
      _currentPatient = _currentPatient!.copyWith(
        selectedDoctorIds: doctorIds,
      );
      
      // Update in registered list
      final index = _registeredPatients.indexWhere(
        (p) => p.id == _currentPatient!.id,
      );
      if (index >= 0) {
        _registeredPatients[index] = _currentPatient!;
      }
    }
  }
  
  // Add doctor to current patient
  void addDoctorToCurrentPatient(String doctorId) {
    if (_currentPatient != null) {
      final updatedIds = [
        ..._currentPatient!.selectedDoctorIds,
        doctorId,
      ];
      updateSelectedDoctors(updatedIds);
    }
  }
  
  // Remove doctor from current patient
  void removeDoctorFromCurrentPatient(String doctorId) {
    if (_currentPatient != null) {
      final updatedIds = _currentPatient!.selectedDoctorIds
          .where((id) => id != doctorId)
          .toList();
      updateSelectedDoctors(updatedIds);
    }
  }
  
  // Logout patient
  void logout() {
    _currentPatient = null;
  }
  
  // Get all registered patients (for doctor dashboard)
  List<PatientData> getAllPatients() {
    return _registeredPatients;
  }
  
  // Get patients who selected a specific doctor
  List<PatientData> getPatientsByDoctor(String doctorId) {
    return _registeredPatients
        .where((patient) => patient.selectedDoctorIds.contains(doctorId))
        .toList();
  }
}
