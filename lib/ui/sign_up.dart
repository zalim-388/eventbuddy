import 'package:eventbuddy/service/Authcontroller.dart';
import 'package:eventbuddy/ui/home_page.dart';
import 'package:eventbuddy/ui/login_page.dart';
import 'package:eventbuddy/utils/fontstyle.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _formKey = GlobalKey<FormState>();
  List<String> events = ['Tech', 'Sports', 'Culture', 'Music'];
  String? selectedCategory;

  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    usernameController.dispose();
    emailController.dispose();
    mobileController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 22),
          child: Consumer<AuthController>(
            builder: (context, authController, child) {
              return Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 100.h),
                    Row(
                      children: [
                        Text(
                          "sign up",
                          style: fontStyle.heading.copyWith(
                            color: Color(0xFF6C63FF),
                          ),
                        ),
                        SizedBox(width: 80.w),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => HomePage(),
                              ),
                            );
                          },
                          child: Text(
                            "Skip",
                            style: TextStyle(color: Color(0xFF6C63FF)),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 50.h),

                    _TextField(
                      hint: "Username",
                      controller: usernameController,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter your username';
                        }
                        return null;
                      },
                    ),

                    SizedBox(height: 5.h),
                    _TextField(
                      hint: "Email",
                      controller: emailController,
                      keybordtype: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter your email';
                        } else if (!RegExp(
                          r'^[^@]+@[^@]+\.[^@]+',
                        ).hasMatch(value)) {
                          return 'Enter a valid email';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 5.h),
                    _TextField(
                      hint: "Mobile",
                      controller: mobileController,
                      keybordtype: TextInputType.phone,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Enter mobile number';
                        } else if (!RegExp(
                          r'^\+?[\d\s\-\(\)]{10,15}$',
                        ).hasMatch(value.trim())) {
                          return 'Enter valid mobile number';
                        }
                        return null;
                      },
                    ),

                    SizedBox(height: 5.h),
                    Container(
                      height: 50.h,
                      width: 346.w,
                      decoration: BoxDecoration(
                        border: Border.all(color: Color(0xFFBBBBBB)),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          hint: Text(
                            "    Select Categories",
                            style: fontStyle.body.copyWith(fontSize: 12),
                          ),
                          isExpanded: true,
                          value: selectedCategory,
                          icon: const Icon(Icons.keyboard_arrow_down),
                          items:
                              events.map((String event) {
                                return DropdownMenuItem<String>(
                                  value: event,
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 10),
                                    child: Text(
                                      event,
                                      style: fontStyle.body.copyWith(
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                );
                              }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              selectedCategory = newValue;
                            });
                          },
                        ),
                      ),
                    ),
                    SizedBox(height: 5.h),

                    _TextField(
                      hint: "Password",
                      controller: passwordController,
                      password: true,
                      validator: (value) {
                        if (value == null || value.length < 6) {
                          return 'Minimum 6 characters required';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 5.h),
                    if (authController.errorMessage != null)
                      Container(
                        margin: EdgeInsets.only(top: 10.h),
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.red.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: Colors.red.withOpacity(0.3),
                          ),
                        ),
                        child: Text(
                          authController.errorMessage!,
                          style: TextStyle(color: Colors.red, fontSize: 12.sp),
                        ),
                      ),

                    SizedBox(height: 30.h),

                    GestureDetector(
                      onTap:
                          authController.isLoading
                              ? null
                              : () async {
                                if (_formKey.currentState!.validate()) {
                                  if (selectedCategory == null) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          "Please select an event category",
                                        ),
                                        backgroundColor: Colors.red,
                                      ),
                                    );
                                    return;
                                  }

                                  final success = await authController
                                      .registerUser(
                                        email: emailController.text.trim(),
                                        password:
                                            passwordController.text.trim(),
                                        username:
                                            usernameController.text.trim(),
                                        mobile: mobileController.text.trim(),
                                        category: selectedCategory!,
                                      );

                                  if (success) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          "Account created successfully!",
                                        ),
                                        backgroundColor: Colors.green,
                                      ),
                                    );
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => HomePage(),
                                      ),
                                    );
                                  }
                                }
                              },
                      child: Container(
                        height: 52.h,
                        width: 343.w,
                        decoration: BoxDecoration(
                          color:
                              authController.isLoading
                                  ? Colors.grey
                                  : Color(0xFF6C63FF),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        alignment: Alignment.center,
                        child:
                            authController.isLoading
                                ? CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                )
                                : Text(
                                  "Sign Up",
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                      ),
                    ),
                    SizedBox(height: 20.h),

                    Padding(
                      padding: const EdgeInsets.only(left: 100),
                      child: Text.rich(
                        TextSpan(
                          text: "Already have an account? ",
                          style: fontStyle.body.copyWith(fontSize: 13),
                          children: [
                            TextSpan(
                              text: "Log In",
                              style: fontStyle.body.copyWith(
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                                color: Color(0xFF6C63FF),
                              ),
                              recognizer:
                                  TapGestureRecognizer()
                                    ..onTap = () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => LoginPage(),
                                        ),
                                      );
                                    },
                            ),
                          ],
                        ),
                      ),
                    ),

                    SizedBox(height: 50.h),
                  ],
                ),
              );
            },
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
