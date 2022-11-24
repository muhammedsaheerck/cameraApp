import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class myHomePage extends StatefulWidget {
  @override
  State<myHomePage> createState() => _myHomePageState();
}

class _myHomePageState extends State<myHomePage> {
  File? image;
  List imagearray = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Camera App'),
      ),
      body: Center(
        child: ListView(
          children:[ Column(
            children: [
              CustomButton(
                title: 'Pick a Camera',
                icon: Icons.camera,
                onClick: () async {
                  PermissionStatus cameraStatus =
                      await Permission.camera.request();
                  if (cameraStatus == PermissionStatus.granted) {
                    getimage();
                  } else if (cameraStatus == PermissionStatus.denied) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text('The permission is recomended')));
                  } else if (cameraStatus ==
                      PermissionStatus.permanentlyDenied) {
                    openAppSettings();
                  }
                },
              ),
              Container(
                width: MediaQuery.of(context).size.width*8,
                height: MediaQuery.of(context).size.height*8,
                decoration: BoxDecoration(border: Border.all(width:2)),
                  child: imagearray.isEmpty
                      ? const Center(
                          child: Text('No image'),
                        )
                      : GridView.count(
                          crossAxisCount: 3,
                          children: List.generate(imagearray.length, (index) {
                            var img = imagearray[index];
                            return Image.file(img);
                          }),
                        )),
            ],
          ),
          ]
        ),
      ),
    );
  }

  Future getimage() async {
    final image = await ImagePicker().pickImage(source: ImageSource.camera);
    if (image == null) {
      return;
    }
    final imageTemp = File(image.path);
    imagearray.add(imageTemp);
    setState(() {
      // this.image = imageTemp;
      imagearray;
    });

  }
}

Widget CustomButton({
  required String title,
  required IconData icon,
  required VoidCallback onClick,
}) {
  return Container(
      width: 280,
      child: Row(
        children: [
          ElevatedButton(
              onPressed: onClick,
              child: Row(
                children: [
                  Icon(icon),
                  const SizedBox(
                    width: 20,
                  ),
                  Text(title),
                ],
              ))
        ],
      ));
}
