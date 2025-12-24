import 'package:hive_flutter/hive_flutter.dart';

part 'complaint.g.dart';

@HiveType(typeId: 0)
class Complaint extends HiveObject {
  @HiveField(0)
  late String id;

  @HiveField(1)
  late String title;

  @HiveField(2)
  late String description;

  @HiveField(3)
  late String category;

  @HiveField(4)
  late DateTime date;

  @HiveField(5)
  late String status;

  @HiveField(6)
  late String studentName;

  @HiveField(7)
  late String studentId;

  Complaint({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.date,
    required this.status,
    required this.studentName,
    required this.studentId,
  });
}
