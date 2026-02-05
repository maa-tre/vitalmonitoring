import 'dart:math';

class OTPService {
  static final OTPService _instance = OTPService._internal();
  
  factory OTPService() {
    return _instance;
  }
  
  OTPService._internal();
  
  String? _generatedOTP;
  String? _otpEmail;
  DateTime? _otpExpiryTime;
  int _otpAttempts = 0;
  static const int maxAttempts = 5;
  static const int otpExpiryMinutes = 5;
  
  /// Generate and send OTP to email
  String generateOTP(String email) {
    // Generate 6-digit OTP
    final random = Random();
    _generatedOTP = (100000 + random.nextInt(900000)).toString();
    _otpEmail = email;
    _otpExpiryTime = DateTime.now().add(
      const Duration(minutes: otpExpiryMinutes),
    );
    _otpAttempts = 0;
    
    // In real app, you would send this via email/SMS
    // For demo, we'll print it
    print('OTP for $email: $_generatedOTP');
    print('OTP expires at: $_otpExpiryTime');
    
    return _generatedOTP!;
  }
  
  /// Verify OTP
  bool verifyOTP(String enteredOTP) {
    // Check if OTP is expired
    if (_otpExpiryTime == null || DateTime.now().isAfter(_otpExpiryTime!)) {
      return false;
    }
    
    // Check attempts
    if (_otpAttempts >= maxAttempts) {
      return false;
    }
    
    _otpAttempts++;
    
    // Verify OTP
    if (_generatedOTP == enteredOTP.trim()) {
      _generatedOTP = null;
      _otpEmail = null;
      _otpExpiryTime = null;
      _otpAttempts = 0;
      return true;
    }
    
    return false;
  }
  
  /// Get remaining OTP attempts
  int getRemainingAttempts() {
    return maxAttempts - _otpAttempts;
  }
  
  /// Check if OTP is expired
  bool isOTPExpired() {
    return _otpExpiryTime == null || DateTime.now().isAfter(_otpExpiryTime!);
  }
  
  /// Get time remaining for OTP in seconds
  int getTimeRemaining() {
    if (_otpExpiryTime == null) return 0;
    final remaining = _otpExpiryTime!.difference(DateTime.now()).inSeconds;
    return remaining > 0 ? remaining : 0;
  }
  
  /// Get OTP email
  String? getOTPEmail() => _otpEmail;
  
  /// Clear OTP
  void clearOTP() {
    _generatedOTP = null;
    _otpEmail = null;
    _otpExpiryTime = null;
    _otpAttempts = 0;
  }
}
