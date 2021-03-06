import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/models/user.dart';
import 'package:instagram_clone/pages/comment_page.dart';
import 'package:instagram_clone/providers/user_provider.dart';
import 'package:instagram_clone/resources/firestore_methods.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:instagram_clone/utils/global_variables.dart';
import 'package:instagram_clone/widgets/like_animation.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class PostCard extends StatefulWidget {
  final snap;

  const PostCard({super.key, required this.snap});

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  bool isLikeAnimating = false;

  @override
  Widget build(BuildContext context) {
    User user = Provider.of<UserProvider>(context).getUser;
    final width = MediaQuery.of(context).size.width;
    return Container(
      decoration: BoxDecoration(
          border: Border.all(
              color: width > webScreenSize
                  ? secondaryColor
                  : mobileBackgroundColor),
          color: mobileBackgroundColor),
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(children: [
        Container(
          // color: Colors.red,
          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16)
              .copyWith(right: 0),
          child: Row(children: [
            CircleAvatar(
              radius: 16,
              backgroundImage: NetworkImage(widget.snap['profileImg']),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 8),
                child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.snap['username'],
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      )
                    ]),
              ),
            ),
            IconButton(
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return Dialog(
                          backgroundColor: Colors.grey[900],
                          child: ListView(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shrinkWrap: true,
                              children: [
                                InkWell(
                                  onTap: () async {
                                    Navigator.of(context).pop();
                                    await FirestoreMethods()
                                        .deletePost(widget.snap['postId']);
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10, horizontal: 16),
                                    child: const Text('delete'),
                                  ),
                                )
                              ]),
                        );
                      });
                },
                icon: const Icon(Icons.more_vert))
          ]),
        ),

        //IMAGE SECTION
        GestureDetector(
          onDoubleTap: () async {
            await FirestoreMethods().likePost(
              widget.snap['postId'],
              user.uid,
              widget.snap['likes'],
            );

            setState(() {
              isLikeAnimating = true;
            });
          },
          child: Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.45,
                width: double.infinity,
                child: Image.network(
                  widget.snap['postUrl'],
                  fit: BoxFit.cover,
                ),
              ),
              AnimatedOpacity(
                duration: const Duration(microseconds: 0),
                opacity: isLikeAnimating ? 1 : 0,
                child: LikeAnimation(
                  isAnimating: isLikeAnimating,
                  duration: const Duration(milliseconds: 500),
                  onEnd: () {
                    setState(() {
                      isLikeAnimating = false;
                    });
                  },
                  child: const Icon(
                    Icons.favorite,
                    color: Colors.white,
                    size: 100,
                  ),
                ),
              )
            ],
          ),
        ),

        //LIKE COMMENT SHARE BOOKMARK SECTION
        Row(
          children: [
            LikeAnimation(
                isAnimating: widget.snap['likes'].contains(user.uid),
                smallLike: true,
                child: IconButton(
                    onPressed: () async {
                      await FirestoreMethods().likePost(
                        widget.snap['postId'],
                        user.uid,
                        widget.snap['likes'],
                      );
                    },
                    icon: widget.snap['likes'].length > 0
                        ? const Icon(
                            Icons.favorite,
                            color: Colors.red,
                          )
                        : const Icon(Icons.favorite_border))),
            IconButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => CommentScreen(
                            snap: widget.snap,
                          )));
                },
                icon: const Icon(Icons.comment_outlined)),
            IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.send,
                )),
            Expanded(
                child: Align(
              alignment: Alignment.bottomRight,
              child: IconButton(
                  onPressed: () {}, icon: const Icon(Icons.bookmark_border)),
            ))
          ],
        ),

        //DESCRIPTION AND COMMENTS
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DefaultTextStyle(
                  style: Theme.of(context)
                      .textTheme
                      .subtitle2!
                      .copyWith(fontWeight: FontWeight.bold),
                  child: Text(
                    '${widget.snap['likes'].length} likes',
                    style: Theme.of(context).textTheme.bodyText2,
                  ),
                ),
                Container(
                  // color: Colors.red,
                  width: double.infinity,
                  margin: const EdgeInsets.only(top: 6),
                  child: RichText(
                    text: TextSpan(
                        style: const TextStyle(color: primaryColor),
                        children: [
                          TextSpan(
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                              text: widget.snap['username']),
                          TextSpan(text: " ${widget.snap['description']}")
                        ]),
                  ),
                ),
                StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('posts')
                        .doc(widget.snap['postId'])
                        .collection('comments')
                        .snapshots(),
                    builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      return InkWell(
                        onTap: () {},
                        child: Container(
                          margin: const EdgeInsets.only(top: 6),
                          child: Text(
                            "View all ${snapshot.hasData ? snapshot.data?.docs.length : 0} coments",
                            style: const TextStyle(color: secondaryColor),
                          ),
                        ),
                      );
                    }),
                Container(
                  margin: const EdgeInsets.only(top: 6),
                  child: Text(
                    DateFormat.yMMMd()
                        .format(widget.snap['datePublished'].toDate()),
                    style: const TextStyle(color: secondaryColor),
                  ),
                ),
              ]),
        )
      ]),
    );
  }
}
