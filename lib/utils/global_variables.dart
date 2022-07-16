import 'package:flutter/material.dart';
import 'package:instagram_clone/pages/add_post_page.dart';

import 'package:instagram_clone/pages/feed_page.dart';
import 'package:instagram_clone/pages/profile_page.dart';
import 'package:instagram_clone/pages/search_page.dart';

const webScreenSize = 600;
var homeScreenItems = [
  const FeedScreen(),
  const SearchScreen(),
  const AddPostPage(),
  const Center(child: Text("4")),
  const ProfilePage()
];
