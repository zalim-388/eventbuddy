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
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final AuthService _authService = AuthService();
  bool _isLoading = false;
  bool _isGoogleLoading = false;
  bool _isGoogleSignedIn = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Future<void> _loginUser(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      print("Email: ${emailController.text.trim()}");
      print("Password: ${passwordController.text.trim()}");

      setState(() {
        _isLoading = true;
      });

      try {
        UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
        );

        User? user = userCredential.user;

        if (user != null) {
          if (user.emailVerified) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const HomePage()),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Please verify your email before logging in"),
              ),
            );
            await _auth.signOut();
          }
        }
      } on FirebaseAuthException catch (e) {
        print("FirebaseAuthException $e");
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Login failed$e")));
      } catch (e) {
        print("Unexpected login error: $e");
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Unexpected error: $e")));
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _signInWithGoogle() async {
    setState(() => _isGoogleLoading = true);

    try {
      final userCredential = await _authService.signInWithGoogle();
      final user = userCredential?.user;
      if (user != null && mounted) {
        setState(() {
          emailController.text = user.email ?? "";
          passwordController.text = "";
          _isGoogleSignedIn = true;
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) =>  HomePage()),
          );
        });
      }

      // if (userCredential != null && mounted) {
      //   Navigator.pushReplacement(
      //     context,
      //     MaterialPageRoute(builder: (context) => const HomePage()),
      //   );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Google sign-in failed: $e')));
      }
    } finally {
      if (mounted) {
        setState(() => _isGoogleLoading = false);
      }
    }
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
        leading: const BackButton(),
        title: Text(
          "Login",
          style: fontStyle.heading.copyWith(color: const Color(0xFF6C63FF)),
        ),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 22),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 200.h),
                _TextField(
                  hint: "Email",
                  controller: emailController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    } else if (!RegExp(
                      r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                    ).hasMatch(value)) {
                      return 'Enter a valid email (e.g., example@domain.com)';
                    }
                    return null;
                  },
                  readonly: _isGoogleSignedIn,
                ),
                SizedBox(height: 10.h),
                _TextField(
                  hint: "Password",
                  controller: passwordController,
                  password: true,
                  validator: (value) {
                    if (value == null || value.length < 6) {
                      return 'Password must be at least 6 characters';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20.h),
                GestureDetector(
                  onTap: _isLoading ? null : () => _loginUser(context),
                  child: Container(
                    height: 50.h,
                    width: 343.w,
                    decoration: BoxDecoration(
                      color: const Color(0xFF6C63FF),
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
                                color: Colors.white,
                              ),
                            ),
                  ),
                ),
                SizedBox(height: 20.h),
                GestureDetector(
                  onTap: () => _signInWithGoogle(),
                  child: Container(
                    height: 50.h,
                    width: 343.w,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: const Color(0xFF6C63FF)),
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
                                SizedBox(width: 10.w),
                                Text(
                                  "Sign in with Google",
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    color: const Color(0xFF6C63FF),
                                  ),
                                ),
                              ],
                            ),
                  ),
                ),
                SizedBox(height: 24.h),
                Padding(
                  padding: const EdgeInsets.only(left: 50),
                  child: Text.rich(
                    TextSpan(
                      text: "Don't have an account? ",
                      style: fontStyle.body.copyWith(fontSize: 13),
                      children: [
                        TextSpan(
                          text: "Sign Up",
                          style: fontStyle.body.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
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
                ),
              ],
            ),
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
  bool readonly = false,
}) {
  return SizedBox(
    height: 70.h,
    width: 346.w,
    child: TextFormField(
      controller: controller,
      keyboardType: keybordtype,
      obscureText: password,
      validator: validator,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: fontStyle.body.copyWith(fontSize: 12),
        fillColor: Colors.white,
        filled: true,
        suffixIcon: icon != null ? Icon(icon, size: 18) : null,
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xFFBBBBBB)),
          borderRadius: BorderRadius.circular(8),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xFFBBBBBB)),
          borderRadius: BorderRadius.circular(8),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.red),
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    ),
  );
}
