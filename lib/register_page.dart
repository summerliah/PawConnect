import 'package:flutter/material.dart';
import 'services/auth_service.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmController = TextEditingController();
  bool _isLoading = false;
  bool _privacyConsent = false;
  bool _termsConsent = false;

  DateTime? selectedDate;
  String? selectedGender;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Color(0xFFFFA500),
              onPrimary: Colors.black,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
            dialogBackgroundColor: Colors.white,
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  Future<void> _signUp() async {
    if (_validateForm()) {
      setState(() {
        _isLoading = true;
      });

      try {
        final dateOfBirth = _getDateOfBirth();

        await AuthService.signUp(
          email: emailController.text.trim(),
          password: passwordController.text,
          firstName: firstNameController.text.trim(),
          lastName: lastNameController.text.trim(),
          gender: selectedGender,
          dateOfBirth: dateOfBirth,
        );

        if (mounted) {
          // Show email verification popup with modern design
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return Dialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
                elevation: 0,
                backgroundColor: Colors.transparent,
                child: Container(
                  padding: EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 20,
                        offset: Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Success animation container
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Color(0xFF4CAF50), Color(0xFF8BC34A)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Color(0xFF4CAF50).withOpacity(0.3),
                              blurRadius: 15,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.check_rounded,
                          color: Colors.white,
                          size: 40,
                        ),
                      ),
                      SizedBox(height: 24),

                      // Main title
                      Text(
                        'Account Created! 🎉',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2E2E2E),
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 12),

                      // Subtitle
                      Text(
                        'Welcome to Paw Connect!',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF666666),
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 20),

                      // Email info card
                      Container(
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Color(0xFFF8F9FA),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: Color(0xFFE3E8EE),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Color(0xFFFFA500).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(
                                Icons.email_outlined,
                                color: Color(0xFFFFA500),
                                size: 20,
                              ),
                            ),
                            SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Verify your email',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF2E2E2E),
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    emailController.text.trim(),
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Color(0xFF666666),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 16),

                      // Description
                      Text(
                        'We\'ve sent a verification link to your email. Please check your inbox and click the link to activate your account.',
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFF666666),
                          height: 1.4,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 24),

                      // Modern button
                      Container(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                            Navigator.pushReplacementNamed(context, '/login');
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFFFFA500),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            'Continue to Login',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Registration failed: ${e.toString()}')),
          );
        }
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }

  bool _validateForm() {
    if (firstNameController.text.isEmpty ||
        lastNameController.text.isEmpty ||
        emailController.text.isEmpty ||
        passwordController.text.isEmpty ||
        confirmController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill in all fields')),
      );
      return false;
    }

    if (passwordController.text != confirmController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Passwords do not match')),
      );
      return false;
    }

    if (passwordController.text.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Password must be at least 6 characters')),
      );
      return false;
    }

    if (!_privacyConsent || !_termsConsent) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
                'Please accept both Privacy Policy and Terms & Conditions')),
      );
      return false;
    }

    return true;
  }

  DateTime? _getDateOfBirth() {
    return selectedDate;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFF4E6), // light pink background
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Color(0xFFFFA500),
            size: 24,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(height: 2),

              // PAW CONNECT Logo with paw
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "PAW",
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFFFA500),
                    ),
                  ),
                  SizedBox(width: 8),
                  Icon(Icons.pets, size: 32, color: Color(0xFF00BFA5)),
                  SizedBox(width: 8),
                  Text(
                    "CONNECT",
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFFFA500),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10), // Reduced from 20

              Text(
                "Join our Pet Family!",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 18), // Reduced from 30

              // First Name and Last Name fields
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: firstNameController,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.pets, color: Colors.yellow[700]),
                        labelText: 'First Name',
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: TextField(
                      controller: lastNameController,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.pets, color: Colors.yellow[700]),
                        labelText: 'Last Name',
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),

              // Date of Birth section
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Date Of Birth',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
              ),
              SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: Color.fromARGB(255, 0, 0, 0)),
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(30),
                    onTap: () => _selectDate(context),
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      child: Row(
                        children: [
                          Icon(Icons.calendar_today,
                              color: Color.fromARGB(255, 0, 0, 0)),
                          SizedBox(width: 12),
                          Text(
                            selectedDate != null
                                ? '${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}'
                                : 'Select Date',
                            style: TextStyle(
                              fontSize: 16,
                              color: selectedDate != null
                                  ? Colors.black
                                  : Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16),

              // Gender section
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Gender',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
              ),
              SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Color.fromARGB(255, 0, 0, 0)),
                        borderRadius: BorderRadius.circular(30),
                        color: Colors.white,
                      ),
                      child: Row(
                        children: [
                          Radio<String>(
                            value: 'Male',
                            groupValue: selectedGender,
                            onChanged: (String? value) {
                              setState(() {
                                selectedGender = value;
                              });
                            },
                            activeColor: Color.fromARGB(255, 0, 0, 0),
                          ),
                          Icon(Icons.male,
                              color: Color.fromARGB(255, 54, 178, 255)),
                          Text('Male'),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Color.fromARGB(255, 0, 0, 0)),
                        borderRadius: BorderRadius.circular(30),
                        color: Colors.white,
                      ),
                      child: Row(
                        children: [
                          Radio<String>(
                            value: 'Female',
                            groupValue: selectedGender,
                            onChanged: (String? value) {
                              setState(() {
                                selectedGender = value;
                              });
                            },
                            activeColor: Color(0xFFFFA500),
                          ),
                          Icon(Icons.female,
                              color: Color.fromARGB(255, 251, 91, 131)),
                          Text('Female'),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),

              // Email field
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.email, color: Color(0xFFFFA500)),
                  labelText: 'Email',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide(color: Color(0xFFFFA500)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide(color: Color(0xFFFFA500)),
                  ),
                ),
              ),
              SizedBox(height: 16),

              // Password field
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.lock, color: Color(0xFFFFA500)),
                  labelText: 'Password',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide(color: Color(0xFFFFA500)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide(color: Color(0xFFFFA500)),
                  ),
                ),
              ),
              SizedBox(height: 16),

              // Confirm Password field
              TextField(
                controller: confirmController,
                obscureText: true,
                decoration: InputDecoration(
                  prefixIcon:
                      Icon(Icons.lock_outline, color: Color(0xFFFFA500)),
                  labelText: 'Confirm Password',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide(color: Color(0xFFFFA500)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide(color: Color(0xFFFFA500)),
                  ),
                ),
              ),
              SizedBox(height: 16),

              // Legal Agreements Section
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Legal Agreements',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 12),
                    // Privacy Policy Consent
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Checkbox(
                          value: _privacyConsent,
                          onChanged: (bool? value) {
                            setState(() {
                              _privacyConsent = value ?? false;
                            });
                          },
                          activeColor: Color(0xFFFFA500),
                        ),
                        Expanded(
                          child: Wrap(
                            children: [
                              Text(
                                'I agree to the ',
                                style: TextStyle(fontSize: 14),
                              ),
                              GestureDetector(
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text('Privacy Policy'),
                                        content: SingleChildScrollView(
                                          child: Text(
                                            'By using our app, you agree that we may collect and use your personal information in accordance with our privacy policy. '
                                            'We collect information to provide better services to our users and ensure a safe environment for all pet lovers. '
                                            'Your information is protected and will never be shared with unauthorized third parties.',
                                          ),
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: Text('Close'),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                                child: Text(
                                  'Privacy Policy',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Color(0xFFFFA500),
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ),
                              Text(
                                ' and consent to the processing of my personal information.',
                                style: TextStyle(fontSize: 14),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    // Terms & Conditions Consent
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Checkbox(
                          value: _termsConsent,
                          onChanged: (bool? value) {
                            setState(() {
                              _termsConsent = value ?? false;
                            });
                          },
                          activeColor: Color(0xFFFFA500),
                        ),
                        Expanded(
                          child: Wrap(
                            children: [
                              Text(
                                'I agree to the ',
                                style: TextStyle(fontSize: 14),
                              ),
                              GestureDetector(
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text('Terms & Conditions'),
                                        content: SingleChildScrollView(
                                          child: Text(
                                            'By using Paw Connect, you agree to our terms and conditions. '
                                            'You must be at least 13 years old to use this service. '
                                            'You are responsible for maintaining the security of your account. '
                                            'We reserve the right to modify or terminate the service for any reason, without notice at any time. '
                                            'Do not abuse, harass, threaten, or impersonate others.',
                                          ),
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: Text('Close'),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                                child: Text(
                                  'Terms & Conditions',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Color(0xFFFFA500),
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ),
                              Text(
                                ' that govern the use of Paw Connect.',
                                style: TextStyle(fontSize: 14),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 25),

              // Register button
              SizedBox(
                width: 200,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    backgroundColor: Colors.orange,
                  ),
                  onPressed: _isLoading ? null : _signUp,
                  child: _isLoading
                      ? CircularProgressIndicator(color: Colors.white)
                      : Text('Register',
                          style: TextStyle(fontSize: 18, color: Colors.white)),
                ),
              ),
              SizedBox(height: 10),

              // Already have an account button
              TextButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/');
                },
                child: Text(
                  'Already have an account?',
                  style: TextStyle(color: Colors.black),
                ),
              ),
              SizedBox(height: 20),

              // Cat image at the bottom
              Image.asset(
                'assets/newcat.png',
                height: 350, // Increased from 120
                fit: BoxFit.contain,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
