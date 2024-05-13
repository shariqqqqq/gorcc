import 'package:otp_autofill/otp_autofill.dart';


class SampleStrategy extends OTPStrategy {
  String? generatedOTP;

  SampleStrategy({required this.generatedOTP});

  @override
  Future<String> listenForCode() {
    return Future.delayed(
      const Duration(seconds: 4),
          () => generatedOTP ?? '',
    );
  }
}
