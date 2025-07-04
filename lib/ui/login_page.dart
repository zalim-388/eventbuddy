import 'package:eventbuddy/service/authservice.dart';
import 'package:eventbuddy/ui/home_page.dart';
import 'package:eventbuddy/ui/sign_up.dart';
import 'package:eventbuddy/utils/fontstyle.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final AuthService _authService = AuthService();
  bool _isLoading = false;
  bool _isGoogleLoading = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Future<void> _loginUser() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final userCredential = await _authService.signInWithEmailAndPassword(
        emailController.text.trim(),
        passwordController.text.trim(),
      );

      if (userCredential != null && mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
        );
      }
    } on FirebaseAuthException catch (e) {
      if (mounted) {
        String message = 'Login failed';
        switch (e.code) {
          case 'user-not-found':
            message = 'No user found with this email';
            break;
          case 'wrong-password':
            message = 'Wrong password provided';
            break;
          case 'invalid-email':
            message = 'Invalid email address';
            break;
          case 'user-disabled':
            message = 'User account has been disabled';
            break;
          case 'too-many-requests':
            message = 'Too many failed attempts. Please try again later';
            break;
          default:
            message = e.message ?? 'Login failed';
        }
        _showSnackBar(message);
      }
    } catch (e) {
      if (mounted) {
        _showSnackBar('Login failed: ${e.toString()}');
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _signInWithGoogle() async {
    setState(() => _isGoogleLoading = true);
    try {
      final userCredential = await _authService.signInWithGoogle();
      if (userCredential != null && mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
        );
      }
    } on FirebaseAuthException catch (e) {
      if (mounted) {
        String message = 'Google sign-in failed';
        switch (e.code) {
          case 'account-exists-with-different-credential':
            message = 'An account already exists with a different sign-in method';
            break;
          case 'invalid-credential':
            message = 'Invalid credentials provided';
            break;
          case 'operation-not-allowed':
            message = 'Google sign-in is not enabled';
            break;
          case 'network-request-failed':
            message = 'Network error. Please check your connection';
            break;
          default:
            message = e.message ?? 'Google sign-in failed';
        }
        _showSnackBar(message);
      }
    } catch (e) {
      if (mounted) {
        String message = 'Google sign-in failed';
        
      
        if (e.toString().contains('not configured properly')) {
          message = 'Google Sign-In not configured properly';
        } else if (e.toString().contains('CLIENT_ID')) {
          message = 'Google Sign-In configuration error';
        } else if (e.toString().contains('authentication tokens')) {
          message = 'Failed to authenticate with Google';
        } else {
          message = 'Google sign-in failed: ${e.toString()}';
        }
        
        _showSnackBar(message);
      }
    } finally {
      if (mounted) {
        setState(() => _isGoogleLoading = false);
      }
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const BackButton(color: Color(0xFF6C63FF)),
        title: Text(
          "Login",
          style: fontStyle.heading.copyWith(color: const Color(0xFF6C63FF)),
        ),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 22),
          child: Column(
            children: [
              SizedBox(height: 50.h),

              Icon(Icons.event, size: 80, color: Color(0xFF6C63FF)),

              SizedBox(height: 50.h),

              _TextField(
                hint: "Email",
                controller: emailController,
                keybordtype: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  } else if (!RegExp(
                    r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                  ).hasMatch(value)) {
                    return 'Enter a valid email address';
                  }
                  return null;
                },
              ),

              SizedBox(height: 16.h),

              _TextField(
                hint: "Password",
                controller: passwordController,
                password: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  } else if (value.length < 6) {
                    return 'Password must be at least 6 characters';
                  }
                  return null;
                },
              ),

              SizedBox(height: 24.h),

              GestureDetector(
                onTap: _isLoading || _isGoogleLoading ? null : _loginUser,
                child: Container(
                  height: 50.h,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color:
                        _isLoading || _isGoogleLoading
                            ? const Color(0xFF6C63FF).withOpacity(0.6)
                            : const Color(0xFF6C63FF),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  alignment: Alignment.center,
                  child:
                      _isLoading
                          ? const CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          )
                          : Text(
                            "Login",
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                ),
              ),

              SizedBox(height: 16.h),

              Row(
                children: [
                  Expanded(child: Divider(color: Colors.grey[300])),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      "OR",
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 12.sp,
                      ),
                    ),
                  ),
                  Expanded(child: Divider(color: Colors.grey[300])),
                ],
              ),

              SizedBox(height: 16.h),

              GestureDetector(
                onTap:
                    _isLoading || _isGoogleLoading ? null : _signInWithGoogle,
                child: Container(
                  height: 50.h,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color:
                          _isGoogleLoading
                              ? const Color(0xFF6C63FF).withOpacity(0.6)
                              : const Color(0xFF6C63FF),
                    ),
                  ),
                  alignment: Alignment.center,
                  child:
                      _isGoogleLoading
                          ? const CircularProgressIndicator(
                            color: Color(0xFF6C63FF),
                            strokeWidth: 2,
                          )
                          : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.g_mobiledata,
                                size: 24,
                                color: Color(0xFF6C63FF),
                              ),

                              SizedBox(width: 12.w),
                              Text(
                                "Sign in with Google",
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w500,
                                  color: const Color(0xFF6C63FF),
                                ),
                              ),
                            ],
                          ),
                ),
              ),

              SizedBox(height: 24.h),
              GestureDetector(
                onTap: () {},
                child: Text(
                  "Forgot Password?",
                  style: fontStyle.body.copyWith(
                    fontSize: 14.sp,
                    color: const Color(0xFF6C63FF),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),

              SizedBox(height: 24.h),

              Text.rich(
                TextSpan(
                  text: "Don't have an account? ",
                  style: fontStyle.body.copyWith(
                    fontSize: 14.sp,
                    color: Colors.grey[600],
                  ),
                  children: [
                    TextSpan(
                      text: "Sign Up",
                      style: fontStyle.body.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 14.sp,
                        color: const Color(0xFF6C63FF),
                      ),
                      recognizer:
                          TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const SignUp(),
                                ),
                              );
                            },
                    ),
                  ],
                ),
              ),

              SizedBox(height: 30.h),
            ],
          ),
        ),
      ),
    );
  }
}

Widget _TextField({
  required String hint,
  required TextEditingController controller,
  String? Function(String?)? validator,
  IconData? icon,
  bool password = false,
  TextInputType keybordtype = TextInputType.text,
}) {
  return TextFormField(
    controller: controller,
    keyboardType: keybordtype,
    obscureText: password,
    validator: validator,
    decoration: InputDecoration(
      hintText: hint,
      hintStyle: fontStyle.body.copyWith(
        fontSize: 14.sp,
        color: Colors.grey[500],
      ),
      fillColor: Colors.grey[50],
      filled: true,
      suffixIcon:
          icon != null ? Icon(icon, size: 20, color: Colors.grey[600]) : null,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Color(0xFF6C63FF), width: 2),
        borderRadius: BorderRadius.circular(8),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(8),
      ),
      errorBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.red, width: 2),
        borderRadius: BorderRadius.circular(8),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.red, width: 2),
        borderRadius: BorderRadius.circular(8),
      ),
    ),
  );
}