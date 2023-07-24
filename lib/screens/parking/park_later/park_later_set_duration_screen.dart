import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:parkfinda_mobile/constants/routes.dart';
import 'package:parkfinda_mobile/controllers/park_later_controller.dart';
import 'package:parkfinda_mobile/controllers/user_controller.dart';
import 'package:parkfinda_mobile/services/local/shared_pref.dart';
import 'package:parkfinda_mobile/utils/app_bottom_sheets.dart';
import 'package:parkfinda_mobile/utils/app_custom_toast.dart';
import 'package:parkfinda_mobile/widgets/atoms/app_label.dart';
import 'package:parkfinda_mobile/widgets/molecules/buttons/custom_filled_button.dart';
import 'package:parkfinda_mobile/widgets/molecules/containers/location_code_view.dart';
import '../../../constants/app_colors.dart';
import '../../../controllers/park_now_controller.dart';
import '../../../widgets/molecules/buttons/ghost_button.dart';
import '../../accounts/nmi_payment_screen.dart';

class ParkLaterSetDurationScreen extends StatefulWidget {
  ParkLaterSetDurationScreen({
    Key? key,
  }) : super(key: key);

  var bookingType = Get.arguments;

  @override
  State<ParkLaterSetDurationScreen> createState() =>
      _ParkLaterSetDurationScreenState();
}

