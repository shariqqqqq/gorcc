import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'pages/cart/db.dart';
import 'pages/cart/cart_model.dart';
import 'package:groc/pages/cart/provider.dart';
import 'package:badges/badges.dart' as badge;

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  DBHelper? dbHelper = DBHelper();

  late ValueNotifier<double> totalPrice; // Change the type to double

  @override
  void initState() {
    super.initState();
    totalPrice = ValueNotifier(0.0); // Initialize totalPrice as double
    context.read<CartProvider>().getData();
  }

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('My Shopping Cart'),
        actions: [
          badge.Badge(
            badgeContent: Consumer<CartProvider>(
              builder: (context, value, child) {
                return Text(
                  value.getCounter().toString(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                );
              },
            ),
            position: badge.BadgePosition.topEnd(top: 30, end: 30),
            child: IconButton(
              onPressed: () {},
              icon: const Icon(Icons.shopping_cart),
            ),
          ),
          const SizedBox(width: 20.0),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Consumer<CartProvider>(
              builder: (BuildContext context, provider, widget) {
                if (provider.cart.isEmpty) {
                  return const Center(
                    child: Text(
                      'Your Cart is Empty',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
                    ),
                  );
                } else {
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: provider.cart.length,
                    itemBuilder: (context, index) {
                      return Card(
                        color: Colors.blueGrey.shade200,
                        elevation: 5.0,
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              SizedBox(
                                width: 130,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: 5.0),
                                    RichText(
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                      text: TextSpan(
                                        text: 'Name: ',
                                        style: TextStyle(
                                          color: Colors.blueGrey.shade800,
                                          fontSize: 16.0,
                                        ),
                                        children: [
                                          TextSpan(
                                            text: '${provider.cart[index].productName!}\n',
                                            style: const TextStyle(fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                    ),
                                    RichText(
                                      maxLines: 1,
                                      text: TextSpan(
                                        text: 'Unit: ',
                                        style: TextStyle(
                                          color: Colors.blueGrey.shade800,
                                          fontSize: 16.0,
                                        ),
                                        children: [
                                          TextSpan(
                                            text: '${provider.cart[index].unitTag!}\n',
                                            style: const TextStyle(fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                    ),
                                    RichText(
                                      maxLines: 1,
                                      text: TextSpan(
                                        text: 'Quantity: ',
                                        style: TextStyle(
                                          color: Colors.blueGrey.shade800,
                                          fontSize: 16.0,
                                        ),
                                        children: [
                                          TextSpan(
                                            text: '${provider.cart[index].quantity!}\n',
                                            style: const TextStyle(fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 5.0),
                                  ],
                                ),
                              ),
                              Column(
                                children: [
                                  SizedBox(
                                    height: 50,
                                    width: 50,
                                    child: FloatingActionButton(
                                      onPressed: () {
                                        provider.addQuantity(index);
                                        //final newTotal = ((provider.cart[index].quantity ?? 0).toDouble() * provider.cart[index].initialPrice);                                        totalPrice.value += newTotal;
                                      },
                                      backgroundColor: Colors.green,
                                      child: const Icon(Icons.add),
                                    ),
                                  ),
                                  const SizedBox(height: 5.0),
                                  SizedBox(
                                    height: 50,
                                    width: 50,
                                    child: FloatingActionButton(
                                      onPressed: () {
                                        provider.deleteQuantity(index);
                                        //final newTotal = provider.cart[index].quantity! * provider.cart[index].initialPrice!;
                                        //totalPrice.value -= newTotal;
                                      },
                                      backgroundColor: Colors.red,
                                      child: const Icon(Icons.remove),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
          Container(
            color: Colors.blueGrey.shade200,
            padding: const EdgeInsets.all(8.0),
            child: Consumer<CartProvider>(
              builder: (BuildContext context, provider, widget) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Total Price:',
                      style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '\$${totalPrice.value}',
                      style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}