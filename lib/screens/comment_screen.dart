import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instagram/resources/firestore_methods.dart';
import 'package:instagram/utils/colors.dart';
import 'package:instagram/widgets/comment_card.dart';

class CommentScreen extends StatefulWidget {
  final snap;
  final uid;
  final userName;
  final profilePhoto;
  const CommentScreen(
      {super.key, this.snap, this.uid, this.userName, this.profilePhoto});

  @override
  State<CommentScreen> createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  TextEditingController commentController = TextEditingController();
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    commentController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: mobileBackgroundColor,
        appBar: AppBar(
          backgroundColor: mobileBackgroundColor,
          title: const Text("Comments"),
          centerTitle: false,
        ),
        body: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection("posts")
                .doc(widget.snap["postId"])
                .collection("comments")
                .orderBy("datePublished", descending: true)
                .snapshots(),
            builder: (context,
                AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    return CommentCard(
                      commentData: snapshot.data!.docs[index],
                      snap: widget.snap,
                    );
                  });
            }),
        bottomNavigationBar: Row(
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(widget.snap["profileImage"]),
              radius: 18.0,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: TextField(
                  controller: commentController,
                  decoration: const InputDecoration(
                    hintText: "Comment as username",
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
              child: InkWell(
                onTap: () {
                  FirestoreMethods().comments(
                      comment: commentController.text,
                      postId: widget.snap["postId"],
                      uid: widget.uid,
                      userName: widget.userName,
                      photoUrl: widget.profilePhoto);
                  setState(() {
                    commentController.clear();
                  });
                },
                child: const Text(
                  "Post",
                  style: TextStyle(color: blueColor),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
