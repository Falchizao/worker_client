import 'package:flutter/material.dart';
import 'package:faker/faker.dart';
import '../../services/share.dart';
import '../../utils/handler.dart';

class StarredPage extends StatefulWidget {
  const StarredPage({super.key});

  @override
  _StarredPageState createState() => _StarredPageState();
}

class _StarredPageState extends State<StarredPage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: const Color.fromARGB(255, 162, 194, 216),
        body: ListView.builder(
          itemCount: 2, // Replace with the actual number of posts
          itemBuilder: (BuildContext context, int index) {
            return Card(
              child: Column(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(5),
                        child: Text(
                          faker.job.title(),
                          style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: Text(
                          faker.lorem.sentence(),
                          style: const TextStyle(
                              fontSize: 16, color: Colors.blueGrey),
                        ),
                      ),
                      // Image.asset(
                      //   'assets/images/post_image.jpg',
                      //   width: double.infinity,
                      //   fit: BoxFit.cover,
                      // ),
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.info),
                            onPressed: () {
                              // Add your like action here
                            },
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.star,
                              color: Colors.yellow,
                            ),
                            onPressed: () {
                              // Add your like action here
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.add),
                            onPressed: () {
                              // Add your comment action here
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.share),
                            onPressed: () {
                              shareViaWhatsApp('teste');
                              // Add your share action here
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
