import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:scarlet_graph/models/offer_model.dart';
import 'package:scarlet_graph/utils/handler.dart';
import "package:http/http.dart" as http;
import '../utils/constants.dart';
import '../utils/requests.dart';
import 'jwtservice.dart';

class RegisterOffer extends StatefulWidget {
  @override
  _RegisterOfferState createState() => _RegisterOfferState();
}

class _RegisterOfferState extends State<RegisterOffer> {
  final _formKey = GlobalKey<FormState>();
  String _salary = '';
  String _content = '';
  String _title = '';
  String _hours = '';

  Future _addOffer() async {
    showDialog(
        context: context,
        builder: (context) {
          return const Center(child: CircularProgressIndicator());
        });

    var token = await JwtService().getToken();
    var response = await http.post(Uri.parse('$BASE_URL/$OFFER/add'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        },
        body: json.encode({
          "content": _content,
          "salary": _salary,
          "title": _title,
          "hours": _hours
        }));

    Navigator.of(context).pop();
    if (response.statusCode == 201) {
      handleToast("Offer added with success!");
      Get.back();
    } else {
      handleToast("Erro while trying to add new offer!");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'New Offer',
              style: GoogleFonts.pacifico(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
          ],
        ),
        backgroundColor: Colors.blueGrey,
        elevation: 0.0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                TextFormField(
                  controller: TextEditingController(text: _title),
                  onChanged: (title) {
                    _title = title;
                  },
                  decoration: const InputDecoration(
                    labelText: 'Offer title',
                  ),
                  validator: (title) {
                    if (title != null && title.isEmpty) {
                      return 'Please enter a title';
                    }
                    return null;
                  },
                  onSaved: (title) {
                    if (title != null && title.isEmpty) {
                      _title = title;
                    }
                  },
                ),
                TextFormField(
                  controller: TextEditingController(text: _content),
                  onChanged: (content) {
                    _content = content;
                  },
                  decoration: const InputDecoration(
                    labelText: 'Description',
                  ),
                  validator: (content) {
                    if (content != null && content.isEmpty) {
                      return 'Please enter some description';
                    }
                    return null;
                  },
                  onSaved: (content) {
                    if (content != null && content.isEmpty) {
                      _content = content;
                    }
                  },
                ),
                TextFormField(
                  controller: TextEditingController(text: _hours),
                  onChanged: (value) {
                    _hours = value;
                  },
                  decoration: const InputDecoration(
                    labelText: 'Hours per week',
                  ),
                  validator: (hours) {
                    if (hours == null) {
                      return 'Please enter some text';
                    }
                    if (hours.isEmpty) {
                      return 'Please enter some text';
                    }
                    if (double.tryParse(hours) == null) {
                      return 'Please enter a valid number';
                    }
                    return null;
                  },
                  onSaved: (hours) {
                    if (hours != null) {
                      _hours = hours;
                    }
                  },
                ),
                TextFormField(
                  controller: TextEditingController(text: _salary),
                  onChanged: (salary) {
                    _salary = salary;
                  },
                  decoration: const InputDecoration(
                    labelText: 'Salary',
                  ),
                  validator: (salary) {
                    if (salary != null && salary.isEmpty) {
                      return 'Please enter the salary';
                    }
                    return null;
                  },
                  onSaved: (salary) {
                    if (salary != null && salary.isEmpty) {
                      _salary = salary;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20.0),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState != null) {
                      _addOffer();
                    }
                  },
                  child: Text('Register new offer'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
