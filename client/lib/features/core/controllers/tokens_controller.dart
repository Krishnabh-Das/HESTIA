import 'package:get/get.dart';

class TokensController extends GetxController {
  static TokensController get instance => Get.find();

  Rx<bool> isAchievementClicked = true.obs;
}
