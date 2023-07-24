import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:parkfinda_mobile/controllers/account_controller.dart';
import 'package:parkfinda_mobile/controllers/user_controller.dart';
import 'package:parkfinda_mobile/model/card_detail.dart';
import 'package:parkfinda_mobile/widgets/atoms/app_label.dart';

import '../../../constants/app_colors.dart';

class WalletCardView extends StatelessWidget {
  final CardDetail cardDetail;
  WalletCardView({Key? key, required this.cardDetail}) : super(key: key);
  var userController = Get.find<UserController>();
  var accountController = Get.put(AccountController());

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: Row(
          children: [
            const SizedBox(
              width: 10,
            ),
            const FaIcon(FontAwesomeIcons.creditCard),
            const SizedBox(
              width: 20,
            ),
            AppLabel(
              text: cardDetail.ccNumber ?? '',
              textColor: AppColors.appColorGray,
            ),
            const Spacer(),
            Obx(
              () => Visibility(
                visible:
                    userController.cardList.value.length > 1 ? true : false,
                child: IconButton(
                  icon: const Icon(Icons.more_vert),
                  onPressed: () {
                    showEditCreditCardBottomSheet(
                        context: context, index: cardDetail.id!);
                  },
                ),
              ),
            ),
            const SizedBox(
              width: 10,
            ),
          ],
        ),
      ),
    );
  }

  void showEditCreditCardBottomSheet(
      {required BuildContext context, String? index}) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => SizedBox(
        height: MediaQuery.of(context).size.height * 0.35,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    color: AppColors.appColorWhite),
                child: Column(
                  children: [
                    const SizedBox(height: 20),

                    // InkWell(
                    //   child: Padding(
                    //     padding: const EdgeInsets.symmetric(vertical: 10.0),
                    //     child: AppLabel(
                    //       text: "Edit",
                    //       fontWeight: FontWeight.w500,
                    //     ),
                    //   ),
                    //   onTap: () {
                    //     //Get.to(EditVehicleScreen());
                    //   },
                    // ),
                    const Divider(
                      thickness: 1,
                      color: AppColors.appColorWhiteGray01,
                    ),
                    InkWell(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: AppLabel(
                          text: "Delete",
                          textColor: AppColors.appColorGoogleRed,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      onTap: () {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return CupertinoAlertDialog(
                                title: const Text(
                                  'Delete Card?',
                                  textAlign: TextAlign.left,
                                ),
                                content: const Text(
                                  'Are you sure you want to delete this card?',
                                  textAlign: TextAlign.left,
                                ),
                                actions: <Widget>[
                                  TextButton(
                                      onPressed: () {
                                        Get.back();
                                      },
                                      child: const Text('Cancel')),
                                  TextButton(
                                    onPressed: () {
                                      Get.back();
                                      accountController.deleteCard(
                                        billingId: index!,
                                        context: context,
                                      );
                                    },
                                    child: const Text(
                                      'Delete',
                                      style: TextStyle(
                                        color: Colors.red,
                                      ),
                                    ),
                                  )
                                ],
                              );
                            });
                      },
                    ),
                    const Divider(
                      thickness: 1,
                      color: AppColors.appColorWhiteGray01,
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Container(
                alignment: Alignment.center,
                width: MediaQuery.of(context).size.width,
                height: 50,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    color: AppColors.appColorWhite),
                child: InkWell(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: AppLabel(
                      text: "Cancel",
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  onTap: () {
                    Get.back();
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
