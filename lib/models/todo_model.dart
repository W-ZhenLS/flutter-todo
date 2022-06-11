// To parse this JSON data, do
//
//     final todoModel = todoModelFromJson(jsonString);

import 'dart:convert';

TodosModel todoModelFromJson(String str) => TodosModel.fromJson(json.decode(str));

String todoModelToJson(TodosModel data) => json.encode(data.toJson());

class TodosModel {
    TodosModel({
        this.id,
        this.title,
        this.description,
        this.date,
        this.isCompleted,
    });

    int? id;
    String? title;
    String? description;
    DateTime? date;
    bool? isCompleted;

    factory TodosModel.fromJson(Map<String, dynamic> json) => TodosModel(
        id: json["id"],
        title: json["title"],
        description: json["description"],
        date: DateTime.parse(json["date"]),
        isCompleted: json["isCompleted"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "description": description,
        "date": date!.toIso8601String(),
        "isCompleted": isCompleted,
    };
}
