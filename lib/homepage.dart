import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:groc/Bottom-nav-pages/cart.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_svg/flutter_svg.dart';

import 'cart_screen.dart';
import 'product.dart';
import 'card.dart';
import 'product/details.dart';

class MyHomePage extends StatefulWidget {

  const MyHomePage({super.key});
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<String> postImageUrls = [];
  List<String> imageUrls = [];
  String img =
      "https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Ftse4.mm.bing.net%2Fth%3Fid%3DOIP.bircyBDvJOcKd3mkR6ramwHaEK%26pid%3DApi&f=1&ipt=5909f3cdfdc42fb7effd2baabc4312074c2866f899860a96cf501dc9d1f51cf4&ipo=images";
  List<Map<String, dynamic>> categories = [];
  List<Map<String, dynamic>> products = [];

  @override
  void initState() {
    super.initState();
    fetchCarouselImages();
    fetchPostImages();
    fetchCategories();
    fetchProducts();
  }

  Future<void> fetchPostImages() async {
    try {
      final response = await http.get(
        Uri.parse('https://grocere.co.in/api/banners.php?banner_type=post'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        final List<String> urls = [];
        for (var item in data) {
          urls.add(item['banner_image']);
        }
        setState(() {
          postImageUrls = urls;
        });
      } else {
        throw Exception('Failed to load post images');
      }
    } catch (e) {
      print('Error fetching post images: $e');
    }
  }

  Future<void> fetchCarouselImages() async {
    try {
      final response = await http.get(
        Uri.parse(
            'https://grocere.co.in/api/banners.php?banner_type=slider'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        final List<String> urls = [];
        for (var item in data) {
          urls.add(item['banner_image']);
        }
        setState(() {
          imageUrls = urls;
        });
      } else {
        throw Exception('Failed to load carousel images');
      }
    } catch (e) {
      print('Error fetching carousel images: $e');
    }
  }

  Future<void> fetchCategories() async {
    try {

      final response = await http.post(
        Uri.parse('https://grocere.co.in/api/category.php'),
        body: jsonEncode([{"mobile_number": "none", "token": "none"}]),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        print(response.body);
        final List<Map<String, dynamic>> fetchedCategories = [];
        for (var item in data) {
          fetchedCategories.add({
            "title": item['category_name'],
            "description": item['category_name'],
            "imageUrl": "https://grocere.co.in/api/${item['category_photo']}",
          });
        }

        setState(() {
          categories = fetchedCategories;
        });
      } else {
        throw Exception('Failed to load categories');
      }
    } catch (e) {
      print('Error fetching categories: $e');
    }
  }
  Future<void> fetchProducts() async {
    try {
      final response = await http.post(
        Uri.parse("https://grocere.co.in/api/product-categoryWise.php"),
        body: jsonEncode([{"mobile_number": "none", "token": "none", "language": "en"}]),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        print('Response data: $data'); // Print response data for debugging

        final List<Map<String, dynamic>> fetchedProducts = [];
        for (var category in data) {
          final List<dynamic> productsData = category['products'];
          for (var product in productsData) {
            fetchedProducts.add({
              "product_id": product['product_id'], // Ensure correct key is used
              "title": product['product_name'],
              "description": product['sale_rate'],
              "imageUrl": "https://grocere.co.in/api/${product['product_image']}",
            });
          }
        }

        setState(() {
          products = fetchedProducts;
        });
      } else {
        throw Exception('Failed to load products');
      }
    } catch (e) {
      print('Error fetching products: $e');
    }
  }
  Widget buildPostImages() {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Row(
        children: postImageUrls.map((imageUrl) {
          return Container(
            padding: const EdgeInsets.only(left: 18, top: 10),
            child: ClipOval(
              child: SizedBox.fromSize(
                size: const Size.fromRadius(40),
                child: Image.network(
                    "https://grocere.co.in/api/$imageUrl",
                    fit: BoxFit.cover),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
  Widget postimage() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: postImageUrls.map((imageUrl) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.network("https://grocere.co.in/api/$imageUrl",
                fit: BoxFit.cover),
          );
        }).toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(60, 158, 158, 158),
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: const Text(
          "Grocere-Fresh Fruits & Veggies",
          style: TextStyle(color: Colors.white),
        ),
        actions: <Widget>[
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Carts(),
                ),
              );
            },
            icon: const Icon(Icons.notifications_none),
            color: Colors.greenAccent,
          ),
        ],
      ),
      body: ListView(
        children: [
          CarouselSlider(
            items: imageUrls.map((imageUrl) {
              return Container(
                margin: const EdgeInsets.all(6.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  image: DecorationImage(
                    image: NetworkImage(
                        "https://grocere.co.in/api/$imageUrl"),
                    fit: BoxFit.cover,
                  ),
                ),
              );
            }).toList(),
            options: CarouselOptions(
              height: 180.0,
              enlargeCenterPage: true,
              autoPlay: true,
              aspectRatio: 16 / 9,
              autoPlayCurve: Curves.fastOutSlowIn,
              enableInfiniteScroll: true,
              autoPlayAnimationDuration: const Duration(milliseconds: 800),
              viewportFraction: 0.8,
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(20.0),
            child: Text(
              "Top Categories",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
            ),
          ),
           Padding(
            padding: EdgeInsets.all(10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 30),
                  child: SvgPicture.asset(
                    'assets/images/vegetables.svg', // Replace with the path to your SVG file
                    width: 40,
                    height: 40,
                    color: Colors.green,
                  ),

                ),
                Padding(
                  padding: EdgeInsets.only(left: 30),
                  child: SvgPicture.asset(
                    'assets/images/fruits.svg', // Replace with the path to your SVG file
                    width: 40,
                    height: 40,
                    color: Colors.green,
                  ),
                ),
                Padding(padding: EdgeInsets.only(left:0),
                  child: SvgPicture.asset(
                    'assets/images/spinach.svg', // Replace with the path to your SVG file
                    width: 5,
                    height: 5,
                     color: Colors.green,

                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 30),
                  child: SvgPicture.asset(
                    'assets/images/vegetables.svg', // Replace with the path to your SVG file
                    width: 40,
                    height: 40,
                    color: Colors.green,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 30),
                  child: SvgPicture.asset(
                    'assets/images/fruits.svg', // Replace with the path to your SVG file
                    width: 40,
                    height: 40,
                    color: Colors.green,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 30),
                  child: SvgPicture.asset(
                    'assets/images/spinach.svg', // Replace with the path to your SVG file
                    width: 40,
                    height: 40,
                    color: Colors.green,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              style: const TextStyle(
                  height: 1.2, color: Colors.grey, fontSize: 15),
              decoration: InputDecoration(
                filled: true,
                fillColor: CupertinoColors.systemGrey5,
                labelText: 'Search',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                prefixIcon: const Icon(Icons.search),
              ),
            ),
          ),
          SizedBox(
            height: 250,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: categories.map((category) {
                  return
                  CustomCard(
                      title: category['title'],
                      description: category['description'],
                      imageUrl: category['imageUrl'],
                      onTap: () {},
                      width: 160,
                    );

                }).toList(),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Image.network(
              img,
              height: 200,
              width: 100,
              fit: BoxFit.fitWidth,
            ),
          ),
          const SizedBox(
            height: 16,
          ),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              "Shop By Category",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
            ),
          ),
          SizedBox(
            height: 250,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: products.map((product) {
                  final productId = product['product_id'];
                  if (productId != null) {
                    return CustomCard(
                      title: product['title'],
                      description: product['description'],
                      imageUrl: product['imageUrl'],
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProductDetailsPage(productId: productId),
                          ),
                        );
                      },
                      width: 160,
                    );
                  } else {
                    // Handle the case where product_id is null
                    print('Product ID is null');
                    return SizedBox(); // Or any other fallback widget
                  }
                }).toList(),

              ),
            ),
          ),

          buildPostImages(),
          const SizedBox(),
          postimage(),
        ],
      ),
    );
  }
}


