import 'package:flutter/material.dart';
import 'package:hestia/common/custom_toast_message.dart';
import 'package:hestia/features/core/controllers/chatbot_controller.dart';
import 'package:hestia/utils/constants/colors.dart';

class CustomUserMsgTextField extends StatelessWidget {
  const CustomUserMsgTextField({
    super.key,
    required this.userMessageController,
    required this.chatController,
  });

  final TextEditingController userMessageController;
  final ChatBotController chatController;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 5,
      left: 0,
      right: 0,
      child: Container(
        height: 60,
        margin: const EdgeInsets.symmetric(horizontal: 14),
        width: double.infinity,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Colors.white,
            border: Border.all(width: 2, color: Colors.black45)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            children: [
              // --User Text Form Field
              Expanded(
                  flex: 9,
                  child: TextFormField(
                    controller: userMessageController,
                    style: const TextStyle(color: Colors.black87),
                    decoration: const InputDecoration(
                      hintText: "Type Your Message....",
                      hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                      contentPadding: EdgeInsets.zero,
                    ),
                  )),

              // --User Text Upload IconButton
              Expanded(
                  flex: 1,
                  child: IconButton(
                      onPressed: () async {
                        if (userMessageController.text != "") {
                          chatController.isMsgTyped.value = true;
                          chatController.msgList
                              .add([userMessageController.text, "u", "No"]);
                          var userTextCopy = userMessageController.text;
                          userMessageController.clear();
                          await chatController
                              .uploadAndGetResponseFromChatbot(userTextCopy)
                              .onError((error, stackTrace) => showCustomToast(
                                  context,
                                  color: Colors.red.shade400,
                                  text: "Response Error from Server: $error",
                                  icon: Icons.clear_sharp,
                                  duration: 2500));
                        }
                      },
                      icon: const Icon(
                        Icons.forward,
                        color: MyAppColors.darkBlack,
                      )))
            ],
          ),
        ),
      ),
    );
  }
}
