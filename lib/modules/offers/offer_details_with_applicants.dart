import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../models/offer_model.dart';
import '../../models/user_model.dart';
import '../../services/jwtservice.dart';
import '../../utils/handler.dart';
import '../../utils/requests.dart';
import '../profile/user_data_profile.dart';

class JobOfferDetailsWithApplicantsPage extends StatelessWidget {
  final Offer offer;

  JobOfferDetailsWithApplicantsPage({required this.offer});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(offer.title),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Details'),
              Tab(text: 'Applicants'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            JobOfferDetailsTab(offer: offer),
            JobApplicantsTab(offer: offer),
          ],
        ),
      ),
    );
  }
}

class JobOfferDetailsTab extends StatelessWidget {
  final Offer offer;

  JobOfferDetailsTab({required this.offer});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(offer.title,
              style:
                  const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          Text('Creator: ${offer.employer}'),
          const SizedBox(height: 8),
          Text('Salary: ${offer.salary}'),
        ],
      ),
    );
  }
}

class JobApplicantsTab extends StatelessWidget {
  final Offer offer;

  JobApplicantsTab({required this.offer});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<String>>(
      future: fetchJobApplicants(offer),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                  title: Text(snapshot.data![index]),
                  onTap: () {
                    User user = User("", snapshot.data![index], "");
                    Get.to(() => UserProfileVisualizer(user: user));
                  });
            },
          );
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        return const Center(child: CircularProgressIndicator());
      },
    );
  }

  Future<List<String>> fetchJobApplicants(Offer offer) async {
    List<String> employers = [];
    var token = await JwtService().getToken();
    final response = await http.post(
      Uri.parse('$BASE_URL/offers/offerdetails?id=${offer.id}'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      },
    );

    if (response.statusCode == 200) {
      try {
        var jsonData = jsonDecode(response.body);
        for (var eachEmployer in jsonData["candidates"]) {
          employers.add(eachEmployer["username"]);
        }
        return employers;
      } on Exception catch (_) {
        handleToast('Error casting employers');
        return [];
      }
    } else {
      handleToast('Error fetching employers');
      return [];
    }
  }
}
