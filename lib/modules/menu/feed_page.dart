import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../services/jwtservice.dart';
import '../../services/register_offer.dart';
import '../../services/register_post.dart';
import '../../utils/constants.dart';
import '../chat/chat.dart';
import '../offers/offers.dart';
import '../profile/profile.dart';
import '../search/search_page.dart';
import '../starred/starred_page.dart';

class RootPage extends StatefulWidget {
  @override
  _RootPageState createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
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

  List<String> titleList = [
    'Offers and Social',
    'Search',
    'Messaging',
    'Your Profile'
  ];

  bool _shouldShowFloatingButton() {
    if (_currentPage < 2) {
      return true;
    }
    return false;
  }

  @override
  void dispose() {
    JwtService().removeToken();
    JwtService().removeRole();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                titleList[_currentPage],
                style: GoogleFonts.pacifico(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),
            ],
          ),
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          elevation: 0.0,
        ),
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
