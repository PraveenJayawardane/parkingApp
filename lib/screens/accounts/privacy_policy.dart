import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';
//import 'package:webview_flutter/webview_flutter.dart';

import '../../constants/app_colors.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  late WebViewController _webViewController;
  PrivacyPolicyScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Privacy Policy",
          style: TextStyle(color: AppColors.appColorBlack),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: AppColors.appColorBlack,
          ),
          onPressed: () {
            Get.back();
          },
        ),
      ),
      body: Column(
        children: [
          const Divider(
            thickness: 1,
            color: AppColors.appColorLightGray,
          ),
          const SizedBox(
            height: 10,
          ),
          Container(
            constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.8),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: WebView(
                backgroundColor: AppColors.appColorWhite,
                onWebViewCreated: (WebViewController controller) {
                  _webViewController = controller;
                  _loadHtmlFileFormAssets();
                },
              ),
            ),
          )
        ],
      ),
    );
  }

  void _loadHtmlFileFormAssets() async {
    String fileText =
        await rootBundle.loadString("assets/html/privacy_policy.html");
    _webViewController.loadUrl(Uri.dataFromString(fileText,
            mimeType: 'text/html', encoding: Encoding.getByName('utf-8'))
        .toString());
  }
}
