import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import "package:http/http.dart" as http;
import 'package:scarlet_graph/widget/recommended_card.dart';
import '../models/offer_model.dart';
import '../services/jwtservice.dart';
import '../utils/constants.dart';
import '../utils/requests.dart';

class RecommendedSection extends StatefulWidget {
  @override
  _RecommendedSectionState createState() => _RecommendedSectionState();
}

class _RecommendedSectionState extends State<RecommendedSection> {
  Future<void> refresh() async {
    fetchOffers();
    await Future.delayed(Duration(seconds: 2));

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text('Recommended'.tr),
        ),
        const SizedBox(height: 10),
        FutureBuilder<List<Offer>>(
          future: fetchOffers(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Container(
                height: 200,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: snapshot.data!.length,
                  itemBuilder: (BuildContext context, int index) {
                    return RecommendedJobCard(offer: snapshot.data![index]);
                  },
                ),
              );
            } else if (snapshot.hasError) {
              return Text('${snapshot.error}');
            }
            return const CircularProgressIndicator();
          },
        ),
      ],
    );
  }

  Future<List<Offer>> fetchOffers() async {
    var url = '$BASE_URL/$OFFER';
    var token = await JwtService().getToken();

    var response = await http.get(Uri.parse(url), headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    });

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((offer) => Offer.fromJson(offer)).toList();
    } else {
      throw Exception('Failed to load jobs');
    }
  }
}
