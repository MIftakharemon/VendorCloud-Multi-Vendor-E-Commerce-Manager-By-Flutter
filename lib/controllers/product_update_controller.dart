import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:karmalab_assignment/models/product_model.dart';
import '../screens/product/widgets/dropDownButtonItems.dart';
import '../services/product_service.dart';
import 'image_controller.dart';
import 'product_controller.dart';
import 'user_controller.dart';

class ProductUpdateController extends GetxController {
  final mediaController = Get.put(MediaController());
  final ProductService _productService = ProductService();
  final UserController userController = Get.find<UserController>();
  final variantSizeValues = <RxString>[].obs;
  final variantColorValues = <RxString>[].obs;

  final isLoading = false.obs;
  final RxMap changedFields = {}.obs;
  List<Map<String, dynamic>>? originalVariants;
  Map<String, dynamic> originalValues = {};
  Map<String, dynamic>? originalPackaging;
  Map<String, dynamic>? originalSpecifications;
  final variantCount = 0.obs;
  // Product details controllers
  final nameController = TextEditingController();
  final summaryController = TextEditingController();
  final descriptionController = TextEditingController();
  final brandController = TextEditingController();
  final warrantyController = TextEditingController();

  // Packaging controllers
  final weightController = TextEditingController();
  final heightController = TextEditingController();
  final widthController = TextEditingController();
  final dimensionController = TextEditingController();

  //Specificifications Details
  final screenSizeController = TextEditingController();
  final batteryLifeController = TextEditingController();
  final cameraResolutionController = TextEditingController();
  final storageCapacityController = TextEditingController();
  final osController = TextEditingController();





  // Variant controllers
  final variantNameControllers = <TextEditingController>[].obs;
  final variantPriceControllers = <TextEditingController>[].obs;
  final variantQuantityControllers = <TextEditingController>[].obs;
  final variantSizeControllers = <TextEditingController>[].obs;
  final variantColorControllers = <TextEditingController>[].obs;
  final variantMaterialControllers = <TextEditingController>[].obs;
  final variantGenderControllers = <TextEditingController>[].obs;
  final variantDiscountControllers = <TextEditingController>[].obs;

  void initializeProductData(Product product) {
    // Store original values
    originalValues = {
      'name': product.name,
      'summary': product.summary,
      'description': product.description,
      'brand': product.brand,
      'warranty': product.warranty,
    };
    if (product.specifications != null) {
      originalSpecifications = {
        'screenSize': product.specifications!.screenSize,
        'batteryLife': product.specifications!.batteryLife,
        'cameraResolution': product.specifications!.cameraResolution,
        'storageCapacity': product.specifications!.storageCapacity,
        'operatingSystem': product.specifications!.os,
      };
    }


    if (product.variants != null && product.variants!.isNotEmpty) {
      originalVariants = product.variants!
          .map((variant) => {
        'price': variant.price,
        'quantity': variant.quantity,
        'size': variant.size,
        'color': variant.color,
        'material': variant.material,
        'gender': variant.gender,
        'discount': variant.discount,
        'image': variant.image,
      })
          .toList();
    }

    if (product.packaging != null) {
      originalPackaging = {
        'weight': product.packaging!.weight,
        'height': product.packaging!.height,
        'width': product.packaging!.width,
        'dimension': product.packaging!.dimension,
      };
    }
    if (product.specifications != null) {
      screenSizeController.text = product.specifications!.screenSize ?? '';
      batteryLifeController.text = product.specifications!.batteryLife ?? '';
      cameraResolutionController.text =
          product.specifications!.cameraResolution ?? '';
      storageCapacityController.text =
          product.specifications!.storageCapacity ?? '';
      osController.text = product.specifications!.os ?? '';
    }
    // Set initial values
    nameController.text = product.name ?? '';
    summaryController.text = product.summary ?? '';
    descriptionController.text = product.description ?? '';
    brandController.text = product.brand ?? '';
    warrantyController.text = product.warranty ?? '';

    if (product.packaging != null) {
      weightController.text = product.packaging!.weight ?? '';
      heightController.text = product.packaging!.height ?? '';
      widthController.text = product.packaging!.width ?? '';
      dimensionController.text = product.packaging!.dimension ?? '';
    }
    if (product.variants != null && product.variants!.isNotEmpty) {
      // Initialize the observable lists first
      variantSizeValues.clear();
      variantColorValues.clear();

      initializeVariantControllers(product.variants!.length);

      for (int i = 0; i < product.variants!.length; i++) {
        final variant = product.variants![i];
        variantPriceControllers[i].text = variant.price ?? '';
        variantQuantityControllers[i].text = variant.quantity ?? '';

        // Initialize with null if value not in options
        String? sizeValue = variant.size;
        if (sizeValue != null && !sizeOptions.contains(sizeValue)) {
          sizeValue = null;
        }
        variantSizeValues.add(RxString(sizeValue ?? ''));
        variantSizeControllers[i].text = sizeValue ?? '';

        String? colorValue = variant.color;
        if (colorValue != null && !colorOptions.contains(colorValue)) {
          colorValue = null;
        }
        variantColorValues.add(RxString(colorValue ?? ''));
        variantColorControllers[i].text = colorValue ?? '';

        variantMaterialControllers[i].text = variant.material ?? '';
        variantGenderControllers[i].text = variant.gender ?? '';
        variantDiscountControllers[i].text = variant.discount ?? '';

        if (variant.image != null) {
          mediaController.setVariantImageUrl('variant_$i', variant.image);
        }
      }
    }
    // Handle media
    if (product.coverPhoto != null) {
      mediaController.setCoverPhoto(product.coverPhoto);
    }

    if (product.images != null && product.images!.isNotEmpty) {
      List<String> imageUrls = product.images!
          .map((img) => "https://readyhow.com${(img as Images).secureUrl}")
          .toList();
      mediaController.setAdditionalImages(imageUrls);
    }

    _setupChangeListeners();
  }

