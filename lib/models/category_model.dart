class Category {
  String status = '';
  List<Data> data = [];
  Data? singleData;

  Category({this.status = '', this.data = const [], this.singleData});

  Category.FromJson(Map<String, dynamic> json) {
    status = json['status'] ?? '';
    if (json['data'] is List) {
      data = <Data>[];
      json['data'].forEach((v) {
        data.add(Data.fromJson(v));
      });
    } else if (json['data'] is Map) {
      singleData = Data.fromJson(json['data']);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.data.isNotEmpty) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    } else if (this.singleData != null) {
      data['data'] = this.singleData!.toJson();
    }
    return data;
  }
}




class Data {
  dynamic? image;
  String sId = '';
  String name = '';
  String shippingCharge = '';
  String vat = '';
  String status = '';
  String commission = '';
  String createdAt = '';
  String updatedAt = '';
  int V = 0;
  List<SubCategories> subCategories = [];
  String id = '';
  String icon = '';

  Data({
    this.image,
    this.sId = '',
    this.name = '',
    this.shippingCharge = '',
    this.vat = '',
    this.status = '',
    this.commission = '',
    this.createdAt = '',
    this.updatedAt = '',
    this.V = 0,
    this.subCategories = const [],
    this.id = '',
    this.icon = '',
  });

  Data.fromJson(Map<String, dynamic> json) {
    image = json['image'] != null ? Image.fromJson(json['image']) : null;
    sId = json['_id'] ?? '';
    name = json['name'] ?? '';
    shippingCharge = json['shippingCharge'] ?? '';
    vat = json['vat'] ?? '';
    status = json['status'] ?? '';
    commission = json['commission'] ?? '';
    createdAt = json['createdAt'] ;
    updatedAt = json['updatedAt'] ;
    V = json['__v'] ?? 0;
    if (json['subCategories'] != null) {
      subCategories = <SubCategories>[];
      json['subCategories'].forEach((v) {
        subCategories.add(SubCategories.fromJson(v));
      });
    }
    id = json['id'] ?? '';
    icon = json['icon'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.image != null) {
      data['image'] = this.image;
    }
    data['name'] = this.name;
    data['shippingCharge'] = this.shippingCharge;
    data['vat'] = this.vat;
    data['status'] = this.status;
    data['commission'] = this.commission;
    data['icon'] = this.icon;
    return data;
  }
}

class Image {
  String? publicId ;
  String? secureUrl;

  Image({this.publicId , this.secureUrl });

  Image.fromJson(Map<String, dynamic> json) {
    publicId = json['public_id'];
    secureUrl = json['secure_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['public_id'] = this.publicId;
    data['secure_url'] = this.secureUrl;
    return data;
  }
}

class SubCategories {
  dynamic? image;
  String? sId;
  String? category;
  String? name;
  String? shippingCharge;
  String? vat;
  String? status;
  String? commission;
  String? createdAt;
  String? updatedAt;
  int? iV;

  SubCategories(
      { this.image,
        this.sId,
        this.category,
        this.name,
        this.shippingCharge,
        this.vat,
        this.status,
        this.commission,
        this.createdAt,
        this.updatedAt,
        this.iV});

  SubCategories.fromJson(Map<String, dynamic> json) {
    image = json['image'] != null ? "https://readyhow.com${Image.fromJson(json['image']).secureUrl ?? ''}" : null;




    sId = json['_id'];
    category = json['category'];
    name = json['name'];
    shippingCharge = json['shippingCharge'];
    vat = json['vat'];
    status = json['status'];
    commission = json['commission'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['category'] = this.category;
    data['name'] = this.name;
    data['shippingCharge'] = this.shippingCharge;
    data['vat'] = this.vat;
    data['status'] = this.status;
    data['commission'] = this.commission;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    return data;
  }
}
