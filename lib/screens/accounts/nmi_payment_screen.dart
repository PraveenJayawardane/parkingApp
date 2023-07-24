import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:parkfinda_mobile/constants/routes.dart';
import 'package:parkfinda_mobile/controllers/account_controller.dart';
import 'package:parkfinda_mobile/controllers/booking_controller.dart';
import 'package:parkfinda_mobile/services/local/shared_pref.dart';
import 'package:parkfinda_mobile/utils/app_custom_toast.dart';
import 'package:parkfinda_mobile/utils/app_overlay.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../constants/app_colors.dart';
import '../../controllers/navigation_controllers/bottom_navigation_controller.dart';
import '../../controllers/park_later_controller.dart';
import '../../controllers/park_now_controller.dart';
import '../../controllers/user_controller.dart';

class NmiPaymentScreen extends StatelessWidget {
  final String parkingType;
  final String bookigType;
  final String price;
  late WebViewController _webViewController;
  NmiPaymentScreen({
    Key? key,
    required this.parkingType,
    required this.price,
    required this.bookigType,
  }) : super(key: key);

  var accountController = Get.put(AccountController());
  var userController = Get.find<UserController>();
  var bookingController = Get.find<BookingController>();
  String? token;
  String? cavv;
  String? directoryServerId;
  String? eci;
  String? threeDsVersion;
  String? cardHolderAuth;

  var parkingController = Get.put(ParkingNowController());

  ParkingLaterController parkingLaterController =
      Get.put(ParkingLaterController());

