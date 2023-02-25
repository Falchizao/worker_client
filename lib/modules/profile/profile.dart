import 'dart:io';
import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late File _backgroundImage;
  late File _profileImage;
  late TextEditingController _skillController = TextEditingController();
  late TextEditingController _descriptionController = TextEditingController();
  final picker = ImagePicker();

  Future<void> _selectBackgroundImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _backgroundImage = File(pickedFile.path);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _skillController = TextEditingController();
    _descriptionController = TextEditingController();
    _backgroundImage = File('images/baam.png');
    _profileImage = File('images/baam.png');
  }

  @override
  void dispose() {
    _skillController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _selectProfileImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _profileImage = File(pickedFile.path);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 16),
            GestureDetector(
              onTap: _selectBackgroundImage,
              child: _backgroundImage == null
                  ? Container(
                      color: Colors.grey[300],
                      height: 200,
                      child: const Center(
                        child: Text('Select the background image'),
                      ),
                    )
                  : Image.file(
                      _backgroundImage,
                      height: 200,
                      fit: BoxFit.cover,
                    ),
            ),
            const SizedBox(height: 10),
            GestureDetector(
              onTap: _selectProfileImage,
              child: _profileImage == null
                  ? const CircleAvatar(
                      radius: 50,
                      child: Icon(Icons.person),
                    )
                  : CircleAvatar(
                      radius: 50,
                      backgroundImage: FileImage(_profileImage),
                    ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Skills',
                    style: TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _skillController,
                    decoration: const InputDecoration(
                      hintText: 'Enter your skills',
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Description',
                    style: TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _descriptionController,
                    maxLines: 5,
                    decoration: const InputDecoration(
                      hintText: 'Enter a description',
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () {},
              child: const Text('Save'),
            ),
            TextButton(
              onPressed: () {},
              child: const Text('Generate Portfolio!'),
            ),
          ],
        ),
      ),
    );
  }
}
