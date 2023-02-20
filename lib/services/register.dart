import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import "package:http/http.dart" as http;
import 'package:scarlet_graph/utils/requests.dart';
import '../models/user_model.dart';
import '../utils/validate.dart';

void main() => runApp(LoginPage());

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  User user = User('', '', '');
  Future loginUser() async {
    print("entrou");
    var url = '$BASE_URL/user/login';
    print(url);
    print(user.username + user.password);
    var output = await http.post(url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'username': user.username,
          'password': user.password,
        }));
    print(output.body);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
                    height: 100.0,
                    child: Text(
                      'Welcome',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.pacifico(
                        fontSize: 50.0,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 48.0,
                  ),
                  TextFormField(
                    controller: TextEditingController(text: user.username),
                    onChanged: (value) {
                      user.username = value;
                    },
                    validator: (value) {
                      print('oi');
                      if (value == null) return 'Please enter your username';
                      if (value.isEmpty) return 'Please enter your username';
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
                    height: 8.0,
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
                      print('oi2');
                      if (value == null) return 'Please enter your password';
                      if (value.isEmpty) return 'Please enter your password';
                      // if (!validateEmail(value)) {
                      //   return 'Please enter a valid email';
                      // }
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
                        print(form.validate());
                        print('invalido');
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
                    height: 16.0,
                  ),
                  TextButton(
                    onPressed: () {},
                    child: const Text(
                      'Already have an account?',
                      style: TextStyle(
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
