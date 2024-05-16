import 'package:coremicron/auth/controller/auth_controller.dart';
import 'package:coremicron/common/utils.dart';
import 'package:coremicron/home/screen/home.dart';
import 'package:coremicron/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController userName_controller = TextEditingController();
  TextEditingController password_controller = TextEditingController();
  bool pass = false;
  void loginUser(WidgetRef ref) {
    ref.read(authControllerProvider.notifier).loginUser(
        context: context,
        usernameController: userName_controller.text.trim(),
        passwordController: password_controller.text.trim());
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      height: height,
      width: width,
      decoration: const BoxDecoration(
        image: DecorationImage(
            image: AssetImage("asset/images/background_image.png"),
            fit: BoxFit.fill),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Employee Progress Card",
            style: TextStyle(color: Colors.white, fontSize: width * 0.07),
          ),
          Container(
            height: height * 0.3,
            width: width * 0.88,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(width * 0.01)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                    height: width * 0.1,
                    width: width * 0.88,
                    decoration: BoxDecoration(color: Colors.grey),
                    child: Padding(
                      padding: EdgeInsets.only(left: width * 0.03),
                      child: Text(
                        "Please sign in",
                        style: TextStyle(
                            color: Colors.white, fontSize: width * 0.06),
                      ),
                    )),
                Container(
                  height: width * 0.13,
                  width: width * 0.8,
                  child: TextFormField(
                    controller: userName_controller,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey)),
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey)),
                        hintText: "User Name",
                        hintStyle: TextStyle(color: Colors.grey)),
                  ),
                ),
                Container(
                  height: width * 0.13,
                  width: width * 0.8,
                  child: TextFormField(
                    controller: password_controller,
                    keyboardType: TextInputType.text,
                    obscureText: pass,
                    decoration: InputDecoration(
                        suffixIcon: GestureDetector(
                          onTap: () {
                            pass = !pass;
                            setState(() {});
                          },
                          child: pass == true
                              ? Icon(Icons.visibility_off)
                              : Icon(Icons.visibility),
                        ),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey)),
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey)),
                        hintText: "Password",
                        hintStyle: TextStyle(color: Colors.grey)),
                  ),
                ),
                Consumer(
                  builder:
                      (BuildContext context, WidgetRef ref, Widget? child) {
                    return InkWell(
                      onTap: () {
                        if (userName_controller.text == '' ||
                            password_controller.text == '') {
                          return showSnackBar(
                              context, 'Please Fill All Fields');
                        } else {
                          loginUser(ref);
                        }
                      },
                      child: Padding(
                        padding: EdgeInsets.only(bottom: width * 0.03),
                        child: Container(
                          height: width * 0.14,
                          width: width * 0.8,
                          decoration: BoxDecoration(
                              color: Colors.green,
                              borderRadius:
                                  BorderRadius.circular(width * 0.015)),
                          child: Center(
                            child: Text(
                              "Login",
                              style: TextStyle(
                                  color: Colors.white, fontSize: width * 0.07),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                )
              ],
            ),
          )
        ],
      ),
    ));
  }
}
