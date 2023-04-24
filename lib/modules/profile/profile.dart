import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import '../../services/jwtservice.dart';
import '../../utils/handler.dart';
import 'package:open_file/open_file.dart';
import '../../utils/requests.dart';
import '../../widget/details_tile.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _localizationController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _xpController = TextEditingController();

  bool _isDarkTheme = false;
  late File? _profilePicture;
  bool isLoading = true;
  ThemeMode _themeMode = ThemeMode.system;

  final _formKey = GlobalKey<FormState>();
  bool _isSubmitting = false;
  bool _isGenerating = false;
  String _phoneNumber = '';
  String username = "";
  String email = "";
  String description = "";
  String location = "";
  String xp = "";
  String role = "";
  late final Future myFuture;

  @override
  void initState() {
    super.initState();
    myFuture = _fetchUserDetails();
    Future.delayed(Duration(seconds: 3), () {
      setState(() {
        isLoading = false;
      });
    });
    getPhoneNumber();
  }

  void getPhoneNumber() async {
    // String phoneNumber =
    // await ImeiPlugin.getImei(shouldShowRequestPermissionRationale: false);
    setState(() {
      // _phoneNumber = phoneNumber ?? '';
    });
  }

  Future<void> downloadAndOpenPdf() async {
    setState(() {
      _isGenerating = true;
    });

    var token = await JwtService().getToken();
    var url = '$BASE_URL/curriculum/generate-curriculum';
    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      },
      body: json.encode({
        'username': username,
      }),
    );

    if (response.headers['content-type'] == 'application/pdf') {
      final tempDir = await getTemporaryDirectory();
      final pdfFile = File('${tempDir.path}/curriculum.pdf');
      await pdfFile.writeAsBytes(response.bodyBytes);
      await OpenFile.open(pdfFile.path);
    } else {
      handleToast('Error downloading PDF');
    }

    setState(() {
      _isGenerating = false;
    });
  }

  Future<void> _pickImage() async {
    final pickedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      final directory = await getApplicationDocumentsDirectory();
      final imagePath =
          '${directory.path}/${DateTime.now().toIso8601String()}.jpg';
      final imageFile = await File(pickedImage.path).copy(imagePath);
      setState(() {
        _profilePicture = imageFile;
      });
    }
  }

  void _toggleTheme() {
    setState(() {
      _isDarkTheme = !_isDarkTheme;
      ThemeMode newTheme = _isDarkTheme ? ThemeMode.dark : ThemeMode.light;
      (context.findAncestorWidgetOfExactType<ProfilePage>()
              as _ProfilePageState)
          .changeTheme(newTheme);
    });
  }

  void changeTheme(ThemeMode newTheme) {
    setState(() {
      _themeMode = newTheme;
    });
  }

  Future<void> _submitData() async {
    setState(() {
      _isSubmitting = true;
    });

    var token = await JwtService().getToken();
    var url = '$BASE_URL/user/update';
    final response = await http.post(Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        },
        body: json.encode({
          'firstName': username,
          'lastName': username,
          'location': location,
          'description': description,
          'previousXP': xp
        }));

    setState(() {
      _isSubmitting = false;
    });

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Data submitted successfully!')),
      );
      showDialog(
          context: context,
          builder: (context) {
            return const Center(child: CircularProgressIndicator());
          });
      await _fetchUserDetails();
      Navigator.of(context).pop();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Error submitting data. Please try again later.')),
      );
    }
  }

  Future _fetchUserDetails() async {
    var token = await JwtService().getToken();
    var url = '$BASE_URL/user/owninfo';
    final response = await http.post(Uri.parse(url), headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    });

    if (response.statusCode == 200) {
      final userDetails = jsonDecode(response.body);
      setState(() {
        username = userDetails["username"];
        email = userDetails["email"];
        role = userDetails["role"];
        _descriptionController.text = userDetails["description"] ?? "";
        _xpController.text = userDetails["previousXp"] ?? "";
        _localizationController.text = userDetails["location"] ?? "";
      });
    } else {
      handleToast("Error fetching user data");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Profile Page',
            style: GoogleFonts.pacifico(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : FutureBuilder(
                future: myFuture,
                builder: (context, snapshot) {
                  return SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Column(children: [
                        Container(
                          width: Get.width,
                          height: Get.height,
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Color.fromARGB(255, 251, 249, 255),
                                Color.fromARGB(255, 232, 219, 255)
                              ],
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  height: 100,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                          color:
                                              const Color.fromARGB(221, 0, 0, 0)
                                                  .withOpacity(0.3),
                                          width: 2.0)),
                                  child: GestureDetector(
                                    onTap: _pickImage,
                                    child: CircleAvatar(
                                      radius: 50,
                                      backgroundImage: NetworkImage(
                                          'https://api.dicebear.com/6.x/initials/jpg?seed=$username'),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 16),
                                DetailTile(
                                    title: 'Email Registered', value: email),
                                DetailTile(title: 'Name', value: username),
                                const SizedBox(height: 5),
                                Text(
                                  'Description'.tr,
                                  style: const TextStyle(color: Colors.black),
                                ),
                                const SizedBox(height: 1),
                                TextFormField(
                                  controller: _descriptionController,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                  ),
                                  minLines: 1,
                                  maxLines: 6,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter a description';
                                    }
                                    return null;
                                  },
                                  onChanged: (value) {
                                    setState(() {
                                      description = value;
                                    });
                                  },
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Text('Location'.tr,
                                    style:
                                        const TextStyle(color: Colors.black)),
                                TextFormField(
                                  controller: _localizationController,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                  ),
                                  minLines: 1,
                                  maxLines: 6,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter a location';
                                    }
                                    return null;
                                  },
                                  onChanged: (value) {
                                    setState(() {
                                      location = value;
                                    });
                                  },
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Text('Previous experiences'.tr,
                                    style:
                                        const TextStyle(color: Colors.black)),
                                TextFormField(
                                  controller: _xpController,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                  ),
                                  minLines: 1,
                                  maxLines: 6,
                                  validator: (value) {
                                    return null;
                                  },
                                  onChanged: (value) {
                                    setState(() {
                                      xp = value;
                                    });
                                  },
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      _isGenerating
                                          ? null
                                          : downloadAndOpenPdf();
                                    },
                                    child: _isGenerating
                                        ? const CircularProgressIndicator(
                                            valueColor:
                                                AlwaysStoppedAnimation<Color>(
                                                    Colors.black),
                                          )
                                        : const Text('Generate Portifolio'),
                                  ),
                                ),
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    onPressed:
                                        _isSubmitting ? null : _submitData,
                                    child: _isSubmitting
                                        ? const CircularProgressIndicator(
                                            valueColor:
                                                AlwaysStoppedAnimation<Color>(
                                                    Colors.white),
                                          )
                                        : const Text('Submit'),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      ]));
                },
              ));
  }
}
