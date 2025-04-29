class allProduct {
  String? status;
  int? total;
  List<Product>? data;

  allProduct({this.status, this.total, this.data});

  allProduct.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] is List) {
      total = json['total'];
      data = <Product>[];
      json['data'].forEach((v) {
        data!.add(Product.fromJson(v));
      });
    } else if (json['data'] is Map) {
      data = [Product.fromJson(json['data'])];
    } else if (json['data'] is String) {
      // Handle the case where data is a String
      data = [Product(name: json['data'])];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['status'] = status;
    if (this.data != null && this.data!.length > 1) {
      data['total'] = total;
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    } else if (this.data != null && this.data!.length == 1) {
      data['data'] = this.data!.first.toJson();
    }
    return data;
  }
}


class Product {

  dynamic?  video;
  //String? customId;
  dynamic? user;
  String? name;
  int? price;
  int? quantity;
  String? summary;
  String? description;

  String? brand;
  dynamic? coverPhoto;
  List<dynamic>? images;
  int? stock;
  int? sold;
  int? revenue;
  List<dynamic>? numReviews;
  int? ratings;
  Specifications? specifications;
  List<dynamic>? likes;
  String? category;
  String? subCategory;
  String? warranty;
  Packaging? packaging;

  //String? sId;
  String? createdAt;
  String? updatedAt;
  int? V;
  List<Reviews>? reviews;
  String? id;
  List<ProductVariants>? variants;





  Product({
    this.coverPhoto,
    this.video,
    this.specifications,
    this.user,
    this.name,
    this.price,
    this.quantity,
    this.summary,
    this.description,
    this.category,
    this.brand,
    this.images,
    this.stock,
    this.sold,
    this.revenue,
    this.numReviews,
    this.ratings,
    this.likes,
    this.createdAt,
    this.updatedAt,
    this.V,
    this.reviews,
    this.id,
    this.subCategory,
    this.warranty,
    this.packaging,
    this.variants,
  });



  Product.fromJson(Map<String, dynamic> json) {


    coverPhoto= json['coverPhoto'] != null ? "https://readyhow.com${CoverPhoto.fromJson(json['coverPhoto']).secureUrl ?? ''}" : null;
    video = json['video'] != null ? CoverPhoto.fromJson(json['video']) : null;
    specifications = json['specifications'] != null ? Specifications.fromJson(json['specifications']) : null;
    user = json['user'] != null ? User.fromJson(json['user']) : null;
    name = json['name'];
    price = json['price'];
    quantity = json['quantity'];
    summary = json['summary'];
    warranty = json['warranty'];
    description = json['description'];
    category = json['category'];
    subCategory = json['subCategory'];
    brand = json['brand'];
    if (json['images'] != null) {
      images = <Images>[];
      json['images'].forEach((v) {
        images!.add(Images.fromJson(v ?? {}));
      });
    }
    stock = json['stock'];
    sold = json['sold'];
    revenue = json['revenue'];
    if (json['numReviews'] != null) {
      numReviews = <dynamic>[];
      json['numReviews'].forEach((v) {
        numReviews!.add(v);
      });
    }
    ratings = json['ratings'];
    if (json['likes'] != null) {
      likes = <dynamic>[];
      json['likes'].forEach((v) {
        likes!.add(v);
      });
    }
    packaging = json['packaging'] != null ? Packaging.fromJson(json['packaging']) : null;
    if (json['productVariants'] != null) {
      variants = <ProductVariants>[];
      json['productVariants'].forEach((v) {
        variants!.add(ProductVariants.fromJson(v));
      });
    }
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    V = json['__v'];
    if (json['reviews'] != null) {
      reviews = <Reviews>[];
      json['reviews'].forEach((v) {
        reviews!.add(Reviews.fromJson(v ?? {}));
      });
    }
    id = json['id'];
  }



