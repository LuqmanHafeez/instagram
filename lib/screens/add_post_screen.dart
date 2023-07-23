import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram/models/user.dart';
import 'package:instagram/providers/user_provider.dart';
import 'package:instagram/resources/firestore_methods.dart';
import 'package:instagram/utils/colors.dart';
import 'package:instagram/utils/dimension.dart';
import 'package:instagram/utils/utils.dart';
import 'package:provider/provider.dart';

class AddPost extends StatefulWidget {
  const AddPost({super.key});

  @override
  State<AddPost> createState() => _AddPostState();
}

class _AddPostState extends State<AddPost> {
  TextEditingController captionController = TextEditingController();
  Uint8List? _file;
  bool _isLoading = false;
  selectImage(BuildContext context) async {
    showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: const Text("Select Image"),
            children: [
              SimpleDialogOption(
                child: const Text("Take a photo"),
                onPressed: () async {
                  Navigator.of(context).pop();
                  Uint8List file = await pickImage(ImageSource.camera);
                  setState(() {
                    _file = file;
                  });
                },
              ),
              SimpleDialogOption(
                child: const Text("Select from gallery"),
                onPressed: () async {
                  Navigator.of(context).pop();
                  Uint8List file = await pickImage(ImageSource.gallery);
                  setState(() {
                    _file = file;
                  });
                },
              ),
              SimpleDialogOption(
                child: const Text("Cancel"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

  storePost({
    required String userName,
    required String uid,
    required String photoUrl,
    required String description,
  }) async {
    setState(() {
      _isLoading = true;
    });
    try {
      String res = await FirestoreMethods().uploadPost(
          childName: "Posts",
          file: _file!,
          ispost: true,
          userName: userName,
          description: description,
          uid: uid,
          photoUrl: photoUrl);
      if (res == "Success") {
        setState(() {
          _isLoading = false;
        });
        showSnackBar(context, "Posted");
        clearImage();
      } else {
        showSnackBar(context, "Some Problem");
      }
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  clearImage() {
    setState(() {
      _file = null;
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    captionController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final User? user = Provider.of<UserProvider>(context).getUser;
    return _file == null
        ? Center(
            child: IconButton(
              icon: Icon(Icons.upload,
                  color: width > webScreenSize ? Colors.black : Colors.white),
              onPressed: () {
                selectImage(context);
              },
            ),
          )
        : SafeArea(
            child: Scaffold(
              backgroundColor:
                  width > webScreenSize ? Colors.white : mobileBackgroundColor,
              appBar: AppBar(
                elevation: 0,
                backgroundColor: width > webScreenSize
                    ? Colors.white
                    : mobileBackgroundColor,
                leading: IconButton(
                  icon: Icon(
                    Icons.arrow_back,
                    color: width > webScreenSize ? Colors.black : null,
                  ),
                  onPressed: () {
                    clearImage();
                  },
                ),
                title: Text(
                  "Add Post",
                  style: TextStyle(
                    color: width > webScreenSize ? Colors.black : Colors.white,
                  ),
                ),
                centerTitle: false,
                actions: [
                  TextButton(
                      onPressed: () {
                        storePost(
                          userName: user!.userName,
                          uid: user.uid,
                          photoUrl: user.photoUrl,
                          description: captionController.text,
                        );
                      },
                      child: const Text("Post"))
                ],
              ),
              body: Column(
                children: [
                  _isLoading
                      ? const LinearProgressIndicator()
                      : const Padding(padding: EdgeInsets.only(top: 0)),
                  Divider(
                    color: width > webScreenSize ? Colors.black : null,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        backgroundImage: NetworkImage(user!.photoUrl),
                      ),
                      SizedBox(
                        width: width > webScreenSize
                            ? MediaQuery.of(context).size.width * 0.35
                            : MediaQuery.of(context).size.width * 0.45,
                        child: TextField(
                          style: TextStyle(
                            color: width > webScreenSize ? Colors.black : null,
                          ),
                          controller: captionController,
                          decoration: InputDecoration(
                              hintText: "Write a caption...",
                              hintStyle: TextStyle(
                                color:
                                    width > webScreenSize ? Colors.black : null,
                              ),
                              border: InputBorder.none),
                          maxLines: 8,
                        ),
                      ),
                      SizedBox(
                        height: 45.0,
                        width: 45.0,
                        child: AspectRatio(
                          aspectRatio: 487 / 451,
                          child: Container(
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                fit: BoxFit.fill,
                                image: MemoryImage(_file!),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const Divider(),
                    ],
                  )
                ],
              ),
            ),
          );
  }
}
