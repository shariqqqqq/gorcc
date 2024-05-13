import 'package:flutter/material.dart';

class Account extends StatefulWidget {
  const Account({super.key});

  @override
  State<Account> createState() => _CartState();
}

class _CartState extends State<Account> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Account",style: TextStyle(
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
