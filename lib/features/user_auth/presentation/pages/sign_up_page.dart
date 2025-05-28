import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../global/common/toast.dart';
import '../../firebase_auth_implementation/firebase_auth_services.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _fromController = TextEditingController();
  final TextEditingController _languageController = TextEditingController();

  final FirebaseAuthService _auth = FirebaseAuthService();
  bool isSigningUp = false;

  void _signUp() async {
    setState(() {
      isSigningUp = true;
    });

    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();
    String name = _usernameController.text.trim();
    String from = _fromController.text.trim();
    String language = _languageController.text.trim();

    if (email.isEmpty || password.isEmpty || name.isEmpty) {
      showToast(message: "Please fill all required fields.");
      setState(() {
        isSigningUp = false;
      });
      return;
    }

    User? user = await _auth.signUpWithEmailAndPassword(email, password);

    if (user != null) {
      await FirebaseFirestore.instance.collection("users").doc(user.uid).set({
        "uid": user.uid,
        "email": email,
        "name": name,
        "from": from,
        "language": language,
        "createdAt": Timestamp.now(),
      });

      showToast(message: "User successfully created!");
      Navigator.pushNamed(context, "/home");
    } else {
      showToast(message: "Sign up failed. Please try again.");
    }

    setState(() {
      isSigningUp = false;
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _usernameController.dispose();
    _fromController.dispose();
    _languageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 60),
              const CircleAvatar(
                radius: 40,
                backgroundColor: Colors.green,
                backgroundImage: AssetImage('assets/Short White.png'),
              ),
              const SizedBox(height: 20),
              const Text(
                "Welcome to Do.lk App",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const Text(
                "Please enter your registration details.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 25),

              // Form Fields
              _buildInputField("Name*", _usernameController),
              const SizedBox(height: 15),
              _buildInputField("Email*", _emailController,
                  keyboardType: TextInputType.emailAddress),
              const SizedBox(height: 15),
              _buildInputField("Password*", _passwordController, isPassword: true),
              const SizedBox(height: 15),
              _buildInputField("From", _fromController),
              const SizedBox(height: 15),
              _buildInputField("Language", _languageController),
              const SizedBox(height: 25),

              // Sign Up Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  onPressed: isSigningUp ? null : _signUp,
                  child: isSigningUp
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text("Continue", style: TextStyle(fontSize: 15)),
                ),
              ),

              const SizedBox(height: 15),

              // Social Buttons (for symmetry with login screen)
              const SizedBox(height: 10),


              const SizedBox(height: 30),

              // Navigation Links
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, "/login");
                    },
                    child: const Text("Already have an account?",
                        style: TextStyle(color: Colors.green)),
                  ),
                  TextButton(
                    onPressed: () {
                      // Optionally add Terms or Help
                    },
                    child: const Text("Need Help?",
                        style: TextStyle(color: Colors.green)),
                  ),
                ],
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputField(String label, TextEditingController controller,
      {bool isPassword = false, TextInputType keyboardType = TextInputType.text}) {
    return TextField(
      controller: controller,
      obscureText: isPassword,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      ),
    );
  }
}
