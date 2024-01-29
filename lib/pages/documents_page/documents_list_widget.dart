import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:shape_shifter_mobile/data/services/documents_list_service.dart';

class DocListStatusIndicator extends StatelessWidget {
  final DocListState listState;
  final Function()? onRepeat;

  const DocListStatusIndicator(this.listState, {this.onRepeat, Key? key})
      : super(key: key);

  static bool hasStatus(DocListState listState) =>
      listState.hasError ||
      listState.isLoading ||
      (listState.isInitialized && listState.documents.isEmpty);

  @override
  Widget build(BuildContext context) {
    Widget? stateIndicator;
    if (listState.hasError) {
      stateIndicator = const Text("Ошибка загрузки", textAlign: TextAlign.center);
      if (onRepeat != null) {
        stateIndicator = Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            stateIndicator,
            const SizedBox(width: 8),
            IconButton(onPressed: onRepeat, icon: const Icon(Iconsax.refresh))
          ],
        );
      }
    } else if (listState.isLoading) {
      stateIndicator = const CircularProgressIndicator();
    } else if (listState.isInitialized && listState.documents.isEmpty) {
      stateIndicator = const Text("Нет результатов", textAlign: TextAlign.center);
    }

    if (stateIndicator == null) return Container();

    return Container(alignment: Alignment.center, child: stateIndicator);
  }
}
