import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/product_model.dart';
import '../services/product_service.dart';
import 'image_controller.dart';
import 'user_controller.dart';

class ProductController extends GetxController {
  final ProductService _productService = ProductService();
  final MediaController mediaController = Get.put(MediaController());
  final UserController userController = Get.find<UserController>();

  // Product details controllers
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _summaryController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _subCategoryController = TextEditingController();
  final TextEditingController _brandController = TextEditingController();
  final TextEditingController _videoController = TextEditingController();
  final TextEditingController _warrantyController = TextEditingController();

  // Packaging details controllers
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _widthController = TextEditingController();
  final TextEditingController _dimensionController = TextEditingController();
  // Electronic details controllers
  final TextEditingController _screenSizeController = TextEditingController();
  final TextEditingController _batteryLifeController = TextEditingController();
  final TextEditingController _cameraResolutionController = TextEditingController();
  final TextEditingController _storageCapacityController = TextEditingController();
  final TextEditingController _osController = TextEditingController();

  var isLoading = false.obs;
  var productList = <Product>[].obs;
  var productListForEventAdd = <Product>[].obs;
  var variantCount = 1.obs;

  // Variant controllers
  var variantNameControllers = <TextEditingController>[].obs;
  var variantPriceControllers = <TextEditingController>[].obs;
  var variantDiscountControllers = <TextEditingController>[].obs;
  var variantQuantityControllers = <TextEditingController>[].obs;
  var variantSizeControllers = <TextEditingController>[].obs;
  var variantColorControllers = <TextEditingController>[].obs;
  var variantMaterialControllers = <TextEditingController>[].obs;
  var variantGenderControllers = <TextEditingController>[].obs;

  @override
  void onInit() {
    //final user = userController.user.value;
    _initializeVariantControllers();
    //getProducts(userId: user!.id??'');
    super.onInit();
  }

  // Getters for the product controllers
  TextEditingController get nameController => _nameController;
  TextEditingController get summaryController => _summaryController;
  TextEditingController get descriptionController => _descriptionController;
  TextEditingController get categoryController => _categoryController;
  TextEditingController get subCategoryController => _subCategoryController;
  TextEditingController get brandController => _brandController;
  TextEditingController get videoController => _videoController;
  TextEditingController get warrantyController => _warrantyController;
  TextEditingController get weightController => _weightController;
  TextEditingController get heightController => _heightController;
  TextEditingController get widthController => _widthController;
  TextEditingController get dimensionController => _dimensionController;
  // Getters for the electronic details controllers
  TextEditingController get screenSizeController => _screenSizeController;
  TextEditingController get batteryLifeController => _batteryLifeController;
  TextEditingController get cameraResolutionController =>
      _cameraResolutionController;
  TextEditingController get storageCapacityController =>
      _storageCapacityController;
  TextEditingController get osController => _osController;

  void _initializeVariantControllers() {
    variantNameControllers.add(TextEditingController());
    variantPriceControllers.add(TextEditingController());
    variantDiscountControllers.add(TextEditingController());
    variantQuantityControllers.add(TextEditingController());
    variantSizeControllers.add(TextEditingController());
    variantColorControllers.add(TextEditingController());
    variantMaterialControllers.add(TextEditingController());
    variantGenderControllers.add(TextEditingController());
  }

  void incrementVariantCount() {
    if (variantCount.value < 10) {
      variantCount.value++;
      _initializeVariantControllers();
    }
  }

  void decrementVariantCount() {
    if (variantCount.value > 1) {
      variantCount.value--;
      _removeLastVariantControllers();
    }
  }

  void _removeLastVariantControllers() {
    variantNameControllers.removeLast();
    variantPriceControllers.removeLast();
    variantDiscountControllers.removeLast();
    variantQuantityControllers.removeLast();
    variantSizeControllers.removeLast();
    variantColorControllers.removeLast();
    variantMaterialControllers.removeLast();
    variantGenderControllers.removeLast();
  }

  void updateVariantImage(String variantId) async {
    await mediaController.imagePickerAndBase64Conversion(variantId: variantId);
    final variantImageBase64 = mediaController.variantImageBase64;
    mediaController.setVariantImage(variantId, variantImageBase64);
  }

  List<Product> get products => productList;
  List<Product> get productsForEventAdd => productListForEventAdd;

  Future<void> pickAdditionalImages() async {
    await mediaController.pickAdditionalImages();
  }

