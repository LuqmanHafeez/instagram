import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:instagram/providers/user_provider.dart';
import 'package:instagram/responsive/mobile_layout_screen.dart';
import 'package:instagram/responsive/responsive_layout_screen.dart';
import 'package:instagram/responsive/web_layout_screen.dart';
import 'package:instagram/screens/login_screen.dart';
import 'package:instagram/utils/colors.dart';
import 'package:provider/provider.dart';

void main() async {
  if (!kIsWeb) {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
  } else {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(
        options: const FirebaseOptions(
            apiKey: "AIzaSyAQNp5FM2tHLqX_it6vWIx-BnxN-08ugFI",
            authDomain: "instagram-clone-94986.firebaseapp.com",
            projectId: "instagram-clone-94986",
            storageBucket: "instagram-clone-94986.appspot.com",
            messagingSenderId: "190501827489",
            appId: "1:190501827489:web:03ef05a2ff93f0701bd1e0"));
  }
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) {
        return UserProvider();
      })
    ],
    child: MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark()
          .copyWith(scaffoldBackgroundColor: mobileBackgroundColor),
      // home: const ResponsiveLayout(
      //   mobileScreenLayout: MobileScreenLayout(),
      //   webScreenLayout: WebScreenLayout(),
      // ),
      home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.active) {
              if (snapshot.hasData) {
                return const ResponsiveLayout(
                    webScreenLayout: WebScreenLayout(),
                    mobileScreenLayout: MobileScreenLayout());
              } else if (snapshot.hasError) {
                return Center(
                  child: Text(snapshot.error.toString()),
                );
              }
            } else if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(
                  color: primaryColor,
                ),
              );
            }
            return const LoginScreen();
          }),
    ),
  ));
}

// import 'package:easy_sidemenu/easy_sidemenu.dart';
// import 'package:flutter/material.dart';

// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'easy_sidemenu Demo',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: const MyHomePage(title: 'easy_sidemenu Demo'),
//       debugShowCheckedModeBanner: false,
//     );
//   }
// }

// class MyHomePage extends StatefulWidget {
//   const MyHomePage({Key? key, required this.title}) : super(key: key);

//   final String title;

//   @override
//   _MyHomePageState createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   PageController pageController = PageController();
//   SideMenuController sideMenu = SideMenuController();

