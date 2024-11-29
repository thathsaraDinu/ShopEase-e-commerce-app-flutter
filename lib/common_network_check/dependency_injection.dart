import 'package:get/get.dart';
import 'package:shopease/common_network_check/network_controller.dart';

class DependencyInjection {
  static void init() {
    Get.put<NetworkController>(NetworkController());
  }
}
