import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'models/complaint.dart';

import 'login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(ComplaintAdapter());
  await Hive.openBox<Complaint>('complaints');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(debugShowCheckedModeBanner: false, home: Login());
  }
}
