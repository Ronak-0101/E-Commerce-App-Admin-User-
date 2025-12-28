import 'package:e_commerce_app/Services/auth_service.dart';
import 'package:e_commerce_app/View/login_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

AuthService _authService = AuthService();

class AdminSceen extends StatelessWidget {
  const AdminSceen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      appBar: AppBar(
        title: const Text("Admin Screen"),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Welcome to the Admin Page."),
            ElevatedButton(onPressed: () {
              _authService.signOut();
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=> const LoginScreen()));
            }, child: Text("Sign Out"))
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
    );
  }
}

class UserScreen extends StatelessWidget {
  const UserScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("User Screen"),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Welcome User!"),
            ElevatedButton(
              onPressed: () {
                _authService.signOut();
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (_) => const LoginScreen()));
              },
              child: Text("Sign Out"),
            ),
          ],
        ),
      ),
    );
  }
}
