import 'product_model.dart';

class PackageModel {
  String? status;
  int? total;
  List<Package>? data;

  PackageModel({this.status, this.total, this.data});

  PackageModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    total = json['total'];
    if (json['data'] != null) {
      data = <Package>[];
      json['data'].forEach((v) {
        data!.add(Package.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['total'] = total;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Package {
  String? sId;
  String? name;
  String? user;
  String? status;
  int? price;
  int? duration;
  int? maxProduct;
  String? createdAt;
  String? updatedAt;
  int? iV;
  List<PackageProducts>? packageProducts;
  String? id;

  Package(
      {this.sId,
        this.name,
        this.user,
        this.status,
        this.price,
        this.duration,
        this.maxProduct,
        this.createdAt,
        this.updatedAt,
        this.iV,
        this.packageProducts,
        this.id});

  Package.fromJson(Map<String, dynamic> json) {
    sId = json['_id'] ?? '';
    name = json['name'] ?? '';
    user = json['user'] ?? '';
    status = json['status'] ?? '';
    price = json['price'] ?? 0;
    duration = json['duration'] ?? 0;
    maxProduct = json['maxProduct'] ?? 0;
    createdAt = json['createdAt'] ?? '';
    updatedAt = json['updatedAt'] ?? '';
    iV = json['__v'] ?? 0;
    if (json['packageProducts'] != null) {
      packageProducts = <PackageProducts>[];
      json['packageProducts'].forEach((v) {
        packageProducts!.add(PackageProducts.fromJson(v));
      });
    }
    id = json['id'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['name'] = name;
    data['user'] = user;
    data['status'] = status;
    data['price'] = price;
    data['duration'] = duration;
    data['maxProduct'] = maxProduct;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['__v'] = iV;
    data['id'] = id;
    return data;
  }
}

class PackageProducts {
  String? sId;
  String? package;
  String? user;
  Product? product;
  String? createdAt;
  String? updatedAt;
  int? iV;

  PackageProducts(
      {this.sId,
        this.package,
        this.user,
        this.product,
        this.createdAt,
        this.updatedAt,
        this.iV});

  PackageProducts.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    package = json['package'];
    user = json['user'];
    product = json['product'] != null ? Product.fromJson(json['product']) : null;
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }
}