//   @override
//   void initState() {
//     sideMenu.addListener((index) {
//       pageController.jumpToPage(index);
//     });
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.title),
//         centerTitle: true,
//       ),
//       body: Row(
//         mainAxisAlignment: MainAxisAlignment.start,
//         children: [
//           SideMenu(
//             controller: sideMenu,
//             style: SideMenuStyle(
//               // showTooltip: false,
//               displayMode: SideMenuDisplayMode.auto,
//               hoverColor: Colors.blue[100],
//               selectedHoverColor: Color.alphaBlend(
//                   Color.fromRGBO(
//                       Theme.of(context).colorScheme.surfaceTint.red,
//                       Theme.of(context).colorScheme.surfaceTint.green,
//                       Theme.of(context).colorScheme.surfaceTint.blue,
//                       0.08),
//                   Colors.blue[100]!),
//               selectedColor: Colors.lightBlue,
//               selectedTitleTextStyle: const TextStyle(color: Colors.white),
//               selectedIconColor: Colors.white,
//               // decoration: BoxDecoration(
//               //   borderRadius: BorderRadius.all(Radius.circular(10)),
//               // ),
//               // backgroundColor: Colors.blueGrey[700]
//             ),
//             title: Column(
//               children: [
//                 ConstrainedBox(
//                   constraints: const BoxConstraints(
//                     maxHeight: 150,
//                     maxWidth: 150,
//                   ),
//                   child: Image.asset(
//                     'assets/images/easy_sidemenu.png',
//                   ),
//                 ),
//                 const Divider(
//                   indent: 8.0,
//                   endIndent: 8.0,
//                 ),
//               ],
//             ),
//             footer: const Padding(
//               padding: EdgeInsets.all(8.0),
//               child: Text(
//                 'mohada',
//                 style: TextStyle(fontSize: 15),
//               ),
//             ),
//             items: [
//               SideMenuItem(
//                 priority: 0,
//                 title: 'Dashboard',
//                 onTap: (index, _) {
//                   sideMenu.changePage(index);
//                 },
//                 icon: const Icon(Icons.home),
//                 badgeContent: const Text(
//                   '3',
//                   style: TextStyle(color: Colors.white),
//                 ),
//                 tooltipContent: "This is a tooltip for Dashboard item",
//               ),
//               SideMenuItem(
//                 priority: 1,
//                 title: 'Users',
//                 onTap: (index, _) {
//                   sideMenu.changePage(index);
//                 },
//                 icon: const Icon(Icons.supervisor_account),
//               ),
//               SideMenuItem(
//                 priority: 2,
//                 title: 'Files',
//                 onTap: (index, _) {
//                   sideMenu.changePage(index);
//                 },
//                 icon: const Icon(Icons.file_copy_rounded),
//                 trailing: Container(
//                     decoration: const BoxDecoration(
//                         color: Colors.amber,
//                         borderRadius: BorderRadius.all(Radius.circular(6))),
//                     child: Padding(
//                       padding: const EdgeInsets.symmetric(
//                           horizontal: 6.0, vertical: 3),
//                       child: Text(
//                         'New',
//                         style: TextStyle(fontSize: 11, color: Colors.grey[800]),
//                       ),
//                     )),
//               ),
//               SideMenuItem(
//                 priority: 3,
//                 title: 'Download',
//                 onTap: (index, _) {
//                   sideMenu.changePage(index);
//                 },
//                 icon: const Icon(Icons.download),
//               ),
//               SideMenuItem(
//                 priority: 4,
//                 title: 'Settings',
//                 onTap: (index, _) {
//                   sideMenu.changePage(index);
//                 },
//                 icon: const Icon(Icons.settings),
//               ),
//               // SideMenuItem(
//               //   priority: 5,
//               //   onTap:(index, _){
//               //     sideMenu.changePage(index);
//               //   },
//               //   icon: const Icon(Icons.image_rounded),
//               // ),
//               // SideMenuItem(
//               //   priority: 6,
//               //   title: 'Only Title',
//               //   onTap:(index, _){
//               //     sideMenu.changePage(index);
//               //   },
//               // ),
//               const SideMenuItem(
//                 priority: 7,
//                 title: 'Exit',
//                 icon: Icon(Icons.exit_to_app),
//               ),
//             ],
//           ),
//           Expanded(
//             child: PageView(
//               controller: pageController,
//               children: [
//                 Container(
//                   color: Colors.white,
//                   child: const Center(
//                     child: Text(
//                       'Dashboard',
//                       style: TextStyle(fontSize: 35),
//                     ),
//                   ),
//                 ),
//                 Container(
//                   color: Colors.white,
//                   child: const Center(
//                     child: Text(
//                       'Users',
//                       style: TextStyle(fontSize: 35),
//                     ),
//                   ),
//                 ),
//                 Container(
//                   color: Colors.white,
//                   child: const Center(
//                     child: Text(
//                       'Files',
//                       style: TextStyle(fontSize: 35),
//                     ),
//                   ),
//                 ),
//                 Container(
//                   color: Colors.white,
//                   child: const Center(
//                     child: Text(
//                       'Download',
//                       style: TextStyle(fontSize: 35),
//                     ),
//                   ),
//                 ),
//                 Container(
//                   color: Colors.white,
//                   child: const Center(
//                     child: Text(
//                       'Settings',
//                       style: TextStyle(fontSize: 35),
//                     ),
//                   ),
//                 ),
//                 Container(
//                   color: Colors.white,
//                   child: const Center(
//                     child: Text(
//                       'Only Title',
//                       style: TextStyle(fontSize: 35),
//                     ),
//                   ),
//                 ),
//                 Container(
//                   color: Colors.white,
//                   child: const Center(
//                     child: Text(
//                       'Only Icon',
//                       style: TextStyle(fontSize: 35),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
