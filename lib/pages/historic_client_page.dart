import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'detail_c_page.dart';

class OrderList extends StatefulWidget {

  const OrderList({Key? key}) : super(key: key);

  @override
  State<OrderList> createState() => _OrderListState();

}

class _OrderListState extends State<OrderList> {
  // Récupérer l'utilisateur connecté
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final User user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Mon Historique"),
        ),
        body: StreamBuilder(
          stream: _firestore
              .collection('users_clients')
              .doc(user.uid)
              .collection('orders')
              .snapshots(),
          builder: (BuildContext context,AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            //final orders = snapshot.data!.docs;

            List<Widget> orderWidgets = [];
            if (snapshot.hasData) {
              var orders = snapshot.data!.docs;
              for (var order in orders) {
                final orderData = order.data();

                final orderWidget = ListTile(
                  title: Text(orderData['product'].toString()),
                  subtitle: Text(orderData['quantity'].toString()),
                  onTap: () {
                    // gérer le clic sur la commande
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => OrderDetailPageC(orderId: order.id),
                      ),
                    );
                  },
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
