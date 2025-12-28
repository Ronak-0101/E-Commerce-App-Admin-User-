import 'package:e_commerce_app/Services/auth_service.dart';
import 'package:e_commerce_app/View/login_screen.dart';
import 'package:flutter/material.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  String selectedRole = "User"; // default selected role from dropdown
  bool isLoading = false; // to show loading spinner during signup process
  bool isPasswordHidden = true;

  //instance for AuthService for authentication logic
  final AuthService _authService = AuthService();
  // signup function to handle user registration
  void _signup() async {
    setState(() {
      isLoading = true;
    });
    
    // calling signup method from AuthService with user inputs
    String? result = await _authService.signup(
      name: nameController.text,
      email: emailController.text,
      password: passwordController.text,
      role: selectedRole,
    );
    setState(() {
      isLoading = false;
    });

    if (!mounted) return;

    if (result == null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const LoginScreen(
            successMessage: "Signup Successful! Now turn to Login.",
          ),
        ),
      );
    } else {
      // Signup failed : show the error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Signup Failed $result",
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Image.asset(
                'assets/User_signup.jpg',
                height: 300,
              ),
              const SizedBox(height: 20),
              // Input for Name
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Name',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 15),
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
                  border: OutlineInputBorder(),
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

              //Dropdown for selecting the role
              DropdownButtonFormField(
                value: selectedRole,
                decoration: const InputDecoration(
                  labelText: "Role",
                  border: OutlineInputBorder(),
                ),
                items: ["Admin", "User"].map((role) {
                  return DropdownMenuItem(
                    value: role,
                    child: Text(role),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    selectedRole =
                        newValue!; // update roles selection in text field
                  });
                },
              ),
              const SizedBox(height: 15),

              //Signup button
              isLoading
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _signup,
                        child: const Text("Signup"),
                      ),
                    ),
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Already have an account? ",
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const LoginScreen(),
                        ),
                      );
                    },
                    child: const Text(
                      "Login here",
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
    );
  }
}
