import 'package:eventbuddy/ui/home_page.dart';
import 'package:eventbuddy/ui/login_page.dart';
import 'package:eventbuddy/utils/fontstyle.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  List<String> evants = ['Tech', 'Sports', 'Culture', 'Music'];
  String dropdownvalue = ' Tech';

  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      //  appBar: AppBar(leading: BackButton(),   backgroundColor: Colors.white,),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 22),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 100.h),
              Text(
                "sign up",
                style: fontStyle.heading.copyWith(color: Color(0xFF6C63FF)),
              ),
              SizedBox(height: 50.h),
              _TextField(
                hint: "Username",
                controller: usernameController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your username';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10.h),
              _TextField(
                hint: "Email",
                controller: emailController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10.h),
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
                      "    SelectCategories",
                      style: fontStyle.body.copyWith(fontSize: 12),
                    ),
                    isExpanded: true,
                    value:
                        evants.contains(dropdownvalue) ? dropdownvalue : null,
                    icon: const Icon(Icons.keyboard_arrow_down),
                    items:
                        evants.map((String evant) {
                          return DropdownMenuItem<String>(
                            value: evant,
                            child: Text(
                              evant,
                              style: fontStyle.body.copyWith(fontSize: 12),
                            ),
                          );
                        }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        dropdownvalue = newValue!;
                      });
                    },
                  ),
                ),
              ),
              SizedBox(height: 10.h),
              _TextField(
                hint: "Mobile",
                controller: mobileController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your mobile';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10.h),
              _TextField(
                hint: "password",
                controller: passwordController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }
                  return null;
                },
              ),
              SizedBox(height: 30.h),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => HomePage()),
                  );
                },
                child: Container(
                  height: 52.h,
                  width: 343.w,
                  decoration: BoxDecoration(
                    color: Color(0xFF6C63FF),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    "Sign Up",
                    style: TextStyle(fontSize: 16.sp, color: Colors.white),
                  ),
                ),
              ),
              SizedBox(height: 20.h),
              Padding(
                padding: const EdgeInsets.only(left: 50),
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
