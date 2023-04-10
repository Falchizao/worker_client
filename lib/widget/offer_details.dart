import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import "package:http/http.dart" as http;
import '../models/offer_model.dart';
import '../services/jwtservice.dart';
import '../utils/constants.dart';
import '../utils/handler.dart';
import '../utils/requests.dart';

class JobOfferDetails extends StatelessWidget {
  final Offer offer;

  const JobOfferDetails({super.key, required this.offer});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(offer.title)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              offer.title,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(offer.content),
            const SizedBox(height: 10),
            Text('Salary: ${offer.salary}'),
            const SizedBox(height: 20),
            Text(offer.hours.toString()),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  applyToOffer();
                },
                child: Text('Apply'.tr),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future applyToOffer() async {
    showDialog(
        context: Get.context!,
        builder: (context) {
          return const Center(child: CircularProgressIndicator());
        });
    var token = await JwtService().getToken();
    final int offer_id = offer.id;
    var url = '$BASE_URL/offers/apply?id=$offer_id';
    var response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      },
    );

    Navigator.of(Get.context!).pop();

    if (response.statusCode == 201) {
      handleToast("Your apply have been received, good luck :)");
      Get.back();
    } else {
      handleToast("Error applying to the offer, try again later");
    }
  }
}
