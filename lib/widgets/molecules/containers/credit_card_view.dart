import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:parkfinda_mobile/controllers/user_controller.dart';
import 'package:parkfinda_mobile/model/card_detail.dart';

import '../../../constants/app_colors.dart';

class CreditCardView extends StatelessWidget {
  final CardDetail? cardDetail;
  CreditCardView({super.key, required this.cardDetail});
  var userController = Get.find<UserController>();

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
           userController.selectedCard.value = cardDetail;
        Get.back();
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 5),
        child: Container(
            padding: const EdgeInsets.only(bottom: 15, top: 15, left: 10),
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    offset: const Offset(0, 1),
                    blurRadius: 2,
                    color: Colors.black.withOpacity(0.3),
                  ),
                ],
                borderRadius: BorderRadius.circular(5)),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Icon(FontAwesomeIcons.creditCard,
                    size: 22, color: AppColors.appColorBlack),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  cardDetail?.ccNumber
                          ?.replaceRange(4, 4, ' ')
                          .replaceRange(9, 9, ' ')
                          .replaceRange(14, 14, ' ') ??
                      '',
                  style: const TextStyle(
                      color: AppColors.appColorGray, fontSize: 12),
                ),
              ],
            )),
      ),
    );
  }
}
