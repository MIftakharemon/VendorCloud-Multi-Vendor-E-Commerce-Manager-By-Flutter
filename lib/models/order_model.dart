

import 'package:karmalab_assignment/models/product_model.dart';

import '../utils/helpers/helper_functions.dart';

class OrderModels {
  String? status;
  int? total;
  int? count;
  List<OrderModel>? data;

  OrderModels({this.status, this.total, this.count, this.data});

  OrderModels.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    total = json['total'];
    count = json['count'];
    if (json['data'] != null) {
      data = <OrderModel>[];
      json['data'].forEach((v) {
        data!.add(OrderModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['total'] = total;
    data['count'] = count;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class OrderModel {
  ShippingInfo? shippingInfo;
  String? sId;
  dynamic user;
  dynamic product;
  String? variantId;
  String? transactionId;
  int? price;
  String? currency;
  String? paymentType;
  String? status;
  dynamic createdAt;
  dynamic updatedAt;
  dynamic vat;
  dynamic commission;
  dynamic transactionCost;
  dynamic shippingCharge;
  dynamic profit;
  dynamic quantity;
  String? vendorPaid;
  String? vendor;

  OrderModel({
    this.shippingInfo,
    this.sId,
    this.user,
    this.product,
    this.variantId,
    this.transactionId,
    this.price,
    this.currency,
    this.paymentType,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.vat,
    this.commission,
    this.transactionCost,
    this.shippingCharge,
    this.profit,
    this.quantity,
    this.vendorPaid,
    this.vendor,
  });

  OrderModel.fromJson(Map<String, dynamic> json) {
    shippingInfo = json['shippingInfo'] != null ? ShippingInfo.fromJson(json['shippingInfo']) : null;
    sId = json['_id'] ?? '';
    user = json['user'] is String ? json['user'] : (json['user'] is Map<String, dynamic> ? User.fromJson(json['user']) : null);
    product = json['product'] != null ? Product.fromJson(json['product']) : null;
    variantId = json['variantId'] ?? '';
    transactionId = json['transactionId'] ?? '';

    price = json['price'] ?? 0;  // Default to 0 if null
    currency = json['currency'] ?? '';
    paymentType = json['paymentType'] ?? '';
    status = json['status'] ?? '';

    createdAt = json['createdAt'] ?? '';
    updatedAt = json['updatedAt'] ?? '';

    vat = json['vat'] ?? '';  // Default to 0 if null
    commission = json['commission'] ?? '';  // Default to 0 if null
    transactionCost = json['transactionCost'] ?? '';  // Default to 0 if null
    shippingCharge = json['shippingCharge'] ?? '';  // Default to 0 if null
    profit = json['profit'] ?? '';  // Default to 0 if null

    quantity = json['quantity'] ?? '';  // Default to 0 if null
    vendorPaid = json['vendorPaid'] ?? '';  // Default to false if null
    vendor = json['vendor'] ?? '';
  }




  String get formattedOrderDate {
    DateTime createdAtDate = DateTime.parse(createdAt!);
    return HelperFunctions.getFormattedDate(createdAtDate);
  }


  String get formattedDeliveryDate {
    return updatedAt != null ? HelperFunctions.getFormattedDate(DateTime.parse(updatedAt!)) : '';
  }
  String get orderStatusText => status == 'completed' ? 'Delivered' : status == 'cancelled' ? 'Cancelled': status == 'shipped' ? 'Shipped' : 'Processing';

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (shippingInfo != null) {
      data['shippingInfo'] = shippingInfo!.toJson();
    }
    data['user'] = user;
    if (product != null) {
      data['product'] = product;
    }
    data['variantId'] = variantId??'667ea9b1df5d6c0e864f1814';
    data['transactionId'] = transactionId;
    data['price'] = price;
    data['paymentType'] = paymentType;
    data['status'] = status;
    data['vat'] = vat;
    data['commission'] = commission;
    data['transactionCost'] = transactionCost;
    data['shippingCharge'] = shippingCharge;
    data['profit'] = profit;
    data['quantity'] = quantity;
    data['vendor'] = vendor;
    return data;
  }
}

class ShippingInfo {
  String? name;
  String? email;
  String? phone;
  String? method;
  dynamic deliveryFee;
  String? address1;
  String? address2;
  String? city;
  String? state;
  int? postcode;
  String? country;

  ShippingInfo({
    this.name,
    this.email,
    this.phone,
    this.method,
    this.deliveryFee,
    this.address1,
    this.address2,
    this.city,
    this.state,
    this.postcode,
    this.country,
  });

  ShippingInfo.fromJson(Map<String, dynamic> json) {
    name = json['name'] ?? '';
    email = json['email'] ?? '';
    phone = json['phone'] ?? '';
    method = json['method'] ?? '';
    deliveryFee = json['deliveryFee'] ?? 0;
    address1 = json['address1'] ?? '';
    address2 = json['address2'] ?? '';
    city = json['city'] ?? '';
    state = json['state'] ?? '';
    postcode = json['postCode'] ?? 0000;
    country = json['country'] ?? '';
  }


  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['email'] = email;
    data['phone'] = phone;
    data['method'] = method;
    data['deliveryFee'] = deliveryFee;
    data['address1'] = address1;
    data['address2'] = address2;
    data['city'] = city;
    data['state'] = state;
    data['postcode'] = postcode;
    data['country'] = country;
    return data;
  }
}


class CoverPhoto {
  String? publicId;
  String? secureUrl;

  CoverPhoto({this.publicId, this.secureUrl});

  CoverPhoto.fromJson(Map<String, dynamic> json) {
    publicId = json['public_id']??'';
    secureUrl = json['secure_url']??'';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['public_id'] = publicId;
    data['secure_url'] = secureUrl;
    return data;
  }
}

class Packaging {
  String? weight;
  String? height;
  String? width;
  String? dimension;

  Packaging({this.weight, this.height, this.width, this.dimension});

  Packaging.fromJson(Map<String, dynamic> json) {
    weight = json['weight'];
    height = json['height'];
    width = json['width'];
    dimension = json['dimension'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['weight'] = weight;
    data['height'] = height;
    data['width'] = width;
    data['dimension'] = dimension;
    return data;
  }
}


class Location {
  String? address1;
  String? address2;
  String? city;
  String? state;
  int? postcode;
  String? country;

  Location({
    this.address1,
    this.address2,
    this.city,
    this.state,
    this.postcode,
    this.country,
  });

  Location.fromJson(Map<String, dynamic> json) {
    address1 = json['address1'];
    address2 = json['address2'];
    city = json['city'];
    state = json['state'];
    postcode = json['postcode'];
    country = json['country'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['address1'] = address1;
    data['address2'] = address2;
    data['city'] = city;
    data['state'] = state;
    data['postcode'] = postcode;
    data['country'] = country;
    return data;
  }
}

class OtherPermissions {
  bool? isVendor;
  bool? isCustomer;
  bool? isCategories;
  bool? isProducts;
  bool? isOrders;
  bool? isReviews;
  bool? isVouchers;
  bool? isAdManager;
  bool? isRoleManager;
  bool? isMessageCenter;
  bool? isFinance;
  bool? isShipment;
  bool? isSupport;
  bool? isEventManager;
  bool? isMessage;

  OtherPermissions({
    this.isVendor,
    this.isCustomer,
    this.isCategories,
    this.isProducts,
    this.isOrders,
    this.isReviews,
    this.isVouchers,
    this.isAdManager,
    this.isRoleManager,
    this.isMessageCenter,
    this.isFinance,
    this.isShipment,
    this.isSupport,
    this.isEventManager,
    this.isMessage,
  });

  OtherPermissions.fromJson(Map<String, dynamic> json) {
    isVendor = json['isVendor'];
    isCustomer = json['isCustomer'];
    isCategories = json['isCategories'];
    isProducts = json['isProducts'];
    isOrders = json['isOrders'];
    isReviews = json['isReviews'];
    isVouchers = json['isVouchers'];
    isAdManager = json['isAdManager'];
    isRoleManager = json['isRoleManager'];
    isMessageCenter = json['isMessageCenter'];
    isFinance = json['isFinance'];
    isShipment = json['isShipment'];
    isSupport = json['isSupport'];
    isEventManager = json['isEventManager'];
    isMessage = json['isMessage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['isVendor'] = isVendor;
    data['isCustomer'] = isCustomer;
    data['isCategories'] = isCategories;
    data['isProducts'] = isProducts;
    data['isOrders'] = isOrders;
    data['isReviews'] = isReviews;
    data['isVouchers'] = isVouchers;
    data['isAdManager'] = isAdManager;
    data['isRoleManager'] = isRoleManager;
    data['isMessageCenter'] = isMessageCenter;
    data['isFinance'] = isFinance;
    data['isShipment'] = isShipment;
    data['isSupport'] = isSupport;
    data['isEventManager'] = isEventManager;
    data['isMessage'] = isMessage;
    return data;
  }
}

