import 'dart:io';

import 'package:flutter/material.dart';


class IndivitualUserPost extends StatelessWidget {
  const IndivitualUserPost({
    super.key,
    required this.image,
    required this.description,
    this.address,
  });

  final File image;
  final String description;
  final String? address;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white.withOpacity(0.9)),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                  bottomLeft: Radius.circular(5),
                  bottomRight: Radius.circular(5)),
              child: Image.file(
                image,
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            Row(
              children: [
                const Icon(
                  Icons.location_on,
                  color: Colors.red,
                  size: 20,
                ),
                const SizedBox(
                  width: 5,
                ),
                Expanded(
                  child: Text(
                    address ?? "Guwahati Railway Station",
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        color: Colors.black54,
                        fontWeight: FontWeight.w600,
                        fontSize: 10),
                  ),
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 4),
              child: Text(
                description,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
