import 'package:flutter/material.dart';
import 'cart_screen.dart';
import 'homepage.dart';
import 'package:groc/Bottom-nav-pages/cart.dart';
import 'Bottom-nav-pages/Orders.dart';
import 'Bottom-nav-pages/accounts.dart';
import 'package:provider/provider.dart';
import 'package:groc/pages/cart/provider.dart'; // Import the CartProvider

class bottom extends StatefulWidget {
  const bottom({Key? key}) : super(key: key);

  @override
  State<bottom> createState() => _bottomState();
}

class _bottomState extends State<bottom> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Consumer<CartProvider>(
              builder: (context, cart, _) {
                return Stack(
                  children: [
                    Icon(Icons.shopping_cart),
                    if (cart.getCounter() > 0)
                      Positioned(
                        right: 0,
                        child: CircleAvatar(
                          backgroundColor: Colors.red,
                          radius: 8,
                          child: Text(
                            cart.getCounter().toString(),
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                  ],
                );
              },
            ),
            label: 'Cart',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'Orders',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_box),
            label: 'Account',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.greenAccent,
        unselectedItemColor: Colors.black,
        elevation: 5,
        iconSize: 30,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
      body: _pages[_selectedIndex],
    );
  }

  final List<Widget> _pages = <Widget>[
    const MyHomePage(),
    const CartScreen(),
    const Order(),
    const Account(),
  ];
}
