import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import '../../utils/handler.dart';
import '../../utils/requests.dart';
import '../../services/jwtservice.dart';
import '../../models/user_model.dart';
import 'dart:convert';

class UserProfileVisualizer extends StatefulWidget {
  final User user;

  UserProfileVisualizer({super.key, required this.user});

  @override
  _UserProfileVisualizerState createState() =>
      _UserProfileVisualizerState(this.user);
}

class _UserProfileVisualizerState extends State<UserProfileVisualizer> {
  _UserProfileVisualizerState(this.user);
  late String username = user.username;
  final User user;
  String userrole = "";
  bool _isFollowing = false;
  String userDescription = "";
  String userLocation = "";
  String xp = "";
  late var token;
  bool isLoading = true;
  @override
  void initState() {
    super.initState();
    _fetchUserDetails();
    Future.delayed(Duration(seconds: 3), () {
      setState(() {
        isLoading = false;
      });
    });
  }

  Future<void> _fetchUserDetails() async {
    token = await JwtService().getToken();
    var url = '$BASE_URL/user/findByUsername?name=$username';

    final response = await http.post(Uri.parse(url), headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    });

    if (response.statusCode == 200) {
      final userDetails = jsonDecode(response.body);
      userDescription = userDetails["profile"]["description"] ?? "";
      _isFollowing = userDetails["isfollowing"];
      xp = userDetails["profile"]["previousXP"] ?? "";
      userLocation = userDetails["profile"]["location"] ?? "";
    } else {
      handleToast("Error fetching user data");
    }
  }

  Future<void> _followUser() async {
    String action = !_isFollowing ? "true" : "false";
    final body = {
      'follow': action,
    };

    final response = await http.post(
        Uri.parse('$BASE_URL/connections/follow?name=$username'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        },
        body: jsonEncode(body));

    if (response.statusCode == 200) {
      setState(() {
        _isFollowing = !_isFollowing;
      });
    } else {
      print('Failed to follow user.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'User profile',
            style: GoogleFonts.pacifico(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : SingleChildScrollView(
                child: FutureBuilder(
                    future: _fetchUserDetails(),
                    builder: (context, snapshot) {
                      return Column(
                        children: [
                          Container(
                            width: double.infinity,
                            height: 200,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.deepPurple,
                                  Colors.deepPurple.shade200
                                ],
                              ),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CircleAvatar(
                                  radius: 50,
                                  backgroundImage: NetworkImage(
                                      'https://api.dicebear.com/6.x/initials/jpg?seed=$username'),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  username,
                                  style: const TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                                const SizedBox(height: 10),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Description',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  userDescription ?? "",
                                  style: const TextStyle(fontSize: 16),
                                  textAlign: TextAlign.justify,
                                ),
                                const SizedBox(height: 20),
                                const Text(
                                  'Location',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  userLocation,
                                  style: const TextStyle(fontSize: 16),
                                  textAlign: TextAlign.justify,
                                ),
                                const SizedBox(height: 20),
                                const SizedBox(height: 20),
                                const Text(
                                  'Experience',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  xp,
                                  style: const TextStyle(fontSize: 16),
                                  textAlign: TextAlign.justify,
                                ),
                                const SizedBox(height: 20),
                                Center(
                                  child: ElevatedButton(
                                    onPressed: _followUser,
                                    style: ElevatedButton.styleFrom(
                                      primary: Colors.deepPurple,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 40, vertical: 12),
                                    ),
                                    child: Text(
                                        _isFollowing ? 'Unfollow' : 'Follow',
                                        style: const TextStyle(fontSize: 18)),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    }),
              ));
  }
}
