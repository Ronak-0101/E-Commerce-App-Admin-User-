import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_app/View/home_screen.dart';
import 'package:e_commerce_app/firebase_options.dart';
import 'package:e_commerce_app/View/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AuthStateHandler(),
    );
  }
}

class AuthStateHandler extends StatefulWidget {
  const AuthStateHandler({super.key});

  @override
  State<AuthStateHandler> createState() => _AuthStateHandlerState();
}

class _AuthStateHandlerState extends State<AuthStateHandler> {
  User? _currentUser;
  String? _userRole;

  @override
  void initState() {
    initializeAuthState();
    super.initState();
  }

  void initializeAuthState() {
    FirebaseAuth.instance.authStateChanges().listen((user) async {
      if (!mounted) return; // Prevent stateState if the widget is disposed
      setState(() {
        _currentUser = user;
      });
      if (user != null) {
        final userDoc = await FirebaseFirestore.instance
            .collection(
                "users") // This is the same collection that we have created during the signup
            .doc(user.uid)
            .get();
        if (!mounted) return; // Prevent stateState if the widget is disposed
        if (userDoc.exists) {
          setState(() {
            _userRole = userDoc['role'];
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_currentUser == null) {
      return const LoginScreen();
    }
    if (_userRole == null) {
      //show a loading scaffold
      return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
    }
    // for keep user login
    return _userRole == "Admin"? const AdminSceen() : const UserScreen();
    
  }
}
