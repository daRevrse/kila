import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'historic_client_page.dart';
import 'login.dart';


class HomeClient extends StatefulWidget {
  const HomeClient({Key? key}) : super(key: key);

  @override
  State<HomeClient> createState() => _HomeClientState();
}

class _HomeClientState extends State<HomeClient> {
  final storage = new FlutterSecureStorage();

  // Récupérer l'utilisateur connecté
  //final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late final User user;

  final _formKey = GlobalKey<FormState>();
  late String _product;
  late int _quantity;
  late String _notes;


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Client"),
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
        body: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(labelText: "Produit"),
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Entrez le nom du produit";
                  }
                  return null;
                },
                onSaved: (value) => _product = value!,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: "Quantité"),
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Entrez la quantité";
                  }
                  return null;
                },
                onSaved: (value) => _quantity = int.parse(value!),
              ),
              TextFormField(
                decoration: InputDecoration(labelText: "Notes"),
                onSaved: (value) => _notes = value!,
              ),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    _submitOrder();
                    addOrder();
                  }
                },
                child: Text("Soumettre"),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => OrderList(),
                    ),
                  );
                },
                child: Text("Mon historique"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _submitOrder() async {
    FirebaseFirestore.instance.collection("orders").add({
      "product": _product,
      "quantity": _quantity,
      "notes": _notes,
      "user_id": FirebaseAuth.instance.currentUser.uid,
      "status": "pending",
      "created_at": Timestamp.now(),
    });
  }

  // Ajouter une commande pour l'utilisateur connecté
  Future<void> addOrder() async {
    var user = FirebaseAuth.instance.currentUser;
    await _firestore.collection('users_clients').doc(user.uid).collection('orders').add({
      "product": _product,
      "quantity": _quantity,
      "notes": _notes,
      "user_id": user.uid,
      "status": "pending",
      "created_at": Timestamp.now(),
    });
  }

}
