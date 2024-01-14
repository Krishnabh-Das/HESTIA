import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hestia/features/core/controllers/chatbot_controller.dart';
import 'package:hestia/utils/constants/images_strings.dart';
import 'package:hestia/utils/helpers/helper_function.dart';

class ChatScreen extends StatelessWidget {
  ChatScreen({super.key});

  var chatController = ChatBotController.instance;

  var userMessageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Chat Bot",
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        leading: const Icon(Icons.chat),
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 66),
                child: Obx(
                  () => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      for (var msg in chatController.msgList.value)
                        Align(
                          alignment: msg[1] == "u"
                              ? Alignment.centerRight
                              : Alignment.centerLeft,
                          child: CustomMessage(text: msg[0], role: msg[1]),
                        ),
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
          ),
          Positioned(
            bottom: 0,
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
                    Expanded(
                        flex: 9,
                        child: TextFormField(
                          controller: userMessageController,
                          decoration: const InputDecoration(
                            hintText: "Type Your Message....",
                            hintStyle:
                                TextStyle(color: Colors.grey, fontSize: 14),
                            border: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            errorBorder: InputBorder.none,
                            disabledBorder: InputBorder.none,
                            contentPadding: EdgeInsets.zero,
                          ),
                        )),
                    Expanded(
                        flex: 1,
                        child: IconButton(
                            onPressed: () async {
                              chatController.isMsgTyped.value = true;
                              chatController.msgList
                                  .add([userMessageController.text, "u"]);
                              var userTextCopy = userMessageController.text;
                              userMessageController.clear();
                              await chatController
                                  .uploadAndGetResponseFromChatbot(
                                      userTextCopy);
                            },
                            icon: const Icon(Icons.forward)))
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CustomMessage extends StatelessWidget {
  const CustomMessage({
    super.key,
    required this.text,
    required this.role,
  });

  final String text;
  final String role;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      constraints: BoxConstraints(
        maxWidth: MyAppHelperFunctions.screenWidth() * 0.7,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
          color: role == "u" ? Colors.greenAccent : Colors.grey.shade300,
          borderRadius: BorderRadius.circular(10)),
      child: Text(
        text,
        style: const TextStyle(
            color: Colors.black, fontSize: 14, fontWeight: FontWeight.w500),
      ),
    );
  }
}
