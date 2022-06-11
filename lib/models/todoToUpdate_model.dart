// To parse this JSON data, do
//
//     final todoToUpdateModel = todoToUpdateModelFromJson(jsonString);

import 'dart:convert';

TodoToUpdateModel todoToUpdateModelFromJson(String str) => TodoToUpdateModel.fromJson(json.decode(str));

String todoToUpdateModelToJson(TodoToUpdateModel data) => json.encode(data.toJson());

class TodoToUpdateModel {
    TodoToUpdateModel({
        this.title,
        this.description,
        this.date,
        this.isCompleted,
    });

    String? title;
    String? description;
    DateTime? date;
    bool? isCompleted;

    factory TodoToUpdateModel.fromJson(Map<String, dynamic> json) => TodoToUpdateModel(
        title: json["title"],
        description: json["description"],
        date: DateTime.parse(json["date"]),
        isCompleted: json["isCompleted"],
    );

    Map<String, dynamic> toJson() => {
        "title": title,
        "description": description,
        "date": date!.toIso8601String(),
        "isCompleted": isCompleted,
    };
}
