import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hestia/utils/constants/colors.dart';
import 'package:hestia/utils/helpers/helper_function.dart';

class StatsPost extends StatelessWidget {
  const StatsPost({
    super.key,
    required this.time,
    required this.description,
    required this.address,
    this.image,
  });

  final String time, description, address;
  final File? image;

  @override
  Widget build(BuildContext context) {
    var dark = MyAppHelperFunctions.isDarkMode(context);
    return Column(
      children: [
        // -- Post
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(width: 0.5),
              color: dark ? MyAppColors.darkerGrey : Colors.white,
              boxShadow: [
                BoxShadow(
                    color:
                        dark ? MyAppColors.darkishGrey : Colors.grey.shade300,
                    spreadRadius: 1,
                    blurRadius: 15)
              ]),
          child: Column(
            children: [
              ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: image == null
                      ? const CircularProgressIndicator()
                      : Image.file(image!)),
              const SizedBox(
                height: 5,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Column(
                  children: [
                    Row(
                      children: [
                        const Spacer(),
                        Text(
                          time,
                          style: const TextStyle(fontSize: 12),
                        )
                      ],
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
                          width: 6,
                        ),
                        Flexible(
                          child: Text(
                            address,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 5,
                            style: const TextStyle(fontSize: 12),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        description,
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    )
                  ],
                ),
              ),
            ],
          ),
        ),

        // -- Post Space at bottom
        const SizedBox(
          height: 15,
        )
      ],
    );
  }
}
