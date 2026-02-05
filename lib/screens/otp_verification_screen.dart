import 'package:flutter/material.dart';
import 'dart:async';
import '../services/otp_service.dart';
import '../services/patient_service.dart';
import 'patient_dashboard_screen.dart';

class OTPVerificationScreen extends StatefulWidget {
  final String email;
  final String name;
  final String phone;
  final String password;
  final bool isSignUp;

  const OTPVerificationScreen({
    super.key,
    required this.email,
    required this.name,
    required this.phone,
    required this.password,
    this.isSignUp = true,
  });

  @override
  State<OTPVerificationScreen> createState() => _OTPVerificationScreenState();
}

class _OTPVerificationScreenState extends State<OTPVerificationScreen> {
  late TextEditingController _otpController;
  final OTPService _otpService = OTPService();
  final PatientService _patientService = PatientService();
  late Timer _timer;
  int _timeRemaining = 300; // 5 minutes
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _otpController = TextEditingController();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      final remaining = _otpService.getTimeRemaining();
      setState(() {
        _timeRemaining = remaining;
      });
      if (remaining <= 0) {
        _timer.cancel();
      }
    });
  }

  void _verifyOTP() {
    if (_otpController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter OTP'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    // Verify OTP
    if (_otpService.verifyOTP(_otpController.text)) {
      // OTP verified successfully
      if (widget.isSignUp) {
        // Sign up with verified email
        final newPatient = _patientService.signUpPatient(
          name: widget.name,
          email: widget.email,
          phone: widget.phone,
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) =>
                PatientDashboardScreen(patientData: newPatient),
          ),
        );
      } else {
        // Login with verified email
        final isLoggedIn = _patientService.loginPatient(
          widget.email,
          widget.password,
        );

        if (isLoggedIn) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  PatientDashboardScreen(
                    patientData: _patientService.currentPatient,
                  ),
            ),
          );
        }
      }
    } else {
      setState(() => _isLoading = false);
      final remaining = _otpService.getRemainingAttempts();
      if (remaining <= 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Maximum attempts exceeded. Please try again later.'),
            backgroundColor: Colors.red,
          ),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Invalid OTP. Attempts remaining: $remaining'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _resendOTP() {
    _otpService.clearOTP();
    _otpService.generateOTP(widget.email);
    _otpController.clear();
    _timeRemaining = 300;
    _startTimer();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('OTP resent to your email'),
        backgroundColor: Colors.green,
      ),
    );
  }

  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final secs = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _otpController.dispose();
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green.shade600,
        elevation: 0,
        title: const Text('Verify Email'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
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
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 50),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.green.shade600,
                  ),
                  child: const Icon(
                    Icons.mail_outline,
                    size: 50,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 30),
                const Text(
                  'Verify Your Email',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
                const SizedBox(height: 15),
                Text(
                  'We sent a verification code to',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  widget.email,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
                const SizedBox(height: 40),

                // OTP Input Field
                TextField(
                  controller: _otpController,
                  keyboardType: TextInputType.number,
                  maxLength: 6,
                  textAlign: TextAlign.center,
                  enabled: !_isLoading,
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 10,
                  ),
                  decoration: InputDecoration(
                    hintText: '000000',
                    hintStyle: TextStyle(
                      fontSize: 32,
                      color: Colors.grey.shade300,
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: const BorderSide(color: Colors.green),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(color: Colors.green.shade300),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(color: Colors.green.shade600, width: 2),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 20,
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Timer
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(
                    color: _timeRemaining > 60
                        ? Colors.blue.shade50
                        : Colors.orange.shade50,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: _timeRemaining > 60
                          ? Colors.blue.shade200
                          : Colors.orange.shade200,
                    ),
                  ),
                  child: Text(
                    'Code expires in: ${_formatTime(_timeRemaining)}',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: _timeRemaining > 60
                          ? Colors.blue.shade600
                          : Colors.orange.shade600,
                    ),
                  ),
                ),
                const SizedBox(height: 30),

                // Verify Button
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _isLoading || _timeRemaining == 0
                        ? null
                        : _verifyOTP,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green.shade600,
                      disabledBackgroundColor: Colors.grey.shade400,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.white,
                              ),
                            ),
                          )
                        : const Text(
                            'Verify',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                  ),
                ),
                const SizedBox(height: 20),

                // Resend OTP Button
                TextButton(
                  onPressed: _timeRemaining == 0 ? _resendOTP : null,
                  child: Text(
                    _timeRemaining == 0
                        ? 'Resend OTP'
                        : 'Resend OTP (${_formatTime(_timeRemaining)})',
                    style: TextStyle(
                      color: _timeRemaining == 0
                          ? Colors.green.shade600
                          : Colors.grey.shade400,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
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
