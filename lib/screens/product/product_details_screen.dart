import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';
import 'package:remixicon/remixicon.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:readmore/readmore.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';

import '../../controllers/product_controller.dart';
import '../../models/product_model.dart';

class ProductDetailsScreen extends GetView<ProductController> {
  static const routeName = "/productDetailsScreen";
  final Product product;

  const ProductDetailsScreen({required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Remix.arrow_left_line, color: Colors.black),
          onPressed: () => Get.back(),
        ),
        title: Text(
          product.name ?? '',
          style: GoogleFonts.poppins(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildImageCarousel(),
            _buildProductInfo(),
            _buildVariants(),
            _buildSpecifications(),
            _buildDescription(),
          ],
        ).animate(
          effects: [
            FadeEffect(duration: Duration(milliseconds: 800)),
            SlideEffect(
              begin: Offset(0, 0.5),
              end: Offset.zero,
              duration: Duration(milliseconds: 800),
              curve: Curves.easeOutQuart,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageCarousel() {
    List<String> allImages = [
      if (product.coverPhoto != null) product.coverPhoto!,
      ...product.images?.map((img) => "https://readyhow.com${img.secureUrl}") ?? [],
      ...product.variants?.where((v) => v.image != null).map((v) => v.image!) ?? [],
    ];

    return Hero(
      tag: 'product-${product.id}',
      child: FlutterCarousel(
        items: allImages.map((url) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: CachedNetworkImage(
              imageUrl: url,
              fit: BoxFit.fitHeight,
              width: double.infinity,
              placeholder: (context, url) => Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
                child: Container(color: Colors.white),
              ),
            ),
          );
        }).toList(),
        options: CarouselOptions(
          height: 250.0, // Reduced height for compactness
          showIndicator: true,
          slideIndicator: CircularSlideIndicator(),
          autoPlay: true,
          autoPlayInterval: const Duration(seconds: 3),
          autoPlayCurve: Curves.easeInOut,
          enableInfiniteScroll: true,
          viewportFraction: 1.0,
          enlargeCenterPage: false,
        ),
      ),
    );
  }

  Widget _buildProductInfo() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8), // Reduced padding
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  product.name ?? '',
                  style: GoogleFonts.poppins(
                    fontSize: 16, // Smaller font size
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4), // Smaller padding
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(12), // Smaller radius
                ),
                child: Text(
                  'Stock: ${product.getTotalQuantity()}',
                  style: TextStyle(
                    color: Colors.green,
                    fontSize: 12, // Smaller font size
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 4), // Reduced gap
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (product.getPriceRange().contains('~~'))
                Text(
                  '৳${product.getPriceRange().replaceAll('~~', '')}',
                  style: TextStyle(
                    decoration: TextDecoration.lineThrough,
                    color: Colors.grey,
                    fontSize: 14, // Smaller font size
                  ),
                ),
              SizedBox(width: 4), // Reduced gap
              Text(
                '৳${product.getDiscountedPriceRange()}',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18, // Smaller font size
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildVariants() {
    if (product.variants == null || product.variants!.isEmpty) return SizedBox.shrink();

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8), // Reduced padding
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Available Variants',
            style: GoogleFonts.poppins(
              fontSize: 14, // Smaller font size
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 8), // Reduced gap
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: BouncingScrollPhysics(),
            child: Row(
              children: List.generate(
                product.variants!.length,
                    (index) {
                  final variant = product.variants![index];
                  return Padding(
                    padding: EdgeInsets.only(
                      left: index == 0 ? 16 : 8,
                      right: index == product.variants!.length - 1 ? 16 : 8,
                    ),
                    child: SizedBox(
                      width: 240, // Wider width for rectangular shape
                      height: 140, // Reduced height for rectangular shape
                      child: Card(
                        color: Colors.white,
                        elevation: 0.5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                          side: BorderSide(color: Colors.grey.shade200),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(8),
                          child: Row( // Changed to Row for horizontal layout
                            children: [
                              if (variant.image != null)
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: SizedBox(
                                    width: 110, // Fixed width for image
                                    height: double.infinity,
                                    child: Padding(
                                      padding: const EdgeInsets.all(2.0),
                                      child: CachedNetworkImage(
                                        imageUrl: variant.image!,
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                  ),
                                ),
                              SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    if (variant.color?.isNotEmpty ?? false)
                                      Text(
                                        'Color: ${variant.color}',
                                        style: TextStyle(fontSize: 12),
                                      ),
                                    if (variant.size?.isNotEmpty ?? false)
                                      Text(
                                        'Size: ${variant.size}',
                                        style: TextStyle(fontSize: 12),
                                      ),
                                    SizedBox(height: 4),
                                    Text(
                                      '৳${variant.price}',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ).animate(
                      effects: [
                        FadeEffect(
                          delay: Duration(milliseconds: 100 * index),
                          duration: Duration(milliseconds: 800),
                          curve: Curves.easeOutQuart,
                        ),
                        SlideEffect(
                          begin: Offset(0.5, 0),
                          end: Offset.zero,
                          delay: Duration(milliseconds: 100 * index),
                          duration: Duration(milliseconds: 800),
                          curve: Curves.easeOutQuart,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          )        ],
      ),
    );
  }

  Widget _buildSpecifications() {
    if (product.specifications == null) return SizedBox.shrink();

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4), // Reduced padding
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white, // Background color
          borderRadius: BorderRadius.circular(8), // Rounded corners
          border: Border.all(
            color: Colors.grey.shade300, // Light border
            width: 1,
          ),
        ),
        child: ExpansionTile(
          tilePadding: EdgeInsets.symmetric(horizontal: 12), // Padding for the tile
          title: Text(
            'Specifications',
            style: GoogleFonts.poppins(
              fontSize: 14, // Smaller font size
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
          collapsedIconColor: Colors.grey.shade600, // Icon color when collapsed
          iconColor: Colors.grey.shade600, // Icon color when expanded
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8), // Rounded corners for the tile
          ),
          collapsedShape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8), // Rounded corners when collapsed
          ),
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8), // Inner padding
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: product.specifications!.toJson().entries
                    .where((e) => e.value != null)
                    .map((e) => Padding(
                  padding: EdgeInsets.only(bottom: 8), // Reduced gap
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 2,
                        child: Text(
                          '${e.key.replaceAllMapped(RegExp(r'([A-Z])'), (match) => ' ${match.group(1)}').trim().capitalize!}:',                          style: TextStyle(
                            color: Colors.grey.shade700,
                            fontSize: 12, // Slightly larger font size
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Text(
                          '${e.value}',
                          style: TextStyle(
                            fontSize: 12, // Slightly larger font size
                            fontWeight: FontWeight.w400,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                    ],
                  ),
                ))
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
  Widget _buildDescription() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8), // Reduced padding
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Description',
            style: GoogleFonts.poppins(
              fontSize: 14, // Smaller font size
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 4), // Reduced gap
          ReadMoreText(
            product.description ?? '',
            trimLines: 15,
            colorClickableText: Colors.blue,
            trimMode: TrimMode.Line,
            trimCollapsedText: 'Show more',
            trimExpandedText: 'Show less',
            style: TextStyle(
              fontSize: 14, // Smaller font size
              color: Colors.grey.shade700,
              height: 1.4, // Adjusted line height
            ),
          ),
          SizedBox(height: 40), // Reduced gap
        ],
      ),
    );
  }
}