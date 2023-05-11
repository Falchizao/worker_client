import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:scarlet_graph/services/register.dart';

import '../utils/handler.dart';

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

  bool _isChecked = false;

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
        mainAxisAlignment: MainAxisAlignment.start,
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
          const SizedBox(height: 10.0),
          Text(
            _selectedIndex != 0 ? '' : '* This option is only for woman',
            textAlign: TextAlign.center,
            textDirection: TextDirection.ltr,
            style: GoogleFonts.pacifico(
              color: const Color.fromARGB(255, 252, 209, 205),
              fontWeight: FontWeight.bold,
              fontSize: 20.0,
            ),
          ),
          const SizedBox(height: 10.0),
          Container(
            child: _selectedIndex != 0 ? Text("") : GetCheckbox(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          if (_selectedIndex == 0 && !_isChecked) {
            handleToast("You must agree with the terms!".tr);
            return;
          }

          _selectedIndex != -1
              ? _onSubmitPressed(context)
              : handleToast("You must select a role for your profile!".tr);
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

  String _getTerms() {
    return "Welcome to ScarletGraph. These terms and conditions outline the rules" +
        "and regulations for the use of the app By accessing and using this application" +
        "you accept and agree to be bound by the following terms and conditions. " +
        "If you disagree with any part of these terms and conditions, please do not use our application. " +
        "Users of ScarletGraph with the role CANDIDATE must be a woman, we treat the users with respect and dignity, regardless of their gender, race, ethnicity, religion, sexual orientation, or any other characteristic. Any violation of this policy may result in immediate termination of your account and access to the application."
            "If you have any questions about these terms and conditions, please contact us at scarletgraph@gmail.com";
  }

  Widget GetCheckbox() {
    return CheckboxListTile(
      title: Text(
        // ignore: prefer_interpolation_to_compose_strings
        'I agree to the Terms and Conditions  \n' + _getTerms(),
        style: TextStyle(color: Colors.white, fontSize: 12),
      ),
      value: _isChecked,
      onChanged: (bool? value) {
        setState(() {
          _isChecked = value ?? false;
        });
      },
      controlAffinity: ListTileControlAffinity.leading,
    );
  }
}
