import 'package:flutter/material.dart';

class Order extends StatefulWidget {
  const Order({super.key});

  @override
  State<Order> createState() => _CartState();
}

class _CartState extends State<Order> {
  var img="http://allpicts.in/wp-content/uploads/2018/03/Natural-Images-HD-1080p-Download-with-Keyhole-Arch-at-Pfeiffer-Beach.jpg";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Orders",style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w400
        ),),
      ),
      body: ListView(
        children: const [

        ],
      ),
    );
  }
}
