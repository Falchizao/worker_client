import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:faker/faker.dart';
import 'package:scarlet_graph/services/jwtservice.dart';
import '../../models/offer_model.dart';
import '../../services/share.dart';
import '../../utils/constants.dart';
import '../../utils/handler.dart';
import '../../utils/requests.dart';
import "package:http/http.dart" as http;

class OffersPage extends StatefulWidget {
  OffersPage({super.key});

  @override
  _OffersPageState createState() => _OffersPageState();
}

class _OffersPageState extends State<OffersPage> {
  List<dynamic> offers = [];

  Future _getOffers() async {
    var url = '$BASE_URL/$OFFER';
    var token = await JwtService().getToken();

    var response = await http.get(Uri.parse(url), headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    });

    if (response.statusCode == 200) {
      String s = response.body;
      try {
        offers = jsonDecode(response.body);
      } on Exception catch (_) {
        handleToast('Error casting offers');
      }
    } else {
      handleToast('Error fetching offers');
    }
  }

  @override
  void initState() {
    super.initState();
    _getOffers();
  }

  @override
  Widget build(BuildContext context) {
    int selectedIndex = 0;
    Size size = MediaQuery.of(context).size;

    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
            backgroundColor: const Color.fromARGB(255, 162, 194, 216),
            body: FutureBuilder(
                future: _getOffers(),
                builder: (context, snapshot) {
                  return ListView.builder(
                    itemCount: offers
                        .length, // Replace with the actual number of posts
                    itemBuilder: (BuildContext context, int index) {
                      return Card(
                        child: Column(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(5),
                                  child: Text(
                                    offers[index]["title"],
                                    style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: Text(
                                    offers[index]["content"],
                                    style: const TextStyle(
                                        fontSize: 16, color: Colors.blueGrey),
                                  ),
                                ),
                                Row(
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.info),
                                      onPressed: () {
                                        // Add your like action here
                                      },
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.star),
                                      onPressed: () {
                                        // Add your like action here
                                      },
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.add),
                                      onPressed: () {
                                        // Add your comment action here
                                      },
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.share),
                                      onPressed: () {
                                        shareViaWhatsApp('teste');
                                        // Add your share action here
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  );
                })));
  }
}
