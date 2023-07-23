import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:instagram/screens/full_screen.dart';
import 'package:instagram/screens/profile_screen.dart';
import 'package:instagram/utils/colors.dart';
import 'package:instagram/utils/dimension.dart';
import 'package:instagram/utils/utils.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController searchController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool userRecordViewActive = false;
  bool isLoading = true;

  QuerySnapshot<Map<String, dynamic>>? userRecordSnaphsot;
  QuerySnapshot<Map<String, dynamic>>? postRecordSnaphsot;

  @override
  void initState() {
    loadPostsData();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    searchController.dispose();
  }

  loadUsersData() async {
    setState(() {
      isLoading = true;
    });
    userRecordSnaphsot = await FirebaseFirestore.instance
        .collection("users")
        .where("userName", isGreaterThanOrEqualTo: searchController.text)
        .get();

    userRecordViewActive = true;
    isLoading = false;
    setState(() {});
  }

  loadPostsData() async {
    postRecordSnaphsot = await FirebaseFirestore.instance
        .collection("posts")
        .orderBy("datePublished", descending: true)
        .get();

    userRecordViewActive = false;
    isLoading = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return SafeArea(
        child: Form(
            key: _formKey,
            child: Scaffold(
                backgroundColor: width > webScreenSize
                    ? Colors.white
                    : mobileBackgroundColor,
                appBar: AppBar(
                  backgroundColor: width > webScreenSize
                      ? Colors.white
                      : mobileBackgroundColor,
                  elevation: 0,
                  title: Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: TextFormField(
                      style: TextStyle(
                        color: width > webScreenSize ? Colors.black : null,
                      ),
                      controller: searchController,
                      decoration: InputDecoration(
                        labelText: "Search for a user",
                        labelStyle: TextStyle(
                          color: width > webScreenSize ? Colors.black : null,
                        ),
                        border: const OutlineInputBorder(
                            borderSide: BorderSide.none),
                      ),
                      onFieldSubmitted: (String value) {
                        loadUsersData();
                      },
                    ),
                  ),
                ),
                body: isLoading
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : userRecordViewActive
                        ? ListView.builder(
                            itemCount: userRecordSnaphsot!.docs.length,
                            itemBuilder: (context, index) {
                              final userRecord =
                                  userRecordSnaphsot!.docs[index].data();
                              return InkWell(
                                onTap: () {
                                  // searchController.clear();
                                  // setState(() {
                                  //   isShowUser = false;
                                  // });
                                  Navigator.of(context).push(
                                      MaterialPageRoute(builder: (context) {
                                    return ProfileScreen(
                                        uid: userRecord["uid"]);
                                  }));
                                },
                                child: ListTile(
                                  leading: CircleAvatar(
                                    backgroundImage: NetworkImage(
                                      userRecord["photoUrl"] ?? dumyProfileUrl,
                                    ),
                                  ),
                                  title: Text(
                                    userRecord["userName"],
                                    style: TextStyle(
                                      color: width > webScreenSize
                                          ? Colors.black
                                          : Colors.white,
                                    ),
                                  ),
                                ),
                              );
                            },
                          )
                        : MasonryGridView.builder(
                            //mainAxisSpacing: 8.0,
                            //crossAxisSpacing: 8.0,
                            itemCount: postRecordSnaphsot!.docs.length,
                            gridDelegate:
                                const SliverSimpleGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                            ),
                            itemBuilder: (builder, index) {
                              final postRecord =
                                  postRecordSnaphsot!.docs[index].data();
                              return InkWell(
                                onTap: () {
                                  Navigator.of(context).push(
                                      MaterialPageRoute(builder: (context) {
                                    return FullImage(
                                      imageUrl: postRecord[index]["postUrl"],
                                    );
                                  }));
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Image.network(
                                    postRecord["postUrl"],
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              );
                            },
                          ))));
  }
}
