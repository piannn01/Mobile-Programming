class ItemModel {
  String id;
  String name;
  String description;
  bool isAvailable;
  String? bookedBy;
  DateTime? bookingDate;
  DateTime? endDate;

  ItemModel({
    required this.id,
    required this.name,
    required this.description,
    required this.isAvailable,
    this.bookedBy,
    this.bookingDate,
    this.endDate,
  });

  // Convert Firebase Map to ItemModel
  factory ItemModel.fromMap(String id, Map<String, dynamic> data) {
    return ItemModel(
      id: id,
      name: data['name'],
      description: data['description'],
      isAvailable: data['isAvailable'],
      bookedBy: data['bookedBy'],
      bookingDate: data['bookingDate'] != null
          ? DateTime.parse(data['bookingDate'])
          : null,
      endDate: data['endDate'] != null
          ? DateTime.parse(data['endDate'])
          : null,
    );
  }

  // Convert ItemModel to Firebase Map
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
