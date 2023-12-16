import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hestia/features/core/screens/maps/MarkerMap/MapScreen.dart';
import 'package:hestia/utils/constants/api_constants.dart';
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
    await Firebase.initializeApp();
  }

  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.system,
      theme: MyAppTheme.lightTheme,
      darkTheme: MyAppTheme.darkTheme,
      home: MarkerMapScreen(),
    );
  }
}