  String getPriceRange() {
    if (variants == null) return '0';

    List<double> prices = variants!.map((variant) {
      double originalPrice = double.tryParse(variant.price ?? '0') ?? 0;
      double discountPercent = double.tryParse(variant.discount ?? '0') ?? 0;

      // If there's a discount, mark it for strike-through
      return discountPercent > 0 ? -originalPrice : originalPrice;
    }).toList();

    prices.sort((a, b) => a.abs().compareTo(b.abs()));
    double lowestPrice = prices.first.abs();
    double highestPrice = prices.last.abs();

    // Check if prices need strike-through (negative values indicate discount)
    bool hasDiscount = prices.any((price) => price < 0);
    String priceText = lowestPrice == highestPrice
        ? lowestPrice.toString()
        : '$lowestPrice - $highestPrice';

    return hasDiscount ? '~~$priceText~~' : priceText;
  }

  String getDiscountedPriceRange() {
    if (variants == null) return '0';

    List<double> discountedPrices = variants!.map((variant) {
      return double.tryParse(variant.discount ?? '0') ?? 0;
    }).toList();

    discountedPrices.sort();
    double lowestPrice = discountedPrices.first ?? 0;
    double highestPrice = discountedPrices.last ?? 0;

    return lowestPrice == highestPrice
        ? lowestPrice.toStringAsFixed(2)
        : '${lowestPrice.toStringAsFixed(2)} - ${highestPrice.toStringAsFixed(2)}';
  }














  String getTotalQuantity() {
    if (variants == null) return '0';

    int total = variants!.fold(0, (sum, variant) =>
    sum! + (int.tryParse(variant.quantity ?? '0') ?? 0));
    return total.toString();
  }



  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (coverPhoto != null) {
      data['coverPhoto'] = coverPhoto;
    }
    if (video != null) {
      data['video'] = video;
    }
    if (specifications != null) {
      data['specifications'] = specifications!.toJson();
    }
    data['user'] = user;
    data['name'] = name;
    data['price'] = price;
    data['quantity'] = quantity;
    data['summary'] = summary;
    data['description'] = description;
    data['category'] = category;
    data['subCategory'] = subCategory;
    data['brand'] = brand;
    data['warranty'] = warranty;
    data['packaging'] = packaging;
    if (variants != null) {
      data['productVariants'] = variants!.map((v) => v.toJson()).toList();
    }
    if (images != null) {
      data['images'] = images;
    }
    data['stock'] = stock;
    data['sold'] = sold;
    return data;
  }
}

class CoverPhoto {
  String? publicId;
  String? secureUrl;

  CoverPhoto({this.publicId, this.secureUrl});

  CoverPhoto.fromJson(Map<String, dynamic> json) {
    publicId = json['public_id'];
    secureUrl = json['secure_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['public_id'] = publicId;
    data['secure_url'] = secureUrl;
    return data;
  }
}

class Specifications {
  String? screenSize;
  String? batteryLife;
  String? cameraResolution;
  String? storageCapacity;
  String? os;


  Specifications({
    this.screenSize,
    this.batteryLife,
    this.cameraResolution,
    this.storageCapacity,
    this.os,
  });

  Specifications.fromJson(Map<String, dynamic> json) {
    screenSize = json['screenSize'];
    batteryLife = json['batteryLife'];
    cameraResolution = json['cameraResolution'];
    storageCapacity = json['storageCapacity'];
    os = json['os'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['screenSize'] = screenSize;
    data['batteryLife'] = batteryLife;
    data['cameraResolution'] = cameraResolution;
    data['storageCapacity'] = storageCapacity;
    data['os'] = os;
    return data;
  }
}

class User {
  CoverPhoto? avatar;
  Location? location;
  String? sId;
  String? name;
  String? email;
  String? role;
  bool? isActive;
  bool? isVerified;
  String? phone;
  String? gender;
  List<dynamic>? likes;
  String? status;
  String? createdAt;
  String? updatedAt;
  int? iV;

  User({
    this.avatar,
    this.location,
    this.sId,
    this.name,
    this.email,
    this.role,
    this.isActive,
    this.isVerified,
    this.phone,
    this.gender,
    this.likes,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.iV,
  });

