import 'dart:io';
import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../services/portfolioGenerator.dart';
import '../../widget/profile_config.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // late File _backgroundImage;
  // late File _profileImage;
  // late TextEditingController _skillController = TextEditingController();
  // late TextEditingController _descriptionController = TextEditingController();
  // final picker = ImagePicker();

  // Future<void> _selectBackgroundImage() async {
  //   final pickedFile = await picker.getImage(source: ImageSource.gallery);
  //   setState(() {
  //     if (pickedFile != null) {
  //       //_backgroundImage = File(pickedFile.path);
  //     }
  //   });
  // }

  @override
  void initState() {
    super.initState();
    // _skillController = TextEditingController();
    // _descriptionController = TextEditingController();
  }

  @override
  void dispose() {
    // _skillController.dispose();
    // _descriptionController.dispose();
    super.dispose();
  }

  // Future<void> _selectProfileImage() async {
  //   final pickedFile = await picker.getImage(source: ImageSource.gallery);
  //   setState(() {
  //     if (pickedFile != null) {
  //       // _profileImage = File(pickedFile.path);
  //     }
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        body: SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.all(16),
        height: size.height,
        width: size.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 150,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                      color: Color.fromARGB(221, 0, 0, 0), width: 3.0)),
              child: CircleAvatar(
                  radius: 60,
                  backgroundColor: Colors.transparent,
                  backgroundImage: ExactAssetImage("images/baam.png")),
            ),
            const SizedBox(
              height: 15,
            ),
            Text(
              'Falchizao',
              style: TextStyle(color: Colors.black, fontSize: 20),
            ),
            const SizedBox(
              height: 10,
            ),
            Text('marcelonavarro11md@gmail.com',
                style: TextStyle(color: Colors.black.withOpacity(.4))),
            const SizedBox(
              height: 25,
            ),
            SizedBox(
              height: size.height * .7,
              width: size.width,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: const [
                  ConfgProfileWidget(
                    icon: Icons.person,
                    title: 'Profile',
                  ),
                  ConfgProfileWidget(
                    icon: Icons.settings,
                    title: 'Settings',
                  ),
                  ConfgProfileWidget(
                    icon: Icons.share,
                    title: 'Share',
                  ),
                  ConfgProfileWidget(
                    icon: Icons.logout,
                    title: 'Log out',
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    ));
  }
}
