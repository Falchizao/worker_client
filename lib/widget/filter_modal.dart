import 'package:flutter/material.dart';

import 'filter_job_offers.dart';

class FilterModal extends StatefulWidget {
  @override
  _FilterModalState createState() => _FilterModalState();
}

class _FilterModalState extends State<FilterModal> {
  // Example filters
  bool _fullTime = false;
  bool _partTime = false;
  String? _location;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Job Type'),
          CheckboxListTile(
            title: Text('Full Time'),
            value: _fullTime,
            onChanged: (bool? value) {
              setState(() {
                _fullTime = value!;
              });
            },
          ),
          CheckboxListTile(
            title: Text('Part Time'),
            value: _partTime,
            onChanged: (bool? value) {
              setState(() {
                _partTime = value!;
              });
            },
          ),
          Divider(),
          Text('Location'),
          DropdownButton<String>(
            value: _location,
            hint: Text('Select location'),
            items: ['New York', 'Los Angeles', 'Chicago']
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
          Divider(),
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
              child: Text('Apply Filters'),
            ),
          ),
        ],
      ),
    );
  }
}
