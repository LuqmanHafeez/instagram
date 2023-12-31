import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:instagram/resources/auth.dart';
import 'package:instagram/resources/firestore_methods.dart';
import 'package:instagram/resources/storage.dart';
import 'package:instagram/screens/full_screen.dart';
import 'package:instagram/screens/login_screen.dart';
import 'package:instagram/utils/colors.dart';
import 'package:instagram/utils/dimension.dart';
import 'package:instagram/widgets/follow_button.dart';

class ProfileScreen extends StatefulWidget {
  final String uid;
  const ProfileScreen({super.key, required this.uid});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  var userMap = {};
  var postMap;
  bool isLoading = true;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  getData() async {
    debugPrint("uid : " + widget.uid.toString());
    try {
      var userData = await FirebaseFirestore.instance
          .collection("users")
          .doc(widget.uid)
          .get();
      userMap = userData.data()!;
      var postData = await FirebaseFirestore.instance
          .collection("posts")
          .where("uid", isEqualTo: widget.uid)
          .get();
      postMap = postData.docs;
      setState(() {
        debugPrint(postMap.toString());
        isLoading = false;
      });
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return isLoading
        ? const Center(child: CircularProgressIndicator())
        : Scaffold(
            backgroundColor:
                width > webScreenSize ? Colors.white : mobileBackgroundColor,
            appBar: AppBar(
              elevation: 0,
              backgroundColor:
                  width > webScreenSize ? Colors.white : mobileBackgroundColor,
              title: Text(
                userMap["userName"],
                style: TextStyle(
                    color: width > webScreenSize ? Colors.black : Colors.white,
                    //fontWeight: FontWeight.w600
                    fontSize: 15.0),
              ),
              centerTitle: false,
            ),
            body: Container(
              margin: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        radius: 40.0,
                        backgroundImage: NetworkImage(userMap["photoUrl"]),
                      ),
                      Expanded(
                        //flex: 1,
                        child: Column(
                          children: [
                            Row(
                              //mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                buildColumnState(
                                    postMap.length, "posts", width),
                                buildColumnState(userMap["followers"].length,
                                    "followers", width),
                                buildColumnState(userMap["following"].length,
                                    "following", width),
                              ],
                            ),
                            const SizedBox(height: 8.0),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                FirebaseAuth.instance.currentUser!.uid ==
                                        widget.uid
                                    ? FollowButton(
                                        textColor: width > webScreenSize
                                            ? Colors.white
                                            : Colors.blue,
                                        text: "Sign Out",
                                        color: width > webScreenSize
                                            ? Colors.blue
                                            : Colors.grey,
                                        backGroundColor: width > webScreenSize
                                            ? Colors.blue
                                            : mobileBackgroundColor,
                                        function: () async {
                                          await AuthMethod().signOut();
                                          Navigator.of(context).pushReplacement(
                                              MaterialPageRoute(
                                                  builder: (context) {
                                            return const LoginScreen();
                                          }));
                                        },
                                      )
                                    : userMap["followers"].contains(FirebaseAuth
                                            .instance.currentUser!.uid)
                                        ? FollowButton(
                                            textColor: width > webScreenSize
                                                ? Colors.white
                                                : Colors.blue,
                                            text: "Un follow",
                                            color: Colors.blue,
                                            backGroundColor:
                                                width > webScreenSize
                                                    ? Colors.blue
                                                    : mobileBackgroundColor,
                                            function: () async {
                                              // setState(() {
                                              //   isLoading = true;
                                              // });
                                              await FirestoreMethods()
                                                  .followUser(
                                                currentUserUid: FirebaseAuth
                                                    .instance.currentUser!.uid,
                                                followId: widget.uid,
                                                followers: true,
                                              );
                                              var followers =
                                                  userMap["followers"];
                                              followers.remove(FirebaseAuth
                                                  .instance.currentUser!.uid);
                                              userMap["followers"] = followers;
                                              setState(() {});
                                            },
                                          )
                                        : FollowButton(
                                            textColor: width > webScreenSize
                                                ? Colors.white
                                                : Colors.blue,
                                            text: "Follow",
                                            color: Colors.blue,
                                            backGroundColor:
                                                width > webScreenSize
                                                    ? Colors.blue
                                                    : mobileBackgroundColor,
                                            function: () async {
                                              // setState(() {
                                              //   isLoading = true;
                                              // });

                                              await FirestoreMethods()
                                                  .followUser(
                                                      currentUserUid:
                                                          FirebaseAuth.instance
                                                              .currentUser!.uid,
                                                      followId: widget.uid,
                                                      followers: false);

                                              var followList =
                                                  userMap["followers"];
                                              followList.add(FirebaseAuth
                                                  .instance.currentUser!.uid);
                                              userMap["followers"] = followList;
                                              setState(() {});
                                            },
                                          )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16.0),
                  Text(
                    userMap["userName"],
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    userMap["bio"],
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4.0),
                  Divider(
                    color: width > webScreenSize ? Colors.black : null,
                  ),
                  FutureBuilder(
                      future: FirebaseFirestore.instance
                          .collection("posts")
                          .where("uid", isEqualTo: widget.uid)
                          .get(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        }
                        return Expanded(
                          child: GridView.builder(
                            shrinkWrap: true,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              crossAxisSpacing: 5,
                              mainAxisSpacing: 1.5,
                              childAspectRatio: 1,
                            ),
                            itemCount: snapshot.data!.docs.length,
                            itemBuilder: (context, index) {
                              return InkWell(
                                onTap: () {
                                  Navigator.of(context).push(
                                      MaterialPageRoute(builder: (context) {
                                    return FullImage(
                                      imageUrl: snapshot.data!.docs[index]
                                          ["postUrl"],
                                    );
                                  }));
                                },
                                child: Image.network(
                                  snapshot.data!.docs[index]["postUrl"],
                                  fit: BoxFit.cover,
                                ),
                              );
                            },
                          ),
                        );
                      })
                ],
              ),
            ),
          );
  }

  Column buildColumnState(int num, String text, final width) {
    return Column(
      children: [
        Text(
          num.toString(),
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20.0,
            color: width > webScreenSize ? Colors.black : Colors.grey,
          ),
        ),
        const SizedBox(height: 5.0),
        Text(
          text,
          style: TextStyle(
            color: width > webScreenSize ? Colors.black : Colors.grey,
          ),
        ),
      ],
    );
  }
}
