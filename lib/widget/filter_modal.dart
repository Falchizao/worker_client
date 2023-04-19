import 'package:flutter/material.dart';

import 'filter_job_offers.dart';

class FilterModal extends StatefulWidget {
  @override
  _FilterModalState createState() => _FilterModalState();
}

class _FilterModalState extends State<FilterModal> {
  bool _fullTime = false;
  bool _partTime = false;
  bool _homeOffice = false;
  String? _location;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Job Type'),
          CheckboxListTile(
            title: const Text('Full Time'),
            value: _fullTime,
            onChanged: (bool? value) {
              setState(() {
                _fullTime = value!;
              });
            },
          ),
          CheckboxListTile(
            title: const Text('Part Time'),
            value: _partTime,
            onChanged: (bool? value) {
              setState(() {
                _partTime = value!;
              });
            },
          ),
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
          const Text('Location'),
          DropdownButton<String>(
            value: _location,
            hint: const Text('Select location'),
            items: ['Brazil', 'United States', 'Spain', 'United Kingdom']
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: (String? value) {
              setState(() {
                _location = value;
              });
            },
          ),
          const Divider(),
          Center(
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FilteredJobOffers(
                      fullTime: _fullTime,
                      partTime: _partTime,
                      location: _location,
                    ),
                  ),
                );
              },
              child: const Text('Apply Filters'),
            ),
          ),
        ],
      ),
    );
  }
}
