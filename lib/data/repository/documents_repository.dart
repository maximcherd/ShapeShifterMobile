import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

import '../model/document_model.dart';

class DocRepository {
  List<DocumentModel> _store = [];

  static final DocRepository _instance = DocRepository._internal();

  factory DocRepository() => _instance;

  DocRepository._internal() : super();

  Future<bool> _loadDB() async {
    try {
      // load db from assets
      String dbPath = "assets/db/db.json";
      String db = await rootBundle.loadString(dbPath);
      List<dynamic> json = jsonDecode(db) as List<dynamic>;
      List<DocumentModel> documents = List<DocumentModel>.generate(
          json.length, (index) => DocumentModel.fromJson(json[index]));
      for (DocumentModel doc in documents) {
        final String imageName = doc.url.split('/').last;
        final String imageLocalPath = await _localFilePath("/images/$imageName");
        await File(imageLocalPath).create(recursive: true);
        ByteData image = await rootBundle.load(doc.url);
        await _writeToFile(image, imageLocalPath);
        doc.url = imageLocalPath;
      }
      // write db to local files
      String output = jsonEncode(documents);
      final String dbLocalPath = await _localFilePath("/db/db.json");
      // create file rec
      await File(dbLocalPath).create(recursive: true);
      await File(dbLocalPath).writeAsString(output);
      return true;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  Future<bool> _writeToFile(ByteData data, String path) async {
    try {
      await File(path).writeAsBytes(data.buffer.asUint8List());
      return true;
    } catch(e) {
      print(e.toString());
      return false;
    }
  }

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<String> _localFilePath(String filePath) async {
    final path = await _localPath;
    return '$path$filePath';
  }

  Future<bool> addDocument(DocumentModel doc) async {
    try {
      final String dbLocalPath = await _localFilePath("/db/db.json");
      String db = await File(dbLocalPath).readAsString();
      List<dynamic> json = jsonDecode(db) as List<dynamic>;
      List<DocumentModel> documents = List<DocumentModel>.generate(
          json.length, (index) => DocumentModel.fromJson(json[index]));
      documents.add(doc);
      String output = jsonEncode(documents);
      await File(dbLocalPath).writeAsString(output);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> deleteDocument(DocumentModel doc) async {
    try {
      final String dbLocalPath = await _localFilePath("/db/db.json");
      String db = await File(dbLocalPath).readAsString();
      List<dynamic> json = jsonDecode(db) as List<dynamic>;
      List<DocumentModel> documents = List<DocumentModel>.generate(
          json.length, (index) => DocumentModel.fromJson(json[index]));
      bool result = documents.remove(doc);
      String output = jsonEncode(documents);
      await File(dbLocalPath).writeAsString(output);
      print("doc delete $result");
      return result;
    } catch (e) {
      return false;
    }
  }

  Future<bool> createAndAddDocument(File imageFile, String name) async {
    const id = Uuid();
    String fileName = "${id.v4()}.png";
    String url = await _localFilePath("/images/$fileName");
    await imageFile.copy(url);
    DateTime creationDate = DateTime.now();
    DocumentModel doc = DocumentModel(url: url, creationDate: creationDate, name: name);
    return await addDocument(doc);
  }

  bool _dbLoaded = false;
  Future<List<DocumentModel>> queryDocuments(DocQuery? query) async {
    final String dbPath = await _localFilePath("/db/db.json");
    if (!File(dbPath).existsSync() && !_dbLoaded) {
      _dbLoaded = await _loadDB();
      print("DB loaded: $_dbLoaded");
    }
    String db = await File(dbPath).readAsString();
    List<dynamic> json = jsonDecode(db) as List<dynamic>;
    _store = List<DocumentModel>.generate(
        json.length, (index) => DocumentModel.fromJson(json[index]));
    // await Future.delayed(const Duration(seconds: 1));
    final sortedList = List.of(_store);
    if (query != null) sortedList.sort(query.compareDocs);
    return sortedList.where((doc) => query == null || query.fits(doc)).toList();
  }
}

class DocQuery {
  final String? contains;
  final String? sortBy;

  const DocQuery({
    this.contains,
    this.sortBy,
  });

  int compareDocs(DocumentModel doc1, DocumentModel doc2) {
    if (sortBy == null || sortBy!.isEmpty) {
      return 0;
    }
    switch (sortBy) {
      case "name_up":
        return compareByName(doc1, doc2);
      case "name_down":
        return -compareByName(doc1, doc2);
      case "date_up":
        return compareByCreationDate(doc1, doc2);
      case "date_down":
        return -compareByCreationDate(doc1, doc2);
      default:
        return 0;
    }
  }

  int compareByName(DocumentModel doc1, DocumentModel doc2) {
    return doc1.name.toLowerCase().compareTo(doc2.name.toLowerCase());
  }

  int compareByCreationDate(DocumentModel doc1, DocumentModel doc2) {
    return doc1.creationDate.compareTo(doc2.creationDate);
  }

  bool fits(DocumentModel doc) {
    if (contains == null || contains!.isEmpty) {
      return true;
    }
    return doc.name.contains(contains!);
  }
}
