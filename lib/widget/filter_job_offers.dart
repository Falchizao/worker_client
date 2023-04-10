import 'dart:convert';

import 'package:flutter/material.dart';
import "package:http/http.dart" as http;
import '../models/offer_model.dart';
import '../services/jwtservice.dart';
import '../utils/constants.dart';
import '../utils/requests.dart';

class FilteredJobOffers extends StatefulWidget {
  final bool fullTime;
  final bool partTime;
  final String? location;

  FilteredJobOffers(
      {required this.fullTime, required this.partTime, this.location});

  @override
  _FilteredJobOffersState createState() => _FilteredJobOffersState();
}

class _FilteredJobOffersState extends State<FilteredJobOffers> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Filtered Job Offers')),
      body: FutureBuilder<List<Offer>>(
        future: fetchOffers(widget.fullTime, widget.partTime, widget.location),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  title: Text(snapshot.data![index].title),
                  subtitle: Text(snapshot.data![index].content),
                );
              },
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('An error occurred while loading job offers.'),
            );
          }
          return CircularProgressIndicator();
        },
      ),
    );
  }

  Future<List<Offer>> fetchOffers(
      bool fulltime, bool partTime, String? location) async {
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
