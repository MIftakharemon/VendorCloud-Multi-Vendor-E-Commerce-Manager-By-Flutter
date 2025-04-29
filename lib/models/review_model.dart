import 'order_model.dart';
import 'user_model.dart';

class reviewModel {
  String? status;
  int? total;
  int? count;
  List<Data>? data;

  reviewModel({this.status, this.total, this.count, this.data});

  reviewModel.fromJson(Map<String, dynamic> json) {
    status = json['status']??'';
    total = json['total']??'';
    count = json['count']??'';
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['total'] = this.total;
    data['count'] = this.count;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  dynamic image;
  String? sId;
  dynamic user;
  dynamic product;
  String? review;
  dynamic ratings;
  List<dynamic>? likes;
  List<dynamic>? dislikes;
  String? createdAt;
  String? updatedAt;
  int? iV;
  String? comment;
  ReplyTo? replyTo;

  Data(
      {this.image,
        this.sId,
        this.user,
        this.product,
        this.review,
        this.ratings,
        this.likes,
        this.dislikes,
        this.createdAt,
        this.updatedAt,
        this.iV,
        this.comment,
        this.replyTo});

  Data.fromJson(Map<String, dynamic> json) {
    image = (json['image'] != null && json['image'] is Map)
        ? "https://readyhow.com${CoverPhoto.fromJson(json['image']).secureUrl ?? ''}"
        : null;
    sId = json['_id'] ?? '';
    user = json['user'] != null ? UserModel.fromJson(json['user']) : null;
    product = json['product'] ?? '';
    review = json['review'] ?? '';
    ratings = json['ratings'] != null ? json['ratings'] : 0;
    likes = json['likes'] != null ? List<dynamic>.from(json['likes']) : [];
    dislikes = json['dislikes'] != null ? List<dynamic>.from(json['dislikes']) : [];
    createdAt = json['createdAt'] ?? '';
    updatedAt = json['updatedAt'] ?? '';
    comment = json['comment'] ?? '';
    replyTo = json['replyTo'] != null ? ReplyTo.fromJson(json['replyTo']) : null;
  }


  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['image'] = this.image;
    if (this.user != null) {
      data['user'] = this.user;
    }

    data['product'] = this.product;
    data['ratings'] = this.ratings;

    if (this.comment != null && this.comment!.isNotEmpty) {
      data['comment'] = this.comment;
    } else {
      data['review'] = this.review;
    }

    if (this.replyTo != null) {
      data['replyTo'] = this.replyTo!.toJson();
    }

    return data;
  }
}

class ReplyTo {
  dynamic image;
  String? sId;
  dynamic user;
  dynamic product;
  String? comment;
  int? ratings;
  List<dynamic>? likes;
  List<dynamic>? dislikes;
  String? createdAt;
  String? updatedAt;
  int? iV;

  ReplyTo(
      {this.image,
        this.sId,
        this.user,
        this.product,
        this.comment,
        this.ratings,
        this.likes,
        this.dislikes,
        this.createdAt,
        this.updatedAt,
        this.iV});

  ReplyTo.fromJson(Map<String, dynamic> json) {
    image = (json['image'] != null && json['image'] is Map)
        ? "https://readyhow.com${CoverPhoto.fromJson(json['image']).secureUrl ?? ''}"
        : null;
    sId = json['_id'] ?? '';

    user = json['user'] != null ? UserModel.fromJson(json['user']) : null;

    product = json['product'] ?? '';

    comment = json['comment'] ?? '';

    ratings = json['ratings'] != null ? json['ratings'] : 0;

    likes = json['likes'] != null ? List<dynamic>.from(json['likes']) : [];

    dislikes = json['dislikes'] != null ? List<dynamic>.from(json['dislikes']) : [];

    createdAt = json['createdAt'] ?? '';

    updatedAt = json['updatedAt'] ?? '';

    iV = json['__v'] ?? 0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['image'] = this.image;
    data['_id'] = this.sId;
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    data['product'] = this.product;
    data['comment'] = this.comment;
    data['ratings'] = this.ratings;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    return data;
  }
}

