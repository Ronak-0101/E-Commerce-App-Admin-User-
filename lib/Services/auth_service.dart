import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  // Firebase authentication instance
  final FirebaseAuth _auth = FirebaseAuth.instance;
  // Firestore instance
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Function to handle user signup
  Future<String?> signup({
    required String name,
    required String email,
    required String password,
    required String role,
  }) async {
    try {
      // Create user in firebase authentication with email and password
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );

      // Save additional user data in firestore(name, role, email)
      await _firestore.collection("users").doc(userCredential.user!.uid).set({
        "name": name.trim(),
        "email": email.trim(),
        "role": role, // Role determines if user is admin or user
      });
      return null; // Success : no error message
    } catch (e) {
      return e.toString(); // Error : return the exception message
    }
  }

// Function to handle user login

  Future<String?> login({
    required String email,
    required String password,
  }) async {
    try {
      // Sign in user using firebase authentication with email and password
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );

      // Fetching the user's role from firestore to determine access level
      DocumentSnapshot userDoc = await _firestore
          .collection("users")
          .doc(userCredential.user!.uid)
          .get();
      return userDoc['role']; // return the user's role(admin/user)
    } catch (e) {
      return e.toString(); // Error : return the exception message
    }
  }

// For user logout
  signOut() async {
    _auth.signOut();
  }
}
