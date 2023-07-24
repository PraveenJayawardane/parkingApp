import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:parkfinda_mobile/services/local/shared_pref.dart';
import 'package:parkfinda_mobile/constants/constant.dart';

import '../constants/routes.dart';

class LoginMiddleware extends GetMiddleware {
  @override
  int? get priority => 2;

  bool hasToken = false;
  bool validToken = false;
  @override
  RouteSettings? redirect(String? route) {
    if (hasToken == false || validToken == false) {
      return const RouteSettings(name: Routes.LOCATION_SERVICE_SCREEN);
    }
    return null;
  }

//This function will be called  before anything created we can use it to
// change something about the page or give it new page
  @override
  GetPage? onPageCalled(GetPage? page) {
    final userBox = GetStorage(Constant.userBox);

    hasToken = SharedPref.hasToken();
    validToken = userBox.read(Constant.isValidToken) ?? false;
    print("Hastoken ${hasToken}");
    print("validtoken ${validToken}");

    return super.onPageCalled(page);
  }

//This function will be called right before the Bindings are initialized.
// Here we can change Bindings for this page.
  @override
  List<Bindings>? onBindingsStart(List<Bindings>? bindings) {
    return super.onBindingsStart(bindings);
  }

//This function will be called right after the Bindings are initialized.
// Here we can do something after  bindings created and before creating the page widget.
  @override
  GetPageBuilder? onPageBuildStart(GetPageBuilder? page) {
    return super.onPageBuildStart(page);
  }

// Page build and widgets of page will be shown
  @override
  Widget onPageBuilt(Widget page) {
    return super.onPageBuilt(page);
  }

//This function will be called right after disposing all the related objects
// (Controllers, views, ...) of the page.
  @override
  void onPageDispose() {
    super.onPageDispose();
  }
}
