import 'package:flutter/material.dart';
import 'package:saint_schoolparent_pro/controllers/parent.dart';
import 'package:saint_schoolparent_pro/models/parent.dart';
import 'package:saint_schoolparent_pro/models/student.dart';
import 'package:saint_schoolparent_pro/screens/registrationpage.dart';
import 'package:saint_schoolparent_pro/theme.dart';

class VerificationPage extends StatefulWidget {
  const VerificationPage({Key? key}) : super(key: key);

  @override
  State<VerificationPage> createState() => _VerificationPageState();
}

class _VerificationPageState extends State<VerificationPage> {
  final icNumberController = TextEditingController();

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
                    )),
                onPressed: () async {
                  var parent = ParentController.getParent(icNumberController.text);
                  showDialog(
                    context: context,
                    builder: (context) {
                      return FutureBuilder<Parent>(
                        future: parent,
                        builder: (BuildContext context, AsyncSnapshot<Parent> snapshot) {
                          if (snapshot.connectionState == ConnectionState.active || snapshot.connectionState == ConnectionState.done) {
                            if (snapshot.hasData) {
                              WidgetsBinding.instance.addPostFrameCallback((_) {
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => RegistrationPage(
                                              parent: snapshot.data!,
                                            )));
                              });
                            } else {
                              return const Text("There is no related student data");
                            }
                          }
                          if (snapshot.hasError) {
                            return Text(snapshot.error.toString());
                          }
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        },
                      );
                    },
                  );
                  // Get.to(() => const RegistrationPage());
                },
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: getWidth(context) * 0.15, vertical: getHeight(context) * 0.02),
                  child: const Text('Verify'),
                )),
          ),
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
