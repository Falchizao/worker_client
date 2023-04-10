import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:scarlet_graph/modules/media/post_card.dart';
import "package:http/http.dart" as http;
import '../../models/post_model.dart';
import '../../services/jwtservice.dart';
import '../../utils/handler.dart';
import '../../utils/requests.dart';

class MediaPage extends StatefulWidget {
  @override
  _MediaPageState createState() => _MediaPageState();
}

class _MediaPageState extends State<MediaPage> {
  List<Post> posts = [];
  final scrollController = ScrollController();
  bool isFetchingPosts = false;
  int fetchPage = 0;
  bool isLoading = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: isFetchingPosts ? posts.length + 1 : posts.length,
              controller: scrollController,
              physics: const BouncingScrollPhysics(),
              itemBuilder: (BuildContext context, int index) {
                if (index < posts.length) {
                  return PostCard(post: posts[index]);
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                ;
              },
            ),
    );
  }

  @override
  void initState() {
    super.initState();
    scrollController.addListener(_scrollListener);
    fetchPosts();
    Future.delayed(Duration(seconds: 3), () {
      setState(() {
        isLoading = false;
      });
    });
  }

  Future<void> fetchPosts() async {
    var url = '$BASE_URL/posts/fetchByFollowing';

    var token = await JwtService().getToken();
    final response = await http.post(Uri.parse(url), headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    });

    if (response.statusCode == 201) {
      final json = jsonDecode(response.body);
      List<Post> postList = [];
      for (var postData in json) {
        final post = Post(
            content: postData['content'],
            creatorUsername: postData['username'],
            createdDate: postData['createdDate']);
        postList.add(post);
      }
      setState(
        () {
          posts = posts + postList;
        },
      );
    } else {
      handleToast("No posts available");
    }
  }

  Future<void> _scrollListener() async {
    if (isFetchingPosts) return;
    if (scrollController.position.pixels ==
        scrollController.position.maxScrollExtent) {
      setState(() {
        isFetchingPosts = true;
      });
      fetchPage = fetchPage + 1;
      await fetchPosts();
      setState(() {
        isFetchingPosts = false;
      });
    }
  }
}
