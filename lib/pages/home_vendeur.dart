import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'login.dart';

class HomeVendeur extends StatefulWidget {
  const HomeVendeur({Key? key}) : super(key: key);

  @override
  State<HomeVendeur> createState() => _HomeVendeurState();
}

class _HomeVendeurState extends State<HomeVendeur> {

  final storage = new FlutterSecureStorage();


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Column(
            children: [
              Center(child: Text("Vendeur"),),
              ElevatedButton(
                onPressed: () async => {
                  await FirebaseAuth.instance.signOut(),
                  await storage.delete(key: "uid"),
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LoginPage(),
                      ),
                          (route) => false)
                },
                child: Text('Logout'),
                style: ElevatedButton.styleFrom(primary: Colors.blueGrey),
              )
            ],
          ),
        ),
      ),
    );
  }
}