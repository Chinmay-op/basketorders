import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'signup.dart';
import 'features/auth/controllers/loginController.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final _formkey = GlobalKey<FormState>();
    final controller = Get.put(LoginController());
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Welcome Back!'),
              SizedBox(height: 10),
              Text('Login to your account'),
              SizedBox(height: 26),
              Form(
                key: _formkey,
                child: Container(
                  width: 300,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: controller.emailController,
                        decoration: InputDecoration(
                          labelText: 'Email',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      SizedBox(height: 16),
                      TextFormField(
                        controller: controller.passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {},
                          child: Text('Forgot Password?'),
                        ),
                      ),

                      ElevatedButton(
                        onPressed: () {
                          if (_formkey.currentState!.validate()) {
                            controller.login();
                          }
                          // Handle login logic
                        },
                        child: Text('Login'),
                        style: ElevatedButton.styleFrom(
                          side: const BorderSide(
                            width: 2,
                            color: Colors.black87,
                          ), // Outline border
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              10,
                            ), // Rounded corners
                          ),

                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 6),
              TextButton(
                child: Text('Don\'t have an account? Sign Up'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SignupPage()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
