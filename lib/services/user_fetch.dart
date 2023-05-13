import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../helper/helper_function.dart';
import '../utils/constants.dart';
import '../utils/handler.dart';
import '../utils/requests.dart';
import '../widget/snackbar.dart';
import 'firebase_auth.dart';

Future<void> fetchUserPasswordDomain(
    String username, String password, String email) async {
  var url = '$BASE_URL/$LOGIN';
  String pass = '';
  String token = '';
  var response = await http.post(Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'username': username,
        'password': password,
      }));

  if (response.statusCode == 200) {
    dynamic unserializable = jsonDecode(response.body);
    token = unserializable["token"];
  } else {
    handleToast(response.body);
  }

  var url2 = '$BASE_URL/user/findByUsername?name=$username';

  final response2 = await http.post(Uri.parse(url2), headers: {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $token'
  });

  if (response2.statusCode == 200) {
    final userDetails = jsonDecode(response2.body);
    pass = userDetails['password'];
  } else {
    handleToast("Error fetching user data");
  }
  AuthService auth = AuthService();

  await auth
      .registerUserWithEmailandPassword(username, email, pass)
      .then((value) async {
    if (value == true) {
      await HelperFunctions.saveUserLoggedInStatus(true);
      await HelperFunctions.saveUserEmailSF(email);
      await HelperFunctions.saveUserNameSF(username);
    } else {
      showSnackbar(Get.context, Colors.red, value);
    }
  });
}
