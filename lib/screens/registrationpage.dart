import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:saint_schoolparent_pro/controllers/auth.dart';
import 'package:saint_schoolparent_pro/controllers/parent.dart';
import 'package:saint_schoolparent_pro/landing_page.dart';
import 'package:saint_schoolparent_pro/models/biodata.dart';
import 'package:saint_schoolparent_pro/models/parent.dart';
import 'package:saint_schoolparent_pro/screens/formController/parent_form_controller.dart';
import 'package:saint_schoolparent_pro/widgets/dropdown.dart';

import '../constants/states.dart';
import '../theme.dart';
import '../widgets/custom_drop_down.dart';
import 'ic_verification_page.dart';
import 'package:get/get.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({Key? key, required this.parent}) : super(key: key);
  final Parent parent;

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  @override
  void initState() {
    controller = ParentFormController.fromParent(widget.parent!);
    super.initState();
  }

  late ParentFormController controller;
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  bool isVisible = true;

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Scaffold(
          appBar: AppBar(
            title: const Text('Registration'),
            centerTitle: true,
          ),
          body: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.only(
                    top: getHeight(context) * 0.01,
                  ),
                  child: Image.asset(
                    'assets/logo.png',
                    height: getHeight(context) * 0.20,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    top: getHeight(context) * 0.05,
                    bottom: getWidth(context) * 0.02,
                    left: getWidth(context) * 0.02,
                    right: getWidth(context) * 0.02,
                  ),
                  child: CustomTextformField(
                    controller: controller.name,
                    prefixIcon: const Icon(Icons.person),
                    hintText: 'Name',
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    top: getWidth(context) * 0.02,
                    bottom: getWidth(context) * 0.02,
                    left: getWidth(context) * 0.02,
                    right: getWidth(context) * 0.02,
                  ),
                  child: CustomTextformField(
                    enabled: false,
                    controller: controller.icNumber,
                    prefixIcon: const Icon(Icons.person),
                    hintText: 'IC NUmber',
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: getWidth(context) * 0.02,
                    vertical: getHeight(context) * 0.02,
                  ),
                  child: CustomTextformField(
                    controller: controller.addressLine1,
                    prefixIcon: const Icon(Icons.email),
                    hintText: 'Address Line 1',
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: getWidth(context) * 0.02,
                    vertical: getHeight(context) * 0.02,
                  ),
                  child: CustomTextformField(
                    controller: controller.addressLine2,
                    prefixIcon: const Icon(Icons.email),
                    hintText: 'Address Line 2',
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: getWidth(context) * 0.02,
                    vertical: getHeight(context) * 0.02,
                  ),
                  child: CustomDropDown<String?>(
                    selectedValue: controller.state,
                    // validator: requiredValidator,
                    items: stateItems,
                    labelText: "State",
                    onChanged: (state) {
                      setState(() {
                        controller.city = null;
                        controller.state = state;
                      });
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: getWidth(context) * 0.02,
                    vertical: getHeight(context) * 0.02,
                  ),
                  child: CustomDropDown<String?>(
                    selectedValue: controller.city,
                    items: getCities(controller.state),
                    labelText: "City",
                    onChanged: (city) {
                      setState(() {
                        controller.city = city;
                      });
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: getWidth(context) * 0.02,
                      vertical: getHeight(context) * 0.02),
                  child: CustomDropdownField<Gender>(
                    items: const [
                      DropdownMenuItem(value: Gender.male, child: Text("MALE")),
                      DropdownMenuItem(
                          value: Gender.female, child: Text("FEMALE")),
                      DropdownMenuItem(
                          value: Gender.unspecified,
                          child: Text("UNSPECIFIED")),
                    ],
                    onChanged: (val) {
                      setState(() {
                        controller.gender = val ?? controller.gender;
                      });
                    },
                    prefixIcon: const Icon(Icons.email),
                    hintText: 'Gender',
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: getWidth(context) * 0.02,
                      vertical: getHeight(context) * 0.02),
                  child: CustomTextformField(
                    controller: controller.primaryPhone,
                    prefixIcon: const Icon(Icons.phone),
                    hintText: 'Primary Phone Number',
                    validator: (string) {
                      if (controller.primaryPhone.text.isEmpty ||
                          !controller.primaryPhone.text.isPhoneNumber) {
                        return "Please enter a valid Phone Number";
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: getWidth(context) * 0.02,
                      vertical: getHeight(context) * 0.02),
                  child: CustomTextformField(
                    controller: controller.secondaryPhone,
                    prefixIcon: const Icon(Icons.phone),
                    hintText: 'Secondary Phone Number',
                    validator: (string) {
                      if (!controller.secondaryPhone.text.isPhoneNumber &&
                          controller.secondaryPhone.text.isNotEmpty) {
                        return "Do not leave this field empty";
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: getWidth(context) * 0.02,
                      vertical: getHeight(context) * 0.02),
                  child: CustomTextformField(
                    controller: controller.email,
                    prefixIcon: const Icon(Icons.email),
                    hintText: 'Email',
                    validator: (string) {
                      if (controller.email.text.isEmpty) {
                        return "Do not leave this field empty";
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: getWidth(context) * 0.02,
                      vertical: getHeight(context) * 0.02),
                  child: CustomTextformField(
                    controller: passwordController,
                    prefixIcon: const Icon(Icons.password),
                    hintText: 'Password',
                    obscureText: isVisible,
                    validator: (val) {
                      if (passwordController.text !=
                          confirmPasswordController.text) {
                        return "Passwords do not match";
                      }
                      return null;
                    },
                    suffixIcon: IconButton(
                      icon: isVisible
                          ? const Icon(Icons.visibility)
                          : const Icon(Icons.visibility_off),
                      onPressed: () {
                        setState(() {
                          isVisible = !isVisible;
                        });
                      },
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: getWidth(context) * 0.02,
                      vertical: getHeight(context) * 0.01),
                  child: CustomTextformField(
                    prefixIcon: const Icon(Icons.password),
                    hintText: 'Confirm Password',
                    obscureText: isVisible,
                    controller: confirmPasswordController,
                    validator: (val) {
                      if (passwordController.text !=
                          confirmPasswordController.text) {
                        return "Passwords do not match";
                      }
                      return null;
                    },
                    suffixIcon: IconButton(
                      icon: isVisible
                          ? const Icon(Icons.visibility)
                          : const Icon(Icons.visibility_off),
                      onPressed: () {
                        setState(() {
                          isVisible = !isVisible;
                        });
                      },
                    ),
                  ),
                ),
                Padding(
                  padding:
                      EdgeInsets.symmetric(vertical: getHeight(context) * 0.10),
                  child: ElevatedButton(
                      style: ButtonStyle(
                          shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(100.0)),
                      )),
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          // Showing a loading dialog or similar user feedback might be beneficial here
                       // Implement this method to show a loading indicator

                          try {
                            var userSnapshot = await FirebaseFirestore.instance
                                .collection('parents')
                                .where('email',
                                    isEqualTo: controller.email.text.trim())
                                .limit(1)
                                .get();

                            if (userSnapshot.docs.isEmpty) {
                              // Close the loading dialog before showing the alert dialog
                              Navigator.pop(context);
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text("Registration Failed"),
                                  content: const Text(
                                      'No account found with that email.'),
                                ),
                              );
                              return;
                            }

                            var userData = userSnapshot.docs.first.data();
                            print("userData $userData");
                            if (userData['isActive'] != true) {
                              Navigator.pop(context); // Close loading dialog
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text("Registration Failed"),
                                  content: const Text(
                                      'Your account is inactive. Please contact support.'),
                                ),
                              );
                              return;
                            }

                            // Proceed with creating the Firebase Auth user if the parent is active
                            var result = await FirebaseAuth.instance
                                .createUserWithEmailAndPassword(
                              email: controller.email.text.trim(),
                              password: passwordController.text,
                            );

                            if (result.user != null) {
                              await FirebaseFirestore.instance
                                  .collection('parents')
                                  .doc(userSnapshot.docs.first.id)
                                  .update({
                                'uid': result.user!
                                    .uid, // Update the document with the new user's UID
                                'isActive':
                                    true, // Optionally ensure the field is set to true again
                              });

                              Navigator.pop(context); // Close loading dialog
                              Get.offAll(() =>
                                  const LandingPage()); // Navigate to the landing page
                            }
                          } catch (e) {
                            Navigator.pop(
                                context); // Ensure to close the loading dialog in case of error
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text("Registration Error"),
                                content: Text(e.toString()),
                              ),
                            );
                          }
                        }
                      },
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: getWidth(context) * 0.15,
                            vertical: getHeight(context) * 0.02),
                        child: const Text('Submit'),
                      )),
                )
              ],
            ),
          )),
    );
  }
}
