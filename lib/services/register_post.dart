import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import "package:http/http.dart" as http;
import '../utils/constants.dart';
import '../utils/handler.dart';
import '../utils/requests.dart';
import 'jwtservice.dart';

class RegisterPost extends StatefulWidget {
  const RegisterPost({Key? key}) : super(key: key);

  @override
  _RegisterPostState createState() => _RegisterPostState();
}

class _RegisterPostState extends State<RegisterPost> {
  final _formKey = GlobalKey<FormState>();
  String? _title;
  String? _content;

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
    }
  }

  Future _addPost() async {
    showDialog(
        context: context,
        builder: (context) {
          return const Center(child: CircularProgressIndicator());
        });

    var token = await JwtService().getToken();
    var response = await http.post(Uri.parse('$BASE_URL/$POST/submit'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        },
        body: json.encode({
          "content": _content,
          "title": _title,
        }));

    Navigator.of(context).pop();
    if (response.statusCode == 201) {
      handleToast("Post submitted with success!");
      Get.back();
    } else {
      handleToast("Erro while trying to add new post!");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(
          color: Colors.black,
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'New Post',
              style: GoogleFonts.pacifico(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
          ],
        ),
        backgroundColor: Colors.white,
        elevation: 0.0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Title',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a title';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    setState(() {
                      _title = value;
                    });
                  }),
              const SizedBox(height: 16.0),
              TextFormField(
                maxLines: null,
                decoration: const InputDecoration(
                  labelText: 'Content',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter content';
                  }
                  return null;
                },
                onChanged: (value) => _content = value,
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _addPost,
                child: const Text('Add Post'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
