import 'dart:io';
import 'dart:ui' as ui;
import 'package:crop_image/crop_image.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shape_shifter_mobile/pages/image_filters_page/image_filters_page.dart';

class ImageCropPage extends StatefulWidget {
  final File imageFile;

  const ImageCropPage({super.key, required this.imageFile});

  @override
  State<ImageCropPage> createState() => _ImageCropPageState();
}

class _ImageCropPageState extends State<ImageCropPage> {
  final String _title = "Редактирование";
  final _cropController = CropController(
    defaultCrop: const Rect.fromLTRB(0.1, 0.1, 0.9, 0.9),
  );

  void goToImageFiltersPage(File imageFile) {
    print(imageFile.lengthSync());
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => ImageFiltersPage(imageFile: imageFile),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0);
          const end = Offset.zero;
          const curve = Curves.ease;
          var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final TextStyle buttonBarTextStyle = TextStyle(
      color: theme.colorScheme.primary,
    );
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
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                border: Border.all(
                  color: theme.colorScheme.primaryContainer,
                  width: 5,
                ),
                borderRadius: BorderRadius.circular(5),
              ),
              child: CropImage(
                controller: _cropController,
                image: Image.file(
                  widget.imageFile,
                ),
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
                Navigator.pop(context);
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
              onTap: () {
                _cropController.rotateRight();
              },
              child: Container(
                width: 100,
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Iconsax.rotate_right,
                      size: 30,
                      color: theme.colorScheme.primary,
                    ),
                    Text(
                      "Повернуть",
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
                final tempDir = await getApplicationDocumentsDirectory();
                File croppedImageFile = File("${tempDir.path}/temp_image.png");
                if (croppedImageFile.existsSync()) {
                  croppedImageFile.delete();
                }
                ui.Image croppedImage = await _cropController.croppedBitmap();
                final data = await croppedImage.toByteData(
                  format: ui.ImageByteFormat.png,
                );
                final bytes = data!.buffer.asUint8List();
                croppedImageFile =
                    await croppedImageFile.writeAsBytes(bytes, flush: false);
                goToImageFiltersPage(croppedImageFile);
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
