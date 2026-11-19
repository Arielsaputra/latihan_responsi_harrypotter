import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'services/notification_service.dart';
import 'views/character_view.dart';
import 'views/login_view.dart';

void main() async {
  // Memastikan binding Flutter terinisialisasi sebelum memanggil kode async native
  WidgetsFlutterBinding.ensureInitialized();

  // 1. Inisialisasi Hive untuk penyimpanan lokal NoSQL
  await Hive.initFlutter();
  // Membuka box Hive untuk menyimpan data spell favorit
  await Hive.openBox('favorite_spells');

  // 2. Inisialisasi Service Notifikasi Lokal
  await NotificationService.initializeNotification();

  // 3. Pengecekan Session Login menggunakan SharedPreferences
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final bool isLoggedIn = prefs.getBool('is_logged_in') ?? false;

  // Jalankan aplikasi dengan status login awal
  runApp(MyApp(isLoggedIn: isLoggedIn));
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;

  const MyApp({super.key, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Harry Potter App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.white,
      ),
      // Jika sudah login sebelumnya, langsung arahkan ke CharacterView, jika belum ke LoginView
      home: isLoggedIn ? const CharacterView() : const LoginView(),
    );
  }
}
