import 'dart:convert';
import 'package:karmalab_assignment/models/product_model.dart';

Chat chatFromJson(String str) => Chat.fromJson(json.decode(str));

String chatToJson(Chat data) => json.encode(data.toJson());

class Chat {
  final String status;
  final int total;
  final int count;
  final List<Datum> data;

  Chat({
    required this.status,
    required this.total,
    required this.count,
    required this.data,
  });

  factory Chat.fromJson(Map<String, dynamic> json) => Chat(
    status: json["status"] ?? "",
    total: json["total"] ?? 0,
    count: json["count"] ?? 0,
    data: List<Datum>.from((json["data"] ?? []).map((x) => Datum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "total": total,
    "count": count,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class Datum {
  final String id;
  final User user;
  final String replyTo;
  final String title;
  final String message;
  final String description;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int v;

  Datum({
    required this.id,
    required this.user,
    required this.replyTo,
    required this.title,
    required this.message,
    required this.description,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["_id"] ?? "",
    user: User.fromJson(json["user"] ?? {}),
    replyTo: json["replyTo"] ?? "",
    title: json["title"] ?? "",
    message: json["message"] ?? "",
    description: json["description"] ?? "",
    createdAt: DateTime.parse(json["createdAt"] ?? DateTime.now().toIso8601String()),
    updatedAt: DateTime.parse(json["updatedAt"] ?? DateTime.now().toIso8601String()),
    v: json["__v"] ?? 0,
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "user": user.toJson(),
    "replyTo": replyTo,
    "title": title,
    "message": message,
    "description": description,
    "createdAt": createdAt.toIso8601String(),
    "updatedAt": updatedAt.toIso8601String(),
    "__v": v,
  };
}
