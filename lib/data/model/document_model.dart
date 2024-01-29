import 'package:uuid/uuid.dart';

var uuid = const Uuid();

class DocumentModel {
  final String id;
  String url;
  final DateTime creationDate;
  String name;

  DateTime now = DateTime.now();

  DocumentModel({
    required this.url,
    required this.creationDate,
    required this.name,
  }) : id = uuid.v4();

  DocumentModel.fromJson(dynamic json)
      : id = json['id'] as String,
        url = json['url'] as String,
        creationDate = DateTime.parse(json['creationDate']),
        name = json['name'] as String;

  Map<String, dynamic> toJson() => {
        'id': id,
        'url': url,
        'creationDate': creationDate.toString(),
        'name': name,
      };

  @override
  bool operator ==(Object other) {
    try {
      DocumentModel doc = other as DocumentModel;
      return this.url == doc.url &&
          this.creationDate == doc.creationDate &&
          this.name == doc.name;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }
}
