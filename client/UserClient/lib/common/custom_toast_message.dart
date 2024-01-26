import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

Widget buildCustomToast(
  BuildContext context, {
  required Color color,
  required String text,
  IconData? icon,
}) {
  FToast ftoast = FToast();
  ftoast.init(context);

  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
    decoration: BoxDecoration(
        color: color ?? Colors.green[400],
        borderRadius: BorderRadius.circular(14)),
    child: Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        if (icon != null) ...[
          Icon(
            icon,
            color: Colors.white,
          ),
          const SizedBox(
            width: 12,
          )
        ],
        Expanded(
          child: Text(
            text ?? "",
            style: const TextStyle(
                fontSize: 14, color: Colors.white, fontWeight: FontWeight.w500),
          ),
        )
      ],
    ),
  );
}

void showCustomToast(BuildContext context,
    {required Color color,
    required String text,
    IconData? icon,
    int? duration}) {
  FToast ftoast = FToast();
  ftoast.init(context);

  Widget toast =
      buildCustomToast(context, color: color, text: text, icon: icon);

  ftoast.showToast(
    child: toast,
    gravity: ToastGravity.BOTTOM,
    toastDuration: duration != null
        ? Duration(milliseconds: duration)
        : const Duration(milliseconds: 3000),
  );
}
