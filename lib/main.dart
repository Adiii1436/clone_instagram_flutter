import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
// import 'package:instagram_clone/pages/login_page.dart';
import 'package:instagram_clone/pages/sign_up_page.dart';
// import 'package:instagram_clone/responsive/mobile_screen_layout.dart';
// import 'package:instagram_clone/responsive/responsive_layout.dart';
// import 'package:instagram_clone/responsive/web_screen_layout.dart';
import 'package:instagram_clone/utils/colors.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
        options: const FirebaseOptions(
            apiKey: "AIzaSyBvE26z3vW1C2TwFjrvcFI_fRwzBZ3xwUg",
            appId: "1:1007252695090:web:4ed53fdb70b2ab716ef42b",
            messagingSenderId: "1007252695090",
            projectId: "instagram-clone-27fa8",
            storageBucket: "instagram-clone-27fa8.appspot.com"));
  } else {
    await Firebase.initializeApp();
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Instagram Clone',
      theme: ThemeData.dark()
          .copyWith(scaffoldBackgroundColor: mobileBackgroundColor),
      // home: const ResponsiveLayout(
      //     webScreenLayout: WebScreenLayout(),
      //     mobileScreenLayout: MobileScreenLayout()),
      home: const SignupPage(),
    );
  }
}
