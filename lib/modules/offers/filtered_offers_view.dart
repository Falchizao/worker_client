import 'package:flutter/material.dart';

import '../../models/offer_model.dart';
import '../../widget/offer_details.dart';

class FilteredJobOffersPage extends StatelessWidget {
  final Map<String, dynamic> filterConfig;
  final String query;

  FilteredJobOffersPage({required this.filterConfig, required this.query});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Filtered Job Offers')),
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
    await Future.delayed(const Duration(seconds: 2));
    return List.generate(
        10,
        (index) => Offer(
              id: index,
              title: 'Offer $index',
              employer: 'Creator $index',
              salary: 1000,
              content: 'awdawdawd',
              createdDate: '3434',
              hours: 10,
            ));
  }
}
