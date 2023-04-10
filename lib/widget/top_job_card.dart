import 'package:flutter/material.dart';

import '../models/offer_model.dart';
import 'offer_details.dart';

class TopJobCard extends StatelessWidget {
  final Offer offer;
  late String title = offer.title;

  TopJobCard({required this.offer});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => JobOfferDetails(offer: offer),
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 8, vertical: 12),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: FadeInImage.assetNetwork(
                placeholder: 'images/Reload.gif',
                image: 'https://api.dicebear.com/6.x/initials/jpg?seed=$title',
                width: 80,
                height: 80,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    offer.title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(offer.createdDate),
                  SizedBox(height: 5),
                  Text('Hours: ${offer.hours}', style: const TextStyle()),
                  SizedBox(height: 5),
                  Text('Salary: ${offer.salary}'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