  User.fromJson(Map<String, dynamic> json) {
    avatar = json['avatar'] == null ? null : CoverPhoto.fromJson(json['avatar'] as Map<String, dynamic>);
    location = json['location'] == null ? null : Location.fromJson(json['location'] as Map<String, dynamic>);
    sId = json['_id'] as String? ?? '';
    name = json['name'] as String? ?? '';
    email = json['email'] as String? ?? '';
    role = json['role'] as String? ?? '';
    isActive = json['isActive'] as bool? ?? false;
    isVerified = json['isVerified'] as bool? ?? false;
    phone = json['phone'] as String? ?? '';
    gender = json['gender'] as String? ?? '';
    likes = <dynamic>[];
    if (json['likes'] != null) {
      likes = List<dynamic>.from(json['likes']);
    }
    status = json['status'] as String? ?? '';
    createdAt = json['createdAt'] as String? ?? '';
    updatedAt = json['updatedAt'] as String? ?? '';
    iV = json['__v'] as int? ?? 0;
  }


  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (avatar != null) {data['avatar'] = avatar!.toJson();}
    if (location != null) {data['location'] = location!.toJson();}
    data['name'] = name;
    data['email'] = email;
    data['role'] = role;
    data['isActive'] = isActive;
    data['isVerified'] = isVerified;
    data['phone'] = phone;
    data['gender'] = gender;
    if (likes != null) {data['likes'] = likes;}
    data['status'] = status;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['__v'] = iV;
    return data;
  }
}

class Reviews {
  User? user;
  String? review;
  int? rating;
  List<dynamic>? likes;
  List<dynamic>? dislikes;
  String? sId;
  String? createdAt;
  String? updatedAt;
  int? iV;


  Reviews({
    this.user,
    this.review,
    this.rating,
    this.likes,
    this.dislikes,
    this.sId,
    this.createdAt,
    this.updatedAt,
    this.iV,
  });

  Reviews.fromJson(Map<String, dynamic> json) {
    user = json['user'] != null ? User.fromJson(json['user']) : null;
    review = json['review'];
    rating = json['rating'];
    if (json['likes'] != null) {
      likes = <dynamic>[];
      json['likes'].forEach((v) {
        likes!.add(v);
      });
    }
    if (json['dislikes'] != null) {
      dislikes = <dynamic>[];
      json['dislikes'].forEach((v) {
        dislikes!.add(v);
      });
    }
    sId = json['_id'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (user != null) {
      data['user'] = user!.toJson();
    }
    data['review'] = review;
    data['rating'] = rating;
    if (likes != null) {
      data['likes'] = likes;
    }
    if (dislikes != null) {
      data['dislikes'] = dislikes;
    }

    data['_id'] = sId;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['__v'] = iV;
    return data;
  }
}

class Images {
  String? publicId;
  String? secureUrl;

  Images({this.publicId, this.secureUrl});

  Images.fromJson(Map<String, dynamic> json) {
    publicId = json['public_id'];
    secureUrl = json['secure_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['public_id'] = publicId;
    data['secure_url'] = secureUrl;
    return data;
  }
}

class Location {
  String? type;
  List<double>? coordinates;

  Location({this.type, this.coordinates});

  Location.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    coordinates = json['coordinates'] != null ? List<double>.from(json['coordinates']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['type'] = type;
    if (coordinates != null) {
      data['coordinates'] = coordinates;
    }
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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['weight'] = weight;
    data['height'] = height;
    data['width'] = width;
    data['dimension'] = dimension;
    return data;
  }
}


class ProductVariants {
  dynamic image;
  String? color;
  String? gender;
  String? size;
  String? material;
  String? price;
  String? discount;
  String? quantity;
  String? sId;
  String? id;

  ProductVariants(
      {this.image,
        this.color,
        this.gender,
        this.size,
        this.material,
        this.price,
        this.discount,
        this.quantity,
        this.sId,
        this.id});

  ProductVariants.fromJson(Map<String, dynamic> json) {
    image = json['image'] != null ? "https://readyhow.com${CoverPhoto.fromJson(json['image']).secureUrl}" : null;
    color = json['color'] ?? '';
    gender = json['gender'] ?? '';
    size = json['size'] ?? '';
    material = json['material'] ?? '';
    price = json['price'] ?? '';
    discount = json['discount'] ?? '';
    quantity = json['quantity'] ?? '';
    id = json['_id'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (image != null) {
      data['image'] = image;
    }
    data['color'] = color;
    data['gender'] = gender;
    data['size'] = size;
    data['material'] = material;
    data['price'] = price;
    data['discount'] = discount;
    data['quantity'] = quantity;
    return data;
  }
}
