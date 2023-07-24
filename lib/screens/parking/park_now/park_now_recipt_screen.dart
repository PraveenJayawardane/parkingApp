import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:parkfinda_mobile/model/Bookingdetail.dart';
import 'package:parkfinda_mobile/utils/app_custom_toast.dart';
import 'package:parkfinda_mobile/utils/app_overlay.dart';

import '../../../constants/app_colors.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';

import '../../../widgets/molecules/buttons/bordered_button.dart';
import '../../../widgets/molecules/buttons/custom_filled_button.dart';
import 'package:downloads_path_provider_28/downloads_path_provider_28.dart';
import 'package:permission_handler/permission_handler.dart';

class ParkNowReceiptScreen extends StatelessWidget {
  ParkNowReceiptScreen({Key? key}) : super(key: key);

  BookingDetail bookingDetail = Get.arguments;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(
            Icons.arrow_back_ios,
            color: AppColors.appColorBlack,
          ),
        ),
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: const Text(
          "Receipt",
          style: TextStyle(color: AppColors.appColorBlack),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: const PDF(
              enableSwipe: true,
              swipeHorizontal: true,
              autoSpacing: false,
              pageFling: false,
            ).fromUrl(
              '${bookingDetail.invoiceURL}',
              placeholder: (progress) => Center(child: Text('$progress %')),
              errorWidget: (error) => Center(child: Text(error.toString())),
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
            child: Column(
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16.0, vertical: 5),
                  child: CustomFilledButton(
                      height: 40,
                      text: "Download Receipt",
                      clickEvent: () async {
                        {
                          AppOverlay.startOverlay(context);
                          Map<Permission, PermissionStatus> statuses = await [
                            Permission.storage,
                          ].request();

                          if (statuses[Permission.storage]!.isGranted) {
                            var dir =
                                await DownloadsPathProvider.downloadsDirectory;
                            if (dir != null) {
                              String savename =
                                  "${bookingDetail.bookingId}.pdf";
                              String savePath = "${dir.path}/$savename";
                              print(savePath);

                              try {
                                await Dio().download(
                                    bookingDetail.invoiceURL!, savePath,
                                    onReceiveProgress: (received, total) {
                                  if (total != -1) {
                                    print(
                                        "${(received / total * 100).toStringAsFixed(0)}%");
                                  }
                                });
                                print("File is saved to download folder.");
                                AppOverlay.hideOverlay();
                                AppCustomToast.successToast(
                                    'File is saved to download folder.');
                              } on DioError catch (e) {
                                print(e.message);
                                AppOverlay.hideOverlay();
                              }
                            }
                          } else {
                            AppOverlay.hideOverlay();
                            print("No permission to read and write.");
                          }
                        }
                      }),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: BorderedButton(
                      height: 40, text: "Email Receipt", clickEvent: () {}),
                ),
                const SizedBox(
                  height: 30,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
