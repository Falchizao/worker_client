import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../helper/helper_function.dart';
import '../../models/dialog_model.dart';
import '../../models/offer_model.dart';
import '../../models/user_model.dart';
import '../../services/firebase_db.dart';
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
  DatabaseService dbSv = DatabaseService();
  late String currentUsername;

  selectUserForRole(String username) async {
    var token = await JwtService().getToken();

    final body = {
      'username': username,
      'offer_id': offer.id,
    };

    await http.post(Uri.parse('$BASE_URL/email/sendEmail'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        },
        body: jsonEncode(body));

    handleToast('Email sent successfully!');
    await HelperFunctions.getUserNameFromSF().then((val) {
      currentUsername = val!;
    });

    dbSv.instantiateGroup(
        currentUsername, username, '${offer.title} - $username');
  }

  void showConfirmationDialog(BuildContext context, String username) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ConfirmationDialog(
          title: 'Select This Candidate',
          content: 'Are you sure you want to proceed?',
          onConfirm: () {
            selectUserForRole(username);
          },
          onDismiss: () {},
        );
      },
    );
  }

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
                  trailing: IconButton(
                    icon: const Icon(Icons.check, color: Colors.green),
                    onPressed: () async {
                      showConfirmationDialog(context, snapshot.data![index]);
                    },
                  ),
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
