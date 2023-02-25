import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../utils/constants.dart';
import '../chat/chat.dart';
import '../offers/offers.dart';
import '../profile/profile.dart';
import '../search/search_page.dart';
import '../starred/starred_page.dart';

class FeedPage extends StatefulWidget {
  @override
  _FeedPageState createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  int currentPage = 0;
  List<Widget> pages = [
    const OffersPage(),
    StarredPage(),
    SearchPage(),
    ChatPage(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[currentPage],
      bottomNavigationBar: NavigationBar(
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home), label: 'Offers'),
          NavigationDestination(icon: Icon(Icons.star), label: 'Starred'),
          NavigationDestination(icon: Icon(Icons.search), label: 'Search'),
          NavigationDestination(icon: Icon(Icons.chat), label: 'Chat'),
          NavigationDestination(icon: Icon(Icons.person), label: 'Profile')
        ],
        onDestinationSelected: (int index) {
          setState(() {
            print(index);
            print('entrou');
            currentPage = index;
          });
        },
        selectedIndex: currentPage,
      ),
    );
  }
}
