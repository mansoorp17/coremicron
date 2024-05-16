import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';

import '../../common/failure.dart';
import '../../common/type_defs.dart';
import '../../constants/firebase_constants.dart';


final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository(firestore: FirebaseFirestore.instance);
});

class AuthRepository{
  final FirebaseFirestore _firestore;
  AuthRepository({
    required FirebaseFirestore firestore
  }):_firestore=firestore;
  CollectionReference get _admin =>
      _firestore.collection(FirebaseConstants.adminCollection);

  FutureVoid loginUser(
      String usernameController, String passwordController) async {
    QuerySnapshot userData = await FirebaseFirestore.instance
        .collection(FirebaseConstants.adminCollection)
        .where('username', isEqualTo: usernameController)
        .where("password", isEqualTo: passwordController)
        .get();
    try {
      if (userData.docs.isNotEmpty) {
        return right(userData);
      } else {
        return left(Failure(e.toString()));
      }
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }
}