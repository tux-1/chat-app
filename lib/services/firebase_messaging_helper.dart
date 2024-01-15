import 'package:firebase_messaging/firebase_messaging.dart';

class FirebaseMessagingHelper {
  // create an instance of Firebase Messaging
  final _firebaseMessaging = FirebaseMessaging.instance;

  // function to initialize notifications
  Future<void> initNotifications() async {
    // request permission from user (will prompt user)
    await _firebaseMessaging.requestPermission();

    // fetch FCM token
    final fCMToken = await _firebaseMessaging.getToken();

    print('FCM Token: $fCMToken');
  }
}
