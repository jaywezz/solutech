// To parse this JSON data, do
//
//     final activities = activitiesFromJson(jsonString);

import 'dart:convert';

List<Activities> activitiesFromJson(String str) => List<Activities>.from(json.decode(str).map((x) => Activities.fromJson(x)));

String activitiesToJson(List<Activities> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Activities {
    int id;
    String description;
    bool isSelected;
    DateTime createdAt;

    Activities({
        required this.id,
        required this.description,
        required this.isSelected,
        required this.createdAt,
    });

    factory Activities.fromJson(Map<String, dynamic> json) => Activities(
        id: json["id"],
        description: json["description"],
        isSelected: false,
        createdAt: DateTime.parse(json["created_at"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "description": description,
        "created_at": createdAt.toIso8601String(),
    };
}
