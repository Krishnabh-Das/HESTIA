
import 'package:flutter/material.dart';
import 'package:hestia/utils/constants/colors.dart';


class IndivitualProfileField extends StatelessWidget {
  const IndivitualProfileField({
    super.key,
    required this.column1String,
    this.column2String,
    this.isEditable = true,
    this.onPressed,
  });

  final String column1String;
  final String? column2String;
  final bool isEditable;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(40), color: Colors.grey.shade300),
      child: Padding(
        padding: isEditable
            ? const EdgeInsets.fromLTRB(30, 18, 10, 18)
            : const EdgeInsets.fromLTRB(30, 18, 35, 18),
        child: Row(
          children: [
            SizedBox(
              width: 100,
              child: Text(
                column1String,
                style: const TextStyle(
                    color: Colors.black54,
                    fontWeight: FontWeight.w500,
                    fontSize: 14),
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Expanded(
              child: Text(
                column2String ?? "--------",
                style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                    color: Colors.black87),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (isEditable) ...[
              const SizedBox(
                width: 7,
              ),
              Container(
                width: 40,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(width: 0.5, color: Colors.grey)),
                child: IconButton(
                    onPressed: onPressed,
                    icon: const Icon(
                      Icons.edit,
                      color: MyAppColors.darkerGrey,
                    )),
              )
            ]
          ],
        ),
      ),
    );
  }
}
