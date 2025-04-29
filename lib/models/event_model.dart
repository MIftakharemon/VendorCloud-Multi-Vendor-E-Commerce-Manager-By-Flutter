import 'package:karmalab_assignment/models/category_model.dart';
import 'package:karmalab_assignment/models/product_model.dart';

class EventModel {
  String? status;
  int? total;
  List<Event>? data;

  EventModel({this.status, this.total, this.data});

  EventModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    total = json['total'];
    if (json['data'] != null) {
      data = <Event>[];
      json['data'].forEach((v) {
        data!.add(new Event.fromJson(v));
      });
    }
  }
}

class Event {
  dynamic? image;
  String? sId;
  String? user;
  String? name;
  String? status;
  String? startDate;
  String? endDate;
  String? description;
  String? price;
  String? createdAt;
  String? updatedAt;
  int? iV;
  List<EventProducts>? eventProducts;
  String? id;

  Event(
      {this.image,
        this.sId,
        this.user,
        this.name,
        this.status,
        this.startDate,
        this.endDate,
        this.description,
        this.price,
        this.createdAt,
        this.updatedAt,
        this.iV,
        this.eventProducts,
        this.id});

  Event.fromJson(Map<String, dynamic> json) {
    image = json['image'] != null ? Image.fromJson(json['image']) : null;
    sId = json['_id'] ?? '';
    user = json['user'] ?? '';
    name = json['name'] ?? '';
    status = json['status'] ?? '';
    startDate = json['startDate'] ?? '';
    endDate = json['endDate'] ?? '';
    description = json['description'] ?? '';
    price = json['price'] ?? 0;
    createdAt = json['createdAt'] ?? '';
    updatedAt = json['updatedAt'] ?? '';
    iV = json['__v'] ?? 0;

    if (json['eventProducts'] != null && json['eventProducts'] is List) {
      eventProducts = <EventProducts>[];
      json['eventProducts'].forEach((v) {
        eventProducts!.add(EventProducts.fromJson(v));
      });
    } else {
      eventProducts = [];
    }

    id = json['id'] ?? '';
  }




}

class EventProducts {
  String? sId;
  String? event;
  String? user;
  Product? product;
  String? createdAt;
  String? updatedAt;
  int? iV;

  EventProducts(
      {this.sId,
        this.event,
        this.user,
        this.product,
        this.createdAt,
        this.updatedAt,
        this.iV});

  EventProducts.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    event = json['event'];
    user = json['user'];
    product = json['product'] != null ? new Product.fromJson(json['product']) : null;
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }
}