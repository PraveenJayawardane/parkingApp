import 'package:get/get.dart';
import 'package:parkfinda_mobile/main.dart';
import 'package:parkfinda_mobile/middlewares/login_middleware.dart';
import 'package:parkfinda_mobile/middlewares/otp_middleware.dart';
import 'package:parkfinda_mobile/middlewares/update_middleware.dart';
import 'package:parkfinda_mobile/screens/accounts/change_name_screen.dart';
import 'package:parkfinda_mobile/screens/accounts/change_password_screen.dart';
import 'package:parkfinda_mobile/screens/accounts/change_phone_number_screen.dart';
import 'package:parkfinda_mobile/screens/accounts/edit_profile_screen.dart';
import 'package:parkfinda_mobile/screens/accounts/faq_screen.dart';
import 'package:parkfinda_mobile/screens/accounts/help_screen.dart';
import 'package:parkfinda_mobile/screens/accounts/my_vehicles_screen.dart';
import 'package:parkfinda_mobile/screens/accounts/my_wallet_screen.dart';
import 'package:parkfinda_mobile/screens/accounts/notification_screen.dart';
import 'package:parkfinda_mobile/screens/accounts/payment_option_screen.dart';
import 'package:parkfinda_mobile/screens/accounts/privacy_policy.dart';
import 'package:parkfinda_mobile/screens/accounts/region_screen.dart';
import 'package:parkfinda_mobile/screens/accounts/select_country_screen.dart';
import 'package:parkfinda_mobile/screens/accounts/single_faq_screen.dart';
import 'package:parkfinda_mobile/screens/accounts/touch_with_us_screen.dart';
import 'package:parkfinda_mobile/screens/auth/OTP_pin_verification_screen.dart';
import 'package:parkfinda_mobile/screens/auth/OTP_verification_screen.dart';
import 'package:parkfinda_mobile/screens/auth/forgot_password_OTP_screen.dart';
import 'package:parkfinda_mobile/screens/auth/forgot_password_reset_screen.dart';
import 'package:parkfinda_mobile/screens/auth/forgot_password_screen.dart';
import 'package:parkfinda_mobile/screens/auth/get_started_screen.dart';
import 'package:parkfinda_mobile/screens/auth/login_screen.dart';
import 'package:parkfinda_mobile/screens/auth/signup_screen.dart';
import 'package:parkfinda_mobile/screens/parking/park_again/park_again_screen.dart';
import 'package:parkfinda_mobile/screens/payment/park_now_payment_screen.dart';
import 'package:parkfinda_mobile/screens/dashboard/dashboard_navigation.dart';
import 'package:parkfinda_mobile/screens/parking/add_foreign_vehicle_screen.dart';
import 'package:parkfinda_mobile/screens/parking/add_payment_method_screen.dart';
import 'package:parkfinda_mobile/screens/parking/park_later/street_view_screen.dart';
import 'package:parkfinda_mobile/screens/parking/park_now/enter_location_screen.dart';
import 'package:parkfinda_mobile/screens/parking/park_later/park_later_booked_details_screen.dart';
import 'package:parkfinda_mobile/screens/parking/park_later/park_later_extend_booking_Screen.dart';
import 'package:parkfinda_mobile/screens/parking/park_now/park_now_dont_Know_parking_booked_details_screen.dart';
import 'package:parkfinda_mobile/screens/parking/park_now/park_now_set_duration_screen.dart';
import 'package:parkfinda_mobile/screens/dashboard/parking_search_screen.dart';
import 'package:parkfinda_mobile/screens/parking/parking_summery_screen.dart';
import 'package:parkfinda_mobile/screens/parking/receipt_screen.dart';
import 'package:parkfinda_mobile/screens/parking/park_later/park_later_search_result_map_screen.dart';
import 'package:parkfinda_mobile/screens/parking/select_vehicle_screen.dart';
import '../screens/accounts/my_vehical/add_vehicle_screen.dart';
import '../screens/accounts/my_vehical/change_vehicle_screen.dart';
import '../screens/accounts/terms_of_use_screen.dart';
import '../screens/auth/location_service_screen.dart';
import '../screens/booking/booking_details_tabs/dont_know_parking_booking_status_tab.dart';
import '../screens/booking/booking_fixed_duration_details_tab_screen.dart';
import '../screens/booking/single_booking_screen.dart';
import '../screens/booking/write_review_screen.dart';

import '../screens/dashboard/home_screen.dart';
import '../screens/parking/park_later/park_later_set_duration_screen.dart';
import '../screens/parking/park_now/book_again_set_duration_screen.dart';
import '../screens/parking/park_now/park_now_fixed_duration_recipt_screen.dart';
import '../screens/parking/park_now/park_now_recipt_screen.dart';
import '../screens/parking/qr_code_screen.dart';
import '../screens/payment/dont_know_parking_payment_screen.dart';
import '../screens/update_screen.dart';

