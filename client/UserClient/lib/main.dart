import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hestia/bottom_nav_bar.dart';
import 'package:hestia/features/authentication/screens/login/login_screen.dart';
import 'package:hestia/features/authentication/screens/on_board/onBoarding.dart';
import 'package:hestia/features/authentication/screens/splash_screen.dart';
import 'package:hestia/features/core/controllers/chatbot_controller.dart';
import 'package:hestia/features/core/controllers/tokens_controller.dart';
import 'package:hestia/features/core/controllers/half_map_controller.dart';
import 'package:hestia/features/core/controllers/marker_map_controller.dart';
import 'package:hestia/features/personalization/controllers/settings_controller.dart';
import 'package:hestia/utils/constants/api_constant.dart';
import 'package:hestia/utils/theme/theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (kIsWeb) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: APIConstants.firebase_api_key,
        appId: APIConstants.firebase_app_id,
        projectId: APIConstants.firebase_project_id,
        messagingSenderId: APIConstants.firebase_messaging_sender_id,
      ),
    );
  } else {
    try {
      await Firebase.initializeApp();
    } catch (e) {
      print("Firebase Initialize App $e");
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);
      runApp(const App());
    }
  }

  await GetStorage.init();

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(const App());
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(MarkerMapController());
    Get.put(settingsController());
    Get.put(HalfMapController());
    Get.put(TokensController());
    Get.put(ChatBotController());

    return GetMaterialApp(
        debugShowCheckedModeBanner: false,
        themeMode: ThemeMode.system,
        theme: MyAppTheme.lightTheme,
        darkTheme: MyAppTheme.darkTheme,
        home: SplashScreen());
  }
}
