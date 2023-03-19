import 'package:flutter/material.dart';

class ConfgProfileWidget extends StatelessWidget {
  final IconData icon;
  final String title;
  const ConfgProfileWidget({Key? key, required this.icon, required this.title})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 18.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(
                icon,
                color: Colors.black.withOpacity(.6),
                size: 25.0,
              ),
              const SizedBox(
                width: 16.0,
              ),
              Text(
                this.title,
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold),
              )
            ],
          ),
          Icon(
            Icons.arrow_forward_ios,
            color: Colors.black87.withOpacity(.4),
            size: 16.0,
          )
        ],
      ),
    );
  }
}
