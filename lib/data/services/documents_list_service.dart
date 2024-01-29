import 'package:shape_shifter_mobile/data/model/document_model.dart';

enum ListStage { idle, loading, error, complete }

class DocListState {
  DocListState({
    List<DocumentModel>? documents,
    this.stage = ListStage.idle,
  }) : documentsStore = documents {
    if (isInitialized &&
        stage != ListStage.complete &&
        this.documents.isEmpty) {
      throw Exception("List is empty but has stage marker other than complete");
    }
  }

  final List<DocumentModel>? documentsStore; // текущие записи

  bool get isInitialized => documentsStore != null;

  final ListStage stage;

  List<DocumentModel> get documents =>
      documentsStore ?? List<DocumentModel>.empty();

  bool get hasError => stage == ListStage.error;

  bool get isLoading => stage == ListStage.loading;

  // т.к. объект ListState не изменяемый, копируем для изменений
  DocListState copyWith({
    List<DocumentModel>? records,
    ListStage? stage,
  }) {
    return DocListState(
      documents: records ?? documentsStore,
      stage: stage ?? this.stage,
    );
  }
}
