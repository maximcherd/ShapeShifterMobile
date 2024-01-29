import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:shape_shifter_mobile/data/model/document_model.dart';
import 'package:shape_shifter_mobile/data/repository/documents_repository.dart';
import 'package:shape_shifter_mobile/data/services/documents_list_service.dart';

class DocListController extends ValueNotifier<DocListState> {
  DocQuery? query;

  DocListController({this.query}) : super(DocListState()) {
    loadDocuments(query); // init
  }

  // get data for list
  Future<List<DocumentModel>> _fetchDocuments(DocQuery? query) async {
    final loadedDocuments = await DocRepository().queryDocuments(query);
    return loadedDocuments;
  }

  // state change
  Future<void> loadDocuments(DocQuery? query) async {
    // ignore new query if still loading
    if (value.isLoading) {
      return;
    }

    value = value.copyWith(stage: ListStage.loading);

    try {
      final fetchResult = await _fetchDocuments(query);

      // add to list
      value = value.copyWith(
        stage: ListStage.idle,
        records: fetchResult,
      );
    } catch (e) {
      value = value.copyWith(stage: ListStage.error);
      rethrow;
    }
  }

  // repeat to change state
  repeatQuery([DocQuery? query]) {
    if (query != null) {
      this.query = query;
    }
    return loadDocuments(this.query);
  }

  Future<bool> addDocument(File imageFile, String name) async {
    return await DocRepository().createAndAddDocument(imageFile, name);
  }

  Future<bool> deleteDocument(DocumentModel document) async {
    return await DocRepository().deleteDocument(document);
  }
}
