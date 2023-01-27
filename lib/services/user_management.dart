import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kila/pages/home_client.dart';
import 'package:kila/pages/home_vendeur.dart';

class UserManagement {

  storeNewUser(user,type, context) async {
    final firebaseUser = await FirebaseAuth.instance.currentUser;
    if (firebaseUser != null)
    await FirebaseFirestore.instance
        .collection('users')
        .doc(firebaseUser.uid)
        .set({'email': user.email, 'uid': user.uid, 'type': type})
        .then((value) => {})
        .catchError((e) {
      print(e);
    });
  }

  storeNewUserByType(user,type, context) async {
    final firebaseUser = await FirebaseAuth.instance.currentUser;
    if (firebaseUser != null)
      await FirebaseFirestore.instance
          .collection('users_${type}s')
          .doc(firebaseUser.uid)
          .set({'email': user.email, 'uid': user.uid})
          .then((value) => {})
          .catchError((e) {
        print(e);
      });
  }

  getUserType(context) {
    final firebaseUser = FirebaseAuth.instance.currentUser;
    if (firebaseUser != null)
      FirebaseFirestore.instance
        .collection('users')
        .doc(firebaseUser.uid)
        .get()
        .then((value) {
      var userType = value.data()['type'];
      if (userType == "client") {
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => HomeClient()));
      }
      else if (userType == "vendeur") {
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => HomeVendeur()));
      }
    });
  }
}