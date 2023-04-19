import 'package:flutter/material.dart';

class DetailTile extends StatelessWidget {
  final String title;
  final String value;

  DetailTile({
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(
        title,
        style: const TextStyle(color: Colors.black),
      ),
      subtitle: Text(
        value,
        style: TextStyle(color: Colors.black),
      ),
    );
  }
}