class Routes {
  static const MY_APP = "/";
  static const LOCATION_SERVICE_SCREEN = "/LocationServiceScreen";
  static const LOGIN = "/Login";
  static const SIGNUP = "/Signup";
  static const FORGET_PASSWORD_SCREEN = "/ForgotPasswordScreen";
  static const FORGET_PASSWORD_RESET_SCREEN = "/ForgotPasswordResetScreen";
  static const FORGET_PASSWORD_OTP_SCREEN = "/ForgotPasswordOTPScreen";
  static const OTP_PIN_VERIFICATION_SCREEN = "/OTPPinVerificationScreen";
  static const OTP_VERIFICATION_SCREEN = "/OTPVerificationScreen";
  static const DASHBOARD = "/Dashboard";
  static const DIRECT_DASHBOARD = "/DirectDashbord";
  static const EDIT_PROFILE_SCREEN = "/EditProfileScreen";
  static const GET_STARTED_SCREEN = "/GetStartedScreen";
  static const MY_VEHICLES_SCREEN = "/MyVehiclesScreen";
  static const MY_WALLET_SCREEN = "/MyWalletScreen";
  static const NOTIFICATION_SCREEN = "/NotificationScreen";
  static const TERMS_OF_USE_SCREEN = "/TermsOfUseScreen";
  static const PRIVACY_POLICY_SCREEN = "/PrivacyPolicyScreen";
  static const HELP_SCREEN = "/HelpScreen";
  static const CHANGE_NAME_SCREEN = "/ChangeNameScreen";
  static const CHANGE_PASSWORD_SCREEN = "/ChangePasswordScreen";
  static const CHANGE_PHONE_NUMBER_SCREEN = "/ChangePhoneNumberScreen";
  static const FAQ_SCREEN = "/FAQScreen";
  static const TOUCH_WITH_US_SCREEN = "/TouchWithUsScreen";
  static const SINGLE_FAQ_SCREEN = "/SingleFAQScreen";
  static const ENTER_LOCATION_SCREEN = "/EnterLocationScreen";
  static const ENTER_LOCATION_DETAILS_SCREEN = "/EnterLocationDetailsScreen";
  static const SELECT_VEHICLE_SCREEN = "/SelectVehicleScreen";
  static const ADD_VEHICLE_SCREEN = "/AddVehicleScreen";
  static const ADD_FOREIGN_VEHICLE_SCREEN = "/AddForeignVehicleScreen";
  static const ADD_PAYMENT_METHOD_SCREEN = "/AddPaymentMethodScreen";
  static const PARKING_DETAILS_SCREEN = "/ParkingDetailsScreen";
  static const PARKING_SUMMERY_SCREEN = "/ParkingSummeryScreen";
  static const RECEIPT_SCREEN = "/ReceiptScreen";
  static const PARKING_SEARCH_SCREEN = "/ParkingSearchScreen";
  static const SEARCH_RESULT_MAP_SCREEN = "/SearchResultMapScreen";
  static const PARK_LATER_EXTEND_BOOKING_SCREEN =
      "/ParkLaterExtendBookingScreen";
  static const PARK_LATER_BOOKED_DETAILS_SCREEN =
      "/ParkLaterBookedDetailsScreen";
  static const PARK_NOW_SET_DURATION_SCREEN = "/ParkNowSetDurationScreen";
  static const PARK_NOW_FIXED_DURATION_DETAILS_SCREEN = "/ParkNowDetailsScreen";
  static const PARK_NOW_DONT_KNOW_PARKING_DETAILS_SCREEN =
      "/ParkNowDontKnowParkingDetailsScreen";
  static const PAYMENT_OPTION_SCREEN = "/PaymentOptionScreen";
  static const QR_CODE_SCREEN = "/QrCodeScreen";
  static const STREET_VIEW_SCREEN = "/StreetViewScreen";
  static const SINGLE_BOOK_SCREEN = "/SingleBookingScreen";
  static const PAYMENT_SCREEN = "/PaymentScreen";
  static const BOOKING_FIXED_DURATION_DETAILS_TAB_SCREEN =
      "/BookingFixedDurationDetailsTabScreen";
  static const DONT_KNOW_PARKING_PAYMENT_SCREEN =
      "/DontKnowParkingPaymentScreen";

  static const PARK_NOWPARKING_REGISTRATION_BOOKED_DETAILS_SCREEN =
      "/ParkNowDontKnowParkingRegisterBookedDetailsScreen";

