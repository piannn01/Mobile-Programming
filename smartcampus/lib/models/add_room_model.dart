class PlaceModel {
  final String id;
  final String name;
  final String description;
  final bool isAvailable;
  final String? bookedBy;
  final DateTime? bookingDate;
  final DateTime? endDate;

  PlaceModel({
    required this.id,
    required this.name,
    required this.description,
    required this.isAvailable,
    this.bookedBy,
    this.bookingDate,
    this.endDate,
  });

  // Add the copyWith method
  PlaceModel copyWith({
    String? id,
    String? name,
    String? description,
    bool? isAvailable,
    String? bookedBy,
    DateTime? bookingDate,
    DateTime? endDate,
  }) {
    return PlaceModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      isAvailable: isAvailable ?? this.isAvailable,
      bookedBy: bookedBy ?? this.bookedBy,
      bookingDate: bookingDate ?? this.bookingDate,
      endDate: endDate ?? this.endDate,
    );
  }

  // Optional: fromMap and toMap for Firebase integration
  factory PlaceModel.fromMap(String id, Map<String, dynamic> map) {
    return PlaceModel(
      id: id,
      name: map['name'] as String,
      description: map['description'] as String,
      isAvailable: map['isAvailable'] as bool,
      bookedBy: map['bookedBy'] as String?,
      bookingDate: map['bookingDate'] != null
          ? DateTime.parse(map['bookingDate'] as String)
          : null,
      endDate: map['endDate'] != null
          ? DateTime.parse(map['endDate'] as String)
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'isAvailable': isAvailable,
      'bookedBy': bookedBy,
      'bookingDate': bookingDate?.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
    };
  }
}
