import 'dart:io';

import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:flutter_scroll_to_top/flutter_scroll_to_top.dart';
import 'package:shape_shifter_mobile/data/controllers/documents_list_controller.dart';
import 'package:shape_shifter_mobile/data/model/document_model.dart';
import 'package:shape_shifter_mobile/pages/document_page/document_page.dart';
import 'package:shape_shifter_mobile/pages/documents_page/documents_list_widget.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shape_shifter_mobile/pages/image_crop_page/image_crop_page.dart';

import '../../data/repository/documents_repository.dart';

class DocumentsPage extends StatefulWidget {
  const DocumentsPage({super.key});

  @override
  State<DocumentsPage> createState() => _DocumentsPageState();
}

enum SortBy {
  nameUp("Имя", Iconsax.arrow_up_2, "name_up"),
  nameDown("Имя", Iconsax.arrow_down_1, "name_down"),
  dateUp("Дата", Iconsax.arrow_up_2, "date_up"),
  dateDown("Дата", Iconsax.arrow_down_1, "date_down");

  const SortBy(this.label, this.iconData, this.func);

  final String label;
  final IconData iconData;
  final String func;
}

class _DocumentsPageState extends State<DocumentsPage> {
  final ScrollController _scrollController = ScrollController();
  final String _title = "ShapeShifter";
  SortBy? _sortBy;
  bool _isImageSelected = false;
  File? _imageFile;

  void _scrollUp() {
    _scrollController.animateTo(
      _scrollController.position.minScrollExtent,
      duration: const Duration(seconds: 1),
      curve: Curves.fastOutSlowIn,
    );
  }

