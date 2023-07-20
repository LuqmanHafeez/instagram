import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:instagram/screens/full_screen.dart';
import 'package:instagram/screens/profile_screen.dart';
import 'package:instagram/utils/colors.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController searchController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool isShowUser = false;
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Form(
        key: _formKey,
        child: Scaffold(
            appBar: AppBar(
              backgroundColor: mobileBackgroundColor,
              elevation: 0,
              title: Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: TextFormField(
                  controller: searchController,
                  decoration: const InputDecoration(
                    labelText: "Search for a user",
                    // hintText: "Search for a user",
                    border: OutlineInputBorder(borderSide: BorderSide.none),
                  ),
                  onFieldSubmitted: (String value) {
                    setState(() {
                      isShowUser = true;
                    });
                  },
                ),
              ),
            ),
            body: isShowUser
                ? FutureBuilder(
                    future: FirebaseFirestore.instance
                        .collection("users")
                        .where("userName",
                            isGreaterThanOrEqualTo: searchController.text)
                        .get(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      return ListView.builder(
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () {
                              // searchController.clear();
                              // setState(() {
                              //   isShowUser = false;
                              // });
                              Navigator.of(context)
                                  .push(MaterialPageRoute(builder: (context) {
                                return ProfileScreen(
                                    uid: snapshot.data!.docs[index]["uid"]);
                              }));
                            },
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundImage: NetworkImage(
                                  snapshot.data!.docs[index]["photoUrl"],
                                ),
                              ),
                              title: Text(
                                snapshot.data!.docs[index]["userName"],
                              ),
                            ),
                          );
                        },
                      );
                    })
                : FutureBuilder(
                    future: FirebaseFirestore.instance
                        .collection("posts")
                        .orderBy("datePublished", descending: true)
                        .get(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      return MasonryGridView.builder(
                        //mainAxisSpacing: 8.0,
                        //crossAxisSpacing: 8.0,
                        itemCount: snapshot.data!.docs.length,
                        gridDelegate:
                            const SliverSimpleGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                        ),
                        itemBuilder: (builder, index) {
                          return InkWell(
                            onTap: () {
                              Navigator.of(context)
                                  .push(MaterialPageRoute(builder: (context) {
                                return FullImage(
                                  imageUrl: snapshot.data!.docs[index]
                                      ["postUrl"],
                                );
                              }));
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Image.network(
                                snapshot.data!.docs[index]["postUrl"],
                                fit: BoxFit.cover,
                              ),
                            ),
                          );
                        },
                      );
                    })),
      ),
    );
  }
}
