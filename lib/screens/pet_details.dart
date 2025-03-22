import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pets_tracker/models/pet.dart';
import 'package:intl/intl.dart';
import 'package:pets_tracker/services/firebase_service.dart';
import 'package:pets_tracker/services/image_service.dart';
import 'package:pets_tracker/services/notifications.dart';
import 'package:pets_tracker/widgets/detail_row.dart';
import 'package:pets_tracker/widgets/pet_image.dart';

class PetDetails extends StatefulWidget {
  const PetDetails({super.key, required this.pet, this.onImageSelected});

  final Pet pet;
  final Function(int)? onImageSelected;

  @override
  _PetDetailsState createState() => _PetDetailsState();
}

class _PetDetailsState extends State<PetDetails> {
  // ignore: unused_field
  String? _imagePath;
  final NotificationService _notificationService = NotificationService();
  final ImageService _imageService = ImageService();
  final FirebaseService _firebaseService = FirebaseService();

  Future<void> _pickImage() async {
    try {
      final imagePath = await _imageService.pickImage();
      if (imagePath != null) {
        final path = await _imageService.generateFilePath(XFile(imagePath));
        await _imageService.saveImageToAppDirectory(XFile(imagePath), path);

        setState(() {
          _imagePath = path;
          widget.pet.images.add(path);
        });

        await _firebaseService.updatePetImages(
            widget.pet.id, widget.pet.images);

        _notificationService.showNotification(
            2, 'Success!', 'Pet was updated in firebase!');
      }
    } catch (e) {
      _notificationService.showNotification(
          2, 'Fail!', 'Could not pick image!');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.pet.name),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DetailRow(label: 'Name:', value: widget.pet.name),
              DetailRow(label: 'Species:', value: widget.pet.species),
              DetailRow(
                  label: 'Date of Birth:',
                  value: DateFormat('yyyy-MM-dd').format(widget.pet.dob)),
              const SizedBox(height: 10),
              const Padding(
                padding: EdgeInsets.only(bottom: 15.0),
                child: Text(
                  'All Images:',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
              for (int i = 0; i < widget.pet.images.length; i++)
                GestureDetector(
                  onTap: () {
                    if (widget.onImageSelected != null) {
                      widget.onImageSelected!(i);
                    }
                  },
                  child: PetImage(imagePath: widget.pet.images[i]),
                ),
              const SizedBox(height: 10),
              Center(
                child: ElevatedButton(
                  onPressed: _pickImage,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 16),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)),
                  ),
                  child: const Text('Add Image'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
