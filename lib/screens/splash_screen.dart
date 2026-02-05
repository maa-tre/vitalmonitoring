import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../services/patient_service.dart';
import '../screens/patient_dashboard_screen.dart';
import '../screens/doctor_dashboard_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );

    _animationController.forward();

    // Navigate after 5 seconds
    Future.delayed(const Duration(seconds: 5), () async {
      if (mounted) {
        final loginInfo = await AuthService.getLogin();
        
        if (loginInfo != null) {
          final role = loginInfo['role'];
          final email = loginInfo['email'];

          if (role == 'patient') {
            final patientService = PatientService();
            // Since we don't have a real DB yet, we use the email to find the mock patient
            // john@example.com is the default
            final loggedIn = await patientService.loginPatient(email!, 'password'); 
            
            if (loggedIn && mounted) {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => PatientDashboardScreen(
                    patientData: patientService.currentPatient,
                  ),
                ),
              );
            } else if (mounted) {
              // If patient not found (e.g. data cleared), go to login
              Navigator.of(context).pushReplacementNamed('/login-selection');
            }
          } else if (role == 'doctor') {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => const DoctorDashboardScreen()),
            );
          }
        } else {
          Navigator.of(context).pushReplacementNamed('/login-selection');
        }
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.blue.shade900,
              Colors.blue.shade600,
              Colors.blue.shade400,
            ],
          ),
        ),
        child: Center(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.2),
                  ),
                  child: const Icon(
                    Icons.favorite,
                    size: 80,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 30),
                const Text(
                  'IoT Based Vital',
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
                const Text(
                  'Monitoring System',
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                const Text(
                  'Real-time Health Monitoring',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white70,
                  ),
                ),
                const SizedBox(height: 50),
                SizedBox(
                  width: 50,
                  height: 50,
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Colors.white.withOpacity(0.7),
                    ),
                    strokeWidth: 3,
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
