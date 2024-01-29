import 'dart:io';

import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:shape_shifter_mobile/data/controllers/documents_list_controller.dart';
import 'package:shape_shifter_mobile/data/model/document_model.dart';

class DocumentPage extends StatefulWidget {
  final DocumentModel document;

  const DocumentPage({super.key, required this.document});

  @override
  State<DocumentPage> createState() => _DocumentPageState();
}

class _DocumentPageState extends State<DocumentPage> {
  final String _title = "Документ";

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final document = widget.document;
    final DateFormat formatter = DateFormat('HH:MM dd/MM/yyyy');
    Image docImage = Image.file(
      File(document.url),
      fit: BoxFit.cover,
    );
    final TextStyle buttonBarTextStyle = TextStyle(
      color: theme.colorScheme.primary,
    );
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        surfaceTintColor: Colors.transparent,
        backgroundColor: theme.colorScheme.inversePrimary,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              _title,
              style: const TextStyle(
                fontSize: 28,
                color: Colors.black,
                fontWeight: FontWeight.bold,
                shadows: [
                  Shadow(
                    offset: Offset(0.0, 0.0),
                    blurRadius: 10.0,
                    color: Colors.white,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Container(
          margin: const EdgeInsets.all(10.0),
          padding: const EdgeInsets.all(5.0),
          color: theme.colorScheme.primaryContainer,
          child: Column(
            children: [
              Center(
                child: Container(
                  child: docImage,
                ),
              ),
              Center(
                child: Text(
                  textAlign: TextAlign.center,
                  document.name,
                  style: TextStyle(
                    fontSize: 20,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  formatter.format(document.creationDate),
                  style: TextStyle(
                    fontSize: 15,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        height: 75,
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              color: theme.colorScheme.outline,
              width: 1,
            ),
          ),
        ),
        child: ButtonBar(
          alignment: MainAxisAlignment.spaceAround,
          mainAxisSize: MainAxisSize.max,
          children: [
            InkWell(
              customBorder: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50),
              ),
              onTap: () {
                Navigator.of(context).pop();
              },
              child: Container(
                width: 100,
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Iconsax.arrow_left,
                      size: 30,
                      color: theme.colorScheme.primary,
                    ),
                    Text(
                      "Назад",
                      style: buttonBarTextStyle,
                    ),
                  ],
                ),
              ),
            ),
            InkWell(
              customBorder: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50),
              ),
              onTap: () async {
                DocListController docListController = DocListController();
                await docListController.deleteDocument(document);
                Navigator.of(context).pop();
              },
              child: Container(
                width: 100,
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Iconsax.trash,
                      size: 30,
                      color: theme.colorScheme.primary,
                    ),
                    Text(
                      "Удалить",
                      style: buttonBarTextStyle,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
