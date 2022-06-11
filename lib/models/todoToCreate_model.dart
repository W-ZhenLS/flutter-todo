// To parse this JSON data, do
//
//     final todoToUpdateModel = todoToUpdateModelFromJson(jsonString);

import 'dart:convert';

TodoToCreateModel todoToCreateModelFromJson(String str) => TodoToCreateModel.fromJson(json.decode(str));

String todoToCreateModelToJson(TodoToCreateModel data) => json.encode(data.toJson());

class TodoToCreateModel {
    TodoToCreateModel({
        this.title,
        this.description,
        this.date,
    });

    String? title;
    String? description;
    DateTime? date;

    factory TodoToCreateModel.fromJson(Map<String, dynamic> json) => TodoToCreateModel(
        title: json["title"],
        description: json["description"],
        date: DateTime.parse(json["date"]),
    );

    Map<String, dynamic> toJson() => {
        "title": title,
        "description": description,
        "date": date!.toIso8601String(),
    };
}
