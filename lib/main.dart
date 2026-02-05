import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';
import 'screens/login_selection_screen.dart';
import 'screens/patient_login_screen.dart';
import 'screens/doctor_login_screen.dart';
import 'screens/signup_selection_screen.dart';
import 'screens/patient_signup_screen.dart';
import 'screens/doctor_signup_screen.dart';
import 'screens/patient_dashboard_screen.dart';
import 'screens/doctor_dashboard_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Vital Monitoring System',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.light,
        ),
      ),
      home: const SplashScreen(),
      routes: {
        '/login-selection': (context) => const LoginSelectionScreen(),
        '/patient-login': (context) => const PatientLoginScreen(),
        '/doctor-login': (context) => const DoctorLoginScreen(),
        '/signup-selection': (context) => const SignUpSelectionScreen(),
        '/patient-signup': (context) => const PatientSignUpScreen(),
        '/doctor-signup': (context) => const DoctorSignUpScreen(),
        '/patient-dashboard': (context) => const PatientDashboardScreen(),
        '/doctor-dashboard': (context) => const DoctorDashboardScreen(),
      },
    );
  }
}
