import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:scarlet_graph/services/register.dart';

class SelectPage extends StatefulWidget {
  @override
  _SelectPageState createState() => _SelectPageState();
}

class _SelectPageState extends State<SelectPage> {
  int _selectedIndex = -1;
  String roleDescText = 'Please, select a user role';
  Color companyColor = Colors.grey;
  Color candidateColor = Colors.grey;
  final List<String> _roles = [
    'Apply to offers, create a profile, receive emails when selected, generate a dynamic portifolio from you profile and chat with your connections!',
    'Create offers, create a profile, receive emails from the applies, chat with the candidates and your connections!',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 13, 66, 105),
      appBar: AppBar(
        title: Text(
          'Select an user type',
          style: GoogleFonts.pacifico(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: candidateColor, // Background color
                ),
                onPressed: () {
                  setState(() {
                    _selectedIndex = 0;
                    companyColor = Colors.grey;
                    candidateColor = Colors.blue;
                    roleDescText = _roles[_selectedIndex];
                  });
                },
                child: const Text('Candidate'),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: companyColor, // Background color
                ),
                onPressed: () {
                  setState(() {
                    _selectedIndex = 1;
                    companyColor = Colors.blue;
                    candidateColor = Colors.grey;
                    roleDescText = _roles[_selectedIndex];
                  });
                },
                child: const Text('Company'),
              ),
            ],
          ),
          const SizedBox(height: 16.0),
          Text(
            roleDescText,
            textAlign: TextAlign.center,
            textDirection: TextDirection.ltr,
            style: const TextStyle(
              fontSize: 22.0,
              color: Colors.white,
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          _selectedIndex != -1 ? _onSubmitPressed(context) : null;
        },
        tooltip: 'Submit',
        label: const Text('Next'),
        backgroundColor: _selectedIndex != -1 ? Colors.blue : Colors.grey,
      ),
    );
  }

  void _onSubmitPressed(BuildContext context) {
    Get.to(() => RegisterPage(role: _selectedIndex));
  }
}
