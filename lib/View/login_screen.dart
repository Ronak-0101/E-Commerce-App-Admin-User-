// ignore_for_file: use_build_context_synchronously

import 'package:e_commerce_app/View/home_screen.dart';
import 'package:e_commerce_app/View/signup_screen.dart';
import 'package:flutter/material.dart';

import '../Services/auth_service.dart';

class LoginScreen extends StatefulWidget {
  final String? successMessage;

  const LoginScreen({super.key, this.successMessage});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool isLoading = false; // to show loading spinner during signup process
  bool isPasswordHidden = true;
  //instance for AuthService for authentication logic
  final AuthService _authService = AuthService();
  void login() async {
    setState(() {
      isLoading = true;
    });

    // Call login method from AuthService with user inputs
    String? result = await _authService.login(
      email: emailController.text,
      password: passwordController.text,
    );
    setState(() {
      isLoading = false;
    });

    // Navigate based on the role or show the error message
    if (result == "Admin") {
      Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => const AdminSceen(),
      ),
    );
    } else if (result == "User" ) {
      Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => const UserScreen(),
      ),
    );
    } else {
      // Login failed : show the error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Login Failed $result",
          ),
        ),
      );
    }
  } 

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.successMessage != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(widget.successMessage!),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Image.asset(
                  'assets/User_login.jpg',
                  height: 300,
                ),
                const SizedBox(height: 20),
                // Input for Email
                TextField(
                  controller: emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 15),
                // Input for Password
                TextField(
                  controller: passwordController,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    border: const OutlineInputBorder(),
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          isPasswordHidden = !isPasswordHidden;
                        });
                      },
                      icon: Icon(
                        isPasswordHidden
                            ? Icons.visibility_off
                            : Icons.visibility,
                      ),
                    ),
                  ),
                  obscureText: isPasswordHidden,
                ),
                const SizedBox(height: 20),
                //login button
                isLoading
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: login,
                          child: const Text("Login"),
                        ),
                      ),
                const SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Don't have an account? ",
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const SignupScreen(),
                          ),
                        );
                      },
                      child: const Text(
                        "Signup here",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                          letterSpacing: -1,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
