import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:groc/pages/cart/db.dart';
import 'package:provider/provider.dart';
import 'package:groc/pages/cart/provider.dart';

import '../pages/cart/cart_model.dart'; // Import the CartProvider

class ProductDetailsPage extends StatefulWidget {
  final String productId;

  ProductDetailsPage({required this.productId});

  @override
  _ProductDetailsPageState createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeInAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<Offset> _slideAnimation;

  Map<String, dynamic>? productDetails;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 800),
    );

    _fadeInAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _scaleAnimation = Tween<double>(
      begin: 0.5,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _slideAnimation = Tween<Offset>(
      begin: Offset(-1.0, 0.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    fetchProductDetails();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> fetchProductDetails() async {
    try {
      final response = await http.get(
        Uri.parse(
            'https://grocere.co.in/api/getProductDetail.php?product_id=${widget.productId}&language=en'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        if (data.isNotEmpty) {
          setState(() {
            productDetails = data.first;
          });
          _animationController.forward();
        }
      } else {
        throw Exception('Failed to load product details');
      }
    } catch (e) {
      print('Error fetching product details: $e');
    }
  }

  // Method to add item to the cart
  Future<void> saveData(BuildContext context) async {
    if (productDetails != null) {
      DBHelper().insert(
        Cart(
          id: int.parse(productDetails!['product_id']),
          productId: productDetails!['product_id'],
          productName: productDetails!['product_name'],
          initialPrice: int.parse(productDetails!['sale_rate']),
          productPrice: int.parse(productDetails!['sale_rate']),
          quantity: ValueNotifier(1),
          unitTag: 'unit', // Update this accordingly
          image: productDetails!['product_image'],
        ),
      ).then((value) {
        Provider.of<CartProvider>(context, listen: false)
            .addTotalPrice(double.parse(productDetails!['sale_rate']));
        Provider.of<CartProvider>(context, listen: false).addCounter();

        // Show a snackbar for successful addition
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Product Added to cart'),
          ),
        );

        print('Product Added to cart');
      }).onError((error, stackTrace) {
        print(error.toString());
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Product Details'),
      ),
      body: productDetails != null
          ? SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            SlideTransition(
              position: _slideAnimation,
              child: FadeTransition(
                opacity: _fadeInAnimation,
                child: Container(
                  alignment: Alignment.center,
                  child: ScaleTransition(
                    scale: _scaleAnimation,
                    child: SizedBox(
                      width: 300,
                      height: 300,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.network(
                          'https://grocere.co.in/api/${productDetails!['product_image']}',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            FadeTransition(
              opacity: _fadeInAnimation,
              child: SlideTransition(
                position: _slideAnimation,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Product Name:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      '${productDetails!['product_name']}',
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Description:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      '${productDetails!['description']}',
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Sale Rate:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      '${productDetails!['sale_rate']}',
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                    SizedBox(height: 20),
                    ListTile(
                      tileColor: Colors.grey.withOpacity(0.2),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      contentPadding: EdgeInsets.all(16),
                      leading: Image.network(
                        'https://grocere.co.in/api/${productDetails!['product_image']}',
                        fit: BoxFit.cover,
                        width: 60,
                        height: 60,
                      ),
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Sale Rate: ${productDetails!['sale_rate']}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'MRP: ${productDetails!['mrp']}',
                            style: TextStyle(
                              fontSize: 16,
                              decoration: TextDecoration.lineThrough,
                              color: Colors.red,
                            ),
                          ),
                        ],
                      ),
                      trailing: cart.isItemInCart(productDetails!['product_id'])
                          ? Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            onPressed: () {
                              // Decrement quantity
                              cart.deleteQuantity(int.parse(productDetails!['product_id']));
                            },
                            icon: Icon(Icons.remove),
                          ),
                          ValueListenableBuilder<int>(
                            valueListenable: cart.getQuantityNotifier(productDetails!['product_id']),
                            builder: (context, quantity, _) {
                              return Text(
                                '$quantity',
                              );
                            },
                          ),
                          IconButton(
                            onPressed: () {
                              // Increment quantity
                              cart.addQuantity(int.parse(productDetails!['product_id']));
                            },
                            icon: Icon(Icons.add),
                          ),
                          IconButton(
                            onPressed: () {
                              // Remove item from cart
                              cart.removeItem(int.parse(productDetails!['product_id']));
                            },
                            icon: Icon(Icons.delete),
                          ),
                        ],
                      )
                          : IconButton(
                        onPressed: () {
                          saveData(context); // Call saveData method with context
                        },
                        icon: Icon(Icons.add_shopping_cart),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      )
          : Center(child: CircularProgressIndicator()),
    );
  }
}
