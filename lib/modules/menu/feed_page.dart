import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scarlet_graph/services/firebase_auth.dart';
import '../../services/jwtservice.dart';
import '../../services/register_offer.dart';
import '../../services/register_post.dart';
import '../chat/chat.dart';
import '../offers/offers.dart';
import '../profile/profile.dart';
import '../search/search_page.dart';

class RootPage extends StatefulWidget {
  @override
  _RootPageState createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final AuthService authService = AuthService();
  int _currentPage = 0;

  List<Widget> pages = [
    OffersPage(),
    SearchPage(),
    ChatPage(),
    ProfilePage(),
  ];

  List<IconData> iconsBar = [
    Icons.home,
    Icons.search,
    Icons.chat,
    Icons.person,
  ];

  bool _shouldShowFloatingButton() {
    if (_currentPage < 2) {
      return true;
    }
    return false;
  }

  @override
  void dispose() async {
    JwtService().removeToken();
    JwtService().removeRole();
    authService.signOut();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: IndexedStack(index: _currentPage, children: pages),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: AnimatedBottomNavigationBar(
          splashColor: Colors.white,
          activeColor: Colors.red,
          inactiveColor: Colors.black.withOpacity(.5),
          icons: iconsBar,
          activeIndex: _currentPage,
          gapLocation: GapLocation.center,
          notchSmoothness: NotchSmoothness.softEdge,
          onTap: (index) {
            setState(() {
              _currentPage = index;
            });
          },
        ),
        floatingActionButton: Visibility(
          visible: _shouldShowFloatingButton(), // Set it to false
          child: FloatingActionButton(
            onPressed: () async {
              if (_currentPage == 0) {
                String? role = await JwtService().getRole();
                if (role.toString() == "COMPANY") {
                  Get.to(() => RegisterOffer());
                } else {
                  Get.to(() => RegisterPost());
                }
              } else {
                Get.to(() => RegisterPost());
              }
            },
            backgroundColor: Colors.white,
            child: const Icon(
              Icons.add,
              color: Colors.black,
            ),
          ),
        ));
  }
}
