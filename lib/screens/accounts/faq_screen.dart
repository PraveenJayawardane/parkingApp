import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../constants/app_colors.dart';

import '../../widgets/atoms/app_label.dart';

class FAQScreen extends StatelessWidget {
  const FAQScreen({Key? key}) : super(key: key);
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
       backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: AppColors.appColorBlack,
          ),
          onPressed: () {
            Get.back();
          },
        ),
        shape: const Border(
            bottom: BorderSide(color: AppColors.appColorBlack, width: 0.5)),
        title: const Text(
          "FAQs",
          style: TextStyle(
              color: AppColors.appColorBlack, fontWeight: FontWeight.w500),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 20,
              ),

              // Padding(
              //   padding: const EdgeInsets.symmetric(horizontal:16.0),
              //   child: TermsOfUseCard(label: "How to change password",onTap: (){Get.toNamed(Routes.SINGLE_FAQ_SCREEN);},),
              // ),

              // const SizedBox(height: 20,),

              // Padding(
              //   padding: const EdgeInsets.symmetric(horizontal: 16.0),
              //   child: TermsOfUseCard(label: "Getting Started",onTap: (){Get.toNamed(Routes.SINGLE_FAQ_SCREEN);},),
              // )

              AppLabel(
                  text: 'How do I Change my email and reset your password?'),
              const SizedBox(
                height: 10,
              ),
              AppLabel(
                  fontSize: 12,
                  text:
                      'After entering the email address associated with your account, you will receive an email with the necessary instructions to reset your password.'),
              const SizedBox(
                height: 10,
              ),
              AppLabel(text: 'How do I create an account?'),
              const SizedBox(
                height: 10,
              ),
              AppLabel(
                  fontSize: 12,
                  text:
                      'To create an account simply click here and enter your email address, phone number and contact details. Create your account in a few simple hassle-free steps!'),
              const SizedBox(
                height: 10,
              ),
              AppLabel(text: 'I can’t log into my account?'),
              const SizedBox(
                height: 10,
              ),
              AppLabel(
                  fontSize: 12,
                  text:
                      'Our technical support team can fix any issues regarding your account that are preventing you from logging in. Please email to  info@parkfinda.com with the email address you used for the account, your mobile number, your full name and your vehicle registration. Our team will reset your details and send you your new login information. After that, you can simply change the password to your liking.'),
              const SizedBox(
                height: 10,
              ),
              AppLabel(text: 'Why am I not receiving any email notifications?'),
              const SizedBox(
                height: 10,
              ),
              AppLabel(
                  fontSize: 12,
                  text:
                      'Some mail filters can filter emails into other folders such as your junk and spam folder. Please check your junk mail for any missing emails. To prevent this from occurring, kindly ensure to add  info@parkfinda.com  to your mailing list.'),
              const SizedBox(
                height: 10,
              ),
              AppLabel(text: 'Can I log in as a guest?'),
              const SizedBox(
                height: 10,
              ),
              AppLabel(
                  fontSize: 12,
                  text:
                      'Unfortunately, you cannot place bookings without creating or logging into an account.'),
              const SizedBox(
                height: 10,
              ),
              AppLabel(text: 'How do I change the time of my booking?'),
              const SizedBox(
                height: 10,
              ),
              AppLabel(
                  fontSize: 12,
                  text:
                      'To change the duration of a booking simply click on amend booking details and enter the new duration.'),
            ],
          ),
        ),
      ),
    );
  }
}
