import 'dart:math';
import '../config/supabase_config.dart';

class OtpService {
  static String? _currentOtp;
  static String? _currentEmail;
  static DateTime? _otpExpiry;

  static String _generateOtp() {
    final random = Random();
    return (100000 + random.nextInt(900000)).toString(); // 6-digit code
  }

  static Future<String> sendPasswordResetOtp(String email) async {
    // Generate OTP and store locally
    _currentOtp = _generateOtp();
    _currentEmail = email;
    _otpExpiry = DateTime.now().add(Duration(minutes: 5)); // 5-minute expiry
    
    // For development/testing: return the OTP so we can show it to user
    // In production, you'd send this via email service
    
    try {
      // Still send the email (but user can use the generated OTP)
      await supabase.auth.resetPasswordForEmail(
        email,
        redirectTo: 'https://pawconnect.app/otp?code=$_currentOtp',
      );
      
      // Return the OTP for immediate use (development only)
      return _currentOtp!;
    } catch (e) {
      throw Exception('Failed to send OTP: $e');
    }
  }

  static bool verifyOtp(String email, String inputOtp) {
    // Check if OTP is valid and not expired
    if (_currentEmail != email) return false;
    if (_currentOtp != inputOtp) return false;
    if (_otpExpiry == null || DateTime.now().isAfter(_otpExpiry!)) return false;
    
    return true; // Don't clear OTP here, let reset password page clear it
  }

  static void clearOtp() {
    _currentOtp = null;
    _currentEmail = null;
    _otpExpiry = null;
  }

  // Development helper - get current OTP for testing
  static String? getCurrentOtp() => _currentOtp;
}
