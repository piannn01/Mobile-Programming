import 'package:cloud_firestore/cloud_firestore.dart';
class ReportModel {
  final String id;
  final String userId;
  final String message;
  final String status; // Bisa memiliki status seperti 'pending', 'resolved', etc.
  final DateTime createdAt;

  ReportModel({
    required this.id,
    required this.userId,
    required this.message,
    required this.status,
    required this.createdAt,
  });

  // Untuk membuat model dari data Firestore
  factory ReportModel.fromMap(String id, Map<String, dynamic> data) {
    return ReportModel(
      id: id,
      userId: data['userId'],
      message: data['message'],
      status: data['status'],
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }

  // Untuk mengubah ke format map agar dapat disimpan ke Firestore
  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'message': message,
      'status': status,
      'createdAt': createdAt,
    };
  }
}