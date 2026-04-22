import 'package:cloud_firestore/cloud_firestore.dart';

class Note {
  String? id;
  final String title;
  final String description;
  String? imageBase64;
  String? imageUrl;
  Timestamp? createdAt;
  Timestamp? updatedAt;

  Note({
    this.id,
    required this.title,
    required this.description,
    this.imageBase64,
    this.imageUrl,
    this.createdAt,
    this.updatedAt,
  });

  factory Note.fromDocument(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Note(
      id: doc.id,
      title: data['title'],
      description: data['description'],
      imageBase64: data['image_base64'],
      imageUrl: data['image_url'],
      createdAt: data['created_at'] as Timestamp,
      updatedAt: data['updated_at'] as Timestamp,
    );
  }

  Map<String, dynamic> toDocument() {
    return {
      'title': title,
      'description': description,
      'image_base64': imageBase64,
      'image_url': imageUrl,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}