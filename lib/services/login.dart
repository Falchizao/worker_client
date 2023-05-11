import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import "package:http/http.dart" as http;
import 'package:scarlet_graph/helper/helper_function.dart';
import 'package:scarlet_graph/services/firebase_auth.dart';
import 'package:scarlet_graph/utils/constants.dart';
import 'package:scarlet_graph/utils/requests.dart';
import '../models/user_model.dart';
import '../modules/content/lets_start.dart';
import '../modules/menu/feed_page.dart';
import '../utils/handler.dart';
import 'package:get/get.dart';
import '../utils/validate.dart';
import '../widget/snackbar.dart';
import 'firebase_db.dart';
import 'jwtservice.dart';

void main() => runApp(const LoginPage());

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  AuthService authService = AuthService();
  final jwtService = JwtService();
  final _formKey = GlobalKey<FormState>();
  User user = User('', '', '');

  Future loginUser() async {
    showDialog(
        context: context,
        builder: (context) {
          return const Center(child: CircularProgressIndicator());
        });

    var url = '$BASE_URL/$LOGIN';
    var response = await http.post(Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'username': user.username,
          'password': user.password,
        }));

    Navigator.of(context).pop();

    if (response.statusCode == 200) {
      dynamic unserializable = jsonDecode(response.body);
      JwtService().removeToken();
      JwtService().removeRole();
      JwtService().setToken(unserializable["token"]);
      JwtService().setRole(unserializable["user_role"]);
      authService.signOut();
      _fetchUserDetails();
    } else {
      handleToast(response.body);
    }
  }

  Future _fetchUserDetails() async {
    var token = await JwtService().getToken();
    var url2 = '$BASE_URL/user/findByUsername?name=${user.username}';

    final response2 = await http.post(Uri.parse(url2), headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    });

    if (response2.statusCode == 200) {
      final userDetails = jsonDecode(response2.body);
      String pass = userDetails['password'];

      authService.loginFirebase(userDetails['email'], pass, Get.context!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Login Page',
      home: Scaffold(
        backgroundColor: const Color.fromARGB(255, 13, 66, 105),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  // SizedBox(
                  //   height: 100.0,
                  //   child: Image.asset(
                  //     'assets/images/logo.png',
                  //   ),
                  // ),
                  SizedBox(
                    height: 90.0,
                    child: Text(
                      'Scarlet_graph',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.pacifico(
                        fontSize: 40.0,
                        color: Colors.lightBlue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 30.0,
                  ),
                  TextFormField(
                    controller: TextEditingController(text: user.username),
                    onChanged: (value) {
                      user.username = value;
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your username'.tr;
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      hintText: 'Enter your username',
                      hintStyle: GoogleFonts.roboto(
                        color: Colors.white70,
                      ),
                      prefixIcon: const Icon(
                        Icons.person,
                        color: Colors.white,
                      ),
                    ),
                    style: GoogleFonts.roboto(
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(
                    height: 8.0,
                  ),
                  TextFormField(
                    controller: TextEditingController(text: user.password),
                    onChanged: (value) {
                      user.password = value;
                    },
                    decoration: InputDecoration(
                      hintText: 'Enter your password'.tr,
                      hintStyle: GoogleFonts.roboto(
                        color: Colors.white70,
                      ),
                      prefixIcon: const Icon(
                        Icons.lock,
                        color: Colors.white,
                      ),
                    ),
                    obscureText: true,
                    style: GoogleFonts.roboto(
                      color: Colors.white,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password'.tr;
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 24.0,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      final form = _formKey.currentState;
                      if (form != null && !form.validate()) {
                        return;
                      }
                      loginUser();
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.lightBlue[900],
                      backgroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(32.0),
                      ),
                    ),
                    child: Text(
                      'Log In',
                      style: TextStyle(
                        color: Colors.lightBlue[900],
                        fontSize: 16.0,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 7.0,
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      handleToast("Sign in with google".tr);
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.lightBlue[900],
                      backgroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(32.0),
                      ),
                    ),
                    icon: Image.asset(
                      'images/google.png',
                      height: 30,
                      width: 30,
                    ),
                    label: Text(
                      'Sign in with google',
                      style: TextStyle(
                        color: Colors.lightBlue[900],
                        fontSize: 16.0,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 7.0,
                  ),
                  TextButton(
                    onPressed: () {
                      Get.to(() => const LetsGetStartedPage());
                    },
                    child: Text(
                      'Don´t have an account yet?  Sign Up'.tr,
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
