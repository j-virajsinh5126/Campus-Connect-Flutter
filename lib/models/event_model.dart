class EventModel {
  final String id;
  final String title;
  final String description;
  final String category;
  final String location;
  final DateTime date;
  final String? imageUrl;
  final String organizer;
  final List<String> attendees;
  final DateTime createdAt;

  const EventModel({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.location,
    required this.date,
    this.imageUrl,
    required this.organizer,
    this.attendees = const [],
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'category': category,
      'location': location,
      'date': date.toIso8601String(),
      'imageUrl': imageUrl,
      'organizer': organizer,
      'attendees': attendees,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory EventModel.fromMap(Map<String, dynamic> map) {
    return EventModel(
      id: map['id'] as String,
      title: map['title'] as String,
      description: map['description'] as String,
      category: map['category'] as String,
      location: map['location'] as String,
      date: DateTime.parse(map['date'] as String),
      imageUrl: map['imageUrl'] as String?,
      organizer: map['organizer'] as String,
      attendees: List<String>.from(map['attendees'] ?? []),
      createdAt: DateTime.parse(map['createdAt'] as String),
    );
  }

  EventModel copyWith({
    String? id,
    String? title,
    String? description,
    String? category,
    String? location,
    DateTime? date,
    String? imageUrl,
    String? organizer,
    List<String>? attendees,
    DateTime? createdAt,
  }) {
    return EventModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      location: location ?? this.location,
      date: date ?? this.date,
      imageUrl: imageUrl ?? this.imageUrl,
      organizer: organizer ?? this.organizer,
      attendees: attendees ?? this.attendees,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is EventModel &&
            id == other.id &&
            title == other.title &&
            description == other.description &&
            category == other.category &&
            location == other.location &&
            date == other.date &&
            imageUrl == other.imageUrl &&
            organizer == other.organizer &&
            _listEquals(attendees, other.attendees) &&
            createdAt == other.createdAt;
  }

  @override
  int get hashCode => Object.hash(
    id,
    title,
    description,
    category,
    location,
    date,
    imageUrl,
    organizer,
    Object.hashAll(attendees),
    createdAt,
  );

  static bool _listEquals(List<String> a, List<String> b) {
    if (a.length != b.length) return false;

    for (var i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }

    return true;
  }
}
