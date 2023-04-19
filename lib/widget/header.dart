import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../services/jwtservice.dart';
import '../utils/handler.dart';
import '../utils/requests.dart';

class UserHeader extends StatefulWidget {
  @override
  _UserHeaderState createState() => _UserHeaderState();
}

class _UserHeaderState extends State<UserHeader> {
  String username = "";
  bool isLoading = true;
  late final Future myFuture;

  @override
  void initState() {
    super.initState();
    myFuture = _fetchUserDetails();
    Future.delayed(Duration(seconds: 3), () {
      setState(() {
        isLoading = false;
      });
    });
  }

  Future _fetchUserDetails() async {
    var token = await JwtService().getToken();
    var url = '$BASE_URL/user/owninfo';
    final response = await http.post(Uri.parse(url), headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    });

    if (response.statusCode == 200) {
      final userDetails = jsonDecode(response.body);
      setState(() {
        username = userDetails["username"];
      });
    } else {
      handleToast("Error fetching user data");
    }
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : FutureBuilder(
            future: myFuture,
            builder: (context, snapshot) {
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          backgroundImage: NetworkImage(
                              'https://api.dicebear.com/6.x/initials/jpg?seed=$username'),
                          radius: 20,
                        ),
                        SizedBox(width: 10),
                        Text('Welcome, $username'),
                      ],
                    ),
                    IconButton(
                      icon: const Icon(Icons.notifications),
                      onPressed: () {
                        // Handle notification button press
                      },
                    ),
                  ],
                ),
              );
            });
  }
}
