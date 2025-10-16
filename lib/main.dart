import 'package:flutter/material.dart';
import 'package:spotapot/screens/layout.dart';
import 'package:spotapot/screens/login.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:device_preview/device_preview.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: "AIzaSyBzC5yTP_ytezVYsA7FMerVCRVqCnWutUQ",
      projectId: "spotapot-37f73",
      storageBucket: "spotapot-37f73.firebasestorage.app",
      messagingSenderId: "92938933679",
      appId: "1:92938933679:android:52b0b285ad61f24ba94b5a",
    ),
  );

  runApp(DevicePreview(enabled: true, builder: (context) => const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      builder: DevicePreview.appBuilder,
      theme: ThemeData(fontFamily: 'Poppins'),
      initialRoute: '/login',
      routes: {'/login': (context) => LoginScreen()},
      home: Layout(),
    );
  }
}
