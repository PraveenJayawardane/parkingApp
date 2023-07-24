import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';
import 'package:parkfinda_mobile/controllers/booking_controller.dart';
import 'package:parkfinda_mobile/controllers/park_now_controller.dart';
import 'package:parkfinda_mobile/widgets/atoms/app_label.dart';
import 'package:parkfinda_mobile/widgets/molecules/buttons/custom_filled_button.dart';
import 'package:parkfinda_mobile/widgets/molecules/input_fields/app_comment_box.dart';

import '../../constants/app_colors.dart';

class WriteReviewScreen extends StatelessWidget {
  WriteReviewScreen({Key? key}) : super(key: key);
  final GlobalKey<FormState> _commentKey = GlobalKey<FormState>();
  final TextEditingController _commentController = TextEditingController();
  // var parkingController = Get.find<ParkingNowController>();

  var q1Answer = true.obs;
  var q2Answer = true.obs;
  var q3Answer = true.obs;

  var ratedValue = 0.obs;
  var carParkId = Get.arguments;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: true,
        title: const Text(
          "Write Review",
          style: TextStyle(color: AppColors.appColorBlack),
        ),
      ),
      body: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.9,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Divider(
                thickness: 1,
                color: AppColors.appColorLightGray,
              ),
              Center(
                child: Column(children: [
                  AppLabel(text: 'Rate your parking'),
                  const SizedBox(
                    height: 16,
                  ),
                  RatingBar.builder(
                    itemCount: 5,
                    unratedColor: AppColors.appColorLightGray,
                    glowColor: AppColors.appColorWhite,
                    itemBuilder: (context, index) {
                      return const Icon(
                        Icons.star,
                        color: Colors.amber,
                      );
                    },
                    onRatingUpdate: (value) {
                      ratedValue.value = value.toInt();
                      print(value);
                    },
                  ),
                ]),
              ),
              const SizedBox(
                height: 16,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: AppLabel(
                  text: "Please share your opinion",
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 24,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Obx(() {
                  return Row(
                    children: [
                      AppLabel(
                          text: "The parking was easy to find", fontSize: 14),
                      const Spacer(),
                      IconButton(
                          onPressed: () {
                            q1Answer.value = !q1Answer.value;
                          },
                          icon: Icon(
                            Icons.thumb_up,
                            size: 20,
                            color: q1Answer.value
                                ? AppColors.appColorGreen
                                : AppColors.appColorLightGray,
                          )),
                      IconButton(
                          onPressed: () {
                            q1Answer.value = !q1Answer.value;
                          },
                          icon: Icon(
                            Icons.thumb_down,
                            size: 20,
                            color: !q1Answer.value
                                ? AppColors.appColorGreen
                                : AppColors.appColorLightGray,
                          ))
                    ],
                  );
                }),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Obx(() {
                  return Row(
                    children: [
                      AppLabel(
                          text: "The parking fits your vehicle", fontSize: 14),
                      const Spacer(),
                      IconButton(
                          onPressed: () {
                            q2Answer.value = !q2Answer.value;
                          },
                          icon: Icon(
                            Icons.thumb_up,
                            size: 20,
                            color: q2Answer.value
                                ? AppColors.appColorGreen
                                : AppColors.appColorLightGray,
                          )),
                      IconButton(
                          onPressed: () {
                            q2Answer.value = !q2Answer.value;
                          },
                          icon: Icon(
                            Icons.thumb_down,
                            size: 20,
                            color: !q2Answer.value
                                ? AppColors.appColorGreen
                                : AppColors.appColorLightGray,
                          ))
                    ],
                  );
                }),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Obx(() {
                  return Row(
                    children: [
                      AppLabel(
                        text: "You felt comfortable leaving \nyour vehicle",
                        fontSize: 14,
                      ),
                      const Spacer(),
                      IconButton(
                          onPressed: () {
                            q3Answer.value = !q3Answer.value;
                          },
                          icon: Icon(
                            Icons.thumb_up,
                            size: 20,
                            color: q3Answer.value
                                ? AppColors.appColorGreen
                                : AppColors.appColorLightGray,
                          )),
                      IconButton(
                          onPressed: () {
                            q3Answer.value = !q3Answer.value;
                          },
                          icon: Icon(
                            Icons.thumb_down,
                            size: 20,
                            color: !q3Answer.value
                                ? AppColors.appColorGreen
                                : AppColors.appColorLightGray,
                          ))
                    ],
                  );
                }),
              ),
              const SizedBox(
                height: 36,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: AppCommentBox(
                    formKey: _commentKey,
                    controller: _commentController,
                    inputType: TextInputType.text,
                    bgColor: AppColors.appColorLightGray.withOpacity(0.2),
                    maxLine: 5,
                    validator: MultiValidator(
                        [RequiredValidator(errorText: "Enter something here")]),
                    hintText:
                        "Any comments? Space owners and other drivers can see your comments (optional)"),
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Obx(
                  () => CustomFilledButton(
                      btnController: ratedValue.value != 0 ? true : false,
                      text: "Submit Review",
                      clickEvent: () {
                        print(ratedValue.value);
                        BookingController().createReview(
                            carParkId: carParkId,
                            date: DateTime.now().millisecondsSinceEpoch,
                            rating: ratedValue.value,
                            review: _commentController.text.isEmpty
                                ? null
                                : _commentController.text);
                        Get.back();
                      }),
                ),
              ),
              const SizedBox(
                height: 40,
              )
            ],
          ),
        ),
      ),
    );
  }
}
