import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../models/offer_model.dart';
import '../../services/jwtservice.dart';
import '../../utils/handler.dart';
import '../../utils/requests.dart';
import 'offer_details_with_applicants.dart';

class CompanyJobOffersPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<Offer>>(
        future: fetchCompanyJobOffers(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (BuildContext context, int index) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: ListTile(
                        title: Text(snapshot.data![index].title),
                        subtitle: Text(snapshot.data![index].content),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  JobOfferDetailsWithApplicantsPage(
                                      offer: snapshot.data![index]),
                            ),
                          );
                        },
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        // deleteJobOffer(snapshot.data![index]);
                      },
                    ),
                  ],
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

  Future<List<Offer>> fetchCompanyJobOffers() async {
    List<Offer> offers = [];
    var token = await JwtService().getToken();
    final response = await http.post(
      Uri.parse('$BASE_URL/offers/myoffers'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      },
    );

    if (response.statusCode == 200) {
      try {
        var jsonData = jsonDecode(response.body);
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
        return offers;
      } on Exception catch (_) {
        handleToast('Error casting offers');
        return [];
      }
    } else {
      handleToast('Error fetching applied jobs');
      return [];
    }
  }
}
