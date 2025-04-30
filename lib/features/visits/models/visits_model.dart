// To parse this JSON data, do
//
//     final visits = visitsFromJson(jsonString);

import 'dart:convert';

List<Visits> visitsFromJson(String str) => List<Visits>.from(json.decode(str).map((x) => Visits.fromJson(x)));

String visitsToJson(List<Visits> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Visits {
    int? id;
    int customerId;
    DateTime visitDate;
    Status? status;
    String location;
    String notes;
    List<int> activitiesDone;
    DateTime createdAt;

    Visits({
        this.id,
        required this.customerId,
        required this.visitDate,
        this.status,
        required this.location,
        required this.notes,
        required this.activitiesDone,
        required this.createdAt,
    });

    factory Visits.fromJson(Map<String, dynamic> json) => Visits(
        id: json["id"],
        customerId: json["customer_id"],
        visitDate: DateTime.parse(json["visit_date"]),
        status: statusValues.map[json["status"]]!,
        location: json["location"],
        notes: json["notes"],
        activitiesDone: List<int>.from(json["activities_done"].map((x) => int.parse(x))),
        createdAt: DateTime.parse(json["created_at"]),
    );

    Map<String, dynamic> toJson() => {
        "customer_id": customerId,
        "visit_date": visitDate.toIso8601String(),
        "location": location,
        "notes": notes,
        "activities_done": List<dynamic>.from(activitiesDone.map((x) => x)),
        "created_at": createdAt.toIso8601String(),
        "status": "Pending",
    };
}

enum Status {
    CANCELLED,
    COMPLETED,
    PENDING
}

final statusValues = EnumValues({
    "Cancelled": Status.CANCELLED,
    "Completed": Status.COMPLETED,
    "Pending": Status.PENDING
});

class EnumValues<T> {
    Map<String, T> map;
    late Map<T, String> reverseMap;

    EnumValues(this.map);

    Map<T, String> get reverse {
            reverseMap = map.map((k, v) => MapEntry(v, k));
            return reverseMap;
    }
}
