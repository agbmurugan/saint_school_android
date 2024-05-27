import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Import FirebaseAuth
import 'package:saint_schoolparent_pro/controllers/parent.dart';
import 'package:saint_schoolparent_pro/models/parent.dart';
import 'package:saint_schoolparent_pro/screens/registrationpage.dart';
import 'package:saint_schoolparent_pro/theme.dart';

class VerificationPage extends StatefulWidget {
  const VerificationPage({Key? key}) : super(key: key);

  @override
  State<VerificationPage> createState() => _VerificationPageState();
}

class _VerificationPageState extends State<VerificationPage> {
  final icNumberController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance; // Firebase Auth instance

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.only(top: getHeight(context) * 0.16, bottom: getHeight(context) * 0.05),
            child: Image.asset(
              'assets/logo.png',
              height: getHeight(context) * 0.20,
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: getWidth(context) * 0.02, vertical: getHeight(context) * 0.05),
            child: CustomTextformField(
              prefixIcon: const Icon(Icons.person_pin_sharp),
              controller: icNumberController,
              hintText: 'Parent IC NO',
            ),
          ),
          Padding(
  padding: EdgeInsets.symmetric(vertical: getHeight(context) * 0.10),
  child: ElevatedButton(
    style: ButtonStyle(
      elevation: MaterialStateProperty.all(16),
      shape: MaterialStateProperty.all(
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(100.0)),
      ),
    ),
    onPressed: () async {
      var result = await ParentController.getParent(icNumberController.text);

      if (result is Parent) {
        Parent parent = result;
        _auth.fetchSignInMethodsForEmail(parent.email).then((methods) {
          if (methods.isNotEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text("This IC Number is already registered."),
              backgroundColor: Colors.red,
            ));
          } else {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => RegistrationPage(parent: parent)),
            );
          }
        }).catchError((e) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("Failed to check email: ${e.message}"),
            backgroundColor: Colors.red,
          ));
        });
      } else if (result is String) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(result),
          backgroundColor: Colors.red,
        ));
      }
    },
    child: Padding(
      padding: EdgeInsets.symmetric(horizontal: getWidth(context) * 0.15, vertical: getHeight(context) * 0.02),
      child: const Text('Verify'),
    ),
  ),
)

        ],
      ),
    ));
  }
}


class CustomTextformField extends StatelessWidget {
  const CustomTextformField({
    Key? key,
    this.controller,
    this.obscureText,
    required this.hintText,
    this.prefixIcon,
    this.suffixIcon,
    this.validator,
    this.enabled,
  }) : super(key: key);

  final TextEditingController? controller;
  final bool? obscureText;
  final String hintText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final String? Function(String?)? validator;
  final bool? enabled;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: TextFormField(
          enabled: enabled,
          controller: controller,
          validator: validator,
          autofocus: true,
          obscureText: obscureText ?? false,
          decoration: InputDecoration(
              hintText: hintText,
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: lightColorScheme.secondary,
                  width: 1,
                ),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(4.0),
                  topRight: Radius.circular(4.0),
                ),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: lightColorScheme.secondary,
                  width: 2,
                ),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(4.0),
                  topRight: Radius.circular(4.0),
                ),
              ),
              prefixIcon: prefixIcon,
              suffixIcon: suffixIcon),
        ),
      ),
    );
  }
}
