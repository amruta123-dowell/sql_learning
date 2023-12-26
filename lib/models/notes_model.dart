import 'package:intl/intl.dart';

class Notes {
  int? id;
   String? title;
  late final String date;
  String? description;
  int? priority;
  Notes(
      {this.id,
      this.description,
      required this.title,
      required this.date,
      required this.priority});

//Extract a Notes object from a Map object
  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {};
    map["id"] = id;
    map["title"] = title;
    map["date"] = date;
    map["priority"] = priority ?? 1;
    map["description"] = description;
    return map;
  }

  Notes.fromMap(Map<String, dynamic> map) {
    id = map["id"];
    title = map["title"]??'';
    date = map["date"];
    // formattedDate(map["date"]);
    priority = map["priority"] ?? 1;
    description = map["description"];
  }

  String formattedDate(String date) {
    print(DateFormat("dd-MM-yyyy").format(DateFormat().parse(date)));
    return DateFormat("dd-MM-yyyy").format(DateFormat().parse(date));
  }
}
