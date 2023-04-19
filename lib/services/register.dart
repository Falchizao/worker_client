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

  String? _username;
  String? _email;
  String? _password;
  String? _confirmPassword;
  int role;
  User user = User('', '', '', 0);

  Future registerUser() async {
    showDialog(
        context: context,
        builder: (context) {
          return const Center(child: CircularProgressIndicator());
        });
    user.role = role;
    var response = await http.post(Uri.parse('$BASE_URL/$REGISTER'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'username': user.username,
          'password': user.password,
          'email': user.email
        }));

    Navigator.of(context).pop();
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
            'Set up your credentials!'.tr,
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
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a username';
                      } else if (value.length < 6 || value.length > 20) {
                        return 'Username must be between 6 and 20 characters'
                            .tr;
                      }
                      return null;
                    },
                    onSaved: (value) {
                      user.username = value!;
                    },
                    onChanged: (value) {
                      user.username = value;
                    },
                    decoration: InputDecoration(
                      hintText: 'Enter your username'.tr,
                      hintStyle: const TextStyle(
                        color: Colors.white70,
                      ),
                      prefixIcon: const Icon(
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
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter an email'.tr;
                      } else if (!value.contains('@')) {
                        return 'Please enter a valid email'.tr;
                      }
                      return null;
                    },
                    onSaved: (value) {
                      user.email = value!;
                    },
                    onChanged: (value) {
                      user.email = value;
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
                    onChanged: (value) {
                      user.password = value;
                    },
                    obscureText: true,
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a password'.tr;
                      } else if (value.length < 8 || value.length > 20) {
                        return 'Password must be between 8 and 20 characters'
                            .tr;
                      } else if (!value.contains(RegExp(r'[A-Z]'))) {
                        return 'Password must contain at least one uppercase letter'
                            .tr;
                      }
                      return null;
                    },
                    onSaved: (value) {
                      user.password = value!;
                    },
                  ),
                  const SizedBox(
                    height: 7.0,
                  ),
                  TextFormField(
                    controller: _confirmationController,
                    decoration: InputDecoration(
                      hintText: 'Confirm your password'.tr,
                      hintStyle: const TextStyle(
                        color: Colors.white70,
                      ),
                      prefixIcon: const Icon(
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
                        return 'Please confirm your password'.tr;
                      } else if (value != user.password) {
                        return 'Passwords do not match'.tr;
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _confirmPassword = value;
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
                      handleToast("Register with google".tr);
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
                      'Register with google'.tr,
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
