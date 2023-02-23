import 'dart:io';

import 'package:compress_images_flutter/compress_images_flutter.dart';
import 'package:flutter/material.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:image_picker/image_picker.dart';
import 'package:advertising_id/advertising_id.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final CompressImagesFlutter compressImagesFlutter = CompressImagesFlutter();
  XFile? photo;
  double photoLengthCompressed = 0;
  double photoLengthNormal = 0;
  final ImagePicker _picker = ImagePicker();
  File? newPhoto;
  File? compressedPhoto;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            GallerySaver.saveImage(newPhoto!.path);
            print("saved");

            // GallerySaver.saveImage(compressedPhoto!.path).then((String path) {print("object"),    });
          },
          label: Row(
            children: [Icon(Icons.save), Text('Save in Gallery')],
          ),
        ),
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                // TextButton(
                //     onPressed: () async {
                //      await compressImagesFlutter
                //           .rotateImage(compressedPhoto!.path);
                //       imageCache.clearLiveImages();
                //       imageCache.clear();
                //       setState(() {});
                //     },
                //     child: const Text('Rotate')),
                // TextButton(
                //     onPressed: () async {
                //       photo = await _picker.pickImage(
                //           source: ImageSource.camera, maxWidth: 1600);
                //       newPhoto = File(photo!.path);
                //       compressedPhoto = await compressImagesFlutter
                //           .compressImage(photo!.path, quality: 30);
                //       photoLengthCompressed =
                //           (((compressedPhoto!.readAsBytesSync().lengthInBytes) *
                //                       1.0) /
                //                   1024) /
                //               1024;
                //       photoLengthNormal =
                //           (((newPhoto!.readAsBytesSync().lengthInBytes) * 1.0) /
                //                   1024) /
                //               1024;
                //       setState(() {});
                //     },
                //     child: const Text("Take Photo")),
                TextButton(
                    onPressed: () async {
                      photo = await _picker.pickImage(
                          source: ImageSource.gallery, maxWidth: 1600);
                      // if (newPhoto != null) {
                      //   newPhoto = File(photo!.path);
                      // } else {
                      //   print('noimage');
                      // }
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
                      setState(() {});
                    },
                    child: const Text("Galery Photo")),
                Text(
                    'Compressed Photo ${photoLengthCompressed.toStringAsFixed(4)} mb'),
                // Text('Normal Photo ${photoLengthNormal.toStringAsFixed(4)} mb'),
                if (compressedPhoto != null)
                  Image.file(
                    compressedPhoto!,
                    key: UniqueKey(),
                  ),
                const SizedBox(
                  height: 20.0,
                ),
                if (newPhoto != null) Image.file(newPhoto!),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
