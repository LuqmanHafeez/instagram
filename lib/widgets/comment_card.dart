import 'package:flutter/material.dart';
import 'package:instagram/models/user.dart';
import 'package:instagram/providers/user_provider.dart';
import 'package:instagram/resources/firestore_methods.dart';
import 'package:instagram/widgets/like_animation.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class CommentCard extends StatefulWidget {
  final commentData;
  final snap;
  const CommentCard({super.key, required this.commentData, required this.snap});

  @override
  State<CommentCard> createState() => _CommentCardState();
}

class _CommentCardState extends State<CommentCard> {
  @override
  Widget build(BuildContext context) {
    User? user = Provider.of<UserProvider>(context).getUser;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleAvatar(
            backgroundImage: NetworkImage(widget.commentData["photoUrl"]),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    child: RichText(
                      maxLines: 4,
                      overflow: TextOverflow.ellipsis,
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: "${widget.commentData["userName"]} ",
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                          TextSpan(
                            text: widget.commentData["comment"],
                            style: const TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 4.0),
                    child: Text(DateFormat.yMMMd()
                        .format(widget.commentData["datePublished"].toDate())),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
              child: LikeAnimation(
            isAnimating: widget.commentData["likes"].contains(user!.uid),
            smallLike: true,
            child: IconButton(
                onPressed: () async {
                  await FirestoreMethods().commentLikes(
                      postId: widget.snap["postId"],
                      commentId: widget.commentData["commentId"],
                      likes: widget.commentData["likes"],
                      uid: user.uid);
                },
                icon: widget.commentData["likes"].contains(user!.uid)
                    ? const Icon(
                        Icons.favorite,
                        color: Colors.red,
                      )
                    : const Icon(Icons.favorite_border)),
          ))
        ],
      ),
    );
  }
}