  @override
  Widget build(BuildContext context) {
    print('price is');
    print(price);
    print(parkingController.bookAgainId);
    print(bookingController.baseUrl);
    var nmiPaymentAndroid = """

<html>
    <head>
        <meta name="viewport" content="width=device-width, initial-scale=0.5">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-KK94CHFLLe+nY2dmCWGMq91rCGa5gtU4mk92HdvYe+M/SXH301p5ILy+dN9+nJOZ" crossorigin="anonymous">
    </head>
    <style>
    .payment-field {
        border-bottom: 1px solid #0000;
    }
    #threeDSMountPoint {
        text-align: center !important;
        scale: 1.8;
        height: 1;
    }
    .input[type="text"]:focus{ 
        border-bottom-color: #1CC48B !important;
        border-bottom-style: solid;
        border-bottom-width: 2px;
     }
    .loader {
      border: 16px solid #f3f3f3;
      border-radius: 50%;
      border-top: 16px solid black;
      width: 120px;
      height: 120px;
      -webkit-animation: spin 2s linear infinite; /* Safari */
      animation: spin 2s linear infinite;
      display:none;
      text-align:-webkit-center;
}
    }

/* Safari */
@-webkit-keyframes spin {
  0% { -webkit-transform: rotate(0deg); }
  100% { -webkit-transform: rotate(360deg); }
}

@keyframes spin {
  0% { transform: rotate(0deg); }
  100% { transform: rotate(360deg); }
}
    </style>
<body>
    <section style="font-size: 36px; margin: 0px 16px;" class="payment-form bg-transparent" id="paymentForm">
        <div class="row">
            <div class="col-12">
            <form action="">
                <div>
                    <input type="hidden" name="variant" value="inline" class="border-0">
                </div>
                <div class="my-5">
                    <input type="hidden" name="amount" value="5.00">
                </div>
                <div class="formInner my-2">
                    <div class="payment-field mb-4 f-2">
                        <label for="">First Name</label>
                        <input type="text" name="fname" placeholder="Enter First Name" value="" autofocus style="width:100%; border:unset !important; border-bottom: 2px solid #000000 !important;outline:none;">
                    </div>
                    <div class="payment-field my-4 f-2">
                        <label for="">Last Name</label>
                        <input type="text" name="lname" placeholder="Enter Last Name" value="" autofocus style="width:100%; border:unset !important; border-bottom: 2px solid #000000 !important;outline:none;">
                    </div>
                    <div id="payment-field my-4">
                        <label for=""> Card Number</label>
                        <div class="payment-field my-3" id="ccnumber" autofocus style="width:100%; border:unset !important; border-bottom: 3px solid #000000 !important;"></div>
                        <div class="row">
                            <div class="col-6">
                                <label for="">Expiry</label>
                            <div class="payment-field my-3" id="ccexp" autofocus style="width:100%; border:unset !important; border-bottom: 2px solid #000000 !important"></div>
                         </div>
                            <div class="col-6">
                                <label for="">CVV</label>
                                <div class="payment-field my-3" id="cvv" autofocus style="width:100%; border:unset !important; border-bottom: 2px solid #000000 !important"></div>
                            </div>
                        </div> 
                    </div>
                    <div class="payment-field my-4 f-2">
                        <label for="">Postal Code</label>
                        <input type="text"  oninput="this.value = this.value.toUpperCase()" name="lname" placeholder="Enter Postal Code" value="" autofocus style="width:100%; border:unset !important; border-bottom: 2px solid #000000 !important;outline:none;">
                    </div>
                </div>
                <div class="my-5">
                    <button type="submit" id="payButton" class="btn btn-primary btn-block" style="background-color: black; color: #fff; border-radius: 10px; padding: 15px; width:100%; font-size: 36px !important; margin-top: 10vh;">
                        Save Card
                    </button>
                </div>
            </form>
        </div>
        </div>
    </section>
    <div style="width: 100%">
    <div id="loader" class="loader" style="margin:0 auto"></div>
    <div id="paymentTokenInfo"></div>

    <div id="threeDSMountPoint"></div>
   

    <script src="https://secure.nmi.com/js/v1/Gateway.js"></script>
    <script src="https://secure.nmi.com/token/Collect.js" data-tokenization-key="W4QpuN-hJp2BM-G755WN-c7C32V"></script>
    <script>

       

        const gateway = Gateway.create('checkout_public_d7tpW8Ew35Tc8K9fm6sg2G59ph9VmHJt');
        const threeDS = gateway.get3DSecure();

        window.addEventListener('DOMContentLoaded', () => {
            CollectJS.configure({
                variant: 'inline',
                invalidCss: {
                  color: '#B40E3E'
                },
                validCss: {
                  color: '#14855F',
                },
                customCss: {
                  'border-color': '#FFFFFF',
                  'border-style': 'solid'
                },
                focusCss: {
                  'border-bottom-color': '#1CC48B',
                  'border-bottom-style': 'solid',
                  'border-bottom-width': '2px',
                },
                fields: {
                    ccnumber: {
                        placeholder: 'xxxx-xxxx-xxxx-xxxx',
                        selector: '#ccnumber'
                    },
                    ccexp: {
                        placeholder: 'MM/YY',
                        selector: '#ccexp'
                    },
                    cvv: {
                        placeholder: '***',
                        selector: '#cvv'
                    }
                },
                callback: (e) => {
			
                    const options = {
                        paymentToken: e.token,
                        currency: 'GBP',
                        amount: '${price == '' ? '0.00' : price}',
                        email: 'none@example.com',
                        phone: '8008675309',
                        city: 'New York',
                        state: 'NY',
                        address1: '123 Fist St.',
                        country: 'US',
                        firstName: '${SharedPref().getUser().firstName}',
                        lastName:'${SharedPref().getUser().lastName}',
                        postalCode: '60001',
                        challengeIndicator: "04",
                    };

                    const threeDSecureInterface = threeDS.createUI(options);
			              threeDSecureInterface.start('#threeDSMountPoint');
                   

                    threeDSecureInterface.on('challenge', function (e) {
                        var loader = document.getElementById("loader");
                        loader.style.display = 'none';
				                const form = document.getElementById("paymentForm");
    			  	          form.style.display = "none";
                    });

                    threeDSecureInterface.on('complete', function (b) {
                        
                     console.log("completed", e.token);
                        Token.postMessage(e.token);
                        Cavv.postMessage(b.cavv);
                        DirectoryServerId.postMessage(b.directoryServerId);
                        Eci.postMessage(b.eci);
                        ThreeDsVersion.postMessage(b.threeDsVersion);
                        CardHolderAuth.postMessage(b.cardHolderAuth);
                    });

                    threeDSecureInterface.on('failure', function (e) {
                          Fail.postMessage('fail');
                        console.log('failure');
                        console.log(e);
                    });
                }
            })

            gateway.on('error', function (e) {
                  Fail.postMessage('fail');
                console.error(e);
            })
        })

        document.getElementById("payButton").onclick = function() {
          var button = document.getElementById("payButton");
          var loader = document.getElementById("loader");
          var form = document.getElementById("paymentForm");
    			form.style.display = "none";
          loader.style.display = 'block';
          button.disabled = true;
        }
    </script>
</body>

</html>""";

    var nmiPaymentIos = """

<html>
    <head>
        <meta name="viewport" content="width=device-width, initial-scale=0.1">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-KK94CHFLLe+nY2dmCWGMq91rCGa5gtU4mk92HdvYe+M/SXH301p5ILy+dN9+nJOZ" crossorigin="anonymous">
    </head>
    <style>
    .payment-field {
        border-bottom: 1px solid #0000;
    }
    #threeDSMountPoint {
        text-align: center !important;
        scale: 1.8;
        height: 1;
    }
    .input[type="text"]:focus{ 
        border-bottom-color: #1CC48B !important;
        border-bottom-style: solid;
        border-bottom-width: 2px;
     }

         .loader {
      border: 16px solid #f3f3f3;
      border-radius: 50%;
      border-top: 16px solid black;
      width: 120px;
      height: 120px;
      -webkit-animation: spin 2s linear infinite; /* Safari */
      animation: spin 2s linear infinite;
      display:none;
      text-align:-webkit-center;
}
    }

/* Safari */
@-webkit-keyframes spin {
  0% { -webkit-transform: rotate(0deg); }
  100% { -webkit-transform: rotate(360deg); }
}

@keyframes spin {
  0% { transform: rotate(0deg); }
  100% { transform: rotate(360deg); }
}
    </style>
<body>
    <section style="font-size: 16px; margin: 0px 16px;" class="payment-form bg-transparent" id="paymentForm">
        <div class="row">
            <div class="col-12">
            <form action="">
                <div>
                    <input type="hidden" name="variant" value="inline" class="border-0">
                </div>
                <div class="my-5">
                    <input type="hidden" name="amount" value="5.00">
                </div>
                <div class="formInner my-2">
                    <div class="payment-field mb-4 f-2">
                        <label for="">First Name</label>
                        <input type="text" name="fname" placeholder="Enter First Name" value="" autofocus style="width:100%; border:unset !important; border-bottom: 2px solid #000000 !important;outline:none;">
                    </div>
                    <div class="payment-field my-4 f-2">
                        <label for="">Last Name</label>
                        <input type="text" name="lname" placeholder="Enter Last Name" value="" autofocus style="width:100%; border:unset !important; border-bottom: 2px solid #000000 !important;outline:none;">
                    </div>
                    <div id="payment-field my-4">
                        <label for=""> Card Number</label>
                        <div class="payment-field my-3" id="ccnumber" autofocus style="width:100%; border:unset !important; border-bottom: 3px solid #000000 !important;"></div>
                        <div class="row">
                            <div class="col-6">
                                <label for="">Expiry</label>
                            <div class="payment-field my-3" id="ccexp" autofocus style="width:100%; border:unset !important; border-bottom: 2px solid #000000 !important"></div>
                         </div>
                            <div class="col-6">
                                <label for="">CVV</label>
                                <div class="payment-field my-3" id="cvv" autofocus style="width:100%; border:unset !important; border-bottom: 2px solid #000000 !important"></div>
                            </div>
                        </div> 
                    </div>
                    <div class="payment-field my-4 f-2">
                        <label for="">Postal Code</label>
                        <input type="text"  oninput="this.value = this.value.toUpperCase()" name="lname" placeholder="Enter Postal Code" value="" autofocus style="width:100%; border:unset !important; border-bottom: 2px solid #000000 !important;outline:none;">
                    </div>
                </div>
                <div class="my-5">
                    <button type="submit" id="payButton" class="btn btn-primary btn-block" style="background-color: black; color: #fff; border-radius: 10px; padding: 15px; width:100%; font-size: 16px !important; margin-top: 10vh;">
                        Save Card
                    </button>
                </div>
            </form>
        </div>
        </div>
    </section>
     <div style="width: 100%">
    <div id="loader" class="loader" style="margin:0 auto"></div>
    <div id="paymentTokenInfo"></div>

    <div id="threeDSMountPoint"></div>
   

    <script src="https://secure.nmi.com/js/v1/Gateway.js"></script>
    <script src="https://secure.nmi.com/token/Collect.js" data-tokenization-key="W4QpuN-hJp2BM-G755WN-c7C32V"></script>
    <script>

       

        const gateway = Gateway.create('checkout_public_d7tpW8Ew35Tc8K9fm6sg2G59ph9VmHJt');
        const threeDS = gateway.get3DSecure();

        window.addEventListener('DOMContentLoaded', () => {
            CollectJS.configure({
                variant: 'inline',
                invalidCss: {
                  color: '#B40E3E'
                },
                validCss: {
                  color: '#14855F',
                },
                customCss: {
                  'border-color': '#FFFFFF',
                  'border-style': 'solid'
                },
                focusCss: {
                  'border-bottom-color': '#1CC48B',
                  'border-bottom-style': 'solid',
                  'border-bottom-width': '2px',
                },
                fields: {
                    ccnumber: {
                        placeholder: 'xxxx-xxxx-xxxx-xxxx',
                        selector: '#ccnumber'
                    },
                    ccexp: {
                        placeholder: 'MM/YY',
                        selector: '#ccexp'
                    },
                    cvv: {
                        placeholder: '***',
                        selector: '#cvv'
                    }
                },
                callback: (e) => {
                    const options = {
                        paymentToken: e.token,
                        currency: 'GBP',
                        amount: '${price == '' ? '0.00' : price}',
                        email: 'none@example.com',
                        phone: '8008675309',
                        city: 'New York',
                        state: 'NY',
                        address1: '123 Fist St.',
                        country: 'US',
                        firstName: '${SharedPref().getUser().firstName}',
                        lastName:'${SharedPref().getUser().lastName}',
                        postalCode: '60001',
                        challengeIndicator: "04",
                    };

                    const threeDSecureInterface = threeDS.createUI(options);
			              threeDSecureInterface.start('#threeDSMountPoint');
                   

                    threeDSecureInterface.on('challenge', function (e) {
                        var loader = document.getElementById("loader");
                        loader.style.display = 'none';
				                const form = document.getElementById("paymentForm");
    			  	          form.style.display = "none";
			
  		    	  	
                    });

                    threeDSecureInterface.on('complete', function (b) {
                        
                     console.log("completed", e.token);
                        Token.postMessage(e.token);
                        Cavv.postMessage(b.cavv);
                        DirectoryServerId.postMessage(b.directoryServerId);
                        Eci.postMessage(b.eci);
                        ThreeDsVersion.postMessage(b.threeDsVersion);
                        CardHolderAuth.postMessage(b.cardHolderAuth)
                    });

                    threeDSecureInterface.on('failure', function (e) {
                          Fail.postMessage('fail');
                        console.log('failure');
                        console.log(e);
                    });
                }
            })

            gateway.on('error', function (e) {
                  Fail.postMessage('fail');
                console.error(e);
            })
        })

         document.getElementById("payButton").onclick = function() {
          var button = document.getElementById("payButton");
          var loader = document.getElementById("loader");
          var form = document.getElementById("paymentForm");
    			form.style.display = "none";
          loader.style.display = 'block';
          button.disabled = true;
        }
    </script>
</body>

</html>""";
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Payment",
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
            color: AppColors.appColorWhite,
            constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width,
                maxHeight: MediaQuery.of(context).size.height * 0.8),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: WebView(
                initialUrl: Uri.dataFromString(
                  defaultTargetPlatform == TargetPlatform.android
                      ? nmiPaymentAndroid
                      : nmiPaymentIos,
                  mimeType: 'text/html',
                  encoding: Encoding.getByName('utf-8')!,
                ).toString(),
                javascriptMode: JavascriptMode.unrestricted,
                backgroundColor: AppColors.appColorWhite,
                zoomEnabled: false,
                onProgress: (progress) {
                  AppOverlay.startPaymentOverlay(context);
                },
                onPageFinished: (url) async {
                  Future.delayed(const Duration(seconds: 3), (() {
                    AppOverlay.hideOverlay();
                  }));
                },
                onWebViewCreated: (WebViewController controller) async {
                  _webViewController = controller;

                  // await _loadHtmlFileFormAssets();
                },
                javascriptChannels: {
                  JavascriptChannel(
                      name: 'Token',
                      onMessageReceived: (JavascriptMessage message) async {
                        token = message.message;
                      }),
                  JavascriptChannel(
                    name: 'Cavv',
                    onMessageReceived: (message) {
                      cavv = message.message;
                    },
                  ),
                  JavascriptChannel(
                    name: 'DirectoryServerId',
                    onMessageReceived: (message) {
                      directoryServerId = message.message;
                    },
                  ),
                  JavascriptChannel(
                    name: 'Eci',
                    onMessageReceived: (message) {
                      eci = message.message;
                    },
                  ),
                  JavascriptChannel(
                    name: 'ThreeDsVersion',
                    onMessageReceived: (message) {
                      threeDsVersion = message.message;
                    },
                  ),
                  JavascriptChannel(
                    name: 'CardHolderAuth',
                    onMessageReceived: (message) {
                      cardHolderAuth = message.message;

                      if (cardHolderAuth != null) {
                        print(parkingType);
                        if (price != '') {
                          print(price);
                          if (parkingType == "parkNow") {
                            print('park now-->data');
                            if (context.mounted) {
                              parkingController.draftBooking(
                                  billingId: null,
                                  cardType: 'new',
                                  cavv: cavv!,
                                  directoryServerId: directoryServerId!,
                                  eci: eci!,
                                  firstName: SharedPref().getUser().firstName,
                                  lastName: SharedPref().getUser().lastName,
                                  paymentToken: token!,
                                  threeDsVersion: threeDsVersion,
                                  ctrl: parkingController,
                                  context: context,
                                  parkingFromTime: parkingController
                                      .parkingFromTime!.millisecondsSinceEpoch,
                                  parkingUntilTime: parkingController
                                      .parkingUntilTime!
                                      .millisecondsSinceEpoch);
                            }
                          } else if (parkingType == 'parkLater') {
                            if (bookigType == "Monthly") {
                              // ignore: use_build_context_synchronously
                              parkingLaterController.draftBookingMonthly(
                                  billingId: null,
                                  cardType: 'new',
                                  cavv: cavv!,
                                  directoryServerId: directoryServerId!,
                                  eci: eci!,
                                  firstName: SharedPref().getUser().firstName,
                                  lastName: SharedPref().getUser().lastName,
                                  paymentToken: token!,
                                  threeDsVersion: threeDsVersion,
                                  parkingFromTime: parkingLaterController
                                      .parkingFromTime!.millisecondsSinceEpoch,
                                  parkingId: parkingLaterController
                                      .parkLaterLocationData.id!,
                                  parkingUntilTime: parkingLaterController
                                      .parkingUntilTime!.millisecondsSinceEpoch,
                                  context: context);
                            } else {
                              // ignore: use_build_context_synchronously
                              parkingLaterController.parkLaterDraftBooking(
                                  billingId: null,
                                  cardType: 'new',
                                  cavv: cavv!,
                                  directoryServerId: directoryServerId!,
                                  eci: eci!,
                                  firstName: SharedPref().getUser().firstName,
                                  lastName: SharedPref().getUser().lastName,
                                  paymentToken: token!,
                                  threeDsVersion: threeDsVersion,
                                  parkingId: parkingLaterController
                                      .parkLaterLocationData.id!,
                                  context: context,
                                  parkingFromTime: parkingLaterController
                                      .parkingFromTime!.millisecondsSinceEpoch,
                                  parkingUntilTime: parkingLaterController
                                      .parkingUntilTime!
                                      .millisecondsSinceEpoch);
                            }
                          }
                        } else {
                          accountController.saveCardDetail(
                              url: bookingController.baseUrl.value,
                              paymentToken: token!,
                              context: context,
                              controller: parkingController);
                        }
                      } else {
                        var bottomNavigation =
                            Get.find<BottomNavigationController>();
                        bottomNavigation.activeIndex.value = 0;
                        Get.toNamed(Routes.DIRECT_DASHBOARD);
                        AppCustomToast.errorToast('Unable to process payment');
                      }
                    },
                  ),
                  JavascriptChannel(
                    name: 'Fail',
                    onMessageReceived: (message) {
                      var bottomNavigation =
                          Get.find<BottomNavigationController>();
                      bottomNavigation.activeIndex.value = 0;
                      Get.toNamed(Routes.DIRECT_DASHBOARD);
                      AppCustomToast.errorToast('Unable to process payment');
                    },
                  ),
                },
              ),
            ),
          )
        ],
      ),
    );
  }

  Future _loadHtmlFileFormAssets() async {
    String fileText = await rootBundle.loadString(
        defaultTargetPlatform == TargetPlatform.android
            ? "assets/html/nmi_payment_android.html"
            : "assets/html/nmi_payment_ios.html");
    _webViewController.loadUrl(Uri.dataFromString(fileText,
            mimeType: 'text/html', encoding: Encoding.getByName('utf-8'))
        .toString());
  }
}
