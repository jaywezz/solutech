// To parse this JSON data, do
//
//     final customers = customersFromJson(jsonString);

import 'dart:convert';

List<Customers> customersFromJson(String str) => List<Customers>.from(json.decode(str).map((x) => Customers.fromJson(x)));

String customersToJson(List<Customers> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Customers {
    int id;
    String name;
    DateTime createdAt;

    Customers({
        required this.id,
        required this.name,
        required this.createdAt,
    });

    factory Customers.fromJson(Map<String, dynamic> json) => Customers(
        id: json["id"],
        name: json["name"],
        createdAt: DateTime.parse(json["created_at"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "created_at": createdAt.toIso8601String(),
    };
}
