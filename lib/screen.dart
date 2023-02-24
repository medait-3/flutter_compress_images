import 'package:compress_images_flutter/compress_images_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class compres extends StatefulWidget {
  const compres({super.key});

  @override
  State<compres> createState() => _compresState();
}

class _compresState extends State<compres> {
  final CompressImagesFlutter compressImagesFlutter = CompressImagesFlutter();
  XFile? photo;
  double photoLengthCompressed = 0;
  double photoLengthNormal = 0;
  final ImagePicker _picker = ImagePicker();
  File? newPhoto;
  File? compressedPhoto;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          if (newPhoto != null) {
            GallerySaver.saveImage(newPhoto!.path);
            print("saved");
            var snackBar = SnackBar(content: Text('Save in Gallery'));
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          } else {
            var snackBar = SnackBar(
              content: Text('select image'),
              duration: Duration(seconds: 60, milliseconds: 500),
              margin: EdgeInsets.only(
                left: 10,
                right: 10,
              ),
            );
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          }
        },
        label: Row(
          children: [Icon(Icons.save), Text('Save in Gallery')],
        ),
      ),
      appBar: AppBar(
        title: const Text('Compress image'),
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              InkWell(
                onTap: () async {
                  photo = await _picker.pickImage(
                    source: ImageSource.gallery,
                  );
                  setState(() {});
                  if (newPhoto != null) {
                    newPhoto = File(photo!.path);
                    compressedPhoto = await compressImagesFlutter
                        .compressImage(photo!.path, quality: 30);
                    photoLengthCompressed =
                        (((compressedPhoto!.readAsBytesSync().lengthInBytes) *
                                    1.0) /
                                1024) /
                            1024;
                    photoLengthNormal =
                        (((newPhoto!.readAsBytesSync().lengthInBytes) * 1.0) /
                                1024) /
                            1024;
                  }
                  if (newPhoto == compressedPhoto) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text('its comopressed before'),
                        duration: Duration(seconds: 3, milliseconds: 500),
                        behavior: SnackBarBehavior.floating,
                        margin: EdgeInsets.only(
                          bottom: 100,
                          left: 10,
                          right: 10,
                        ),
                      ),
                    );
                  } else {
                    print("no image");
                  }
                },
                child: Image(
                    fit: BoxFit.fill,
                    height: 115,
                    width: 115,
                    image: AssetImage("assets/add-image.png")),
              ),
              if (compressedPhoto != null)
                Image.file(
                  compressedPhoto!,
                  key: UniqueKey(),
                ),
              const SizedBox(
                height: 20.0,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
