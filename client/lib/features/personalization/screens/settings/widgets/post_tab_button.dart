
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hestia/features/personalization/controllers/settings_controller.dart';


class PostTabButton extends StatelessWidget {
  const PostTabButton({
    super.key,
    required this.settingsController1,
  });

  final settingsController settingsController1;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => GestureDetector(
        onTap: () => settingsController1.isPostSelected.value = true,
        child: Container(
          decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(100),
                  bottomLeft: Radius.circular(100)),
              color: settingsController1.isPostSelected.value
                  ? const Color.fromARGB(204, 0, 212, 127)
                  : Colors.grey),
          child: const Padding(
            padding: EdgeInsets.fromLTRB(30, 7, 40, 7),
            child: Row(
              children: [
                Icon(
                  Icons.handshake_outlined,
                  color: Colors.white,
                  size: 35,
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  "Posts",
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
