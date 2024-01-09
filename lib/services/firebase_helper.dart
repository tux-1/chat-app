import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/exception_message.dart';

class FireBaseHelper {
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  static Future<void> submitAuthForm({
    required String email,
    required String password,
    required String username,
    required bool isLogin,
  }) async {
    final UserCredential authResult;

    try {
      if (isLogin) {
        authResult = await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
      }
      //Registering mode
      else {
        authResult = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
        await FirebaseFirestore.instance
            .collection('users/')
            .doc(authResult.user?.uid)
            .set({
          'username': username,
          'email': email,
        });
      }
    } on FirebaseAuthException catch (error) {
      String message = 'An error occured, please check your credentials.';
      if (error.message != null) {
        message = error.message.toString();
      }
      throw ExceptionMessage(message);
    } catch (error) {
      //Any other error

      print(error);
      throw ExceptionMessage('An error occured');
    }
  }
}
