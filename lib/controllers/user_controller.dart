import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:parkfinda_mobile/constants/constant.dart';
import 'package:parkfinda_mobile/controllers/network_controller.dart';
import 'package:parkfinda_mobile/model/Vehical.dart';
import 'package:parkfinda_mobile/model/card_detail.dart';
import 'package:parkfinda_mobile/services/local/shared_pref.dart';
import 'package:parkfinda_mobile/services/remote/auth_service.dart';

import '../model/user.dart';
import '../utils/app_custom_toast.dart';

class UserController extends GetxController {
  var user = Rxn<User>();
  var xfile = Rxn<XFile>();
  Rxn<Vehicles>? vehicles = Rxn<Vehicles>();
  var isVehicleLoading = false.obs;
  var isWalletLoading = false.obs;
  NetworkController networkController = Get.find<NetworkController>();
  var isLoading = true.obs;
  var photoLoading = false.obs;
  var dropDownValue = ''.obs;
  var dropDownShowValue = ''.obs;
  Rxn<Vehicle>? selectedVehicle = Rxn<Vehicle>();
  Rxn<Vehicle>? selectedVehicleInUpcomeingBooking = Rxn<Vehicle>();
  var cardList = RxList<CardDetail>();
  Rxn<CardDetail> selectedCard = Rxn<CardDetail>();
  bool curentRegion = true;

  void saveUserData() {
    SharedPref().saveUserData(user.value!);
  }

  User getUserData() {
    return SharedPref().getUser();
  }

  Future<void> getVehicleData({required String url}) async {
    try {
      if (networkController.connectionStatus.value != -1) {
        isVehicleLoading.value = true;
        var responce = await AuthService()
            .getAllVehicle(token: SharedPref.getToken()!, url: url);
        isVehicleLoading.value = false;
        if (responce.statusCode == 200) {
          print(responce.data);
          if (responce.data['errorMessage'] == null) {
            selectedVehicle?.value = null;
            vehicles?.value = Vehicles.fromJson(responce.data);
            selectedVehicle?.value = vehicles?.value?.data?.first;
            if (vehicles!.value!.data!.isNotEmpty) {
              dropDownShowValue.value =
                  '${vehicles!.value!.data![0].vRN!}\n${vehicles!.value!.data![0].model!}(${vehicles!.value!.data![0].color!})';
              dropDownValue.value = vehicles!.value!.data![0].id!;
            }
          } else {
            AppCustomToast.errorToast(responce.data['errorMessage']);
          }
        } else {
          AppCustomToast.errorToast('Something went wrong');
        }
      } else {
        AppCustomToast.warningToast('Please check your internet connection');
      }
    } catch (e) {
      isVehicleLoading.value = false;
      print(e);
    }
  }

  Future<void> getCardDetail() async {
    try {
      print('---->card volut id');
      print(user.value?.customerVaultId);
      if (networkController.connectionStatus.value != -1) {
        isWalletLoading.value = true;
        var responce = await AuthService().getCardDetail(
            token: SharedPref.getToken()!,
            url: SharedPref.getTimeZone() == 'Asia/Colombo'
                ? Constant.slUrl
                : Constant.slUrl);
        isWalletLoading.value = false;
        if (responce.statusCode == 200) {
          print('->card details');
          print(responce.data);
          if (responce.data['errorMessage'] == null) {
            List data = responce.data['data'];
            cardList.value = data.map((e) => CardDetail.fromJson(e)).toList();
            print(cardList.length);
            selectedCard.value = cardList.first;
          } else {
            //AppCustomToast.errorToast(responce.data['errorMessage']);
          }
        } else {
          AppCustomToast.errorToast('Something went wrong');
        }
      } else {
        AppCustomToast.warningToast('Please check your internet connection');
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> getSingleRegionCardDetail({required String url}) async {
    try {
      print('---->card volut id');
      print(user.value?.customerVaultId);
      if (networkController.connectionStatus.value != -1) {
        isWalletLoading.value = true;
        var responce = await AuthService()
            .getCardDetail(token: SharedPref.getToken()!, url: url);
        isWalletLoading.value = false;

        if (responce.statusCode == 200) {
          print('->card details');
          print(responce.data);
          if (responce.data['errorMessage'] == null) {
            selectedCard.value = null;
            List data = responce.data['data'];
            cardList.value = data.map((e) => CardDetail.fromJson(e)).toList();
            if (cardList.isNotEmpty) {
              selectedCard.value = cardList.first;
            }

            //AppCustomToast.errorToast(responce.data['errorMessage']);
          }
        } else {
          AppCustomToast.errorToast('Something went wrong');
        }
      } else {
        AppCustomToast.warningToast('Please check your internet connection');
      }
    } catch (e) {
      print(e);
    }
  }
}
