/*
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
class PaymentScreen extends StatefulWidget {
  const PaymentScreen({Key? key}) : super(key: key);

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  late WebViewController controller;

  @override
  void initState() {
    // TODO: implement initState
    controller = WebViewController()..loadRequest(Uri.parse("https://staging-parkfinda-api.eu-west-2.elasticbeanstalk.com/api/v1/test/payment"));
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WebViewWidget(controller: controller,),
    );
  }
}
*/
