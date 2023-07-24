import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:parkfinda_mobile/controllers/tab_controllers/privacy_policy_tab_controller.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../constants/app_colors.dart';

class TermsOfUseScreen extends StatelessWidget {
  late WebViewController _webViewController;
  TermsOfUseScreen({Key? key}) : super(key: key);
  PrivacyPolicyTabController parkingTabController =
      Get.put(PrivacyPolicyTabController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        centerTitle: true,
        title: const Text(
          "Terms & Conditions",
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
          const SizedBox(
            height: 10,
          ),
          TabBar(
              indicatorPadding: const EdgeInsets.symmetric(horizontal: 20),
              indicatorColor: AppColors.appColorBlack,
              controller: parkingTabController.tabController,
              tabs: parkingTabController.bookingTabs),
          Expanded(
              child: TabBarView(
                  controller: parkingTabController.tabController,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                Container(
                  constraints: BoxConstraints(
                      maxHeight: MediaQuery.of(context).size.height * 0.8),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: WebView(
                      backgroundColor: AppColors.appColorWhite,
                      onWebViewCreated: (WebViewController controller) {
                        _webViewController = controller;
                        _loadHtmlFileFormAssets(
                            "assets/html/terms_conditions.html");
                      },
                    ),
                  ),
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
                        _loadHtmlFileFormAssets(
                            "assets/html/terms_conditions_srilanka.html");
                      },
                    ),
                  ),
                )
              ])),
        ],
      ),
    );
  }

  void _loadHtmlFileFormAssets(String url) async {
    String fileText = await rootBundle.loadString(url);
    _webViewController.loadUrl(Uri.dataFromString(fileText,
            mimeType: 'text/html', encoding: Encoding.getByName('utf-8'))
        .toString());
  }
}
