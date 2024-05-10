import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:saint_schoolparent_pro/controllers/auth.dart';
import 'package:saint_schoolparent_pro/controllers/parent.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset('assets/logo.png'),
      ),
    );
  }
}

class NewReleasePopup extends StatelessWidget {
  const NewReleasePopup({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('New Update Available!'),
      content: const Text(
          'A new version of the app is available. Would you like to update now?'),
      actions: <Widget>[
        TextButton(
          child: const Text('Update'),
          onPressed: () {
            // Implement your update logic here, e.g., opening an app store
            Navigator.of(context)
                .pop(); // Close the dialog after choosing to update
          },
        ),
        TextButton(
          child: const Text('Later'),
          onPressed: () {
            Navigator.of(context).pop(); // Optionally handle delay/cancellation
          },
        ),
      ],
    );
  }
}

class ResetPasswordWidget extends StatefulWidget {
  const ResetPasswordWidget({Key? key}) : super(key: key);

  @override
  _ResetPasswordWidgetState createState() => _ResetPasswordWidgetState();
}

class _ResetPasswordWidgetState extends State<ResetPasswordWidget> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Reset Password"),
      ),
      body: SingleChildScrollView( // Use SingleChildScrollView to avoid overflow
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Email'),
                validator: (value) {
                  if (value == null || value.isEmpty || !value.contains('@')) {
                    return 'Please enter a valid email address';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10), // Adds space between input fields
              TextFormField(
                controller: _oldPasswordController,
                obscureText: true,
                decoration: InputDecoration(labelText: 'Old Password'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your old password';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10), // Adds space between input fields
              TextFormField(
                controller: _newPasswordController,
                obscureText: true,
                decoration: InputDecoration(labelText: 'New Password'),
                validator: (value) {
                  if (value == null || value.isEmpty || value.length < 6) {
                    return 'Password must be at least 6 characters long';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10), // Adds space between input fields
              TextFormField(
                controller: _confirmPasswordController,
                obscureText: true,
                decoration: InputDecoration(labelText: 'Confirm Password'),
                validator: (value) {
                  if (value != _newPasswordController.text) {
                    return 'Passwords do not match';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20), // Space before the button
              ElevatedButton(
                onPressed: () => attemptPasswordUpdate(
                  _emailController.text,
                  _oldPasswordController.text,
                  _newPasswordController.text,
                ),
                child: Text("Reset Password"),
              ),
            ],
          ),
        ),
      ),
    );
  }


  

  Future<void> _setFirstLaunch() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('first_launch', false);
  }

 Future<void> attemptPasswordUpdate(String email, String oldPassword, String newPassword) async {
  // Ensure the form is valid before proceeding
  if (_formKey.currentState!.validate()) {
    try {
      // Attempt to update the password through the AuthController
      String authResult = await AuthController.instance.updatePassword(email, oldPassword, newPassword);
      
      if (authResult == "Password updated successfully") {
        try {
          // Update the password in Firestore database
          await ParentController.addPasswordToParentVsEmail(email, newPassword);
          await _setFirstLaunch();
          Navigator.pop(context); // Successfully updated, navigate back
        } catch (e) {
          // Handle database update failure
          _showSnackBar('Failed to update password in database: $e');
        }
      } else {
        // Handle unsuccessful password update
        _showSnackBar(authResult);
      }
    } catch (e) {
      // Handle errors in the password update process, such as network issues
      _showSnackBar('An error occurred while updating password: $e');
    }
  }
}

void _showSnackBar(String message) {
  final snackBar = SnackBar(content: Text(message));
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

}