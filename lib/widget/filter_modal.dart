import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'filter_job_offers.dart';

class FilterModal extends StatefulWidget {
  @override
  _FilterModalState createState() => _FilterModalState();
}

class _FilterModalState extends State<FilterModal> {
  bool _homeOffice = false;
  bool offertype = true;
  late final SharedPreferences _prefs;

  @override
  void initState() {
    super.initState();
    _carregarSharedPreferences();
  }

  Future<void> _carregarSharedPreferences() async {
    _prefs = await SharedPreferences.getInstance();
    setState(() {});
  }

  void _savePrefs() {
    _prefs.setBool('remote', _homeOffice);
    _prefs.setBool('offertype', offertype);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CheckboxListTile(
            title: const Text('Home Office'),
            value: _homeOffice,
            onChanged: (bool? value) {
              setState(() {
                _homeOffice = value!;
              });
            },
          ),
          const Divider(),
          const Text('Full Time?'),
          DropdownButton<bool>(
            hint: Text("Full Time?"),
            value: offertype,
            items: [true, false].map((bool value) {
              return DropdownMenuItem<bool>(
                value: value,
                child: Text(value ? 'True' : 'False'),
              );
            }).toList(),
            onChanged: (bool? newValue) {
              setState(() {
                offertype = newValue ?? true;
              });
            },
          ),
          const Divider(),
          Center(
            child: ElevatedButton(
              onPressed: () {
                _savePrefs();
                Navigator.pop(context);
              },
              child: const Text('Apply Filters'),
            ),
          ),
        ],
      ),
    );
  }
}
