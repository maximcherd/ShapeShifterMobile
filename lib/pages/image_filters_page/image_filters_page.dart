import 'dart:io';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:shape_shifter_mobile/data/controllers/documents_list_controller.dart';

class ImageFiltersPage extends StatefulWidget {
  final File imageFile;

  const ImageFiltersPage({super.key, required this.imageFile});

  @override
  State<ImageFiltersPage> createState() => _ImageFiltersPageState();
}

class _ImageFiltersPageState extends State<ImageFiltersPage> {
  final String _title = "Фильтры";
  Widget? _currImage;
  bool _isNormal = true;
  late TextEditingController _nameController;
  String? _docName;

  void saveImg() async {
    File imageFile = widget.imageFile;
    if (!_isNormal) {
      //no logic for this
    }
    if (_docName == null) {
      //why?
      return;
    }
    var docListController = DocListController();
    await docListController.addDocument(imageFile, _docName!);
    int count = 0;
    Navigator.of(context).popUntil((_) => count++ >= 2);
  }

  Future<void> _showSaveDialog() async {
    ThemeData theme = Theme.of(context);
    _nameController = TextEditingController();
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            "Сохранить документ",
            style: TextStyle(
              color: theme.colorScheme.onSurface,
            ),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                TextField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    labelText: 'Название документа',
                    labelStyle: TextStyle(
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                  maxLines: 1,
                  maxLength: 200,
                  style: TextStyle(
                    color: theme.colorScheme.onSurface,
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Сохранить'),
              onPressed: () {
                if (_nameController.value.text.isNotEmpty) {
                  _docName = _nameController.value.text;
                  _nameController.clear();
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    print(widget.imageFile.lengthSync());
    final ThemeData theme = Theme.of(context);
    final TextStyle buttonBarTextStyle = TextStyle(
      color: theme.colorScheme.primary,
    );
    imageCache.clear();
    imageCache.clearLiveImages();
    if (_currImage == null) {
      _currImage = Image.file(
        widget.imageFile,
      );
    }
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        automaticallyImplyLeading: false,
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
          ],
        ),
      ),
      body: Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer,
                border: Border.all(
                  color: theme.colorScheme.primaryContainer,
                  width: 5,
                ),
                borderRadius: BorderRadius.circular(5),
              ),
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  maxHeight: 500,
                ),
                child: _currImage,
              ),
            ),
            Container(
              height: 100,
              child: Row(
                children: [
                  InkWell(
                    customBorder: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                    onTap: () {
                      setState(() {
                        _currImage = Image.file(
                          widget.imageFile,
                        );
                        _isNormal = true;
                      });
                    },
                    child: Container(
                      width: 100,
                      alignment: Alignment.center,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Iconsax.record,
                            size: 30,
                            color: theme.colorScheme.primary,
                          ),
                          Text(
                            "Без фильтра",
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
                    onTap: () {
                      setState(() {
                        _currImage = ColorFiltered(
                          colorFilter: const ColorFilter.mode(
                            Colors.white,
                            BlendMode.saturation,
                          ),
                          child: Image.file(
                            widget.imageFile,
                          ),
                        );
                        _isNormal = false;
                      });
                    },
                    child: Container(
                      width: 100,
                      alignment: Alignment.center,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Iconsax.flash_circle1,
                            size: 30,
                            color: theme.colorScheme.primary,
                          ),
                          Text(
                            "Чёрно-\nбелый",
                            style: buttonBarTextStyle,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
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
                Navigator.of(context).pop(true);
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
                await _showSaveDialog();
                saveImg();
              },
              child: Container(
                width: 100,
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Iconsax.arrow_right_1,
                      size: 30,
                      color: theme.colorScheme.primary,
                    ),
                    Text(
                      "Далее",
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