  static const WRITE_REVIEW_SCREEN = "/WriteReviewScreen";
  static const PARK_AGAIN_SCREEN = "/ParkAgainScreen";
  static const EXTEND_BOOKING_DURATION_SCREEN = "/ExtendBookingDurationScreen";
  static const CANCELLATION_POLICY_SCREEN = "/CancellationPolicyScreen";
  static const PARK_NOW_RECIPT_SCREEN = "/ParkNowReceiptScreen";
  static const PARK_LATER_SET_DURATION_SCREEN = "/ParkLaterSetDurationScreen";
  static const HOME_SCREEN = "/HomeScreen";
  static const PARK_NOW_FIXED_DURATION_RECIPT_SCREEN =
      "/ParkNowFixedDurationReceiptScreen";
  static const PARK_NOW_PAYMENT_SCREEN = "/ParkNowPaymentScreen";
  static const BOOK_AGAIN_SET_DURATION_SCREEN = "/BookAgainSetDurationScreen";
  static const DONTKNOW_PARKING_BOOKING_STATUS_TAB =
      "/DontKnowParkingBookingStatusTab";
  static const CHANGE_VEHICAL_SCREEN = "/ChangeVehicleScreen";
  static const UPDATE_SCREEN = "/UpdateScreen";
  static const REGION_SCREEN = "/RegionScreen";
  static const SELECT_COUNTRY_SCREEN = "/SelectCountryScreen";
  //SelectCountryScreen
  //UpdateScreen
  //DontKnowParkingBookingStatusTab
  //ChangeVehicleScreen