  _pickImageFromGallery() async {
    try {
      final pickedImage =
          await ImagePicker().pickImage(source: ImageSource.gallery);
      if (pickedImage != null) {
        setState(() {
          _imageFile = File(pickedImage.path);
          _isImageSelected = true;
        });
      } else {
        setState(() {
          _imageFile = null;
          _isImageSelected = false;
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }

  _pickImageFromCamera() async {
    try {
      final pickedImage =
          await ImagePicker().pickImage(source: ImageSource.camera);
      if (pickedImage != null) {
        setState(() {
          _imageFile = File(pickedImage.path);
          _isImageSelected = true;
        });
      } else {
        setState(() {
          _imageFile = null;
          _isImageSelected = false;
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Widget documentWidget(DocumentModel document, ThemeData theme,
      DocListController docListController) {
    final DateFormat formatter = DateFormat('HH:MM dd/MM/yyyy');
    return InkWell(
      onTap: () async {
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return DocumentPage(document: document);
            },
          ),
        );
        setState(() {
          // redraw page
          docListController.repeatQuery();
        });
      },
      child: Container(
        margin: const EdgeInsets.all(10.0),
        padding: const EdgeInsets.all(5.0),
        color: theme.colorScheme.primaryContainer,
        child: Column(
          children: [
            Center(
              child: ConstrainedBox (
                constraints: BoxConstraints(
                  maxHeight: 400,
                ),
                child: Image.file(
                  File(document.url),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Center(
              child: Text(
                textAlign: TextAlign.center,
                document.name.length > 50
                    ? "${document.name.substring(0, 50)}..."
                    : document.name,
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
    );
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final docListController = context.watch<DocListController>();
    final docListState = docListController.value;
    final itemCount = docListState.documents.length +
        (DocListStatusIndicator.hasStatus(docListState) ? 1 : 0);
    if (this._sortBy == null) {
      this._sortBy = SortBy.dateDown;
    }
    const TextStyle textStyle = TextStyle(
      fontSize: 18,
      color: Colors.black,
    );
    var sortByDropdown = Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: theme.colorScheme.outline,
          style: BorderStyle.solid,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
      child: DropdownButton<SortBy>(
        value: this._sortBy,
        icon:
            const Visibility(visible: false, child: Icon(Icons.arrow_downward)),
        style: textStyle,
        dropdownColor: Colors.white.withOpacity(0),
        selectedItemBuilder: (BuildContext context) {
          return SortBy.values.map((SortBy sortBy) {
            return Container(
              width: 80,
              alignment: Alignment.center,
              color: theme.colorScheme.inversePrimary,
              padding: const EdgeInsets.all(5),
              child: Row(
                children: [
                  Text(
                    this._sortBy!.label,
                    style: textStyle,
                  ),
                  Icon(
                    this._sortBy!.iconData,
                    size: 20,
                  ),
                ],
              ),
            );
          }).toList();
        },
        items: SortBy.values.map<DropdownMenuItem<SortBy>>((SortBy sortBy) {
          return DropdownMenuItem<SortBy>(
            value: sortBy,
            child: Container(
              decoration: BoxDecoration(
                color: theme.colorScheme.inversePrimary,
              ),
              alignment: Alignment.center,
              padding: const EdgeInsets.all(8),
              margin: const EdgeInsets.all(0),
              child: Row(
                children: [
                  Text(
                    sortBy.label,
                    style: textStyle,
                  ),
                  Icon(
                    sortBy.iconData,
                    size: 20,
                  ),
                ],
              ),
            ),
          );
        }).toList(),
        onChanged: (SortBy? sortBy) {
          setState(
            () {
              _scrollUp();
              this._sortBy = sortBy;
              docListController
                  .repeatQuery(DocQuery(sortBy: this._sortBy?.func));
            },
          );
        },
      ),
    );

    return Scaffold(
      appBar: AppBar(
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
                  )
                ],
              ),
            ),
            sortByDropdown,
          ],
        ),
      ),
      body: Scaffold(
        body: ScrollWrapper(

          reverse: true,
          primary: true,
          scrollDirection: Axis.vertical,
          promptAlignment: Alignment.topCenter,
          promptDuration: const Duration(milliseconds: 300),
          enabledAtOffset: 100,
          alwaysVisibleAtOffset: true,
          scrollOffsetUntilVisible: 200,
          promptTheme: PromptButtonTheme(
            icon: Icon(
              Iconsax.arrow_up_2,
              size: 25,
              color: theme.colorScheme.primary,
            ),
            color: theme.colorScheme.inversePrimary,
            iconPadding: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(32),
          ),
          builder: (context, properties) => ListView.builder(
            controller: _scrollController,
            itemBuilder: (context, index) {
              if (index == docListState.documents.length &&
                  DocListStatusIndicator.hasStatus(docListState)) {
                return DocListStatusIndicator(
                  docListState,
                  onRepeat: docListController.repeatQuery,
                );
              }
              final document = docListState.documents[index];
              return documentWidget(document, theme, docListController);
            },
            itemCount: itemCount,
          ),
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            margin: const EdgeInsets.all(5),
            child: FloatingActionButton(
              heroTag: "galleryButton",
              onPressed: () async {
                await _pickImageFromGallery();
                if (_isImageSelected) {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return ImageCropPage(imageFile: _imageFile!);
                      },
                    ),
                  );
                  setState(() {
                    //redraw page
                    docListController.repeatQuery();
                  });
                }
              },
              foregroundColor: theme.colorScheme.primary,
              backgroundColor: theme.colorScheme.onPrimary,
              child: const Icon(
                Iconsax.image,
                size: 25,
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.all(5),
            child: FloatingActionButton(
              heroTag: "cameraButton",
              onPressed: () async {
                await _pickImageFromCamera();
                if (_isImageSelected) {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return ImageCropPage(imageFile: _imageFile!);
                      },
                    ),
                  );
                  setState(() {
                    //redraw page
                      docListController.repeatQuery();
                  });
                }
              },
              foregroundColor: theme.colorScheme.primary,
              backgroundColor: theme.colorScheme.onPrimary,
              child: const Icon(
                Iconsax.camera,
                size: 25,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
