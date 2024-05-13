import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:groc/bottom-nav.dart';
import 'package:http/http.dart' as http;
import 'package:otp_autofill/otp_autofill.dart';
import 'package:groc/pages/startergies.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Verification extends StatefulWidget {
  final String generatedOTP;
  final String number;
  const Verification({super.key, required this.generatedOTP,required this.number});
  @override
  State<Verification> createState() => _VerificationState();
}

class _VerificationState extends State<Verification>
{
  late OTPTextEditController controller;

  @override
  void initState() {
    super.initState();
    controller = OTPTextEditController(
      codeLength: 4,
      onCodeReceive: (code) async{
        print('Received OTP: $code');
        if (code == widget.generatedOTP) {
          await verify_user(widget.number);
          await Future.delayed(const Duration(seconds: 1));
          printSharedPrefsValues();
          print('OTP verified automatically!');
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const bottom(),
            ),
          );
        }else{
          print("invalid otp!");
        }
      },
    )..startListenUserConsent(
            (code) {
          final exp = RegExp(r'(\d{5})');
          return exp.stringMatch(code ?? '') ?? '';
        },
      strategies: [
         SampleStrategy(generatedOTP: widget.generatedOTP)
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SvgPicture.asset(
            'assets/images/otp-security.svg',
            semanticsLabel: 'My SVG Image',
            height: 400,
            width: 300,
          ),
          const Text(
            "Enter OTP",
            style: TextStyle(fontSize: 20),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: TextField(
              controller: controller,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Enter OTP',
              ),
            ),

          ),



        ],
      ),
    );
  }

  // Function to verify OTP


  Future<void> verify_user(String mobile_number) async {
    try {
      final data = [
        {
          'mobile_number': mobile_number,
          'fcm_registered_id': "123333",
        }
      ];

      final jsonData = jsonEncode(data);

      final response = await http.post(
        Uri.parse('https://grocere.co.in/api/user-login.php'),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonData,
      );

      print("Response Status Code: ${response.statusCode}");
      print("Response Body: ${response.body}");

      if (response.statusCode == 200) {
        // Parse the response body
        final List<dynamic> responseBody = jsonDecode(response.body);

        // Access the first element of the array (assuming it contains the desired data)
        final Map<String, dynamic> user = responseBody.isNotEmpty ? responseBody[0] : {};
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('success', user['success'] ?? '');
        prefs.setString('customer_type', user['customer_type'] ?? '');
        prefs.setString('mobile_number', user['mobile_number'] ?? '');
        prefs.setString('customer_id', user['customer_id'].toString());
        prefs.setString('title', user['title'] ?? '');
        prefs.setString('first_name', user['first_name'] ?? '');
        prefs.setString('last_name', user['last_name'] ?? '');
        prefs.setString('email', user['email'] ?? '');
        prefs.setString('customer_status', user['customer_status'] ?? '');
        prefs.setString('min_order_value', user['min_order_value'] ?? '');
        prefs.setString('delivery_amount', user['delivery_amount'] ?? '');

        // Return a Future indicating that the values have been updated
        return Future.value();
      } else {
        print("Failed: ${response.body}");
        throw Exception('Failed to post data');
      }
    } catch (e) {
      print('Error: $e');
      rethrow; // Rethrow the exception to handle it elsewhere if needed
    }
  }


  Future<void> printSharedPrefsValues() async  {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Retrieve and print each value using the corresponding key
    print('success: ${prefs.getString('success')}');
    print('customer_type: ${prefs.getString('customer_type')}');
    print('mobile_number: ${prefs.getString('mobile_number')}');
    print('customer_id: ${prefs.getString('customer_id')}');
    print('title: ${prefs.getString('title')}');
    print('first_name: ${prefs.getString('first_name')}');
    print('last_name: ${prefs.getString('last_name')}');
    print('email: ${prefs.getString('email')}');
    print('customer_status: ${prefs.getString('customer_status')}');
    print('min_order_value: ${prefs.getString('min_order_value')}');
    print('delivery_amount: ${prefs.getString('delivery_amount')}');
  }


}


