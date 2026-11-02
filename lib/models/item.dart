class Item {
  final int? id;
  final String itemName;
  final String description;
  final String location;
  final String date;
  final String type;
  final String? imagePath;
  final String status;

  const Item({
    this.id,
    required this.itemName,
    required this.description,
    required this.location,
    required this.date,
    required this.type,
    this.imagePath,
    this.status = 'Pending',
  }) : assert(type == 'Lost' || type == 'Found'),
       assert(
         status == 'Pending' || status == 'Claimed' || status == 'Returned',
       );

  factory Item.fromMap(Map<String, dynamic> map) {
    final rawImagePath = map['imagePath'] as String?;

    return Item(
      id: map['id'] as int?,
      itemName: map['itemName'] as String,
      description: map['description'] as String,
      location: map['location'] as String,
      date: map['date'] as String,
      type: map['type'] as String,
      imagePath: rawImagePath == null || rawImagePath.trim().isEmpty
          ? null
          : rawImagePath,
      status: map['status'] as String? ?? 'Pending',
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'itemName': itemName,
      'description': description,
      'location': location,
      'date': date,
      'type': type,
      'imagePath': imagePath == null || imagePath!.trim().isEmpty
          ? null
          : imagePath,
      'status': status,
    };
  }

  Item copyWith({
    int? id,
    String? itemName,
    String? description,
    String? location,
    String? date,
    String? type,
    String? imagePath,
    String? status,
  }) {
    return Item(
      id: id ?? this.id,
      itemName: itemName ?? this.itemName,
      description: description ?? this.description,
      location: location ?? this.location,
      date: date ?? this.date,
      type: type ?? this.type,
      imagePath: imagePath ?? this.imagePath,
      status: status ?? this.status,
    );
  }
}
