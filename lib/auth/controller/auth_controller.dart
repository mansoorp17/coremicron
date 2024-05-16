import 'package:coremicron/home/screen/home.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../common/utils.dart';
import '../repository/auth_repository.dart';


final authControllerProvider = NotifierProvider<AuthController,bool>(() {
  return AuthController();
});

class AuthController extends Notifier<bool>{
  AuthRepository get _authRepository => ref.read(authRepositoryProvider);



  Future loginUser({
    required BuildContext context,
    required String usernameController,
    required String passwordController,
  }) async {
    final res =
    await _authRepository.loginUser(usernameController, passwordController);

    res.fold((l) {
      return showSnackBar(context, "User Not Found");
    },
            (r) async {
          return Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => Home(),
              ),
                  (route) => false);
        });
  }
  @override
  bool build() {
    return false;
    // TODO: implement build
    throw UnimplementedError();
  }

}