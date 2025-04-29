import 'package:karmalab_assignment/models/product_model.dart';

class EventProductModel {
  String? status;
  Data? data;

  EventProductModel({
    this.status,
    this.data,
  });
  factory EventProductModel.fromJson(Map<String, dynamic> json) => EventProductModel(
    status: json['status'],
    data: json['data'] != null ? Data.fromJson(json['data']) : null,
  );
}

class Data {
  String? id;
  String? event;
  String? user;
  Product? product;
  String? name;
  dynamic? createdAt;
  dynamic? updatedAt;
  int? v;

  Data({
    this.id,
    this.event,
    this.user,
    this.product,
    this.name,
    this.createdAt,
    this.updatedAt,
    this.v,
  });
  factory Data.fromJson(Map<String, dynamic> json) => Data(
    id: json['_id'],
    event: json['event'],
    user: json['user'],
    product: json['product'] != null ?  Product.fromJson(json['product']) : null,
    name: json['name'],
    createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
    updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
    v: json['__v'],
  );
}




class Image {
  String? publicId;
  String? secureUrl;
  String? id;
  String? imageId;

  Image({
    this.publicId,
    this.secureUrl,
    this.id,
    this.imageId,
  });
  factory Image.fromJson(Map<String, dynamic> json) => Image(
    publicId: json['public_id'],
    secureUrl: json['secure_url'],
    id: json['_id'],
    imageId: json['imageId'],
  );

}



class ProductVariant {
  String? color;
  String? gender;
  String? size;
  String? material;
  String? price;
  String? discount;
  String? quantity;
  String? id;
  String? productVariantId;

  ProductVariant({
    this.color,
    this.gender,
    this.size,
    this.material,
    this.price,
    this.discount,
    this.quantity,
    this.id,
    this.productVariantId,
  });
  factory ProductVariant.fromJson(Map<String, dynamic> json) => ProductVariant(
    color: json['color'],
    gender: json['gender'],
    size: json['size'],
    material: json['material'],
    price: json['price'],
    discount: json['discount'],
    quantity: json['quantity'],
    id: json['_id'],
    productVariantId: json['productVariantId'],
  );
}


class ProductUser {
  Location? location;
  Map<String, bool>? otherPermissions;
  String? id;
  String? name;
  String? email;
  String? role;
  bool? isActive;
  bool? isVerified;
  String? gender;
  List<dynamic>? likes;
  List<dynamic>? orders;
  String? status;
  bool? isFeatured;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;

  ProductUser({
    this.location,
    this.otherPermissions,
    this.id,
    this.name,
    this.email,
    this.role,
    this.isActive,
    this.isVerified,
    this.gender,
    this.likes,
    this.orders,
    this.status,
    this.isFeatured,
    this.createdAt,
    this.updatedAt,
    this.v,
  });
  factory ProductUser.fromJson(Map<String, dynamic> json) => ProductUser(
    location: json['location'] != null ? Location.fromJson(json['location']) : null,
    otherPermissions: json['otherPermissions'] != null ? Map<String, bool>.from(json['otherPermissions']) : null,
    id: json['_id'],
    name: json['name'],
    email: json['email'],
    role: json['role'],
    isActive: json['isActive'],
    isVerified: json['isVerified'],
    gender: json['gender'],
    likes: json['likes'],
    orders: json['orders'],
    status: json['status'],
    isFeatured: json['isFeatured'],
    createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
    updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
    v: json['__v'],
  );
}
