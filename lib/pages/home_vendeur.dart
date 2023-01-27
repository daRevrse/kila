import 'package:cloud_firestore/cloud_firestore.dart';
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
        appBar: AppBar(
          title: Text("Vendeur"),
          actions: [
            IconButton(onPressed: ()async => {
              await FirebaseAuth.instance.signOut(),
              await storage.delete(key: "uid"),
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LoginPage(),
                  ),
                      (route) => false)}, icon: Icon(Icons.logout))
          ],
        ),
        body: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('orders').snapshots(),
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            List<Widget> orderWidgets = [];
            if (snapshot.hasData) {
              var orders = snapshot.data!.docs;

              for (var order in orders) {
                final orderData = order.data();
                final orderWidget = ListTile(
                  title: Text(orderData['product'].toString()),
                  subtitle: Text(orderData['quantity'].toString()),
                );
                orderWidgets.add(orderWidget);
              }
            }
            return ListView(
              children: orderWidgets,
            );
          },
        ),
      ),
    );
  }
}