import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:saint_schoolparent_pro/screens/splashscreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:saint_schoolparent_pro/controllers/auth.dart';
import '../theme.dart';
import 'ic_verification_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isVisible = true;
  final _formKey = GlobalKey<FormState>();
  final email = TextEditingController();
  final password = TextEditingController();

  @override
  void initState() {
    super.initState();
    _checkFirstLaunch();
  }

  Future<void> _checkFirstLaunch() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    String lastVersion = prefs.getString('last_version') ?? '';
    String currentVersion = packageInfo.version;
    if (lastVersion != currentVersion) {
      // This means there's either a first launch or an update has occurred
      await Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => const ResetPasswordWidget()),
      );

      // Update the stored version to the current version after showing the ResetPasswordWidget
      await prefs.setString('last_version', currentVersion);
    }
  }

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          content: SizedBox(
            height: getHeight(context) * 0.25,
            child: Column(
              children: const [
                CircleAvatar(
                  radius: 40,
                  backgroundImage: AssetImage('assets/logo.png'),
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(' Please Enter your registered Email'),
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: CustomTextformField(
                    prefixIcon: Icon(Icons.email),
                    hintText: 'Email',
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Reset password'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Scaffold(
          body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.only(
                  top: getHeight(context) * 0.10,
                  bottom: getHeight(context) * 0.05),
              child: Image.asset(
                'assets/logo.png',
                height: getHeight(context) * 0.20,
              ),
            ),
            Text(
              'Welcome',
              style: getText(context).headline5,
            ),
            Text(
              'Login To Your Account',
              style: getText(context)
                  .bodyText1!
                  .apply(color: getColor(context).secondary),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: getWidth(context) * 0.02,
                  vertical: getHeight(context) * 0.05),
              child: CustomTextformField(
                prefixIcon: const Icon(Icons.email),
                hintText: 'Email',
                controller: email,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: getWidth(context) * 0.02,
                  vertical: getHeight(context) * 0.001),
              child: CustomTextformField(
                prefixIcon: const Icon(Icons.password),
                controller: password,
                hintText: 'Password',
                obscureText: isVisible,
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
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Not verified?',
                    style: getText(context).button,
                  ),
                  TextButton(
                      onPressed: () {
                        Get.to(() => const VerificationPage());
                      },
                      child: Text(
                        'Click here',
                        style: getText(context)
                            .button
                            ?.apply(color: getColor(context).inversePrimary),
                      ))
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextButton(
                  onPressed: () {
                    _showMyDialog();
                  },
                  child: Text(
                    'Forgot Password?',
                    style: getText(context)
                        .button
                        ?.apply(color: getColor(context).inversePrimary),
                  )),
            ),
            Padding(
              padding:
                  EdgeInsets.symmetric(vertical: getHeight(context) * 0.10),
              child: ElevatedButton(
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(100.0)),
                    ),
                  ),
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      try {
                        await auth.signInWithEmailAndPassword(
                            email.text, password.text);
                        // Navigate to the next page or show success message
                      } catch (e) {
                        _showErrorDialog(e.toString());
                      }
                    }
                  },
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: getWidth(context) * 0.15,
                        vertical: getHeight(context) * 0.02),
                    child: const Text('Login'),
                  )),
            )
          ],
        ),
      )),
    );
  }

  Future<void> _showErrorDialog(String message) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Login Failed'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(message),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
