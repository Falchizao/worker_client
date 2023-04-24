import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:faker/faker.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:scarlet_graph/modules/offers/registered_jobs_view.dart';
import 'package:scarlet_graph/services/jwtservice.dart';
import '../../models/offer_model.dart';
import '../../services/share.dart';
import '../../utils/constants.dart';
import '../../utils/handler.dart';
import '../../utils/requests.dart';
import "package:http/http.dart" as http;
import '../../widget/filter.dart';
import '../../widget/header.dart';
import '../../widget/recommended_section.dart';
import '../../widget/top_jobs.dart';
import '../media/media_page.dart';
import 'applied_jobs_view.dart';

class OffersPage extends StatefulWidget {
  OffersPage({super.key});

  @override
  _OffersPageState createState() => _OffersPageState();
}

class _OffersPageState extends State<OffersPage> {
  List<Offer> offers = [];
  String? role;
  List<String> subMenus = ["Offers", "Social"];
  late final Future myFuture;

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
  }

  Future<void> refreshJobOffers() async {
    setState(() {});
  }

  Future<void> getrole() async {
    role = await JwtService().getRole();
  }

  Widget getTabByRole() {
    return role == 'CANDIDATE' ? AppliedJobsPage() : CompanyJobOffersPage();
  }

  @override
  void initState() {
    myFuture = getrole();
    _getOffers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            title: Text(
              'Social',
              style: GoogleFonts.pacifico(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            bottom: const TabBar(tabs: [
              Tab(icon: Icon(Icons.work), text: 'Job Offers'),
              Tab(icon: Icon(Icons.person), text: 'Media'),
              Tab(icon: Icon(Icons.work), text: 'My Jobs'),
            ]),
          ),
          body: FutureBuilder(
              future: myFuture,
              builder: (context, snapshot) {
                return TabBarView(
                  children: [
                    RefreshIndicator(
                      onRefresh: refreshJobOffers,
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            UserHeader(),
                            SearchAndFilter(),
                            RecommendedSection(),
                            TopJobsSection(),
                          ],
                        ),
                      ),
                    ),
                    MediaPage(),
                    getTabByRole(),
                  ],
                );
              }),
        ));
  }
}
