import 'package:flutter/material.dart';
import 'package:instagram_clone/pages/add_post_page.dart';

import 'package:instagram_clone/pages/feed_page.dart';

const webScreenSize = 600;
var homeScreenItems = [
  const FeedScreen(),
  const Center(child: Text("2")),
  const AddPostPage(),
  const Center(child: Text("4")),
  const Center(child: Text("5")),
];
