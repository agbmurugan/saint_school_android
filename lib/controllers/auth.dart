import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:saint_schoolparent_pro/controllers/session.dart';


class AuthController extends GetxController {
  static AuthController instance = Get.find();
  final _firebaseAuth = FirebaseAuth.instance;

  Stream<User?> authStateChanges() => _firebaseAuth.authStateChanges();

  @override
  void onInit() {
    super.onInit();
    authStateChanges().listen((event) {
      if (event != null) {
      } else {
        sessionController.session.parent = null;
      }
    });
  }

  Stream<bool> checkUserVerified() async* {
    bool verified = false;
    while (!verified) {
      await Future.delayed(const Duration(seconds: 5));
      if (currentUser != null) {
        await currentUser!.reload();
        verified = currentUser!.emailVerified;
        if (verified) yield true;
      }
    }
  }

  User? get currentUser => _firebaseAuth.currentUser;

  String? get uid => currentUser?.uid;

  // Future<User?> signInWithEmailAndPassword(String email, String password) async {
  //   final userCredential = await _firebaseAuth.signInWithCredential(
  //     EmailAuthProvider.credential(email: email, password: password),
  //   );
  //   return userCredential.user;
  // }

  Future<User?> signInWithEmailAndPassword(String email, String password) async {
  try {
    final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return userCredential.user;
  } on FirebaseAuthException catch (e) {
    if (e.code == 'user-not-found' || e.code == 'wrong-password') {
      throw 'Wrong email or password'; // Throwing a custom error message
    } else {
      throw 'Login failed, please try again later'; // General error message for other errors
    }
  }
}

  // Future<User?> createUserWithEmailAndPassword(String email, String password) async {
  //   printError(info: password);
  //   final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
  //     email: email,
  //     password: password,
  //   );
  //   return userCredential.user;
  // }
  Future<User?> createUserWithEmailAndPassword(String email, String password) async {
  try {
    final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    return userCredential.user;
  } catch (e) {
    if (e is FirebaseAuthException) {
      // Handle FirebaseAuthException
      print('FirebaseAuthException: ${e.message}');
      // You can return null or throw a custom exception here
    } else {
      // Handle other exceptions
      print('Error: $e');
      // You can return null or throw a custom exception here
    }
    return null; // or throw an exception
  }
}


  Future<String> resetPassword({required String email}) async {
    return _firebaseAuth.sendPasswordResetEmail(email: email).then((value) => "Success").catchError((error) {
      return error.code.toString();
    });
  }

  signInwithPhoneNumber(String phoneNumber) async {
    await _firebaseAuth.verifyPhoneNumber(
      phoneNumber: '+44 7123 123 456',
      verificationCompleted: (PhoneAuthCredential credential) async {
        await _firebaseAuth.signInWithCredential(credential);
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
      codeSent: (String verificationId, int? forceResendingToken) {},
      verificationFailed: (FirebaseAuthException error) {},
    );
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  // Inside AuthController
Future<String> updatePassword(String email, String oldPassword, String newPassword) async {
  try {
    UserCredential userCredential = await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: oldPassword,
    );
    await userCredential.user!.updatePassword(newPassword);
    return "Password updated successfully";
  } on FirebaseAuthException catch (e) {
    return "Failed to update password: ${e.message}";
  }
}

}

AuthController auth = AuthController.instance;
