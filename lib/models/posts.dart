// ignore_for_file: public_member_api_docs, sort_constructors_first
class Post {
  final String description;
  final String uid;
  final String postId;
  final String username;
  final DateTime datePublished;
  final String postUrl;
  final String profileImg;
  final List likes;

  Post(
      {required this.description,
      required this.uid,
      required this.postId,
      required this.username,
      required this.datePublished,
      required this.likes,
      required this.profileImg,
      required this.postUrl});

  Map<String, dynamic> toJson() => {
        "username": username,
        "uid": uid,
        "description": description,
        "postId": postId,
        "datePublished": datePublished,
        "likes": likes,
        "profileImg": profileImg,
        'postUrl': postUrl
      };
}
