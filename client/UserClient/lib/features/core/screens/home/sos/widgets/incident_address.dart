
import 'package:flutter/material.dart';
import 'package:hestia/features/core/controllers/sos_mini_map_controller.dart';
import 'package:hestia/features/core/screens/home/sos/widgets/custom_map_select_dialog.dart';
import 'package:hestia/utils/constants/images_strings.dart';

class IncidentAddress extends StatelessWidget {
  const IncidentAddress({
    super.key,
    required this.addressController,
    required this.sosMiniMapController,
  });

  final TextEditingController addressController;
  final SOSMiniMapController sosMiniMapController;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 9,
          child: TextFormField(
            controller: addressController,
            decoration: const InputDecoration(
              labelText: "Address of Incident",
            ),
            maxLines: 2,
          ),
        ),
        const SizedBox(
          width: 10,
        ),
        Expanded(
            flex: 2,
            child: GestureDetector(
              onTap: () async {
                showDialog(
                    context: context,
                    builder: (context) => CustomMapSelectDialog(
                          sosMiniMapController: sosMiniMapController,
                        ));
              },
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: Colors.grey.shade100, shape: BoxShape.circle),
                child: const Image(
                  image: AssetImage(MyAppImages.markerImage),
                  fit: BoxFit.fitHeight,
                  height: 37,
                ),
              ),
            ))
      ],
    );
  }
}
