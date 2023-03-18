import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scarlet_graph/services/register.dart';

class SelectPage extends StatefulWidget {
  @override
  _SelectPageState createState() => _SelectPageState();
}

class _SelectPageState extends State<SelectPage> {
  int _selectedIndex = -1;
  final List<String> _options = ['Candidate', 'Company'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 13, 66, 105),
      appBar: AppBar(
        title: const Text('Select an user type'),
      ),
      body: ListView.builder(
        itemCount: _options.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(_options[index]),
            trailing: _selectedIndex == index ? const Icon(Icons.check) : null,
            onTap: () {
              setState(() {
                _selectedIndex = index;
              });
            },
          );
        },
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
    Get.to(() => RegisterPage());
    Navigator.pop(context, _options[_selectedIndex]);
  }
}
