import 'package:CredexEcom/model/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

class IntroPage extends StatelessWidget {
  IntroPage({super.key});

  final FocusNode emailFocusNode = FocusNode();
  final FocusNode passwordFocusNode = FocusNode();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<void> _login(BuildContext context) async {
    final email = emailController.text;
    final password = passwordController.text;

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

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('email', email);
      Navigator.pushReplacementNamed(context, '/home');
    } catch (e) {
      _showErrorDialog(context, 'Login failed: ${e.toString()}');
    }
  }

  Future<void> _resetPassword(BuildContext context) async {
    final email = emailController.text;

    if (email.isEmpty) {
      _showErrorDialog(context, "Missing Email");
      return;
    }
    if (!RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(email)) {
      _showErrorDialog(context, 'Invalid email format');
      return;
    }

    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      _showErrorDialog(context, 'Password reset email sent');
    } catch (e) {
      _showErrorDialog(context, 'Error: ${e.toString()}');
    }
  }

  Future<void> _signInWithGoogle(BuildContext context) async {
    try {
      final GoogleSignInAccount? googleSignInAccount =
          await _googleSignIn.signIn();
      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount.authentication;
        final AuthCredential credential = GoogleAuthProvider.credential(
          idToken: googleSignInAuthentication.idToken,
          accessToken: googleSignInAuthentication.accessToken,
        );
        // ignore: unused_local_variable
        final userCredential =
            await FirebaseAuth.instance.signInWithCredential(credential);

        final userEmail = googleSignInAccount.email;
        final userDoc =
            FirebaseFirestore.instance.collection("Users").doc(userEmail);

        final userSnapshot = await userDoc.get();
        if (!userSnapshot.exists) {
          final userModel = UserModel(
            fullname: googleSignInAccount.displayName ?? 'John Doe',
            address: '123 Example St',
            phoneNo: '123-456-7890',
            email: userEmail,
          );
          await userDoc.set(userModel.toJson());
        } else {
          final updatedUserModel = UserModel(
            fullname: googleSignInAccount.displayName ?? 'John Doe',
            address: userSnapshot.data()?['address'] ?? '123 Example St',
            phoneNo: userSnapshot.data()?['phoneNo'] ?? '123-456-7890',
            email: userEmail,
          );
          await userDoc.update(updatedUserModel.toJson());
        }

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('email', userEmail);
        await prefs.setString('image', googleSignInAccount.photoUrl ?? '');

        Navigator.pushReplacementNamed(context, '/home');
      } else {
        _showErrorDialog(context, 'Google sign-in aborted by user.');
      }
    } on FirebaseAuthException catch (e) {
      _showErrorDialog(context, 'Firebase Auth Error: ${e.message}');
    } catch (e) {
      _showErrorDialog(context, 'Google sign-in failed: ${e.toString()}');
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

  void _navigateToSignUp(BuildContext context) {
    Navigator.pushNamed(context, '/signUp');
  }

  Future<void> _checkIfLoggedIn(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString('email');
    if (email != null) {
      Navigator.pushReplacementNamed(context, '/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    _checkIfLoggedIn(context);
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
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 25.0, vertical: 8.0),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    onTap: () => _resetPassword(context),
                    child: Text(
                      "Forgot Password?",
                      style: TextStyle(color: Colors.grey[600], fontSize: 12),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              _buildButton(
                  context: context,
                  label: 'Login',
                  onTap: () => _login(context)),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => _signInWithGoogle(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 244, 244, 244),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset('lib/icons/google.png', height: 24),
                    const SizedBox(width: 10),
                    const Text(
                      'Sign in with Google',
                      style: TextStyle(
                          color: Color.fromARGB(255, 0, 0, 0), fontSize: 12),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: () => _navigateToSignUp(context),
                child: RichText(
                  text: const TextSpan(
                    children: [
                      TextSpan(
                        text: 'New User? ',
                        style: TextStyle(color: Colors.grey, fontSize: 14),
                      ),
                      TextSpan(
                        text: 'Sign Up',
                        style: TextStyle(
                            color: Color(0xFF5B0000),
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
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
            color: const Color(0xFF5B0000),
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: Center(
            child: Text(
              label,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }
}
