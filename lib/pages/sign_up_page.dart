import 'package:CredexEcom/model/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final FocusNode emailFocusNode = FocusNode();
  final FocusNode passwordFocusNode = FocusNode();
  final FocusNode confirmPasswordNode = FocusNode();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  Future<void> _signUp(BuildContext context) async {
  final email = emailController.text;
  final password = passwordController.text;
  final confirmPassword = confirmPasswordController.text;

  if (email.isEmpty) {
    _showErrorDialog(context, "Missing Email");
    return;
  }
  if (!RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(email)) {
    _showErrorDialog(context, 'Invalid email format');
    return;
  }
  if (password.isEmpty || password.length < 6) {
    _showErrorDialog(context, 'Password must be at least 6 characters long');
    return;
  }
  if (password != confirmPassword) {
    _showErrorDialog(context, 'Passwords do not match');
    return;
  }

  try {
    await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    
    final userModel = UserModel(
      fullname: 'John Doe', 
      address: '123 Example St', 
      phoneNo: '123-456-7890', 
      email: email,
    );

    await FirebaseFirestore.instance.collection("Users").doc(email).set(userModel.toJson());

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('email', email);
    Navigator.pushReplacementNamed(context, '/home');
  } catch (e) {
    _showErrorDialog(context, 'Sign up failed: ${e.toString()}');
  }
}

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            child: const Text('OK'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  void _navigateToLogin(BuildContext context) {
    Navigator.pushNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(0, 240, 240, 240),
        elevation: 0,
        toolbarHeight: 0,
      ),
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('lib/images/122.gif', width: 100, height: 100),
              const SizedBox(height: 20),
              _buildTextField(
                context: context,
                controller: emailController,
                focusNode: emailFocusNode,
                hintText: 'Email',
                icon: Icons.email,
                isPassword: false,
              ),
              const SizedBox(height: 20),
              _buildTextField(
                context: context,
                controller: passwordController,
                focusNode: passwordFocusNode,
                hintText: 'Password',
                icon: Icons.lock,
                isPassword: true,
              ),
              const SizedBox(height: 20),
              _buildTextField(
                context: context,
                controller: confirmPasswordController,
                focusNode: confirmPasswordNode,
                hintText: 'Confirm Password',
                icon: Icons.lock,
                isPassword: true,
              ),
              const SizedBox(height: 20),
              _buildButton(context: context, label: 'Sign Up', onTap: () => _signUp(context)),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: () => _navigateToLogin(context),
                child: RichText(
                  text: const TextSpan(
                    children: [
                      TextSpan(
                        text: 'Already a user? ',
                        style: TextStyle(color: Colors.grey, fontSize: 16),
                      ),
                      TextSpan(
                        text: 'Login',
                        style: TextStyle(color: Color(0xFF5B0000), fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required BuildContext context,
    required TextEditingController controller,
    required FocusNode focusNode,
    required String hintText,
    required IconData icon,
    required bool isPassword,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: TextField(
        focusNode: focusNode,
        controller: controller,
        obscureText: isPassword,
        decoration: InputDecoration(
          prefixIcon: Icon(icon),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey[300]!),
            borderRadius: BorderRadius.circular(12.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey[600]!),
            borderRadius: BorderRadius.circular(12.0),
          ),
          fillColor: Colors.grey[200],
          filled: true,
          hintText: hintText,
        ),
      ),
    );
  }

  Widget _buildButton({
    required BuildContext context,
    required String label,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Color(0xFF5B0000),
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: Center(
            child: Text(
              label,
              style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }
}
