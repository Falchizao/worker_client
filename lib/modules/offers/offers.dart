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

  // Future _getOffers() async {
  //   var url = '$BASE_URL/$OFFER';
  //   var token = await JwtService().getToken();

  //   var response = await http.get(Uri.parse(url), headers: {
  //     'Content-Type': 'application/json',
  //     'Authorization': 'Bearer $token'
  //   });

  //   if (response.statusCode == 200) {
  //     try {
  //       offers = jsonDecode(response.body);
  //     } on Exception catch (_) {
  //       handleToast('Error casting offers');
  //     }
  //   } else {
  //     handleToast('Error fetching offers');
  //   }
  // }

  @override
  void initState() {
    super.initState();
    //_getOffers();
  }

  @override
  Widget build(BuildContext context) {
    //int selectedIndex = 0;
    Size size = MediaQuery.of(context).size;

    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
            body: SingleChildScrollView(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
              Container(
                padding: const EdgeInsets.only(top: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16.0,
                      ),
                      width: size.width * .9,
                      decoration: BoxDecoration(
                        color:
                            Color.fromARGB(255, 134, 125, 125).withOpacity(.3),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.search,
                            color: Colors.black54.withOpacity(.6),
                          ),
                          const Expanded(
                              child: TextField(
                            showCursor: false,
                            decoration: InputDecoration(
                              hintText: 'Search Offer',
                              border: InputBorder.none,
                              focusedBorder: InputBorder.none,
                            ),
                          )),
                          Icon(
                            Icons.mic,
                            color: Colors.black54.withOpacity(.6),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              )
            ]))));
  }
}
