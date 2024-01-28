
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hestia/features/personalization/controllers/settings_controller.dart';


class ProfileTabButton extends StatelessWidget {
  const ProfileTabButton({
    super.key,
    required this.settingsController1,
  });

  final settingsController settingsController1;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => GestureDetector(
        onTap: () => settingsController1.isPostSelected.value = false,
        child: Container(
          decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(100),
                  bottomRight: Radius.circular(100)),
              color: !settingsController1.isPostSelected.value
                  ? const Color.fromARGB(204, 0, 212, 127)
                  : Colors.grey),
          child: const Padding(
            padding: EdgeInsets.fromLTRB(20, 7, 30, 7),
            child: Row(
              children: [
                Icon(
                  Icons.person,
                  color: Colors.white,
                  size: 35,
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  "Profile",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