  bool validate() {
    final name = nameController.text.trim();
    final coverPhoto = mediaController.imageBase64;
    final additionalImages = mediaController.additionalImagesBase64;

    if (name.isEmpty || coverPhoto.isEmpty) {
      Get.snackbar(
        'Validation Error',
        'Please upload a cover photo.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    }

    if (additionalImages.isEmpty) {
      Get.snackbar(
        'Validation Error',
        'Please upload at least one additional image.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    }

    return true;
  }

  Future<void> createProduct(
      Function(bool, {String? errorMessage})? onCreate) async {
    final valid = validate();
    final user = userController.user.value;
    if (valid) {
      List<ProductVariants> variants = [];
      for (int i = 0; i < variantCount.value; i++) {
        variants.add(ProductVariants(
          price: variantPriceControllers[i].text,
          discount: variantDiscountControllers[i].text,
          quantity: variantQuantityControllers[i].text,
          material: variantMaterialControllers[i].text,
          size: variantSizeControllers[i].text,
          gender: variantGenderControllers[i].text,
          color: variantColorControllers[i].text,
          image: mediaController.getVariantImage('variant_$i'),
        ));
      }

      final product = Product(
        user: user!.id,
        coverPhoto: mediaController.imageBase64,
        video: mediaController.videoBase64.isNotEmpty ? mediaController.videoBase64 : videoController.text,
        name: nameController.text,
        summary: summaryController.text,
        description: descriptionController.text,
        category: categoryController.text,
        subCategory: subCategoryController.text,
        images: mediaController.additionalImagesBase64,
        brand: brandController.text,
        warranty: warrantyController.text,
        specifications: Specifications(
          screenSize: screenSizeController.text,
          batteryLife: batteryLifeController.text,
          cameraResolution: cameraResolutionController.text,
          storageCapacity: storageCapacityController.text,
          os: osController.text,
        ),
        packaging: Packaging(
          weight: weightController.text,
          height: heightController.text,
          width: widthController.text,
          dimension: dimensionController.text,
        ),
        variants: variants,
      );

      try {
        isLoading.value = true;
        final createdProduct =
            await _productService.createProduct(product.toJson());
        isLoading.value = false;
        if (onCreate != null) {
          onCreate(createdProduct);
        }
      } catch (e) {
        isLoading.value = false;
        if (onCreate != null) onCreate(false, errorMessage: e.toString());
      }
    }
  }

  Future<void> getProducts({required String userId}) async {
    try {
      isLoading.value = true;
      final productResponse = await _productService.getProducts(userId: userId);
      isLoading.value = false;
      if (productResponse != null && productResponse.data != null) {
        productList.assignAll(productResponse.data!);
      } else {
        productList.clear();
      }
    } catch (e) {
      isLoading.value = false;
      Get.snackbar('Error', 'Failed to fetch products: $e',
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  Future<void> getProductsforEventAd({required String userId}) async {
    try {
      isLoading.value = true;
      final productResponse = await _productService.getProducts(userId: userId);
      isLoading.value = false;
      if (productResponse != null && productResponse.data != null) {
        productListForEventAdd.assignAll(productResponse.data!);
      } else {
        productListForEventAdd.clear();
      }
    } catch (e) {
      isLoading.value = false;
      Get.snackbar('Error', 'Failed to fetch products: $e',
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  Future<void> getProductsForSubCategory({
    required String subcategoryId,
    required String userId,
  }) async {
    try {
      isLoading.value = true;
      final productResponse = await _productService.getProductsForSubCategory(
        subcategoryId: subcategoryId,
        userId: userId,
      );
      isLoading.value = false;
      if (productResponse != null && productResponse.data != null) {
        productList.assignAll(productResponse.data!);
      } else {
        productList.clear();
      }
    } catch (e) {
      isLoading.value = false;
      Get.snackbar('Error', 'Failed to fetch products: $e',
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  Future<void> getProductById(
      String id, Function(Product, {String? errorMessage})?) async {
    try {
      isLoading.value = true;
      final productResponse = await _productService.getProductById(id);
      isLoading.value = false;
      if (productResponse != null && productResponse.data != null) {
        productList.assignAll(productResponse.data!);
      } else {
        productList.clear();
      }
    } catch (e) {
      isLoading.value = false;
      Get.snackbar('Error', 'Failed to fetch products: $e',
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  Future<void> updateProductById(String id, Product product,
      Function(bool, {String? errorMessage})? onUpdate) async {
    try {
      isLoading.value = true;
      final bool isUpdated =
          await _productService.updateProductById(id, product.toJson());
      isLoading.value = false;

      if (isUpdated) {
        if (onUpdate != null) onUpdate(true);
      } else {
        if (onUpdate != null)
          onUpdate(false, errorMessage: 'Failed to update product.');
      }
    } catch (e) {
      isLoading.value = false;
      if (onUpdate != null) onUpdate(false, errorMessage: e.toString());
    }
  }

  Future<void> deleteProduct(
      String id, Function(bool, {String? errorMessage})? onDelete) async {
    try {
      isLoading.value = true;
      final bool isDeleted = await _productService.deleteProductById(id);
      isLoading.value = false;

      if (isDeleted) {
        productList.removeWhere((product) => product.id == id);
        if (onDelete != null) onDelete(true);
      } else {
        if (onDelete != null)
          onDelete(false, errorMessage: 'Failed to delete product.');
      }
    } catch (e) {
      isLoading.value = false;
      if (onDelete != null) onDelete(false, errorMessage: e.toString());
    }
  }

  @override
  void onClose() {
    // Clear individual controllers
    nameController.clear();
    summaryController.clear();
    descriptionController.clear();
    categoryController.clear();
    subCategoryController.clear();
    brandController.clear();
    warrantyController.clear();
    weightController.clear();
    heightController.clear();
    widthController.clear();
    dimensionController.clear();
    screenSizeController.clear();
    batteryLifeController.clear();
    cameraResolutionController.clear();
    storageCapacityController.clear();
    osController.clear();

    // Clear variant-related controllers
    _clearVariantControllers();
    cleanUpMediaController();
    // Call parent class's onClose method
    super.onClose();
  }

  void _clearVariantControllers() {
    // Clear all controllers in variant lists
    for (var controller in variantPriceControllers) {
      controller.clear();
    }
    for (var controller in variantQuantityControllers) {
      controller.clear();
    }
    for (var controller in variantSizeControllers) {
      controller.clear();
    }
    for (var controller in variantColorControllers) {
      controller.clear();
    }
    for (var controller in variantMaterialControllers) {
      controller.clear();
    }
    for (var controller in variantGenderControllers) {
      controller.clear();
    }
    for (var controller in variantDiscountControllers) {
      controller.clear();
    }
  }

  void cleanUpMediaController() {
    // Call all the cleanup functions
    Get.find<MediaController>().removeVideo();
    Get.find<MediaController>().removeThumbnail();
    Get.find<MediaController>().clearAdditionalImageBase64();
    Get.find<MediaController>().clearAllVariantImages();
    Get.find<MediaController>().removeCoverPhoto();
    //Get.delete<MediaController>();
  }
}
