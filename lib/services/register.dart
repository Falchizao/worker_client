import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import "package:http/http.dart" as http;
import 'package:scarlet_graph/services/login.dart';
import 'package:scarlet_graph/utils/constants.dart';
import 'package:scarlet_graph/utils/handler.dart';
import 'package:scarlet_graph/utils/requests.dart';
import '../models/user_model.dart';
import '../utils/validate.dart';

class RegisterPage extends StatefulWidget {
  final int role;

  RegisterPage({super.key, required this.role});
  @override
  _RegisterPageState createState() => _RegisterPageState(this.role);
}

class _RegisterPageState extends State<RegisterPage> {
  _RegisterPageState(this.role);
  final _formKey = GlobalKey<FormState>();
  final _confirmationController = TextEditingController();

  int role;
  User user = User('', '', '', 0);

  Future registerUser() async {
    user.role = role;
    var response = await http.post(Uri.parse('$BASE_URL/$REGISTER'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'username': user.username,
          'password': user.password,
          "email": user.email
        }));

    if (response.statusCode == 200) {
      handleToast(response.body);
      Get.offAll(LoginPage());
    } else {
      handleToast(response.body);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Login Page',
      home: Scaffold(
        backgroundColor: const Color.fromARGB(255, 13, 66, 105),
        appBar: AppBar(
          title: Text(
            'Set up your credentials!',
            style: GoogleFonts.pacifico(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Get.back();
            },
          ),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  TextFormField(
                    controller: TextEditingController(text: user.username),
                    onChanged: (value) {
                      user.username = value;
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your username';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      hintText: 'Enter your username',
                      hintStyle: TextStyle(
                        color: Colors.white70,
                      ),
                      prefixIcon: Icon(
                        Icons.person,
                        color: Colors.white,
                      ),
                    ),
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(
                    height: 7.0,
                  ),
                  TextFormField(
                    controller: TextEditingController(text: user.email),
                    onChanged: (value) {
                      user.email = value;
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      } else if (!isValidEmail(value)) {
                        return 'Please enter a valid email address';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      hintText: 'Enter your email',
                      hintStyle: TextStyle(
                        color: Colors.white70,
                      ),
                      prefixIcon: Icon(
                        Icons.email,
                        color: Colors.white,
                      ),
                    ),
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(
                    height: 7.0,
                  ),
                  TextFormField(
                    controller: TextEditingController(text: user.password),
                    onChanged: (value) {
                      user.password = value;
                    },
                    decoration: const InputDecoration(
                      hintText: 'Enter your password',
                      hintStyle: TextStyle(
                        color: Colors.white70,
                      ),
                      prefixIcon: Icon(
                        Icons.lock,
                        color: Colors.white,
                      ),
                    ),
                    obscureText: true,
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 7.0,
                  ),
                  TextFormField(
                    controller: _confirmationController,
                    onChanged: (value) {
                      user.password = value;
                    },
                    decoration: const InputDecoration(
                      hintText: 'Confirm your password',
                      hintStyle: TextStyle(
                        color: Colors.white70,
                      ),
                      prefixIcon: Icon(
                        Icons.lock,
                        color: Colors.white,
                      ),
                    ),
                    obscureText: true,
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please confirm your password';
                      }
                      if (value != user.password) {
                        return 'Passwords do not match';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 14.0,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      final form = _formKey.currentState;
                      if (form != null && !form.validate()) {
                        return;
                      }
                      registerUser();
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
                      'Register',
                      style: TextStyle(
                        color: Colors.lightBlue[900],
                        fontSize: 16.0,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 5.0,
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      handleToast("Register with google");
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
                      'Register with google',
                      style: TextStyle(
                        color: Colors.lightBlue[900],
                        fontSize: 16.0,
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
