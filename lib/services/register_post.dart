import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
      // Perform actions with title and content values here
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(
          color: Colors.black, // <-- SEE HERE
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
                onSaved: (value) => _title = value,
              ),
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
                onSaved: (value) => _content = value,
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _submitForm,
                child: const Text('Add Post'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
