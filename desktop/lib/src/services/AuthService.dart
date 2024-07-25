import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  AuthService();

  Future<String?> getToken() async {
    final user = _auth.currentUser;
    var token;

    try {
      token = await user?.getIdToken(true);
    } catch (e) {
      print('Error fetching ID token: $e');
    }

    return token;
  }

  Future<String?> getUid() async {
    final uid = _auth.currentUser!.uid;
    return uid;
  }
}
