import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:parkfinda_mobile/services/local/shared_pref.dart';
import 'package:parkfinda_mobile/constants/constant.dart';

import '../constants/routes.dart';

class UpdateMiddleware extends GetMiddleware {
  @override
  int? get priority => 1;

  bool hasUpdate = false;

  @override
  RouteSettings? redirect(String? route) {
    if (hasUpdate == true) {
      return const RouteSettings(name: Routes.UPDATE_SCREEN);
    }
    return null;
  }

//This function will be called  before anything created we can use it to
// change something about the page or give it new page
  @override
  GetPage? onPageCalled(GetPage? page) {
    final userBox = GetStorage(Constant.userBox);
    hasUpdate = userBox.read(Constant.hasUpdate) ?? false;
    print("Has Update $hasUpdate");

    return super.onPageCalled(page);
  }

//This function will be called right before the Bindings are initialized.
// Here we can change Bindings for this page.

//This function will be called right after the Bindings are initialized.
// Here we can do something after  bindings created and before creating the page widget.

// Page build and widgets of page will be shown

//This function will be called right after disposing all the related objects
// (Controllers, views, ...) of the page.
}
