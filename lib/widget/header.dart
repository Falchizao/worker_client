import 'package:flutter/material.dart';

class UserHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(
                    'https://api.dicebear.com/6.x/initials/jpg?seed=sg'),
                radius: 20,
              ),
              SizedBox(width: 10),
              Text('Welcome, username'),
            ],
          ),
          IconButton(
            icon: Icon(Icons.notifications),
            onPressed: () {
              // Handle notification button press
            },
          ),
        ],
      ),
    );
  }
}
