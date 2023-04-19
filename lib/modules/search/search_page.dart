import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';
import "package:http/http.dart" as http;
import 'package:scarlet_graph/models/user_model.dart';
import '../../services/jwtservice.dart';
import '../../utils/handler.dart';
import '../../utils/requests.dart';
import '../profile/user_data_profile.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final scrollController = ScrollController();
  bool isFetchingUsers = false;
  String query = '';
  int fetchPage = 0;
  List<User> users = [];
  Timer? debounce;

  Future<void> fetchUsers() async {
    var url = '$BASE_URL/user/page?size=10&page=$fetchPage';

    var token = await JwtService().getToken();
    final response = await http.get(Uri.parse(url), headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    });

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      List<User> usersList = [];
      for (var userData in json['content']) {
        final user = User(
          userData["email"],
          userData["username"],
          "",
          //userData["role"],
        );
        usersList.add(user);
      }
      setState(
        () {
          users = users + usersList;
        },
      );
    } else {
      handleToast("Error fetching users");
    }
  }

  @override
  void initState() {
    super.initState();
    scrollController.addListener(_scrollListener);
    fetchUsers();
  }

  void searchUsers(String query) {
    if (debounce?.isActive ?? false) {
      debounce!.cancel();
    }
    debounce = Timer(const Duration(milliseconds: 500), () async {
      var url = '$BASE_URL/user/fetchallByUsername';

      var token = await JwtService().getToken();
      final response = await http.post(Uri.parse(url),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token'
          },
          body: json.encode({
            'userStr': query,
          }));
      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        List<User> usersList = [];
        for (var userData in json) {
          final user = User(
            userData["email"],
            userData["username"],
            "",
            //userData["role"],
          );
          usersList.add(user);
        }
        setState(
          () {
            users = usersList;
          },
        );
      } else {
        handleToast("Error fetching users by label");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        title: Text(
          'Search for users',
          style: GoogleFonts.pacifico(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20.0),
            const SizedBox(height: 10.0),
            TextField(
              onChanged: (value) {
                setState(() {
                  query = value;
                });

                if (value == "") {
                  setState(
                    () {
                      users.clear();
                    },
                  );
                  fetchPage = 0;
                  users.clear;
                  fetchUsers();
                } else {
                  searchUsers(value);
                }
              },
              decoration: InputDecoration(
                hintText: 'Enter a username',
                filled: true,
                fillColor: Colors.grey.withOpacity(.5),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide.none,
                ),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search, color: Colors.deepPurple),
                  onPressed: () {
                    searchUsers(query);
                  },
                ),
              ),
            ),
            const SizedBox(height: 20.0),
            Expanded(
                child: SizedBox(
                    height: 200.0,
                    child: ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.all(5.0),
                      controller: scrollController,
                      itemCount:
                          isFetchingUsers ? users.length + 1 : users.length,
                      itemBuilder: (context, index) {
                        if (index < users.length) {
                          final user = users[index];
                          final String username = user.username;
                          return Card(
                            child: ListTile(
                              onTap: () {
                                Get.to(() => UserProfileVisualizer(
                                      user: user,
                                    ));
                              },
                              leading: CircleAvatar(
                                backgroundImage: NetworkImage(
                                    'https://api.dicebear.com/6.x/initials/jpg?seed=$username'),
                              ),
                              title: Text(user.username.toString()),
                            ),
                          );
                        } else {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                      },
                    )))
          ],
        ),
      ),
    );
  }

  Future<void> _scrollListener() async {
    if (isFetchingUsers) return;
    if (scrollController.position.pixels ==
        scrollController.position.maxScrollExtent) {
      setState(() {
        isFetchingUsers = true;
      });
      fetchPage = fetchPage + 1;
      await fetchUsers();
      setState(() {
        isFetchingUsers = false;
      });
    }
  }
}
