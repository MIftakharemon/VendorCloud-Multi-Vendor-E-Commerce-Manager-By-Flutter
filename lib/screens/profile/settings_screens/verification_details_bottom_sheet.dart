import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../../controllers/image_controller.dart';
import '../../../controllers/profile_update_controller.dart';
import '../../../controllers/user_controller.dart';
import '../../../models/user_model.dart';
import '../../../utils/popups/loaders.dart';

class VerificationBottomSheet extends StatelessWidget {
  final MediaController mediaController;
  final UpdateUserDataController updateProfileController;

  const VerificationBottomSheet({
    Key? key,
    required this.mediaController,
    required this.updateProfileController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final UserController controller = Get.find<UserController>();
    return Container(
      height: MediaQuery.of(context).size.height * 0.6,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Verification Documents',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Tap to upload/update image. Press and hold to remove image.',
              style: TextStyle(
                color: Colors.red.shade600,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 20),
            Obx(() => _buildExpandableDocument(
              'ID Card Front',
              'idCardFrontPageImage',
              controller.user.value?.idCardFrontPageImage,
              Icons.credit_card,
            )),
            const SizedBox(height: 12),
            Obx(() => _buildExpandableDocument(
              'ID Card Back',
              'idCardBackPageImage',
              controller.user.value?.idCardBackPageImage,
              Icons.credit_card_outlined,
            )),
            const SizedBox(height: 12),
            Obx(() => _buildExpandableDocument(
              'Bank Statement',
              'bankStatementImage',
              controller.user.value?.bankStatementImage,
              Icons.account_balance,
            )),
          ],
        ),
      ),
    );
  }

  Widget _buildExpandableDocument(String title, String field, String? imageUrl, IconData icon) {
    return Theme(
      data: ThemeData().copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        backgroundColor: Colors.white,
        collapsedBackgroundColor: Colors.white,
        leading: Icon(icon, color: Colors.grey.shade600),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: GestureDetector(
              onTap: () => _updateDocument(field),
              onLongPress: () async {
                if (imageUrl != null) {
                  mediaController.clearDocument(field);
                  final imageController = TextEditingController(text: '');
                  await updateProfileController.updateUserField(field, imageController);
                }
              },
              child: Container(
                height: 180,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Obx(() {
                  String? base64Image;
                  switch(field) {
                    case 'idCardFrontPageImage':
                      base64Image = mediaController.idCardFrontBase64;
                      break;
                    case 'idCardBackPageImage':
                      base64Image = mediaController.idCardBackBase64;
                      break;
                    case 'bankStatementImage':
                      base64Image = mediaController.bankStatementBase64;
                      break;
                  }

                  if (base64Image?.isNotEmpty ?? false) {
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.memory(
                        base64Decode(base64Image!.split(',').last),
                        fit: BoxFit.cover,
                      ),
                    );
                  } else if (imageUrl != null) {
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        imageUrl,
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Center(
                            child: CircularProgressIndicator(
                              color: Colors.grey.shade400,
                            ),
                          );
                        },
                        errorBuilder: (context, error, stackTrace) {
                          return Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.error_outline,
                                    color: Colors.red.shade400,
                                    size: 40),
                                const SizedBox(height: 8),
                                Text('Failed to load image',
                                    style: TextStyle(color: Colors.grey.shade600)),
                              ],
                            ),
                          );
                        },
                      ),
                    );
                  } else {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.add_photo_alternate,
                            size: 50,
                            color: Colors.grey.shade400),
                        const SizedBox(height: 8),
                        Text('Tap to upload',
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            )),
                      ],
                    );
                  }
                }),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _updateDocument(String field) async {
    try {
      await mediaController.handleDocumentImage(field);
      String base64Image = '';
      switch(field) {
        case 'idCardFrontPageImage':
          base64Image = mediaController.idCardFrontBase64;
          break;
        case 'idCardBackPageImage':
          base64Image = mediaController.idCardBackBase64;
          break;
        case 'bankStatementImage':
          base64Image = mediaController.bankStatementBase64;
          break;
      }

      if (base64Image.isNotEmpty) {
        final imageController = TextEditingController(text: base64Image);
        await updateProfileController.updateUserField(field, imageController);
      }
    } catch (e) {
      Loaders.errorSnackBar(
        title: 'Error',
        message: 'Failed to update document',
      );
    }
  }
}