  static List<GetPage> getPageRoutes() {
    return [
      GetPage(name: MY_APP, page: () => const MyApp()),
      GetPage(name: UPDATE_SCREEN, page: () => const UpdateScreen()),
      GetPage(name: LOGIN, page: () => const LoginScreen()),
      GetPage(
          name: CHANGE_VEHICAL_SCREEN, page: () => const ChangeVehicleScreen()),
      GetPage(
          name: LOCATION_SERVICE_SCREEN,
          page: () => const LocationServiceScreen()),
      GetPage(
          name: DONTKNOW_PARKING_BOOKING_STATUS_TAB,
          page: () => DontKnowParkingBookingStatusTab()),
      GetPage(name: SIGNUP, page: () => const SignUpScreen()),
      GetPage(
          name: FORGET_PASSWORD_SCREEN,
          page: () => const ForgotPasswordScreen()),
      GetPage(name: GET_STARTED_SCREEN, page: () => const GetStartedScreen()),
      GetPage(
          name: FORGET_PASSWORD_RESET_SCREEN,
          page: () => ForgotPasswordResetScreen()),
      GetPage(
          name: FORGET_PASSWORD_OTP_SCREEN,
          page: () => ForgotPasswordOTPScreen()),
      GetPage(
          name: OTP_PIN_VERIFICATION_SCREEN,
          page: () => OTPPinVerificationScreen()),
      GetPage(
          name: OTP_VERIFICATION_SCREEN, page: () => OTPVerificationScreen()),
      GetPage(name: DASHBOARD, page: () => DashboardNavigation(), middlewares: [
        UpdateMiddleware(),
        LoginMiddleware(),
        OtpMiddleware(),
      ]),
      GetPage(
        name: EDIT_PROFILE_SCREEN,
        page: () => const EditProfileScreen(),
        transition: Transition.fade,
      ),
      GetPage(
        name: MY_VEHICLES_SCREEN,
        page: () => const MyVehiclesScreen(),
      ),
      GetPage(name: MY_WALLET_SCREEN, page: () => MyWalletScreen()),
      GetPage(name: NOTIFICATION_SCREEN, page: () => NotificationScreen()),
      GetPage(name: TERMS_OF_USE_SCREEN, page: () => TermsOfUseScreen()),
      GetPage(name: PRIVACY_POLICY_SCREEN, page: () => PrivacyPolicyScreen()),
      GetPage(name: HELP_SCREEN, page: () => const HelpScreen()),
      GetPage(name: REGION_SCREEN, page: () => const RegionScreen()),
      GetPage(name: CHANGE_NAME_SCREEN, page: () => ChangeNameScreen()),
      GetPage(
          name: CHANGE_PASSWORD_SCREEN,
          page: () => ChangePasswordScreen(),
          transition: Transition.fade),
      GetPage(
          name: CHANGE_PHONE_NUMBER_SCREEN,
          page: () => ChangePhoneNumberScreen()),
      GetPage(name: FAQ_SCREEN, page: () => const FAQScreen()),
      GetPage(name: TOUCH_WITH_US_SCREEN, page: () => TouchWithUsScreen()),
      GetPage(name: SINGLE_FAQ_SCREEN, page: () => const SingleFAQScreen()),
      GetPage(name: ENTER_LOCATION_SCREEN, page: () => EnterLocationScreen()),
      GetPage(name: SELECT_VEHICLE_SCREEN, page: () => SelectVehicleScreen()),
      GetPage(
          name: ADD_VEHICLE_SCREEN,
          page: () => AddVehicleScreen(),
          transition: Transition.fade),
      GetPage(
          name: ADD_FOREIGN_VEHICLE_SCREEN,
          page: () => AddForeignVehicleScreen(),
          transition: Transition.fade),
      GetPage(
          name: ADD_PAYMENT_METHOD_SCREEN,
          page: () => AddPaymentMethodScreen()),
      GetPage(name: PARKING_SUMMERY_SCREEN, page: () => ParkingSummeryScreen()),
      GetPage(name: RECEIPT_SCREEN, page: () => ReceiptScreen()),
      GetPage(
          name: PARKING_SEARCH_SCREEN, page: () => const ParkingSearchScreen()),
      GetPage(
          name: SEARCH_RESULT_MAP_SCREEN,
          page: () => const ParkLaterSearchResultMapScreen()),
      GetPage(
          name: PARK_LATER_EXTEND_BOOKING_SCREEN,
          page: () => ParkLaterExtendBookingScreen()),

      GetPage(
          name: PARK_LATER_BOOKED_DETAILS_SCREEN,
          page: () => ParkLaterBookedDetailsScreen()),
      GetPage(
          name: PARK_NOW_SET_DURATION_SCREEN,
          page: () => ParkNowSetDurationScreen()),
      /*GetPage(
          name: PARK_NOW_FIXED_DURATION_DETAILS_SCREEN,
          page: () => ParkNowFixedDurationBookedDetailsScreen()),*/
      GetPage(
          name: PARK_NOW_DONT_KNOW_PARKING_DETAILS_SCREEN,
          page: () => ParkNowDontKnowParkingBookedDetailsScreen()),
      GetPage(name: PAYMENT_OPTION_SCREEN, page: () => PaymentOptionScreen()),
      GetPage(name: QR_CODE_SCREEN, page: () => const QRCodeScreen()),
      GetPage(name: STREET_VIEW_SCREEN, page: () => StreetViewScreen()),
      GetPage(
        name: DIRECT_DASHBOARD,
        page: () => DashboardNavigation(),
      ),
      GetPage(
        name: SINGLE_BOOK_SCREEN,
        page: () => const SingleBookingScreen(),
      ),
      GetPage(
        name: PAYMENT_SCREEN,
        page: () => ParkNowPaymentScreen(),
      ),
      GetPage(
        name: BOOKING_FIXED_DURATION_DETAILS_TAB_SCREEN,
        page: () => BookingFixedDurationDetailsTabScreen(),
      ),
      GetPage(
        name: DONT_KNOW_PARKING_PAYMENT_SCREEN,
        page: () => DontKnowParkingPaymentScreen(),
      ),
      /*GetPage(
        name: PARK_NOWPARKING_REGISTRATION_BOOKED_DETAILS_SCREEN,
        page: () => ParkNowDontKnowParkingRegisterBookedDetailsScreen(),
      ),*/
      GetPage(
        name: WRITE_REVIEW_SCREEN,
        page: () => WriteReviewScreen(),
      ),
      GetPage(
        name: PARK_AGAIN_SCREEN,
        page: () => ParkAgainScreen(),
      ),

      GetPage(
        name: PARK_NOW_RECIPT_SCREEN,
        page: () => ParkNowReceiptScreen(),
      ),
      //ParkNowReceiptScreen
      GetPage(
        name: PARK_LATER_SET_DURATION_SCREEN,
        page: () => ParkLaterSetDurationScreen(),
      ),
      GetPage(
        name: HOME_SCREEN,
        page: () => const HomeScreen(),
      ),
      GetPage(
        name: PARK_NOW_FIXED_DURATION_RECIPT_SCREEN,
        page: () => ParkNowFixedDurationReceiptScreen(),
      ),
      GetPage(
        name: PARK_NOW_PAYMENT_SCREEN,
        page: () => ParkNowPaymentScreen(),
      ),
      GetPage(
        name: BOOK_AGAIN_SET_DURATION_SCREEN,
        page: () => BookAgainSetDurationScreen(),
      ),
      GetPage(
        name: SELECT_COUNTRY_SCREEN,
        page: () => SelectCountryScreen(),
      ),
      //SELECT_COUNTRY_SCREEN
      //ParkNowPaymentScreen
    ];
  }
}
