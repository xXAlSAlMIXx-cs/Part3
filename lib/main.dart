import 'package:flutter/material.dart';
import 'package:part2_project/pages/mainPage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:part2_project/models/User.dart';
Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  Stream<QuerySnapshot> getUsers(){
    return FirebaseFirestore.instance
        .collection('User')
        .limit(100)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }

}

