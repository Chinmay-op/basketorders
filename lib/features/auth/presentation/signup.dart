import 'package:flutter/material.dart';
import 'login.dart';
import 'features/auth/controllers/SignUpController.dart';
import 'package:get/get.dart';

class SignupPage extends StatelessWidget {
  const SignupPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SignUpController());
    final _formkey = GlobalKey<FormState>();
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Welcome!'),
              SizedBox(height: 10),
              Text('Cresate your account'),
              SizedBox(height: 26),
              Form(
                key: _formkey,
                child: Container(
                  width: 300,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: controller.usernameController,
                        decoration: InputDecoration(
                          labelText: 'Username',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      SizedBox(height: 16),
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
                      SizedBox(height: 24),

                      ElevatedButton(
                        onPressed: () {
                          if (_formkey.currentState!.validate()) {
                            controller.signUp();
                            controller.emailController.text;
                            controller.passwordController.text;
                          }
                          // Handle login logic
                        },
                        child: Text('Sign Up'),
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
                child: Text('Already have an account? Login'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage()),
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
