import 'dart:convert';

import 'package:flutter/material.dart';
import "package:http/http.dart" as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/offer_model.dart';
import '../../services/jwtservice.dart';
import '../../utils/constants.dart';
import '../../utils/handler.dart';
import '../../utils/requests.dart';
import '../../widget/offer_details.dart';

class FilteredJobOffersPage extends StatelessWidget {
  final Map<String, dynamic> filterConfig;
  final String query;
  late final SharedPreferences _prefs;
  List<Offer> offers = [];

  FilteredJobOffersPage({required this.filterConfig, required this.query});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<Offer>>(
        future:
            fetchFilteredJobOffers(filterConfig: filterConfig, query: query),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  title: Text(snapshot.data![index].title),
                  subtitle: Text(snapshot.data![index].content),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            JobOfferDetails(offer: snapshot.data![index]),
                      ),
                    );
                  },
                );
              },
            );
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Future<List<Offer>> fetchFilteredJobOffers(
      {required Map<String, dynamic> filterConfig,
      required String query}) async {
    var url = '$BASE_URL/$OFFER/filter';
    var token = await JwtService().getToken();
    _prefs = await SharedPreferences.getInstance();

    bool type = _prefs.getBool("offertype") ?? true;
    bool remote = _prefs.getBool("remote") ?? true;

    final body = {
      'label': query,
      'type': type,
      'remote': remote,
    };

    var response = await http.post(Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        },
        body: jsonEncode(body));

    if (response.statusCode == 200) {
      try {
        var jsonData = jsonDecode(response.body);
        offers.clear();
        for (var eachOffer in jsonData) {
          final offer = Offer(
            id: eachOffer['id'],
            salary: eachOffer['salary'],
            createdDate: eachOffer['createdDate'].toString(),
            content: eachOffer['content'],
            employer: eachOffer['employer'],
            title: eachOffer['title'],
            hours: eachOffer['hours'],
            remote: eachOffer['remote'],
            requirements: eachOffer['requirements'],
            location: eachOffer['location'],
          );
          offers.add(offer);
        }
      } on Exception catch (_) {
        handleToast('Error casting offers');
      }
    } else {
      handleToast('Error fetching offers');
    }
    return offers;
  }
}
