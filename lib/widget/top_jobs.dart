import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:scarlet_graph/widget/top_job_card.dart';
import "package:http/http.dart" as http;
import '../models/offer_model.dart';
import '../services/jwtservice.dart';
import '../utils/constants.dart';
import '../utils/requests.dart';

class TopJobsSection extends StatefulWidget {
  @override
  _TopJobsSectionState createState() => _TopJobsSectionState();
}

class _TopJobsSectionState extends State<TopJobsSection> {
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
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            'Top Jobs',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(height: 10),
        FutureBuilder<List<Offer>>(
          future: fetchOffers(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Container(
                height: 200,
                child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: snapshot.data!.length,
                  itemBuilder: (BuildContext context, int index) {
                    return TopJobCard(offer: snapshot.data![index]);
                  },
                ),
              );
            } else if (snapshot.hasError) {
              return Text('${snapshot.error}');
            }
            return CircularProgressIndicator();
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
