import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class OrderDetailPageV extends StatefulWidget {
  final String orderId;

  OrderDetailPageV({required this.orderId});

  @override
  _OrderDetailPageVState createState() => _OrderDetailPageVState();
}

class _OrderDetailPageVState extends State<OrderDetailPageV> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Détails de la commande'),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('orders').doc(widget.orderId).snapshots(),
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
