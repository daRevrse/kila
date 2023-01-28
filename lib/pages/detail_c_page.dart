import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class OrderDetailPageC extends StatefulWidget {
  final String orderId;

  OrderDetailPageC({required this.orderId});

  @override
  _OrderDetailPageCState createState() => _OrderDetailPageCState();
}

class _OrderDetailPageCState extends State<OrderDetailPageC> {

  final User user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Détails de la commande'),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('users_clients')
            .doc(user.uid)
            .collection('orders').doc(widget.orderId).snapshots(),
        builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          final order = snapshot.data!;

          //var order = snapshot.data;
          if (!order.exists) {
            return Center(child: Text('La commande n\'existe plus'));
          }


          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Text('Produit: ${order['product']}'),
                Text('Quantité: ${order['quantity']}'),
                Text('Notes: ${order['notes']}'),
                Text('Statut: ${order['status']}'),
              ],
            ),
          );
        },
      ),
    );
  }
}
