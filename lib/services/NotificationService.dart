
import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationService {
  static Future<void> sendToAllUsers({
    required String title,
    required String body,
    required String type,
  }) async {
    await FirebaseFirestore.instance.collection('notifications').add({
      'userId': 'all',
      'title': title,
      'body': body,
      'type': type, // camp / appointment
      'timestamp': FieldValue.serverTimestamp(),
    });
  }
}
