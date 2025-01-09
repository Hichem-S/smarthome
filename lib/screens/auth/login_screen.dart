import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import '../../routes/app_routes.dart';

class LoginScreen extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  LoginScreen({super.key});

  Future<void> _login(BuildContext context) async {
    if (_emailController.text.trim().isEmpty ||
        _passwordController.text.trim().isEmpty) {
      _showErrorDialog(
        context,
        'Login Error',
        'Email and password fields cannot be empty.',
      );
      return;
    }

    try {
      UserCredential credential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      if (credential.user != null && credential.user!.emailVerified) {
        Navigator.pushReplacementNamed(context, AppRoutes.home);
      } else {
        AwesomeDialog(
          context: context,
          dialogType: DialogType.warning,
          animType: AnimType.rightSlide,
          title: 'Email Not Verified',
          desc: 'Please verify your email before logging in.',
          btnOkOnPress: () {},
          btnOkColor: Colors.orange,
        ).show();
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        _showErrorDialog(
            context, 'Login Error', 'Email not found. Please register.');
      } else if (e.code == 'wrong-password') {
        _showErrorDialog(
            context, 'Login Error', 'Incorrect password. Please try again.');
      } else if (e.code == 'invalid-email') {
        _showErrorDialog(context, 'Login Error', 'Invalid email format.');
      } else {
        _showErrorDialog(
          context,
          'Login Error',
          'An unexpected error occurred. Please try again later.',
        );
      }
    } catch (e) {
      _showErrorDialog(
        context,
        'Login Error',
        'Something went wrong. Please try again later.',
      );
    }
  }

  Future<void> _resetPassword(BuildContext context) async {
    if (_emailController.text.trim().isEmpty) {
      _showErrorDialog(
        context,
        'Reset Password Error',
        'Please enter your email to reset the password.',
      );
      return;
    }

    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(
        email: _emailController.text.trim(),
      );
      AwesomeDialog(
        context: context,
        dialogType: DialogType.success,
        animType: AnimType.scale,
        title: 'Success',
        desc: 'A password reset link has been sent to your email.',
        btnOkOnPress: () {},
      ).show();
    } catch (e) {
      _showErrorDialog(
        context,
        'Reset Password Error',
        'An error occurred while sending the reset email. Please try again.',
      );
    }
  }

  void _showErrorDialog(BuildContext context, String title, String message) {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.error,
      animType: AnimType.rightSlide,
      title: title,
      desc: message,
      btnOkOnPress: () {},
      btnOkColor: Colors.red,
    ).show();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[50],
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Smart Home",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.teal[300],
                  ),
                ),
                const SizedBox(height: 20),
                Icon(Icons.home, size: 100, color: Colors.teal[300]),
                const SizedBox(height: 50),
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    hintText: 'Email',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 18,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: 'Password',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 18,
                    ),
                  ),
                ),
                const SizedBox(height: 40), // Space above the Login button
                ElevatedButton(
                  onPressed: () => _login(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal[700],
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 40,
                      vertical: 15,
                    ),
                  ),
                  child: const Text('Login'),
                ),
                const SizedBox(
                    height: 10), // Space between Login and Forgot Password
                TextButton(
                  onPressed: () => _resetPassword(context),
                  child: const Text('Forgot Password?'),
                ),
                const SizedBox(
                    height: 5), // Space between Forgot Password and Register
                TextButton(
                  onPressed: () => Navigator.pushReplacementNamed(
                    context,
                    AppRoutes.register,
                  ),
                  child: const Text('Register'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
