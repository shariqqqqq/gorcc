import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:groc/pages/verification.dart';
import 'package:http/http.dart' as http;
import 'package:otp_autofill/otp_autofill.dart';
import 'package:flutter/foundation.dart';
class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  late final appSignature;
  TextEditingController numberController = TextEditingController();
  late OTPTextEditController controller;
  late OTPInteractor _otpInteractor;
 late int o;
  @override
  void initState() {
    super.initState();
    _initInteractor();
    controller = OTPTextEditController(
      codeLength: 5,

      onCodeReceive: (code) => print('Your Application receive code - $code'),
      otpInteractor: _otpInteractor,
    )..startListenUserConsent(
          (code) {
        final exp = RegExp(r'(\d{5})');
        return exp.stringMatch(code ?? '') ?? '';
      },

    );
  }

  Future<void> _initInteractor() async {
    _otpInteractor = OTPInteractor();

    // You can receive your app signature by using this method.
     appSignature = await _otpInteractor.getAppSignature();

    if (kDebugMode) {
      print('Your app signature: $appSignature');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SvgPicture.asset(
            'assets/images/otp-security.svg',
            semanticsLabel: 'My SVG Image',
            height: 500,
            width: 300,
          ),
          const Text(
            "Enter Mobile Number",
            style: TextStyle(fontSize: 20),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 50.0, right: 50),
            child: TextField(
              controller: numberController,
              keyboardType: TextInputType.number,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 18.0),
            child: ElevatedButton(
              onPressed: () async {
                String otp = _generateOTP();
                _postData(appSignature,otp,numberController.text );
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Verification(
                      generatedOTP: otp,
                      number: numberController.text,
                    ),
                  ),
                );
              },
              child: const Text("Submit"),
            ),
          )
        ],
      ),
    );
  }

  // Function to generate a random 4-digit OTP
  String _generateOTP() {
    var rng = Random();
    return rng.nextInt(10000).toString().padLeft(4, '0');
  }





  Future<void> _postData(String hash_code, String otp, String mobile_number) async {
    try {
      final data = [
        {
          'hash_code': hash_code,
          'otp': otp,
          'mobile_number': mobile_number,
        }
      ];

      final jsonData = jsonEncode(data);

      final response = await http.post(
        Uri.parse('https://grocere.co.in/api/otp.php'),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonData,
      );

      print("Response Status Code: ${response.statusCode}");
      print("Response Body: ${response.body}");

      if (response.statusCode == 200) {



      } else {
        // If the server returns an error response, throw an exception
        print("Failed: ${response.body}");
        throw Exception('Failed to post data');
      }
    } catch (e) {
      print('Error: $e');
    }
  }
}


