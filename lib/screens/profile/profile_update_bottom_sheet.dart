import 'package:flutter/material.dart';

import '../../controllers/profile_update_controller.dart';
import '../../utils/constants/sizes.dart';

void showUpdateProfileBottomSheet(
    BuildContext context, {
      String? title,
      String? fieldName,
      String? hintText,
      IconData? prefixIcon,
      String Function(String?)? validator,
      VoidCallback? onSave,
    }) {
  final updateProfileController = UpdateUserDataController.instance;

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => AnimatedPadding(
      duration: const Duration(milliseconds: 200),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        padding: const EdgeInsets.all(Sizes.defaultSpace),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(Sizes.borderRadiusMd),
            topRight: Radius.circular(Sizes.borderRadiusMd),
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (title != null) ...[
                Text(
                  title,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: Sizes.spaceBtwSections),
              ],
              Text(
                'Use real information for easy validation. This will appear on several pages.',
                style: Theme.of(context).textTheme.labelMedium,
              ),
              const SizedBox(height: Sizes.spaceBtwSections),
              Form(
                key: updateProfileController.updateProfileFormKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: updateProfileController.getFieldController(fieldName),
                      validator: validator,
                      expands: false,
                      decoration: InputDecoration(
                        labelText: fieldName,
                        hintText: hintText,
                        prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null,
                      ),
                    ),
                    const SizedBox(height: Sizes.spaceBtwSections),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          if (onSave != null) {
                            onSave();
                          }
                          Navigator.pop(context);
                        },
                        child: const Text('Save'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}