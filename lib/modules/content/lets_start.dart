import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../services/user_type.dart';

class LetsGetStartedPage extends StatefulWidget {
  const LetsGetStartedPage({super.key});

  @override
  _LetsGetStartedPageState createState() => _LetsGetStartedPageState();
}

class _LetsGetStartedPageState extends State<LetsGetStartedPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 13, 66, 105),
      appBar: AppBar(
        title: Text(
          'Welcome!',
          style: GoogleFonts.pacifico(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Get.back();
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              'Create your portfolio and search for jobs',
              style: GoogleFonts.roboto(
                fontSize: 35,
                color: Colors.lightBlue,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 5.0,
            ),
            Text(
              'easily',
              textAlign: TextAlign.left,
              style: GoogleFonts.pacifico(
                fontSize: 32.0,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 200),
            ElevatedButton(
              onPressed: () {
                Get.to(() => SelectPage());
              },
              child: const Text('Let`s get started'),
            ),
          ],
        ),
      ),
    );
  }
}
