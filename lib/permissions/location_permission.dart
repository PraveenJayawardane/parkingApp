
import 'package:permission_handler/permission_handler.dart';

class LocationPermission {

  Future<bool> getLocationPermission() async {
    var status = await Permission.location.status;
    if(status.isGranted){
      return true;
    }else if(status.isDenied){
      PermissionStatus status = await Permission.location.request();
      return status.isGranted;
    }else if(status.isPermanentlyDenied){
      openAppSettings();
      return false;
    }else if(status.isRestricted){
      openAppSettings();
      return false;
    }else{
      openAppSettings();
      return false;
    }
  }
}