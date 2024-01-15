import 'package:get/get.dart';

class GamifyController extends GetxController {
  static GamifyController get instance => Get.find();

  Rx<bool> isAchievementClicked = true.obs;
}
