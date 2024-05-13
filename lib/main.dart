import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'pages/cart/provider.dart';
import 'homepage.dart';
import 'pages/login.dart';
import 'bottom-nav.dart';

void main() async {
  // Ensure Flutter binding is initialized
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    FutureBuilder(
      future: _checkLoggedIn(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Show a splash screen while checking user login status
          return MaterialApp(home: SplashScreen());
        }  else {
          if (snapshot.data == true) {
            // User is already logged in, navigate to home page
            return MultiProvider(
              providers: [
                ChangeNotifierProvider(create: (context) => CartProvider()),
              ],
              child: MaterialApp(home: const bottom()),
            );
          } else {
            // User is not logged in, navigate to login page
            return MultiProvider(
              providers: [
                ChangeNotifierProvider(create: (context) => CartProvider()),
              ],
              child: MaterialApp(home: const Login()),
            );
          }
        }
      },
    ),
  );
}



// Function to check if the user is already logged in
Future<bool> _checkLoggedIn() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? mobileNumber = prefs.getString('mobile_number');
  return mobileNumber != null && mobileNumber.isNotEmpty;
}

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
