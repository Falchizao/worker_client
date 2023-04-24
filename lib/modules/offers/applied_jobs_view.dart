import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:scarlet_graph/models/offer_model.dart';
import 'package:http/http.dart' as http;
import 'package:scarlet_graph/utils/handler.dart';
import '../../services/jwtservice.dart';
import '../../utils/requests.dart';
import '../../widget/offer_details.dart';

class AppliedJobsPage extends StatefulWidget {
  @override
  _MediaPageState createState() => _MediaPageState();
}

class _MediaPageState extends State<AppliedJobsPage> {
  @override
  void initState() {
    super.initState();
    fetchAppliedJobs();
    Future.delayed(Duration(seconds: 3), () {
      setState(() {
        isLoading = false;
      });
    });
  }

  bool isLoading = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : FutureBuilder<List<Offer>>(
              future: fetchAppliedJobs(),
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

  Future<List<Offer>> fetchAppliedJobs() async {
    List<Offer> offers = [];
    var token = await JwtService().getToken();
    final response = await http.post(
      Uri.parse('$BASE_URL/offers/all'),
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
