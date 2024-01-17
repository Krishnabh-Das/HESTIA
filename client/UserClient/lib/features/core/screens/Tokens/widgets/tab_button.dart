import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:hestia/features/core/controllers/tokens_controller.dart';
import 'package:hestia/features/core/screens/Tokens/widgets/tokens_indivitual_tab.dart';

class TabButton extends StatelessWidget {
  const TabButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: () =>
              TokensController.instance.isAchievementClicked.value = true,
          child: Obx(
            () => TokensIndivitualTab(
              text: "Achievement",
              color: TokensController.instance.isAchievementClicked.value
                  ? const Color(0xFF1F616B)
                  : Colors.teal.shade500,
            ),
          ),
        ),
        GestureDetector(
          onTap: () =>
              TokensController.instance.isAchievementClicked.value = false,
          child: Obx(
            () => TokensIndivitualTab(
              text: "Tasks",
              color: TokensController.instance.isAchievementClicked.value
                  ? Colors.teal.shade500
                  : const Color(0xFF1F616B),
            ),
          ),
        )
      ],
    );
  }
}
