import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:instagram/utils/colors.dart';
import 'package:instagram/utils/dimension.dart';
import 'package:instagram/widgets/post_card.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key});

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: width > webScreenSize ? Colors.white : Colors.black,
      appBar: width > webScreenSize
          ? null
          : AppBar(
              elevation: 0,
              backgroundColor: mobileBackgroundColor,
              title: SvgPicture.asset(
                "assets/instagram.svg",
                color: Colors.white,
              ),
              centerTitle: false,
              actions: [
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.messenger_outline_sharp),
                ),
              ],
            ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("posts")
            .orderBy("datePublished", descending: true)
            .snapshots(),
        builder: ((context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.data != null && snapshot.data!.docs.isNotEmpty) {
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                return Container(
                    padding: width > webScreenSize
                        ? const EdgeInsets.only(left: 25.0)
                        : null,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: width > webScreenSize
                            ? Colors.white
                            : mobileBackgroundColor,
                      ),
                      color: width > webScreenSize
                          ? Colors.white
                          : mobileBackgroundColor,
                    ),
                    margin: EdgeInsets.symmetric(
                      horizontal: width > webScreenSize ? width * 0.1 : 0,
                      vertical: width > webScreenSize ? 10 : 0,
                    ),
                    child: PostCard(snap: snapshot.data!.docs[index]));
              },
            );
          } else {
            return Center(
              child: Text("There are not post yet",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: width > webScreenSize ? Colors.black : Colors.white,
                  )),
            );
          }
        }),
      ),
    );
  }
}
