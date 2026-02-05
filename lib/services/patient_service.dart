import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/patient.dart';

class PatientService {
  static final PatientService _instance = PatientService._internal();
  
  PatientData? _currentPatient;
  static const String _keyPatients = 'registered_patients';
  
  // List to store all registered patients
  static List<PatientData> _registeredPatients = [];
  bool _isLoaded = false;
  
  factory PatientService() {
    return _instance;
  }
  
  PatientService._internal() {
    // Lazily load patients when some method is called
  }

  Future<void> _ensureLoaded() async {
    if (_isLoaded) return;
    final prefs = await SharedPreferences.getInstance();
    final String? patientsJson = prefs.getString(_keyPatients);
    
    if (patientsJson != null) {
      final List<dynamic> decoded = jsonDecode(patientsJson);
      _registeredPatients = decoded.map((p) => PatientData.fromJson(p)).toList();
    } else {
      // Initialize with mock data if empty
      _registeredPatients = List.from(mockPatients);
      await _savePatients();
    }
    _isLoaded = true;
  }

  Future<void> _savePatients() async {
    final prefs = await SharedPreferences.getInstance();
    final String encoded = jsonEncode(_registeredPatients.map((p) => p.toJson()).toList());
    await prefs.setString(_keyPatients, encoded);
  }
  
  // Get current logged-in patient
  PatientData? get currentPatient => _currentPatient;
  
  // Check if patient is logged in
  bool get isLoggedIn => _currentPatient != null;
  
  // Sign up a new patient
  Future<PatientData> signUpPatient({
    required String name,
    required String email,
    required String phone,
  }) async {
    await _ensureLoaded();
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
    await _savePatients();
    _currentPatient = newPatient;
    return newPatient;
  }
  
  // Login patient by email
  Future<bool> loginPatient(String email, String password) async {
    await _ensureLoaded();
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
  Future<void> updateSelectedDoctors(List<String> doctorIds) async {
    await _ensureLoaded();
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
        await _savePatients();
      }
    }
  }
  
  // Add doctor to current patient
  Future<void> addDoctorToCurrentPatient(String doctorId) async {
    if (_currentPatient != null) {
      final updatedIds = [
        ..._currentPatient!.selectedDoctorIds,
        doctorId,
      ];
      await updateSelectedDoctors(updatedIds);
    }
  }
  
  // Remove doctor from current patient
  Future<void> removeDoctorFromCurrentPatient(String doctorId) async {
    if (_currentPatient != null) {
      final updatedIds = _currentPatient!.selectedDoctorIds
          .where((id) => id != doctorId)
          .toList();
      await updateSelectedDoctors(updatedIds);
    }
  }
  
  // Logout patient
  void logout() {
    _currentPatient = null;
  }
  
  // Get all registered patients (for doctor dashboard)
  Future<List<PatientData>> getAllPatients() async {
    await _ensureLoaded();
    return _registeredPatients;
  }
  
  // Get patients who selected a specific doctor
  Future<List<PatientData>> getPatientsByDoctor(String doctorId) async {
    await _ensureLoaded();
    return _registeredPatients
        .where((patient) => patient.selectedDoctorIds.contains(doctorId))
        .toList();
  }
}
