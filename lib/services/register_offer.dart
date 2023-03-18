import 'package:flutter/material.dart';

class RegisterOffer extends StatefulWidget {
  const RegisterOffer({super.key});

  @override
  State<RegisterOffer> createState() => _RegisterOfferState();
}

class _RegisterOfferState extends State<RegisterOffer> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
      title: const Text('Register Offer'),
    ));
  }
}
