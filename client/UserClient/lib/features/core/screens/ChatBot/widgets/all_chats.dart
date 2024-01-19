import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:hestia/features/core/controllers/chatbot_controller.dart';
import 'package:hestia/features/core/screens/ChatBot/widgets/custom_msg.dart';
import 'package:hestia/utils/constants/images_strings.dart';

class AllChats extends StatelessWidget {
  const AllChats({
    super.key,
    required this.chatController,
  });

  final ChatBotController chatController;

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 66),
          child: Obx(
            () => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Loop to generate Message TIll Now
                for (int i = 0; i < chatController.msgList.value.length; i++)
                  Align(
                    alignment: chatController.msgList.value[i][1] == "u"
                        ? Alignment.centerRight
                        : Alignment.centerLeft,

                    // Create Custom Message from text
                    child: CustomMessage(
                      text: chatController.msgList.value[i][0],
                      role: chatController.msgList.value[i][1],
                      animate: chatController.msgList.value[i][2] == "Now",
                      mapIndex: chatController.msgList.value[i][2] == "Now"
                          ? i
                          : null,
                    ),
                  ),

                // Add User Uploaded Msg in Column child
                if (chatController.isMsgTyped.value) ...[
                  const Image(
                    image: AssetImage(MyAppImages.msg_loading),
                    fit: BoxFit.fitHeight,
                    height: 80,
                  )
                ]
              ],
            ),
          ),
        ),
      ),
    );
  }
}
