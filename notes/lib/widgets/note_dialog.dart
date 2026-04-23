import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:notes/models/note.dart';
import 'package:notes/services/note_service.dart';
import 'package:image_picker/image_picker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

class NoteDialog extends StatefulWidget {
  final Note? note;

  const NoteDialog({super.key, this.note});

  @override
  State<NoteDialog> createState() => _NoteDialogState();
}

class _NoteDialogState extends State<NoteDialog> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  File? _imageFile;
  String? _base64Image;
  double? _latitude;
  double? _longitude;

  @override
  void initState() {
    super.initState();
    if (widget.note != null) {
      _titleController.text = widget.note!.title;
      _descriptionController.text = widget.note!.description;
      _base64Image = widget.note!.imageBase64;
      _latitude = widget.note!.latitude;
      _longitude = widget.note!.longitude;
    }
  }

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final bytes = await pickedFile.readAsBytes();
      String base64Image = base64Encode(bytes);
      setState(() {
        _base64Image = base64Image;
        _imageFile = File(pickedFile.path);
      });
      print('Base64 String: $base64Image');
    }else {
      print('No image selected.');
    }
  }

  Future<void> _getLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Location services are disabled. Please enable them.')),
        );
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location permissions are denied. Please grant permission.')),
          );
          return;
        }
      }

      final position = await Geolocator.getCurrentPosition(locationSettings: const LocationSettings(accuracy: LocationAccuracy.high)).timeout(const Duration(seconds: 10));

      setState(() {
        _latitude = position.latitude;
        _longitude = position.longitude;
      });
    }catch (e) {
      debugPrint('Filed to retrive location: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to retrieve location. Please try again.')),
      );
      setState(() {
        _latitude = null;
        _longitude = null;
      });
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.note == null ? 'Add Notes' : 'Update Notes'),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min, // Tambahkan ini agar dialog tidak terlalu tinggi
        children: [
          // Isi input field dan widget gambar akan masuk di sini
          const Text(
            'Title: ',
            textAlign: TextAlign.start,
          ),
          TextField(
            controller: _titleController,
          ),
          const Padding(
            padding: EdgeInsets.only(top: 20),
            child: Text(
              'Description: ',
              textAlign: TextAlign.start,
            ),
          ),
          TextField(
            controller: _descriptionController,
            maxLines: null,
          ),
          
          const Padding(
            padding: EdgeInsets.only(top: 20),
            child: Text('Image: '),
          ),
          Expanded(
            child: _imageFile != null
                ? Image.file(_imageFile!, fit: BoxFit.cover)
                : (widget.note?.imageUrl != null &&
                        Uri.parse(widget.note!.imageUrl!).isAbsolute
                    ? Image.network(widget.note!.imageUrl!, fit: BoxFit.cover)
                    : Container()),
          ),
          TextButton(
            onPressed: _pickImage,
            child: const Text('Pick Image'),
          ),


        ],
      ),
      actions: [
        // Tombol Cancel dan Save akan masuk di sini
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cancel'),
          ),
        ),

        ElevatedButton(
          onPressed: () async {
            String? imageUrl;
            if (_imageFile != null) {
              imageUrl = await NoteService.uploadImage(_imageFile!);
            } else {
              imageUrl = widget.note?.imageUrl;
            }
            
            Note note = Note(
              id: widget.note?.id,
              title: _titleController.text,
              description: _descriptionController.text,
              imageUrl: imageUrl,
              createdAt: widget.note?.createdAt,
            );

            if (widget.note == null) {
              NoteService.addNote(note)
                  .whenComplete(() => Navigator.of(context).pop());
            } else {
              NoteService.updateNote(note)
                  .whenComplete(() => Navigator.of(context).pop());
            }
          },
          child: Text(widget.note == null ? 'Add' : 'Update'),
        ),
      ],
    );
  }
}