class _ParkLaterSetDurationScreenState
    extends State<ParkLaterSetDurationScreen> {
  var status = false.obs;
  var showParkingFrom = ''.obs;
  var showParkingUntil = ''.obs;
  var hours = 0.obs;
  var minutes = 0.obs;
  var difference = 0.obs;

  String? bottomSheetTitle;

  String? bottomSheetBodyText;

  var userController = Get.find<UserController>();

  var parkingController = Get.put(ParkingNowController());

  ParkingLaterController parkingLaterController =
      Get.find<ParkingLaterController>();

  getTime() {
    DateTime? defaultFromTime;
    defaultFromTime = parkingLaterController.parkingFromTime;

    //DEFAULT UNTIL TIME
    DateTime? defaultUntilTime;
    defaultUntilTime = parkingLaterController.parkingUntilTime;

    showParkingFrom.value =
        "${parkingLaterController.getFormattedDay(defaultFromTime!) != 'Today' ? parkingLaterController.parkingFromTime!.day : ''} ${parkingLaterController.getFormattedDay(defaultFromTime) != 'Today' ? parkingLaterController.getMonth(defaultFromTime.month) : ''} ${parkingLaterController.getFormattedDay(defaultFromTime)} at ${parkingLaterController.parkingFromTime!.hour < 10 ? "0${parkingLaterController.parkingFromTime!.hour}" : parkingLaterController.parkingFromTime!.hour} : ${parkingLaterController.parkingFromTime!.minute < 10 ? "0${parkingLaterController.parkingFromTime!.minute}" : parkingLaterController.parkingFromTime!.minute}";

    showParkingUntil.value =
        "${parkingLaterController.getFormattedDay(defaultUntilTime!) != 'Today' ? parkingLaterController.parkingUntilTime!.day : ''} ${parkingLaterController.getFormattedDay(defaultUntilTime) != 'Today' ? parkingLaterController.getMonth(defaultUntilTime.month) : ''} ${parkingLaterController.getFormattedDay(defaultUntilTime)} at ${parkingLaterController.parkingUntilTime!.hour < 10 ? "0${parkingLaterController.parkingUntilTime!.hour}" : parkingLaterController.parkingUntilTime!.hour} : ${parkingLaterController.parkingUntilTime!.minute < 10 ? "0${parkingLaterController.parkingUntilTime!.minute}" : parkingLaterController.parkingUntilTime!.minute}";
    difference.value = parkingLaterController.parkingUntilTime!
        .difference(parkingLaterController.parkingFromTime!)
        .inMinutes;
    hours.value = difference.value ~/ 60;
    minutes.value = difference.value % 60;
  }

  initialTime() {
    var defaultFromTime = DateTime.now().add(const Duration(minutes: 15));
    parkingLaterController.parkingFromTime = defaultFromTime;

    //DEFAULT UNTIL TIME
    var defaultUntilTime = DateTime.now().add(const Duration(minutes: 30));
    parkingLaterController.parkingUntilTime = defaultUntilTime;

    showParkingFrom.value =
        "${parkingLaterController.getFormattedDay(defaultFromTime) != 'Today' ? parkingLaterController.parkingFromTime!.day : ''} ${parkingLaterController.getFormattedDay(defaultFromTime) != 'Today' ? parkingLaterController.getMonth(defaultFromTime.month) : ''} ${parkingLaterController.getFormattedDay(defaultFromTime)} at ${parkingLaterController.parkingFromTime!.hour < 10 ? "0${parkingLaterController.parkingFromTime!.hour}" : parkingLaterController.parkingFromTime!.hour} : ${parkingLaterController.parkingFromTime!.minute < 10 ? "0${parkingLaterController.parkingFromTime!.minute}" : parkingLaterController.parkingFromTime!.minute}";

    showParkingUntil.value =
        "${parkingLaterController.getFormattedDay(defaultFromTime) != 'Today' ? parkingLaterController.parkingUntilTime!.day : ''} ${parkingLaterController.getFormattedDay(defaultFromTime) != 'Today' ? parkingLaterController.getMonth(defaultUntilTime.month) : ''} ${parkingLaterController.getFormattedDay(defaultUntilTime)} at ${parkingLaterController.parkingUntilTime!.hour < 10 ? "0${parkingLaterController.parkingUntilTime!.hour}" : parkingLaterController.parkingUntilTime!.hour} : ${parkingLaterController.parkingUntilTime!.minute < 10 ? "0${parkingLaterController.parkingUntilTime!.minute}" : parkingLaterController.parkingUntilTime!.minute}";
    difference = parkingLaterController.parkingUntilTime!
        .difference(parkingLaterController.parkingFromTime!)
        .inMinutes
        .obs;

    hours.value = difference.value ~/ 60;
    minutes.value = difference.value % 60;
  }

  @override
  void initState() {
    getTime();
    if (userController.vehicles?.value?.data?.isNotEmpty ?? false) {
      if (widget.bookingType == "Monthly") {
        parkingLaterController.calculateMonthlyBill(
            parkingId: parkingLaterController.parkLaterLocationData.id!,
            parkingFromTime:
                parkingLaterController.parkingFromTime!.millisecondsSinceEpoch,
            parkingUntilTime: parkingLaterController
                .parkingUntilTime!.millisecondsSinceEpoch);
      } else {
        parkingLaterController.calculateBill(
            parkingId: parkingLaterController.parkLaterLocationData.id!,
            //  context: context,
            parkingFromTime:
                parkingLaterController.parkingFromTime!.millisecondsSinceEpoch,
            parkingUntilTime: parkingLaterController
                .parkingUntilTime!.millisecondsSinceEpoch);
      }
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: AppColors.appColorBlack,
          ),
          onPressed: () {
            Get.back();
          },
        ),
        title: const Text(
          "Duration",
          style: TextStyle(color: AppColors.appColorBlack),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Divider(
                      thickness: 1,
                      color: AppColors.appColorLightGray,
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: LocationCodeView(
                        postCode: parkingLaterController
                                .parkLaterLocationData.postCode ??
                            '-',
                        parkingId:
                            '${parkingLaterController.parkLaterLocationData.carParkPIN ?? '-'}',
                        parkName: parkingLaterController
                                .parkLaterLocationData.carParkName ??
                            '-',
                        addressOne: parkingLaterController
                                .parkLaterLocationData.addressLineOne ??
                            '-',
                        city:
                            parkingLaterController.parkLaterLocationData.city ??
                                '-',
                        addressTow: parkingLaterController
                                .parkLaterLocationData.addressLineTwo ??
                            '-',
                      ),
                    ),

                    const SizedBox(
                      height: 16,
                    ),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: Card(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(
                                height: 8,
                              ),
                              Visibility(
                                visible: true,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  child: Row(
                                    children: [
                                      Expanded(
                                          child: InkWell(
                                        onTap: () {
                                          // initialTime();
                                          setCustomDurationParkLaterFromWithId(
                                              parkingLaterController
                                                  .parkLaterLocationData.id!);
                                        },
                                        child: Container(
                                          width: 150,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(6),
                                              border: Border.all(
                                                  color: AppColors
                                                      .appColorLightGray)),
                                          child: Column(
                                            children: [
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              AppLabel(
                                                text: "Park From",
                                                fontSize: 14,
                                                textColor:
                                                    AppColors.appColorLightGray,
                                              ),
                                              Obx(
                                                () => AppLabel(
                                                  text: showParkingFrom.value
                                                      .split('at')[1],
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              Obx(
                                                () => AppLabel(
                                                  text: showParkingFrom.value
                                                      .split('at')[0],
                                                  fontSize: 14,
                                                  textColor: AppColors
                                                      .appColorLightGray,
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                            ],
                                          ),
                                        ),
                                      )),
                                      const SizedBox(
                                        width: 16,
                                      ),
                                      Expanded(
                                          child: InkWell(
                                        onTap: () =>
                                            setCustomDurationParkLaterUntil(
                                                id: parkingLaterController
                                                    .parkLaterLocationData.id!),
                                        child: Container(
                                          width: 150,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(6),
                                              border: Border.all(
                                                  color: AppColors
                                                      .appColorLightGray)),
                                          child: Column(
                                            children: [
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              AppLabel(
                                                text: "Park Until",
                                                fontSize: 14,
                                                textColor:
                                                    AppColors.appColorLightGray,
                                              ),
                                              Obx(
                                                () => AppLabel(
                                                  text: showParkingUntil.value
                                                      .split('at')[1],
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              Obx(
                                                () => AppLabel(
                                                  text: showParkingUntil.value
                                                      .split('at')[0],
                                                  fontSize: 14,
                                                  textColor: AppColors
                                                      .appColorLightGray,
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                            ],
                                          ),
                                        ),
                                      )),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 4,
                              ),
                              Obx(() {
                                if (parkingLaterController
                                    .parkLaterPriceLoading.value) {
                                  return Container();
                                } else {
                                  return Container(
                                    color: AppColors.appColorLightGray
                                        .withOpacity(0.2),
                                    alignment: Alignment.center,
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10),
                                    child: Column(
                                      children: [
                                        AppLabel(
                                            text:
                                                "${hours > 0 ? "$hours Hours" : ""} ${minutes > 0 ? "$minutes Minutes" : ""}"),
                                        AppLabel(
                                          text: "Total Duration",
                                          fontSize: 14,
                                          textColor:
                                              AppColors.appColorLightGray,
                                        )
                                      ],
                                    ),
                                  );
                                }
                              })
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    ), //----->
                    Obx(() {
                      if (parkingLaterController.parkLaterPriceLoading.value) {
                        return const Center(
                            child: CircularProgressIndicator.adaptive());
                      } else {
                        return Column(
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  AppLabel(
                                    text: "Parking Fee",
                                    textColor: AppColors.appColorLightGray,
                                    fontSize: 14,
                                  ),
                                  AppLabel(
                                    text:
                                        '${parkingLaterController.parkingFee.data?.carpark?.currency ?? ''}${parkingLaterController.parkingFee.data?.price?.parkingFee?.toStringAsFixed(2) ?? '-'}',
                                    fontSize: 14,
                                  )
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 16,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      AppLabel(
                                        text: "Service Fee",
                                        textColor: AppColors.appColorLightGray,
                                        fontSize: 14,
                                      ),
                                      const SizedBox(
                                        width: 8,
                                      ),
                                      GestureDetector(
                                          onTap: () {
                                            infoBottomSheet(
                                                context,
                                                bottomSheetTitle =
                                                    "Service Fee",
                                                bottomSheetBodyText =
                                                    "Service fees is cost of running the platform and providing customer support on your booking.");
                                          },
                                          child: const Icon(
                                            Icons.info,
                                            size: 18,
                                            color: AppColors.appColorLightGray,
                                          ))
                                    ],
                                  ),
                                  AppLabel(
                                    text:
                                        '${parkingLaterController.parkingFee.data?.carpark?.currency ?? ''}${parkingLaterController.parkingFee.data?.price?.serviceFee?.toStringAsFixed(2) ?? '-'}',
                                    fontSize: 14,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 16,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  AppLabel(
                                    text: "Total Parking Fee",
                                    fontSize: 15,
                                  ),
                                  AppLabel(
                                    text:
                                        '${parkingLaterController.parkingFee.data?.carpark?.currency ?? ''}${parkingLaterController.parkingFee.data?.price?.total?.toStringAsFixed(2) ?? '-'}',
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ],
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16.0),
                              child: Divider(
                                thickness: 1,
                                color: AppColors.appColorLightGray,
                              ),
                            )
                          ],
                        );
                      }
                    }),
                    const SizedBox(
                      height: 16,
                    ),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: AppLabel(text: "Vehicle"),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    InkWell(
                      onTap: () {
                        if (SharedPref.isGuestAccount()) {
                          Get.toNamed(Routes.ADD_VEHICLE_SCREEN);
                        } else {
                          Get.toNamed(Routes.MY_VEHICLES_SCREEN);
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Row(
                                    children: [
                                      const FaIcon(
                                        FontAwesomeIcons.car,
                                        size: 18,
                                      ),
                                      const SizedBox(
                                        width: 16,
                                      ),
                                      Obx(
                                        () => Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const SizedBox(
                                              height: 20,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                AppLabel(
                                                    fontSize: 14,
                                                    text: userController
                                                            .selectedVehicle
                                                            ?.value
                                                            ?.vRN ??
                                                        'Add Vehicle'),
                                                const SizedBox(
                                                  width: 10,
                                                ),
                                                AppLabel(
                                                    fontSize: 12,
                                                    fontWeight:
                                                        FontWeight.normal,
                                                    text: userController
                                                            .selectedVehicle
                                                            ?.value
                                                            ?.model ??
                                                        ''),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                AppLabel(
                                                    fontSize: 10,
                                                    textColor: AppColors
                                                        .appColorGray03,
                                                    text: userController
                                                            .selectedVehicle
                                                            ?.value
                                                            ?.color ??
                                                        ''),
                                                const SizedBox(
                                                  width: 10,
                                                ),
                                                AppLabel(
                                                    fontSize: 10,
                                                    textColor: AppColors
                                                        .appColorGray03,
                                                    text: userController
                                                                .selectedVehicle
                                                                ?.value
                                                                ?.fuelType !=
                                                            null
                                                        ? '(${userController.selectedVehicle?.value?.fuelType ?? ''})'
                                                        : "")
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                      const Spacer(),
                                      IconButton(
                                          icon: const FaIcon(
                                              FontAwesomeIcons.penToSquare),
                                          onPressed: () {
                                            if (SharedPref.isGuestAccount()) {
                                              Get.toNamed(
                                                  Routes.ADD_VEHICLE_SCREEN);
                                            } else {
                                              Get.toNamed(
                                                  Routes.MY_VEHICLES_SCREEN);
                                            }
                                          }),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const Divider(
                              thickness: 1,
                              color: AppColors.appColorLightGray,
                            )
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: AppLabel(text: "Payments"),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    InkWell(
                      onTap: () {
                        if (SharedPref.isGuestAccount()) {
                          AppBottomSheet().signUpBottomSheet(context);
                        } else {
                          if (userController.selectedCard == null) {
                            AppCustomToast.warningToast(
                                'Please Add Vehicle To Continue');
                          } else {
                            if (parkingLaterController
                                    .parkingFee.data?.carpark?.currency ==
                                'LKR') {
                              if (userController.selectedCard.value?.ccNumber ==
                                  null) {
                                if (widget.bookingType == "Monthly") {
                                  parkingLaterController
                                      .payHereDraftBookingMonthly(
                                          parkingId: parkingLaterController
                                              .parkLaterLocationData.id!,
                                          context: context,
                                          parkingFromTime:
                                              parkingLaterController
                                                  .parkingFromTime!
                                                  .millisecondsSinceEpoch,
                                          parkingUntilTime:
                                              parkingLaterController
                                                  .parkingUntilTime!
                                                  .millisecondsSinceEpoch);
                                } else {
                                  parkingLaterController
                                      .payHereHourleyParkLaterDraftBooking(
                                          parkingId: parkingLaterController
                                              .parkLaterLocationData.id!,
                                          context: context,
                                          parkingFromTime:
                                              parkingLaterController
                                                  .parkingFromTime!
                                                  .millisecondsSinceEpoch,
                                          parkingUntilTime:
                                              parkingLaterController
                                                  .parkingUntilTime!
                                                  .millisecondsSinceEpoch);
                                }
                              } else {
                                Get.toNamed(arguments: [
                                  'parkLater',
                                  '${widget.bookingType}',
                                  parkingLaterController
                                      .parkingFee.data!.price!.total!
                                      .toStringAsFixed(2),
                                  parkingLaterController
                                      .parkingFee.data?.carpark?.currency
                                ], Routes.PAYMENT_OPTION_SCREEN);
                              }
                            } else {
                              if (userController.selectedCard.value?.ccNumber ==
                                  null) {
                                Get.to(NmiPaymentScreen(
                                  price: parkingLaterController
                                      .parkingFee.data!.price!.total!
                                      .toStringAsFixed(2),
                                  bookigType: '${widget.bookingType}',
                                  parkingType: 'parkLater',
                                ));
                              } else {
                                Get.toNamed(arguments: [
                                  'parkLater',
                                  '${widget.bookingType}',
                                  parkingLaterController
                                      .parkingFee.data!.price!.total!
                                      .toStringAsFixed(2),
                                  parkingLaterController
                                      .parkingFee.data?.carpark?.currency
                                ], Routes.PAYMENT_OPTION_SCREEN);
                              }
                            }
                          }
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: GestureDetector(
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Obx(
                                          () => InkWell(
                                            onTap: () {
                                              if (SharedPref.isGuestAccount()) {
                                                AppBottomSheet()
                                                    .signUpBottomSheet(context);
                                              } else {
                                                // ignore: unnecessary_null_comparison
                                                if (userController
                                                        .selectedCard ==
                                                    null) {
                                                  AppCustomToast.warningToast(
                                                      'Please Add Vehicle To Continue');
                                                } else {
                                                  if (parkingLaterController
                                                          .parkingFee
                                                          .data
                                                          ?.carpark
                                                          ?.currency ==
                                                      'LKR') {
                                                    if (userController
                                                            .selectedCard
                                                            .value
                                                            ?.ccNumber ==
                                                        null) {
                                                      if (widget.bookingType ==
                                                          "Monthly") {
                                                        parkingLaterController.payHereDraftBookingMonthly(
                                                            parkingId:
                                                                parkingLaterController
                                                                    .parkLaterLocationData
                                                                    .id!,
                                                            context: context,
                                                            parkingFromTime:
                                                                parkingLaterController
                                                                    .parkingFromTime!
                                                                    .millisecondsSinceEpoch,
                                                            parkingUntilTime:
                                                                parkingLaterController
                                                                    .parkingUntilTime!
                                                                    .millisecondsSinceEpoch);
                                                      } else {
                                                        parkingLaterController.payHereHourleyParkLaterDraftBooking(
                                                            parkingId:
                                                                parkingLaterController
                                                                    .parkLaterLocationData
                                                                    .id!,
                                                            context: context,
                                                            parkingFromTime:
                                                                parkingLaterController
                                                                    .parkingFromTime!
                                                                    .millisecondsSinceEpoch,
                                                            parkingUntilTime:
                                                                parkingLaterController
                                                                    .parkingUntilTime!
                                                                    .millisecondsSinceEpoch);
                                                      }
                                                    } else {
                                                      Get.toNamed(
                                                          arguments: [
                                                            'parkLater',
                                                            '${widget.bookingType}',
                                                            parkingLaterController
                                                                .parkingFee
                                                                .data!
                                                                .price!
                                                                .total!
                                                                .toStringAsFixed(
                                                                    2),
                                                            parkingLaterController
                                                                .parkingFee
                                                                .data
                                                                ?.carpark
                                                                ?.currency
                                                          ],
                                                          Routes
                                                              .PAYMENT_OPTION_SCREEN);
                                                    }
                                                  } else {
                                                    if (userController
                                                            .selectedCard
                                                            .value
                                                            ?.ccNumber ==
                                                        null) {
                                                      Get.to(NmiPaymentScreen(
                                                        price:
                                                            parkingLaterController
                                                                .parkingFee
                                                                .data!
                                                                .price!
                                                                .total!
                                                                .toStringAsFixed(
                                                                    2),
                                                        bookigType:
                                                            '${widget.bookingType}',
                                                        parkingType:
                                                            'parkLater',
                                                      ));
                                                    } else {
                                                      Get.toNamed(
                                                          arguments: [
                                                            'parkLater',
                                                            '${widget.bookingType}',
                                                            parkingLaterController
                                                                .parkingFee
                                                                .data!
                                                                .price!
                                                                .total!
                                                                .toStringAsFixed(
                                                                    2),
                                                            parkingLaterController
                                                                .parkingFee
                                                                .data
                                                                ?.carpark
                                                                ?.currency
                                                          ],
                                                          Routes
                                                              .PAYMENT_OPTION_SCREEN);
                                                    }
                                                  }
                                                }
                                              }
                                            },
                                            child: userController
                                                        .selectedCard.value ==
                                                    null
                                                ? const Text('Add Payment')
                                                : Row(
                                                    children: [
                                                      const Icon(
                                                          FontAwesomeIcons
                                                              .creditCard,
                                                          size: 20,
                                                          color: AppColors
                                                              .appColorBlack),
                                                      const SizedBox(
                                                        width: 10,
                                                      ),
                                                      Text(
                                                        userController
                                                                .selectedCard
                                                                .value
                                                                ?.ccNumber
                                                                ?.replaceRange(
                                                                    4, 4, ' ')
                                                                .replaceRange(
                                                                    9, 9, ' ')
                                                                .replaceRange(
                                                                    14,
                                                                    14,
                                                                    ' ') ??
                                                            '',
                                                        style: const TextStyle(
                                                            color: AppColors
                                                                .appColorGray,
                                                            fontSize: 12),
                                                      ),
                                                    ],
                                                  ),
                                          ),
                                        ),
                                        const Spacer(),
                                        InkWell(
                                          child: const FaIcon(
                                              FontAwesomeIcons.penToSquare),
                                          onTap: () {
                                            if (SharedPref.isGuestAccount()) {
                                              AppBottomSheet()
                                                  .signUpBottomSheet(context);
                                            } else {
                                              // ignore: unnecessary_null_comparison
                                              if (userController.selectedCard ==
                                                  null) {
                                                AppCustomToast.warningToast(
                                                    'Please Add Vehicle To Continue');
                                              } else {
                                                if (parkingLaterController
                                                        .parkingFee
                                                        .data
                                                        ?.carpark
                                                        ?.currency ==
                                                    'LKR') {
                                                  if (userController
                                                          .selectedCard.value ==
                                                      null) {
                                                    if (widget.bookingType ==
                                                        "Monthly") {
                                                      parkingLaterController.payHereDraftBookingMonthly(
                                                          parkingId:
                                                              parkingLaterController
                                                                  .parkLaterLocationData
                                                                  .id!,
                                                          context: context,
                                                          parkingFromTime:
                                                              parkingLaterController
                                                                  .parkingFromTime!
                                                                  .millisecondsSinceEpoch,
                                                          parkingUntilTime:
                                                              parkingLaterController
                                                                  .parkingUntilTime!
                                                                  .millisecondsSinceEpoch);
                                                    } else {
                                                      parkingLaterController.payHereHourleyParkLaterDraftBooking(
                                                          parkingId:
                                                              parkingLaterController
                                                                  .parkLaterLocationData
                                                                  .id!,
                                                          context: context,
                                                          parkingFromTime:
                                                              parkingLaterController
                                                                  .parkingFromTime!
                                                                  .millisecondsSinceEpoch,
                                                          parkingUntilTime:
                                                              parkingLaterController
                                                                  .parkingUntilTime!
                                                                  .millisecondsSinceEpoch);
                                                    }
                                                  } else {
                                                    Get.toNamed(
                                                        arguments: [
                                                          'parkLater',
                                                          '${widget.bookingType}',
                                                          parkingLaterController
                                                              .parkingFee
                                                              .data!
                                                              .price!
                                                              .total!
                                                              .toStringAsFixed(
                                                                  2),
                                                          parkingLaterController
                                                              .parkingFee
                                                              .data
                                                              ?.carpark
                                                              ?.currency
                                                        ],
                                                        Routes
                                                            .PAYMENT_OPTION_SCREEN);
                                                  }
                                                } else {
                                                  if (userController
                                                          .selectedCard
                                                          .value
                                                          ?.ccNumber ==
                                                      null) {
                                                    Get.to(NmiPaymentScreen(
                                                      price:
                                                          parkingLaterController
                                                              .parkingFee
                                                              .data!
                                                              .price!
                                                              .total!
                                                              .toStringAsFixed(
                                                                  2),
                                                      bookigType:
                                                          '${widget.bookingType}',
                                                      parkingType: 'parkLater',
                                                    ));
                                                  } else {
                                                    Get.toNamed(
                                                        arguments: [
                                                          'parkLater',
                                                          '${widget.bookingType}',
                                                          parkingLaterController
                                                              .parkingFee
                                                              .data!
                                                              .price!
                                                              .total!
                                                              .toStringAsFixed(
                                                                  2),
                                                          parkingLaterController
                                                              .parkingFee
                                                              .data
                                                              ?.carpark
                                                              ?.currency
                                                        ],
                                                        Routes
                                                            .PAYMENT_OPTION_SCREEN);
                                                  }
                                                }
                                              }
                                            }
                                          },
                                        ),
                                        const SizedBox(
                                          width: 15,
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Divider(
                        thickness: 1,
                        color: AppColors.appColorLightGray,
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Row(
                        children: [
                          AppLabel(
                            text: "Cancellation policy",
                            textColor: AppColors.appColorLightGray,
                            fontSize: 14,
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          GestureDetector(
                              onTap: () {
                                infoBottomSheet(
                                    context,
                                    bottomSheetTitle = "Cancellation policy",
                                    bottomSheetBodyText =
                                        "By making a booking or reservation on our Mobile, Website or Call to Park, you accept and agree to the relevant parking booking conditions, including cancellation and no-show policies. Please refer to the Terms & Conditions Above for more details.\n\n•	Within 24 hours of the time when the parking session is due to start no refund will be issued.\n\n•	At least 24 hours before the time when the parking session is due to start full refund without the service fee.\n\n•	After the parking session has started no refund will be issued.");
                              },
                              child: const Icon(
                                Icons.info,
                                size: 18,
                                color: AppColors.appColorLightGray,
                              ))
                        ],
                      ),
                    ),

                    const SizedBox(
                      height: 16,
                    ),

                    const SizedBox(
                      height: 16,
                    ),

                    const SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),
            ),
            Container(
              decoration: const BoxDecoration(
                  color: AppColors.appColorWhite,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey,
                      offset: Offset(0.0, 1.0),
                      blurRadius: 6.0,
                    ),
                  ]),
              child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 10),
                  child: Obx(
                    () => CustomFilledButton(
                        btnController:
                            // ignore: prefer_is_empty
                            userController.selectedVehicle?.value?.vRN !=
                                    null &&
                                !parkingLaterController
                                    .parkLaterPriceLoading.value &&
                                userController.selectedCard.value?.ccNumber !=
                                    null,
                        text: "Confirm and Pay",
                        bgColor: AppColors.appColorBlack,
                        clickEvent: () {
                          if (SharedPref.isGuestAccount()) {
                            AppBottomSheet().signUpBottomSheet(context);
                          } else {
                            if (userController.selectedCard.value?.ccNumber !=
                                null) {
                              if (parkingLaterController
                                      .parkingFee.data?.carpark?.currency ==
                                  'LKR') {
                                if (widget.bookingType == "Monthly") {
                                  parkingLaterController.draftBookingMonthly(
                                      billingId:
                                          userController.selectedCard.value?.id,
                                      cardType: 'payhere',
                                      cavv: null,
                                      directoryServerId: null,
                                      eci: null,
                                      firstName: null,
                                      lastName: null,
                                      paymentToken: null,
                                      threeDsVersion: null,
                                      parkingFromTime: parkingLaterController
                                          .parkingFromTime!
                                          .millisecondsSinceEpoch,
                                      parkingId: parkingLaterController
                                          .parkLaterLocationData.id!,
                                      parkingUntilTime: parkingLaterController
                                          .parkingUntilTime!
                                          .millisecondsSinceEpoch,
                                      context: context);
                                } else {
                                  parkingLaterController.parkLaterDraftBooking(
                                      billingId:
                                          userController.selectedCard.value?.id,
                                      cardType: 'payhere',
                                      cavv: null,
                                      directoryServerId: null,
                                      eci: null,
                                      firstName: null,
                                      lastName: null,
                                      paymentToken: null,
                                      threeDsVersion: null,
                                      parkingId: parkingLaterController
                                          .parkLaterLocationData.id!,
                                      context: context,
                                      parkingFromTime: parkingLaterController
                                          .parkingFromTime!
                                          .millisecondsSinceEpoch,
                                      parkingUntilTime: parkingLaterController
                                          .parkingUntilTime!
                                          .millisecondsSinceEpoch);
                                }
                              } else {
                                if (widget.bookingType == "Monthly") {
                                  parkingLaterController.draftBookingMonthly(
                                      billingId:
                                          userController.selectedCard.value?.id,
                                      cardType: 'existing',
                                      cavv: null,
                                      directoryServerId: null,
                                      eci: null,
                                      firstName: null,
                                      lastName: null,
                                      paymentToken: null,
                                      threeDsVersion: null,
                                      parkingFromTime: parkingLaterController
                                          .parkingFromTime!
                                          .millisecondsSinceEpoch,
                                      parkingId: parkingLaterController
                                          .parkLaterLocationData.id!,
                                      parkingUntilTime: parkingLaterController
                                          .parkingUntilTime!
                                          .millisecondsSinceEpoch,
                                      context: context);
                                } else {
                                  parkingLaterController.parkLaterDraftBooking(
                                      billingId:
                                          userController.selectedCard.value?.id,
                                      cardType: 'existing',
                                      cavv: null,
                                      directoryServerId: null,
                                      eci: null,
                                      firstName: null,
                                      lastName: null,
                                      paymentToken: null,
                                      threeDsVersion: null,
                                      parkingId: parkingLaterController
                                          .parkLaterLocationData.id!,
                                      context: context,
                                      parkingFromTime: parkingLaterController
                                          .parkingFromTime!
                                          .millisecondsSinceEpoch,
                                      parkingUntilTime: parkingLaterController
                                          .parkingUntilTime!
                                          .millisecondsSinceEpoch);
                                }
                              }
                            } else {
                              if (parkingLaterController
                                      .parkingFee.data?.carpark?.currency ==
                                  'LKR') {
                                if (widget.bookingType == "Monthly") {
                                  parkingLaterController
                                      .payHereDraftBookingMonthly(
                                          parkingId: parkingLaterController
                                              .parkLaterLocationData.id!,
                                          context: context,
                                          parkingFromTime:
                                              parkingLaterController
                                                  .parkingFromTime!
                                                  .millisecondsSinceEpoch,
                                          parkingUntilTime:
                                              parkingLaterController
                                                  .parkingUntilTime!
                                                  .millisecondsSinceEpoch);
                                } else {
                                  parkingLaterController
                                      .payHereHourleyParkLaterDraftBooking(
                                          parkingId: parkingLaterController
                                              .parkLaterLocationData.id!,
                                          context: context,
                                          parkingFromTime:
                                              parkingLaterController
                                                  .parkingFromTime!
                                                  .millisecondsSinceEpoch,
                                          parkingUntilTime:
                                              parkingLaterController
                                                  .parkingUntilTime!
                                                  .millisecondsSinceEpoch);
                                }
                              } else {
                                if (userController
                                        .selectedCard.value?.ccNumber ==
                                    null) {
                                  Get.to(NmiPaymentScreen(
                                    price: parkingLaterController
                                        .parkingFee.data!.price!.total!
                                        .toStringAsFixed(2),
                                    bookigType: '${widget.bookingType}',
                                    parkingType: 'parkLater',
                                  ));
                                } else {
                                  Get.toNamed(arguments: [
                                    'parkLater',
                                    '${widget.bookingType}',
                                    parkingLaterController
                                        .parkingFee.data!.price!.total!
                                        .toStringAsFixed(2)
                                  ], Routes.PAYMENT_OPTION_SCREEN);
                                }
                              }
                            }
                          }
                        }),
                  )),
            ),
          ],
        ),
      ),
    );
  }

  void setCustomDurationParkLaterFromWithId(String? id) {
    int year = DateTime.now().year;
    int month = DateTime.now().month;
    int day = DateTime.now().day;
    int hours = DateTime.now().hour;
    int minutes = DateTime.now().minute;

    showModalBottomSheet(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20), topRight: Radius.circular(20)),
      ),
      context: context,
      backgroundColor: AppColors.appColorWhite,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GhostButton(
                  text: "Cancel",
                  clickEvent: () {
                    Get.back();
                  },
                  color: AppColors.appColorGray,
                ),
                AppLabel(
                  text: "Park From",
                  fontWeight: FontWeight.w500,
                ),
                GhostButton(
                  text: "Next",
                  clickEvent: () {
                    Get.back();
                    setCustomDurationParkLaterUntil(id: id);

                    // ignore: deprecated_member_use
                  },
                  color: AppColors.appColorLightBlue,
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                color: AppColors.appColorWhite,
                height: 200,
                width: 300,
                child: SizedBox(
                  height: 75,
                  child: CupertinoTheme(
                    data: const CupertinoThemeData(
                      brightness: Brightness.light,
                      textTheme: CupertinoTextThemeData(
                          pickerTextStyle: TextStyle(
                        color: Color(0xffB59CCF),
                        fontSize: 18,
                      )),
                    ),
                    child: CupertinoDatePicker(
                        minimumDate: DateTime.now(),
                        maximumDate: parkingLaterController.parkingFromTime!
                            .add(const Duration(days: 30)),
                        initialDateTime: parkingLaterController.parkingFromTime,
                        use24hFormat: true,
                        onDateTimeChanged: ((pickedDateTime) {
                          print(pickedDateTime);
                          parkingLaterController.parkingFromTime =
                              pickedDateTime;
                          parkingLaterController.parkingUntilTime =
                              pickedDateTime.add(const Duration(minutes: 15));
                          // showParkingFrom.value =
                          //     "${parkingLaterController.parkingFromTime!.day} ${parkingLaterController.getMonth(pickedDateTime.month)} ${parkingLaterController.getFormattedDay(pickedDateTime)} at ${parkingLaterController.parkingFromTime!.hour < 10 ? "0${parkingLaterController.parkingFromTime!.hour}" : parkingLaterController.parkingFromTime!.hour} : ${parkingLaterController.parkingFromTime!.minute < 10 ? "0${parkingLaterController.parkingFromTime!.minute}" : parkingLaterController.parkingFromTime!.minute}";

                          showParkingFrom.value =
                              "${parkingLaterController.getFormattedDay(parkingLaterController.parkingFromTime!) != 'Today' ? parkingLaterController.parkingFromTime!.day : ''} ${parkingLaterController.getFormattedDay(parkingLaterController.parkingFromTime!) != 'Today' ? parkingLaterController.getMonth(parkingLaterController.parkingFromTime!.month) : ''} ${parkingLaterController.getFormattedDay(parkingLaterController.parkingFromTime!)} at ${parkingLaterController.parkingFromTime!.hour < 10 ? "0${parkingLaterController.parkingFromTime!.hour}" : parkingLaterController.parkingFromTime!.hour} : ${parkingLaterController.parkingFromTime!.minute < 10 ? "0${parkingLaterController.parkingFromTime!.minute}" : parkingLaterController.parkingFromTime!.minute}";
                          showParkingUntil.value =
                              "${parkingLaterController.getFormattedDay(pickedDateTime.add(const Duration(minutes: 15))) != 'Today' ? pickedDateTime.add(const Duration(minutes: 15)).day : ''} ${parkingLaterController.getFormattedDay(pickedDateTime.add(const Duration(minutes: 15))) != 'Today' ? parkingLaterController.getMonth(pickedDateTime.add(const Duration(minutes: 15)).month) : ''} ${parkingLaterController.getFormattedDay(pickedDateTime.add(const Duration(minutes: 15)))} at ${pickedDateTime.add(const Duration(minutes: 15)).hour < 10 ? "0${pickedDateTime.add(const Duration(minutes: 15)).hour}" : pickedDateTime.add(const Duration(minutes: 15)).hour} : ${pickedDateTime.add(const Duration(minutes: 15)).minute < 10 ? "0${pickedDateTime.add(const Duration(minutes: 15)).minute}" : pickedDateTime.add(const Duration(minutes: 15)).minute}";
                          print(showParkingFrom.value);
                        })),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void setCustomDurationParkLaterUntil({String? id}) {
    showModalBottomSheet(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20), topRight: Radius.circular(20)),
      ),
      context: context,
      backgroundColor: AppColors.appColorWhite,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GhostButton(
                  text: "Cancel",
                  clickEvent: () {
                    Get.back();
                  },
                  color: AppColors.appColorGray,
                ),
                AppLabel(
                  text: "Park Until",
                  fontWeight: FontWeight.w500,
                ),
                GhostButton(
                  text: "Done",
                  clickEvent: () async {
                    Get.back();
                    if (userController.vehicles?.value?.data?.isNotEmpty ??
                        false) {
                      if (widget.bookingType == "Monthly") {
                        print(widget.bookingType);
                        parkingLaterController.calculateMonthlyBill(
                            parkingId: parkingLaterController
                                .parkLaterLocationData.id!,
                            parkingFromTime: parkingLaterController
                                .parkingFromTime!.millisecondsSinceEpoch,
                            parkingUntilTime: parkingLaterController
                                .parkingUntilTime!.millisecondsSinceEpoch);
                      } else {
                        print(parkingLaterController.parkingFromTime);
                        print(parkingLaterController.parkingUntilTime);
                        parkingLaterController.calculateBill(
                            parkingId: parkingLaterController
                                .parkLaterLocationData.id!,
                            parkingFromTime: parkingLaterController
                                .parkingFromTime!.millisecondsSinceEpoch,
                            parkingUntilTime: parkingLaterController
                                .parkingUntilTime!.millisecondsSinceEpoch);
                      }
                      difference = parkingLaterController.parkingUntilTime!
                          .difference(parkingLaterController.parkingFromTime!)
                          .inMinutes
                          .obs;

                      hours.value = difference.value ~/ 60;
                      minutes.value = difference.value % 60;
                    }
                  },
                  color: AppColors.appColorLightBlue,
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                color: AppColors.appColorWhite,
                height: 200,
                width: 300,
                child: SizedBox(
                  height: 75,
                  child: CupertinoTheme(
                    data: const CupertinoThemeData(
                      brightness: Brightness.light,
                      textTheme: CupertinoTextThemeData(
                          pickerTextStyle: TextStyle(
                        color: Color(0xffB59CCF),
                        fontSize: 18,
                      )),
                    ),
                    child: CupertinoDatePicker(
                        minimumDate: parkingLaterController.parkingFromTime!
                            .add(const Duration(minutes: 15)),
                        maximumDate: parkingLaterController.parkingFromTime!
                            .add(const Duration(days: 30)),
                        initialDateTime:
                            parkingLaterController.parkingUntilTime!,
                        use24hFormat: true,
                        onDateTimeChanged: ((pickedDateTime) {
                          parkingLaterController.parkingUntilTime =
                              pickedDateTime;
                          showParkingUntil.value =
                              "${parkingLaterController.getFormattedDay(pickedDateTime) != 'Today' ? parkingLaterController.parkingUntilTime!.day : ''} ${parkingLaterController.getFormattedDay(pickedDateTime) != 'Today' ? parkingLaterController.getMonth(pickedDateTime.month) : ''} ${parkingLaterController.getFormattedDay(pickedDateTime)} at ${parkingLaterController.parkingUntilTime!.hour < 10 ? "0${parkingLaterController.parkingUntilTime!.hour}" : parkingLaterController.parkingUntilTime!.hour} : ${parkingLaterController.parkingUntilTime!.minute < 10 ? "0${parkingLaterController.parkingUntilTime!.minute}" : parkingLaterController.parkingUntilTime!.minute}";
                          difference = parkingLaterController.parkingUntilTime!
                              .difference(
                                  parkingLaterController.parkingFromTime!)
                              .inMinutes
                              .obs;

                          // hours.value = difference.value ~/ 60;
                          // minutes.value = difference.value % 60;
                          // print(hours);
                          // print(minutes);
                        })),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void infoBottomSheet(
      BuildContext context, bottomSheetTitle, bottomSheetBodyText) {
    showModalBottomSheet(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20), topRight: Radius.circular(20)),
      ),
      context: context,
      backgroundColor: AppColors.appColorWhite,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                  onPressed: () {
                    Get.back();
                  },
                  icon: const Icon(Icons.clear))
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: AppLabel(text: bottomSheetTitle),
          ),
          const SizedBox(
            height: 12,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: AppLabel(
              text: bottomSheetBodyText,
              fontSize: 12,
              textColor: AppColors.appColorGray,
            ),
          ),
          const SizedBox(
            height: 60,
          )
        ],
      ),
    );
  }
}
