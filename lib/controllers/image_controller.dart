import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_thumbnail_video/index.dart';
import 'package:get_thumbnail_video/video_thumbnail.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MediaController extends GetxController {
  final _imageBase64 = ''.obs;
  final _imageVariantBase64 = ''.obs;
  final _fileExtension = ''.obs;
  final _encodedImage = ''.obs;
  final _encodedVariantImage = ''.obs;
  final _additionalImagesUrls = <String>[].obs;
  final _videoUrl = ''.obs;
  final _imageUrl = ''.obs;
  final _additionalImagesBase64 = <String>[].obs;

  // Add these new variables at the top of your MediaController class
  final _idCardFrontBase64 = ''.obs;
  final _idCardBackBase64 = ''.obs;
  final _bankStatementBase64 = ''.obs;

// Add these getters
  String get idCardFrontBase64 => _idCardFrontBase64.value;
  String get idCardBackBase64 => _idCardBackBase64.value;
  String get bankStatementBase64 => _bankStatementBase64.value;
  // Add variant URL map
  final _variantImagesUrls = <String, String>{}.obs;
  // variant images

  final _variantImages = <String, String>{}.obs;

  // Video properties
  final _videoBase64 = ''.obs;
  final _videoExtension = ''.obs;
  final _encodedVideo = ''.obs;
  final _videoThumnail = ''.obs;

  // Additional images

  String get imageUrl => _imageUrl.value;
  String get imageBase64 => _imageBase64.value;
  String get variantImageBase64 => _imageVariantBase64.value;
  String get fileExtension => _fileExtension.value;
  String get encodedImage => _encodedImage.value;
  List<String> get additionalImagesBase64 => _additionalImagesBase64;
  List<String> get additionalImagesUrls => _additionalImagesUrls;
  String get videoUrl => _videoUrl.value;

  String get videoBase64 => _videoBase64.value;
  String get videoExtension => _videoExtension.value;
  String get encodedVideo => _encodedVideo.value;
  String get videoThumnail => _videoThumnail.value;


  // Add this method to set variant images
  void setVariantImage(String variantId, String variantImageBase64) {
    _variantImages[variantId] = variantImageBase64;
  }

  // Add this method to get variant images
  String getVariantImage(String variantId) {
    return _variantImages[variantId] ?? '';
  }

  // Add new methods for variant URLs
  void setVariantImageUrl(String variantId, String imageUrl) {
    _variantImagesUrls[variantId] = imageUrl;
  }

  String getVariantImageUrl(String variantId) {
    return _variantImagesUrls[variantId] ?? '';
  }

  // Image picker and base64 conversion
  Future<void> imagePickerAndBase64Conversion({String? variantId}) async {
    final picker = ImagePicker();
    try {
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        final filePath = pickedFile.path;
        _fileExtension.value =
            filePath.split('.').last.toLowerCase(); // File extension

        final file = File(filePath);
        final fileSize = await file.length(); // Get file size in bytes

        // Check if file size is greater than 5 MB (5 * 1024 * 1024 bytes)
        if (fileSize > 5 * 1024 * 1024) {
          Get.snackbar(
            'Error',
            'File size exceeds 5 MB! Please select a smaller image.',
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
          return; // Exit the function
        }

        final bytes = await file.readAsBytes();
        if (variantId?.isEmpty ?? true) {
          _encodedImage.value = base64Encode(bytes);
          _imageBase64.value =
              "data:image/${_fileExtension.value};base64,${_encodedImage.value}";
        } else {
          _encodedVariantImage.value = base64Encode(bytes);
          _imageVariantBase64.value =
              "data:image/${_fileExtension.value};base64,${_encodedVariantImage.value}";
        }
        // Update variant image
        _variantImages[variantId!] = _imageVariantBase64.value;
      } else {
        Get.snackbar(
          'Warning!',
          'No image selected!',
          backgroundColor: Colors.transparent,
          colorText: Colors.black,
        );
      }
    } catch (e) {}
  }



  Future<String> urlToBase64(String url) async => url.isEmpty ? '' : 'data:${(await http.get(Uri.parse(url))).headers['content-type'] ?? 'image/jpeg'};base64,${base64Encode((await http.get(Uri.parse(url))).bodyBytes)}';



  Future<void> videoPickerAndBase64Conversion({String? videoUrl}) async {
    final picker = ImagePicker();

    if (videoUrl != null && videoUrl.isNotEmpty) {
      // Handle the video URL
      try {
        // Generate thumbnail for the video URL
        final videoThumbnail = await VideoThumbnail.thumbnailData(
          video: videoUrl,
          imageFormat: ImageFormat.JPEG,
          maxWidth: 720,
          quality: 50,
        );

        if (videoThumbnail != null) {
          _videoThumnail.value = base64Encode(videoThumbnail);
        } else {}

        // Set the video URL as the base64 string directly
        _encodedVideo.value = ''; // Clear any previous encoded video
        _videoBase64.value = videoUrl; // Use the video URL directly
        _videoExtension.value = videoUrl
            .split('.')
            .last
            .toLowerCase(); // Extract extension from URL
      } catch (e) {}
    } else {
      // Handle video picking from file
      try {
        final pickedFile = await picker.pickVideo(source: ImageSource.gallery);

        if (pickedFile != null) {
          final filePath = pickedFile.path;
          try {
            final videoThumbnail = await VideoThumbnail.thumbnailData(
              video: filePath,
              imageFormat: ImageFormat.PNG,
              maxWidth: 1080,
              quality: 100,
            );

            if (videoThumbnail != null) {
              _videoThumnail.value = base64Encode(videoThumbnail);
            } else {
              Get.snackbar(
                'Error',
                'Unable to generate video thumbnail!',
                backgroundColor: Colors.transparent,
                colorText: Colors.black,
              );
            }
          } catch (thumbnailError) {
            Get.snackbar(
              'Error',
              'An error occurred while generating the thumbnail.',
              backgroundColor: Colors.transparent,
              colorText: Colors.black,
            );
          }

          _videoExtension.value =
              filePath.split('.').last.toLowerCase(); // File extension

          final file = File(filePath);
          final fileSize = await file.length(); // Get file size in bytes

          // Check if file size is greater than 200 MB (200 * 1024 * 1024 bytes)
          if (fileSize > 200 * 1024 * 1024) {
            Get.snackbar(
              'Error',
              'File size exceeds 200 MB! Please select a smaller video.',
              backgroundColor: Colors.red,
              colorText: Colors.white,
            );
            return; // Exit the function
          }

          final bytes = await file.readAsBytes();
          _encodedVideo.value = base64Encode(bytes);
          // Correctly construct the videoBase64 string
          _videoBase64.value =
              "data:video/${_videoExtension.value};base64,${_encodedVideo.value}";
        } else {
          Get.snackbar(
            'Error',
            'No video selected!',
            backgroundColor: Colors.transparent,
            colorText: Colors.black,
          );
        }
      } catch (e) {
        Get.snackbar(
          snackPosition: SnackPosition.BOTTOM,
          'Error',
          'An error occurred while picking the video.',
          backgroundColor: Colors.transparent,
          colorText: Colors.black,
        );
      }
    }
  }

