import 'package:flutter/material.dart';
import 'package:get/get.dart';
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

  final List<String> _options = ['Candidate', 'Company'];
  final List<String> _roles = [
    'Apply to offers, receive emails when you get accepted, generate a dynamic portifolio from you profile and chat with your connections!',
    'Create offers, receive emails when you someone applies to you offer, chat with the candidates and your connections!',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 13, 66, 105),
      appBar: AppBar(
        title: const Text('Select an user type'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            child: const Text('Candidate'),
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
          ),
          ElevatedButton(
            child: const Text('Company'),
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
          ),
          const SizedBox(height: 16.0),
          Text(
            roleDescText,
            style: const TextStyle(fontSize: 24.0),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _selectedIndex != -1 ? _onSubmitPressed : null,
        tooltip: 'Submit',
        label: const Text('Next'),
        backgroundColor: _selectedIndex != -1 ? Colors.blue : Colors.grey,
      ),
    );
  }

  void _onSubmitPressed() {
    Get.to(() => const RegisterPage());
  }
}
