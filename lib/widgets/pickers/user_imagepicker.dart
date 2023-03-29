import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UserImagePicker extends StatefulWidget {
  final void Function(File pickedImage) imagePickFun;

  const UserImagePicker(this.imagePickFun, {super.key});
  @override
  State<UserImagePicker> createState() => _UserImagePickerState();
}

class _UserImagePickerState extends State<UserImagePicker> {
  File? _pickedImage;

  Future pickimages() async {
    var image = await ImagePicker().pickImage(source: ImageSource.camera);
    setState(() {
      image == null ? null : _pickedImage = File(image.path);
    });
    _pickedImage == null ? null : widget.imagePickFun(_pickedImage!);
  }

  Future pickimagesgalry() async {
    var image = await ImagePicker().pickImage(source: ImageSource.gallery);
    setState(() {
      image == null ? null : _pickedImage = File(image.path);
    });

    _pickedImage == null ? null : widget.imagePickFun(_pickedImage!);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 40,
          backgroundColor: Colors.white,
          backgroundImage: _pickedImage != null
              ? FileImage(_pickedImage!)
              : const AssetImage('images/personal photo.png') as ImageProvider,
        ),
        const SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
                onPressed: () async => pickimages(),
                icon: const Icon(
                  Icons.camera_alt_outlined,
                  size: 30,
                  color: Colors.grey,
                )),
            IconButton(
                onPressed: () async => pickimagesgalry(),
                icon: const Icon(
                  Icons.image_outlined,
                  size: 30,
                  color: Colors.grey,
                ))
          ],
        )
      ],
    );
  }
}