// New function for document handling
  Future<void> handleDocumentImage(String documentType) async {
    final picker = ImagePicker();
    try {
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        final filePath = pickedFile.path;
        final fileExt = filePath.split('.').last.toLowerCase();
        final file = File(filePath);
        final bytes = await file.readAsBytes();
        final base64String =
            "data:image/$fileExt;base64,${base64Encode(bytes)}";

        switch (documentType) {
          case 'idCardFrontPageImage':
            _idCardFrontBase64.value = base64String;
            break;
          case 'idCardBackPageImage':
            _idCardBackBase64.value = base64String;
            break;
          case 'bankStatementImage':
            _bankStatementBase64.value = base64String;
            break;
        }
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'An error occurred while picking the image.',
        backgroundColor: Colors.transparent,
        colorText: Colors.black,
      );
    }
  }

  Future<void> pickAdditionalImages() async {
    final picker = ImagePicker();
    try {
      final pickedFiles = await picker.pickMultiImage();

      if (pickedFiles.isEmpty) {
        Get.snackbar(
          'Warning',
          'You did not select any image!',
          backgroundColor: Colors.transparent,
          colorText: Colors.black,
        );
        return;
      }

      final totalFile = additionalImagesBase64.length +
          additionalImagesUrls.length +
          pickedFiles.length;

      if (totalFile > 3) {
        Get.snackbar(
          snackPosition: SnackPosition.BOTTOM,
          'Warning!',
          'You can only select up to 3 images!',
          backgroundColor: Colors.transparent,
          colorText: Colors.black,
        );
        return;
      }

      for (var pickedFile in pickedFiles) {
        final filePath = pickedFile.path;
        final fileExtension =
            filePath.split('.').last.toLowerCase(); // File extension

        final file = File(filePath);
        final fileSize = await file.length(); // Get file size in bytes

        // Check if file size is greater than 5 MB (5 * 1024 * 1024 bytes)
        if (fileSize > 5 * 1024 * 1024) {
          Get.snackbar(
            snackPosition: SnackPosition.BOTTOM,
            'Warning!',
            'File size exceeds 5 MB! Please select a smaller image.',
            backgroundColor: Colors.transparent,
            colorText: Colors.black,
          );
          continue; // Skip this file and continue with the next
        }

        final bytes = await file.readAsBytes();
        final encodedImage = base64Encode(bytes);
        final imageBase64 = "data:image/$fileExtension;base64,$encodedImage";

        // Add to additional images list, ensuring it doesn't exceed 3 images
        if (_additionalImagesBase64.length < 3) {
          _additionalImagesBase64.add(imageBase64);
        } else {
          Get.snackbar(
            snackPosition: SnackPosition.BOTTOM,
            'Warning',
            'You can only upload up to 3 images!',
            backgroundColor: Colors.transparent,
            colorText: Colors.black,
          );
        }
      }
    } catch (e) {
      Get.snackbar(
        snackPosition: SnackPosition.TOP,
        'Error',
        'An error occurred while picking images!',
        backgroundColor: Colors.transparent,
        colorText: Colors.black,
      );
    }
  }

  void removeCoverPhoto() {
    _imageUrl.value = '';
    _imageBase64.value = '';
  }

  void removeImage(int index) {
    if (index >= 0 && index < _additionalImagesBase64.length) {
      //_additionalImagesUrls.removeAt(index-1);
      _additionalImagesBase64.removeAt(index);
    }
  }

  void clearAdditionalImageBase64() {
    _additionalImagesBase64.clear();
    _additionalImagesUrls.clear();
  }
  void clearAllVariantImages() {
    _variantImagesUrls.clear(); // Clear variant image URLs
    _variantImages.clear();     // Clear variant images (Base64)
  }


  void removeUrlImage(int index) {
    if (index >= 0 && index < _additionalImagesUrls.length) {
      _additionalImagesUrls.removeAt(index);
    }
  }

  void removeThumbnail() {
    _videoThumnail.value = '';
  }

  void removeVideo() {
    removeThumbnail();
    _videoBase64.value = '';
  }

  // Add these setter methods
  void setCoverPhoto(String value) {
    if (value.startsWith('data:image')) {
      _imageBase64.value = value;
      _imageUrl.value = '';
    } else {
      _imageUrl.value = value;
      _imageBase64.value = '';
    }
  }

  void setAdditionalImages(List<String> values) {
    _additionalImagesUrls.assignAll(values);
  }

  void setVideo(String value) {
    videoPickerAndBase64Conversion(videoUrl: value);
  }

// New function to clear specific document
  void clearDocument(String documentType) {
    switch (documentType) {
      case 'idCardFrontPageImage':
        _idCardFrontBase64.value = '';
        break;
      case 'idCardBackPageImage':
        _idCardBackBase64.value = '';
        break;
      case 'bankStatementImage':
        _bankStatementBase64.value = '';
        break;
    }
  }
}
