import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_clone/models/user.dart' as model;
import 'package:instagram_clone/providers/user_provider.dart';
import 'package:instagram_clone/resources/firestore_methods.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:instagram_clone/utils/utils.dart';
import 'package:provider/provider.dart';

class AddPostPage extends StatefulWidget {
  const AddPostPage({Key? key}) : super(key: key);

  @override
  State<AddPostPage> createState() => _AddPostPageState();
}

class _AddPostPageState extends State<AddPostPage> {
  Uint8List? _file;
  TextEditingController _descriptionController = TextEditingController();
  String res = '';
  bool _isLoading = false;

  _selectImage(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: const Text(
              "Create a Post 😎",
              style: TextStyle(fontSize: 22),
            ),
            backgroundColor: Colors.grey[900],
            children: [
              SimpleDialogOption(
                padding: const EdgeInsets.only(left: 25, bottom: 12, top: 12),
                child: const Text(
                  "Take a photo 📸",
                  style: TextStyle(fontSize: 15),
                ),
                onPressed: () async {
                  Navigator.of(context).pop();
                  try {
                    Uint8List file = await pickImage(ImageSource.camera);
                    setState(() {
                      _file = file;
                    });
                  } catch (e) {
                    _snackBar("Please select an image");
                  }
                },
              ),
              SimpleDialogOption(
                padding: const EdgeInsets.only(left: 25, bottom: 12, top: 12),
                child: const Text(
                  "Choose from gallery 💾",
                  style: TextStyle(fontSize: 15),
                ),
                onPressed: () async {
                  Navigator.of(context).pop();
                  try {
                    Uint8List file = await pickImage(ImageSource.gallery);
                    setState(() {
                      _file = file;
                    });
                  } catch (e) {
                    _snackBar("Please select an image");
                  }
                },
              ),
              SimpleDialogOption(
                padding: const EdgeInsets.only(left: 25, bottom: 12, top: 12),
                child: const Text(
                  "Cancel",
                  style: TextStyle(fontSize: 15),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

  void _snackBar(String content) {
    showSnackBar(context, content);
  }

  postImage(String uid, String username, String profileImage) async {
    setState(() {
      _isLoading = true;
    });
    try {
      res = await FirestoreMethods().uploadPost(
          _descriptionController.text, _file!, uid, username, profileImage);

      if (res == 'success') {
        setState(() {
          _isLoading = false;
        });
        _snackBar("Posted");
        _clearImage();
      } else {
        setState(() {
          _isLoading = false;
        });
        _snackBar(res);
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      _snackBar(res);
    }
  }

  _clearImage() {
    setState(() {
      _file = null;
    });
  }

  @override
  void initState() {
    super.initState();
    _descriptionController = TextEditingController(text: "");
  }

  @override
  void dispose() {
    super.dispose();
    _descriptionController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final model.User user = Provider.of<UserProvider>(context).getUser;
    return _file == null
        ? Center(
            child: IconButton(
              icon: const Icon(
                Icons.upload,
                size: 35,
              ),
              onPressed: () {
                _selectImage(context);
              },
            ),
          )
        : Scaffold(
            appBar: AppBar(
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  _clearImage();
                },
              ),
              backgroundColor: mobileBackgroundColor,
              title: const Text("Post to"),
              actions: [
                TextButton(
                    onPressed: () async {
                      await postImage(user.uid, user.username, user.photoUrl);
                    },
                    child: const Text(
                      "Post",
                      style: TextStyle(
                          color: Colors.blueAccent,
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
                    ))
              ],
            ),
            body: Column(mainAxisSize: MainAxisSize.min, children: [
              _isLoading
                  ? const LinearProgressIndicator()
                  : const Padding(padding: EdgeInsets.only(top: 0)),
              const Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 21,
                    backgroundImage: NetworkImage(user.photoUrl),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.5,
                    child: TextField(
                      controller: _descriptionController,
                      decoration: const InputDecoration(
                          hintText: "Write a caption..",
                          border: InputBorder.none),
                      maxLines: 3,
                    ),
                  ),
                  SizedBox(
                    height: 40,
                    width: 55,
                    child: AspectRatio(
                      aspectRatio: 487 / 451,
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            image: DecorationImage(
                                fit: BoxFit.fill,
                                alignment: FractionalOffset.topCenter,
                                image: MemoryImage(_file!))),
                      ),
                    ),
                  ),
                ],
              )
            ]),
          );
  }
}
