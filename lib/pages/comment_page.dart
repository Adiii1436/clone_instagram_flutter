import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/models/user.dart';
import 'package:instagram_clone/resources/firestore_methods.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:provider/provider.dart';

import '../providers/user_provider.dart';
import '../widgets/comment_card.dart';

class CommentScreen extends StatefulWidget {
  final snap;

  const CommentScreen({super.key, required this.snap});

  @override
  State<CommentScreen> createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  final TextEditingController _commentController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _commentController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    User user = Provider.of<UserProvider>(context).getUser;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Comments"),
        backgroundColor: mobileBackgroundColor,
      ),
      body: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.07,
            child: Row(children: [
              Padding(
                padding: const EdgeInsets.only(left: 17),
                child: CircleAvatar(
                  backgroundImage: NetworkImage(widget.snap['profileImg']),
                  radius: 20,
                ),
              ),
              Padding(
                  padding: const EdgeInsets.only(left: 16),
                  child: Text(
                    widget.snap['description'],
                  ))
            ]),
          ),
          const Divider(),
          Expanded(
            child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('posts')
                    .doc(widget.snap['postId'])
                    .collection('comments')
                    .orderBy('datePublished', descending: true)
                    .snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  return ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: ((context, index) {
                        return CommentCard(
                          snap: snapshot.data!.docs[index].data(),
                        );
                      }));
                }),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
          child: Container(
        // color: Colors.red,
        height: kToolbarHeight,
        margin:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        padding: const EdgeInsets.only(left: 16, right: 16, bottom: 20),
        child: Row(children: [
          CircleAvatar(
            backgroundImage: NetworkImage(user.photoUrl),
            radius: 20,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 16, right: 8),
              child: TextField(
                controller: _commentController,
                decoration: InputDecoration(
                    hintText: "Comment as ${user.username}",
                    border: InputBorder.none),
              ),
            ),
          ),
          InkWell(
            onTap: () async {
              await FirestoreMethods().postComments(
                  widget.snap['postId'],
                  _commentController.text,
                  user.uid,
                  user.username,
                  user.photoUrl);

              setState(() {
                _commentController.text = '';
              });
            },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
              child: const Text(
                "Post",
                style: TextStyle(color: blueColor, fontWeight: FontWeight.bold),
              ),
            ),
          )
        ]),
      )),
    );
  }
}