  void _setupChangeListeners() {
    void addFieldListener(
        String field, TextEditingController controller, String? originalValue) {
      controller.addListener(() {
        final currentValue = controller.text.trim();
        final origValue = (originalValue ?? '').trim();

        if (currentValue != origValue) {
          changedFields[field] = currentValue;
          print('Field $field changed to: $currentValue');
        } else {
          changedFields.remove(field);
        }
        update();
      });
    }

    // Basic fields
    addFieldListener('name', nameController, originalValues['name']);
    addFieldListener('summary', summaryController, originalValues['summary']);
    addFieldListener(
        'description', descriptionController, originalValues['description']);
    addFieldListener('brand', brandController, originalValues['brand']);
    addFieldListener(
        'warranty', warrantyController, originalValues['warranty']);

    // Packaging fields
    if (originalPackaging != null) {
      addFieldListener(
          'packaging.weight', weightController, originalPackaging?['weight']);
      addFieldListener(
          'packaging.height', heightController, originalPackaging?['height']);
      addFieldListener(
          'packaging.width', widthController, originalPackaging?['width']);
      addFieldListener('packaging.dimension', dimensionController,
          originalPackaging?['dimension']);
    }
    // Specifications fields
    if (originalSpecifications != null) {
      addFieldListener('specifications.screenSize', screenSizeController, originalSpecifications?['screenSize']);
      addFieldListener('specifications.batteryLife', batteryLifeController, originalSpecifications?['batteryLife']);
      addFieldListener('specifications.cameraResolution', cameraResolutionController, originalSpecifications?['cameraResolution']);
      addFieldListener('specifications.storageCapacity', storageCapacityController, originalSpecifications?['storageCapacity']);
      addFieldListener('specifications.os', osController, originalSpecifications?['os']);
    }

    for (int i = 0; i < variantCount.value; i++) {
      final prefix = 'variants[$i]';
      final originalVariant =
      i < (originalVariants?.length ?? 0) ? originalVariants![i] : null;

      addFieldListener(
          '$prefix.name', variantNameControllers[i], originalVariant?['name']);
      addFieldListener('$prefix.price', variantPriceControllers[i],
          originalVariant?['price']);
      addFieldListener('$prefix.quantity', variantQuantityControllers[i],
          originalVariant?['quantity']);
      addFieldListener(
          '$prefix.size', variantSizeControllers[i], originalVariant?['size']);
      addFieldListener('$prefix.color', variantColorControllers[i],
          originalVariant?['color']);
      addFieldListener('$prefix.material', variantMaterialControllers[i],
          originalVariant?['material']);
      addFieldListener('$prefix.gender', variantGenderControllers[i],
          originalVariant?['gender']);
      addFieldListener('$prefix.discount', variantDiscountControllers[i],
          originalVariant?['discount']);

    }


  }

