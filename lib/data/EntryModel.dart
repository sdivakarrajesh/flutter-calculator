import 'dart:convert';

class Entry {
  int id;
  String num1;
  String num2;
  String operation;
  String result;

  Entry({this.id, this.num1, this.num2, this.operation, this.result});

  factory Entry.fromMap(Map<String, dynamic> json) => new Entry(
        id: json["id"],
        num1: json["num1"],
        num2: json["num2"],
        operation: json["operation"],
        result: json["result"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "num1": num1,
        "num2": num2,
        "operation": operation,
        "result": result,
      };
}

Entry entryFromJson(String str) {
  final jsonData = json.decode(str);
  return Entry.fromMap(jsonData);
}

String entryToJson(Entry data) {
  final dyn = data.toMap();
  return json.encode(dyn);
}
