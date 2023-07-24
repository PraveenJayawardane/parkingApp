import 'package:flutter/material.dart';

import '../../widgets/atoms/app_label.dart';
import 'package:html/parser.dart';
import 'package:flutter_html/flutter_html.dart';

class BookingFixedDurationAccessTab extends StatelessWidget {
  const BookingFixedDurationAccessTab(
      {super.key, required this.acsessInformation});
  final String? acsessInformation;

  String _parseHtmlString(String htmlString) {
    final document = parse(htmlString);
    final String parsedString =
        parse(document.body!.text).documentElement!.text;

    return parsedString;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          // Padding(
          //   padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20),
          //   child: Container(
          //     padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          //     width: MediaQuery.of(context).size.width,
          //     decoration: BoxDecoration(
          //         borderRadius: BorderRadius.circular(6),
          //         color: AppColors.appColorGreen.withOpacity(0.2),
          //         border: Border.all(color: AppColors.appColorGreen)),
          //     child: Column(
          //       children: [
          //         AppLabel(
          //           text: "Access Pin Number",
          //           fontSize: 14,
          //         ),
          //         AppLabel(
          //           text: "#7865",
          //           fontSize: 14,
          //           textColor: AppColors.appColorGray,
          //         ),
          //       ],
          //     ),
          //   ),
          // ),
          // const SizedBox(
          //   height: 16,
          // ),
          // Padding(
          //   padding: const EdgeInsets.symmetric(horizontal: 16.0),
          //   child: Row(
          //     children: [
          //       Expanded(
          //           child: TextButton(
          //               style: ButtonStyle(
          //                   foregroundColor: MaterialStateProperty.all<Color>(
          //                       AppColors.appColorBlack),
          //                   shape:
          //                       MaterialStateProperty.all<RoundedRectangleBorder>(
          //                           RoundedRectangleBorder(
          //                               borderRadius: BorderRadius.circular(4),
          //                               side: const BorderSide(
          //                                   color: AppColors.appColorBlack)))),
          //               onPressed: () {
          //                 Get.toNamed(Routes.QR_CODE_SCREEN);
          //               },
          //               child: Row(
          //                 mainAxisAlignment: MainAxisAlignment.center,
          //                 children: const [
          //                   FaIcon(FontAwesomeIcons.qrcode),
          //                   SizedBox(
          //                     width: 8,
          //                   ),
          //                   Text(
          //                     "QR code",
          //                     style: TextStyle(
          //                         fontSize: 14, fontWeight: FontWeight.w600),
          //                   )
          //                 ],
          //               ))),
          //       const SizedBox(
          //         width: 12,
          //       ),
          //       Expanded(
          //         child: TextButton(
          //             style: ButtonStyle(
          //                 foregroundColor: MaterialStateProperty.all<Color>(
          //                     AppColors.appColorBlack),
          //                 shape:
          //                     MaterialStateProperty.all<RoundedRectangleBorder>(
          //                         RoundedRectangleBorder(
          //                             borderRadius: BorderRadius.circular(4),
          //                             side: const BorderSide(
          //                                 color: AppColors.appColorBlack)))),
          //             onPressed: () {},
          //             child: Row(
          //               mainAxisAlignment: MainAxisAlignment.center,
          //               children: const [
          //                 ImageIcon(
          //                   AssetImage("assets/images/parking_gate.png"),
          //                 ),
          //                 SizedBox(
          //                   width: 8,
          //                 ),
          //                 Text(
          //                   "Access Control",
          //                   style: TextStyle(
          //                       fontSize: 14, fontWeight: FontWeight.w600),
          //                 )
          //               ],
          //             )),
          //       )
          //     ],
          //   ),
          // ),

          Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: AppLabel(
              text: "Access Information",
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(
            height: 8,
          ),

          Html(data: acsessInformation!.replaceAll('&lt;', '<')),
          const SizedBox(
            height: 16,
          ),
        ],
      ),
    );
  }
}
