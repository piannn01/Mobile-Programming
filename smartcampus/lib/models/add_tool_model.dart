class ToolModel {
  final String id;
  final String name;
  final String description;
  final bool isAvailable;
  final String? bookedBy;
  final DateTime? bookingDate;
  final DateTime? endDate;

  ToolModel({
    required this.id,
    required this.name,
    required this.description,
    required this.isAvailable,
    this.bookedBy,
    this.bookingDate,
    this.endDate,
  });

  // Factory untuk membuat ToolModel dari Firestore
  factory ToolModel.fromMap(String id, Map<String, dynamic> data) {
    return ToolModel(
      id: id,
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      isAvailable: data['isAvailable'] ?? true,
      bookedBy: data['bookedBy'],
      bookingDate: data['bookingDate'] != null
          ? DateTime.parse(data['bookingDate'])
          : null,
      endDate: data['endDate'] != null
          ? DateTime.parse(data['endDate'])
          : null,
    );
  }

  // Metode copyWith
  ToolModel copyWith({
    String? id,
    String? name,
    String? description,
    bool? isAvailable,
    String? bookedBy,
    DateTime? bookingDate,
    DateTime? endDate,
  }) {
    return ToolModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      isAvailable: isAvailable ?? this.isAvailable,
      bookedBy: bookedBy ?? this.bookedBy,
      bookingDate: bookingDate ?? this.bookingDate,
      endDate: endDate ?? this.endDate,
    );
  }
}