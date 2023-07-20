import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instagram/models/user.dart';
import 'package:instagram/providers/user_provider.dart';
import 'package:instagram/resources/firestore_methods.dart';
import 'package:instagram/screens/comment_screen.dart';
import 'package:instagram/screens/full_screen.dart';
import 'package:instagram/utils/colors.dart';
import 'package:instagram/utils/dimension.dart';
import 'package:instagram/widgets/comment_card.dart';
import 'package:instagram/widgets/like_animation.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class PostCard extends StatefulWidget {
  final QueryDocumentSnapshot snap;
  const PostCard({super.key, required this.snap});

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  bool isLikeAnimating = false;
  QuerySnapshot? commentData;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCommentData();
  }

  getCommentData() async {
    commentData = await FirebaseFirestore.instance
        .collection("posts")
        .doc(widget.snap["postId"])
        .collection("comments")
        .get();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    User? user = Provider.of<UserProvider>(context).getUser;

    if (user == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return Center(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: CircleAvatar(
                    backgroundImage: NetworkImage(widget.snap["profileImage"]),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Text(
                    widget.snap["userName"],
                    style: TextStyle(
                        color: width > webScreenSize ? Colors.black : null),
                  ),
                ),
                Expanded(
                  child: Container(
                    alignment: Alignment.bottomRight,
                    child: IconButton(
                      icon: const Icon(Icons.more_vert),
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return Dialog(
                                  child: ListView(
                                shrinkWrap: true,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16.0),
                                children: [
                                  "Delete",
                                ].map((e) {
                                  return InkWell(
                                    onTap: () async {
                                      if (widget.snap["uid"] == user.uid) {
                                        Navigator.of(context).pop();
                                        await FirestoreMethods()
                                            .deletePost(widget.snap["postId"]);
                                      } else {
                                        Navigator.of(context).pop();
                                      }
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 12.0, horizontal: 16.0),
                                      child: Text(e),
                                    ),
                                  );
                                }).toList(),
                              ));
                            });
                      },
                    ),
                  ),
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
              child: GestureDetector(
                onDoubleTap: () async {
                  await FirestoreMethods().likes(
                    widget.snap["postId"],
                    user.uid,
                    widget.snap["likes"],
                  );
                  setState(() {
                    isLikeAnimating = true;
                  });
                },
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.of(context)
                            .push(MaterialPageRoute(builder: (context) {
                          return FullImage(imageUrl: widget.snap["postUrl"]);
                        }));
                      },
                      child: SizedBox(
                        width: double.infinity,
                        //height: 300.0,
                        child: Image.network(
                          widget.snap["postUrl"],
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    AnimatedOpacity(
                      duration: const Duration(milliseconds: 200),
                      opacity: isLikeAnimating ? 1 : 0,
                      child: LikeAnimation(
                        duration: const Duration(milliseconds: 400),
                        isAnimating: isLikeAnimating,
                        child: const Icon(
                          Icons.favorite,
                          size: 100.0,
                        ),
                        onEnd: () {
                          setState(() {
                            isLikeAnimating = false;
                          });
                        },
                      ),
                    )
                  ],
                ),
              ),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                LikeAnimation(
                  isAnimating: widget.snap["likes"].contains(user.uid),
                  smallLike: true,
                  child: IconButton(
                    //padding: const EdgeInsets.only(left: 0),
                    onPressed: () async {
                      await FirestoreMethods().likes(widget.snap["postId"],
                          user.uid, widget.snap["likes"]);
                    },
                    icon: widget.snap["likes"].contains(user.uid)
                        ? const Icon(Icons.favorite, color: Colors.red)
                        : Icon(
                            Icons.favorite_border,
                            color: width > webScreenSize
                                ? Colors.black
                                : Colors.white,
                          ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (context) {
                      return CommentScreen(
                        snap: widget.snap,
                        uid: user.uid,
                        profilePhoto: user.photoUrl,
                        userName: user.userName,
                      );
                    }));
                  },
                  icon: Icon(
                    Icons.comment_outlined,
                    color: width > webScreenSize ? Colors.black : Colors.white,
                  ),
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.send_outlined,
                  ),
                ),
                Expanded(
                  child: Container(
                    //padding: const EdgeInsets.only(left: 8.0),
                    alignment: Alignment.bottomRight,
                    child: IconButton(
                        onPressed: () {},
                        icon: Icon(
                          Icons.bookmark_border,
                          color: width > webScreenSize
                              ? Colors.black
                              : Colors.white,
                        )),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 3.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${widget.snap["likes"].length} likes",
                    style: width < webScreenSize
                        ? Theme.of(context).textTheme.bodyMedium
                        : TextStyle(
                            color: width > webScreenSize ? Colors.black : null),
                  ),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text.rich(
                      TextSpan(children: [
                        TextSpan(
                          text: "${widget.snap["userName"]}  ",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color:
                                  width > webScreenSize ? Colors.black : null),
                        ),
                        TextSpan(
                          text: widget.snap["description"],
                          style: TextStyle(
                              color:
                                  width > webScreenSize ? Colors.black : null),
                        ),
                      ]),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: InkWell(
                      onTap: () {
                        Navigator.of(context)
                            .push(MaterialPageRoute(builder: (context) {
                          return CommentScreen(
                            uid: user.uid,
                            userName: user.userName,
                            profilePhoto: user.photoUrl,
                            snap: widget.snap,
                          );
                        }));
                      },
                      child: Text(
                        "View all ${commentData?.docs.length ?? 0}",
                        style: TextStyle(
                            color: width > webScreenSize
                                ? Colors.black
                                : secondaryColor),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      DateFormat.yMMMd().format(
                        widget.snap["datePublished"].toDate(),
                      ),
                      style: TextStyle(
                          color: width > webScreenSize
                              ? Colors.black
                              : secondaryColor),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