  Map<String, dynamic> getUpdateData() {
    final Map<String, dynamic> updateData = {};

    // Check if any packaging field has changed
    bool hasPackagingChanges = changedFields.keys.any((key) => key.startsWith('packaging.'));
    if (hasPackagingChanges) {
      updateData['packaging'] = {
        'weight': weightController.text,
        'height': heightController.text,
        'width': widthController.text,
        'dimension': dimensionController.text,
      };
    }

    // Check if any specifications field has changed
    bool hasSpecificationsChanges = changedFields.keys.any((key) => key.startsWith('specifications.'));
    if (hasSpecificationsChanges) {
      updateData['specifications'] = {
        'screenSize': screenSizeController.text,
        'batteryLife': batteryLifeController.text,
        'cameraResolution': cameraResolutionController.text,
        'storageCapacity': storageCapacityController.text,
        'os': osController.text,
      };
    }

    // Handle basic fields
    changedFields.forEach((key, value) {
      if (!key.contains('.')) {
        updateData[key] = value;
      }
    });

    // Check if any variant fields have changed
    bool hasVariantChanges = changedFields.keys.any((key) => key.startsWith('variants['));

    // Only include variants in update data if there are changes
    if (hasVariantChanges || mediaController.variantImageBase64.isNotEmpty) {
      List<Map<String, dynamic>> variants = [];

      if (variantCount.value > 0) {
        for (int i = 0; i < variantCount.value; i++) {
          Map<String, dynamic> variantData = {};

          if (i < (originalVariants?.length ?? 0)) {
            variantData = Map<String, dynamic>.from(originalVariants![i]);
          }

          variantData.addAll({
            if (i < (originalVariants?.length ?? 0))
              '_id': originalVariants![i]['_id'],
            'price': variantPriceControllers[i].text,
            'quantity': variantQuantityControllers[i].text,
            'size': variantSizeControllers[i].text,
            'color': variantColorControllers[i].text,
            'material': variantMaterialControllers[i].text,
            'gender': variantGenderControllers[i].text,
            'discount': variantDiscountControllers[i].text,
          });

          String variantId = 'variant_$i';
          String variantImageBase64 = mediaController.getVariantImage(variantId);
          String variantImageUrl = mediaController.getVariantImageUrl(variantId);

          if (variantImageBase64.isNotEmpty) {
            variantData['image'] = variantImageBase64;
          } else if (variantImageUrl.isNotEmpty) {
            variantData['image'] = mediaController.urlToBase64(variantImageUrl);
          } else {
            variantData['image'] = null;
          }

          variants.add(variantData);
        }
        updateData['productVariants'] = variants;
      }
    }

    // Handle media updates
    if (mediaController.imageBase64.isNotEmpty) {
      updateData['coverPhoto'] = mediaController.imageBase64;
    }

    if (mediaController.additionalImagesBase64.isNotEmpty) {
      updateData['images'] = mediaController.additionalImagesBase64;
    }

    print('Update payload: $updateData');
    return updateData;
  }


  void initializeVariantControllers(int count) {
    variantCount.value = count;
    _clearVariantControllers();
    variantSizeValues.clear();
    variantColorValues.clear();
    for (int i = 0; i < count; i++) {
      variantNameControllers.add(TextEditingController());
      variantPriceControllers.add(TextEditingController());
      variantQuantityControllers.add(TextEditingController());
      variantSizeControllers.add(TextEditingController());
      variantColorControllers.add(TextEditingController());
      variantMaterialControllers.add(TextEditingController());
      variantGenderControllers.add(TextEditingController());
      variantDiscountControllers.add(TextEditingController());
      variantSizeValues.add(RxString(''));
      variantColorValues.add(RxString(''));
    }
  }

  void incrementVariantCount() {
    if (variantCount.value < 10) {
      variantCount.value++;
      _initializeNewVariantControllers();
    }
  }

  void decrementVariantCount() {
    if (variantCount.value > 1) {
      variantCount.value--;
      _removeLastVariantControllers();
    }
  }

  void _initializeNewVariantControllers() {
    variantNameControllers.add(TextEditingController());
    variantPriceControllers.add(TextEditingController());
    variantQuantityControllers.add(TextEditingController());
    variantSizeControllers.add(TextEditingController());
    variantColorControllers.add(TextEditingController());
    variantMaterialControllers.add(TextEditingController());
    variantGenderControllers.add(TextEditingController());
    variantDiscountControllers.add(TextEditingController());
  }

  void _removeLastVariantControllers() {
    variantNameControllers.removeLast();
    variantPriceControllers.removeLast();
    variantQuantityControllers.removeLast();
    variantSizeControllers.removeLast();
    variantColorControllers.removeLast();
    variantMaterialControllers.removeLast();
    variantGenderControllers.removeLast();
    variantDiscountControllers.removeLast();
  }

  void _clearVariantControllers() {
    variantSizeValues.clear();
    variantColorValues.clear();
    variantNameControllers.clear();
    variantPriceControllers.clear();
    variantQuantityControllers.clear();
    variantSizeControllers.clear();
    variantColorControllers.clear();
    variantMaterialControllers.clear();
    variantGenderControllers.clear();
    variantDiscountControllers.clear();
  }

  Future<void> updateProduct(
      String id, Function(bool, {String? errorMessage}) onUpdate) async {
    try {
      final updateData = getUpdateData();

      if (updateData.isEmpty) {
        onUpdate(false, errorMessage: 'No changes detected');
        return;
      }


      isLoading.value = true;
      final response = await _productService.updateProductById(id, updateData);

      if (response == true) {
        final user = userController.user.value;
        Get.find<ProductController>().getProducts(userId: user!.id ?? '');
        onUpdate(true);
      } else {
        onUpdate(false, errorMessage: 'Failed to update product');
      }
    } catch (e) {
      onUpdate(false, errorMessage: e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    nameController.dispose();
    summaryController.dispose();
    descriptionController.dispose();
    brandController.dispose();
    warrantyController.dispose();
    weightController.dispose();
    heightController.dispose();
    widthController.dispose();
    dimensionController.dispose();
    super.onClose();
  }
}
