import 'package:intl/intl.dart';

class Report {
  final String? id;
  final String? userId;
  final String? productId;
  final String? title;
  final String? message;
  final String? description;
  final ImageData? image;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Report({
    this.id,
    this.userId,
    this.productId,
    this.title,
    this.message,
    this.description,
    this.image,
    this.createdAt,
    this.updatedAt,
  });

  factory Report.fromJson(Map<String, dynamic> json) {
    return Report(
      id: json['_id'],
      userId: json['user'],
      productId: json['product'],
      title: json['title'],
      message: json['message'],
      description: json['description'],
      image: json['image'] != null ? ImageData.fromJson(json['image']) : null,
      createdAt: DateTime.tryParse(json['createdAt'] ?? ''),
      updatedAt: DateTime.tryParse(json['updatedAt'] ?? ''),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'user': userId,
      'product': productId,
      'title': title,
      'message': message,
      'description': description,
      'image': image?.toJson(),
      'createdAt': createdAt != null
          ? DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'").format(createdAt!)
          : null,
      'updatedAt': updatedAt != null
          ? DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'").format(updatedAt!)
          : null,
    };
  }
}

class ImageData {
  final String? publicId;
  final String? secureUrl;

  ImageData({
    this.publicId,
    this.secureUrl,
  });

  factory ImageData.fromJson(Map<String, dynamic> json) {
    return ImageData(
      publicId: json['public_id'],
      secureUrl: json['secure_url'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'public_id': publicId,
      'secure_url': secureUrl,
    };
  }
}
