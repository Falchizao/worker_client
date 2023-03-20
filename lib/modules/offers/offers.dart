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
  List<Offer> offers = [];
  List<String> subMenus = ["Offers", "Social"];

  Future _getOffers() async {
    var url = '$BASE_URL/$OFFER';
    var token = await JwtService().getToken();

    var response = await http.get(Uri.parse(url), headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    });

    if (response.statusCode == 200) {
      try {
        var jsonData = jsonDecode(response.body);

        for (var eachOffer in jsonData) {
          final offer = Offer(
            salary: eachOffer['salary'].toString(),
            createdDate: eachOffer['createdDate'].toString(),
            content: eachOffer['content'],
            employer: eachOffer['employer'],
            title: eachOffer['title'],
          );
          offers.add(offer);
        }
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
                        color: const Color.fromARGB(255, 134, 125, 125)
                            .withOpacity(.3),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
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
                            Icons.search,
                            color: Colors.black54.withOpacity(.6),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 50),
                height: 50.0,
                width: size.width,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: subMenus.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedIndex = index;
                          });
                        },
                        child: Text(
                          subMenus[index],
                          style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: selectedIndex == index
                                  ? FontWeight.bold
                                  : FontWeight.w300,
                              color: selectedIndex == index
                                  ? const Color.fromARGB(255, 100, 154, 204)
                                  : const Color.fromARGB(255, 145, 146, 147)),
                        ),
                      ),
                    );
                  },
                ),
              ),
              Container(
                padding: const EdgeInsets.only(left: 15, bottom: 20, top: 20),
                child: const Text(
                  "Recommended",
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(
                  height: size.height * .3,
                  child: FutureBuilder(
                    future: _getOffers(),
                    builder: (context, snapshot) {
                      return ListView.builder(
                        itemCount: offers.length,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (BuildContext context, int index) {
                          return Container(
                            width: 200,
                            margin: const EdgeInsets.symmetric(horizontal: 10),
                            decoration: BoxDecoration(
                              color: Colors.black54.withOpacity(.8),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Stack(
                              children: [
                                Positioned(
                                  top: 10,
                                  right: 10,
                                  child: Container(
                                    height: 30,
                                    width: 30,
                                    child: const IconButton(
                                      onPressed: null,
                                      icon: Icon(Icons.favorite),
                                      color: Colors.yellow,
                                      iconSize: 15,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(50),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  left: 50,
                                  right: 50,
                                  top: 50,
                                  bottom: 50,
                                  child: Image.asset("images/defaultpic.png"),
                                ),
                                Positioned(
                                  bottom: 15,
                                  left: 20,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        offers[index].title,
                                        style: const TextStyle(
                                            color: Colors.blue,
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold),
                                      )
                                    ],
                                  ),
                                ),
                                Positioned(
                                  bottom: 15,
                                  right: 20,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      r'$' + offers[index].salary.toString(),
                                      style: const TextStyle(
                                          color: Colors.green, fontSize: 16),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          );
                        },
                      );
                    },
                  )),
              Container(
                padding: const EdgeInsets.only(left: 15, bottom: 20, top: 20),
                child: const Text(
                  "All offers",
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                ),
              ),
              Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  height: size.height * .5,
                  child: FutureBuilder(
                      future: _getOffers(),
                      builder: (context, snapshot) {
                        return ListView.builder(
                          itemCount: offers.length,
                          scrollDirection: Axis.vertical,
                          physics: const BouncingScrollPhysics(),
                          itemBuilder: (BuildContext context, int index) {
                            return Container(
                              decoration: BoxDecoration(
                                color: Color.fromARGB(255, 168, 206, 241)
                                    .withOpacity(.1),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              height: 80.0,
                              padding: const EdgeInsets.only(left: 10, top: 5),
                              margin: const EdgeInsets.only(bottom: 10, top: 5),
                              width: size.width,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Stack(
                                    clipBehavior: Clip.none,
                                    children: [
                                      Container(
                                        width: 50.0,
                                        height: 70.0,
                                        decoration: BoxDecoration(
                                            color: Color.fromARGB(
                                                    255, 247, 247, 247)
                                                .withOpacity(.8),
                                            shape: BoxShape.circle),
                                      ),
                                      Positioned(
                                        top: 0,
                                        left: 0,
                                        right: 0,
                                        child: SizedBox(
                                          height: 80.0,
                                          child: Image.asset(
                                              "images/defaultpic.png"),
                                        ),
                                      ),
                                      Positioned(
                                        bottom: 5,
                                        left: 80,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              r'$' +
                                                  offers[index]
                                                      .salary
                                                      .toString(),
                                              style: TextStyle(
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.green),
                                            ),
                                            Text(
                                              offers[index].title,
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 15,
                                                  color: Colors.black),
                                            )
                                          ],
                                        ),
                                      )
                                    ],
                                  )
                                ],
                              ),
                            );
                          },
                        );
                      }))
            ]))));
  }
}
