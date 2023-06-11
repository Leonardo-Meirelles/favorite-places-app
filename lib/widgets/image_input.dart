import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImageInput extends StatefulWidget {
  const ImageInput({
    super.key,
    required this.onSelectImage,
  });

  final void Function(File image) onSelectImage;

  @override
  State<ImageInput> createState() => _ImageInputState();
}

class _ImageInputState extends State<ImageInput> {
  File? _selectedImage;

  void _takePicture(bool isFromCamera) async {
    final imagePicker = ImagePicker();

    final XFile? pickedImage = await imagePicker.pickImage(
      source: isFromCamera ? ImageSource.camera : ImageSource.gallery,
      maxWidth: 600,
    );

    if (pickedImage == null) return;

    setState(() {
      _selectedImage = File(pickedImage.path);
    });

    widget.onSelectImage(_selectedImage!);
  }

  @override
  Widget build(BuildContext context) {
    Widget content = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TextButton.icon(
          style: TextButton.styleFrom(
            foregroundColor: Theme.of(context).colorScheme.onBackground,
          ),
          onPressed: () => _takePicture(false),
          label: const Text('Gallery'),
          icon: const Icon(Icons.photo),
        ),
        TextButton.icon(
          style: TextButton.styleFrom(
            foregroundColor: Theme.of(context).colorScheme.onBackground,
          ),
          onPressed: () => _takePicture(true),
          icon: const Icon(Icons.camera),
          label: const Text('Camera'),
        ),
      ],
    );

    if (_selectedImage != null) {
      content = Stack(
        children: [
          Image.file(
            _selectedImage!,
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          Positioned(
            top: 0,
            left: 0,
            child: IconButton.filled(
              style: IconButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.onBackground,
              ),
              onPressed: () {
                setState(() {
                  _selectedImage = null;
                });
              },
              icon: const Icon(Icons.close),
            ),
          )
        ],
      );
    }

    return Container(
      height: 250,
      width: double.infinity,
      alignment: Alignment.center,
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        border: Border.all(
          color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: content,
    );
  }
}
