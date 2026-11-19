import 'dart:io';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// Service untuk mengelola notifikasi lokal pada perangkat
class NotificationService {
  // Instance singleton dari FlutterLocalNotificationsPlugin
  static final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  // Inisialisasi pengaturan notifikasi untuk Android
  static Future<void> initializeNotification() async {
    // Ikon notifikasi menggunakan ic_launcher bawaan aplikasi Android
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
    );

    // Di flutter_local_notifications v23+, parameter menggunakan named arguments
    await _flutterLocalNotificationsPlugin.initialize(
      settings: initializationSettings,
    );

    // Meminta izin notifikasi (wajib untuk Android 13 / Tiramisu ke atas)
    if (Platform.isAndroid) {
      final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
          _flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>();
      await androidImplementation?.requestNotificationsPermission();
    }
  }

  // Menampilkan notifikasi langsung (Immediate Notification) saat spell dihapus
  static Future<void> showDeleteNotification({required String spellName}) async {
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      'delete_channel_id', // ID unik channel notifikasi
      'Delete Notification', // Nama channel
      channelDescription: 'Notifikasi ketika mantra favorit dihapus',
      importance: Importance.max, // Prioritas tinggi agar muncul sebagai banner pop-up
      priority: Priority.high,
      playSound: true,
    );

    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
    );

    // Menampilkan notifikasi secara langsung dengan named arguments
    await _flutterLocalNotificationsPlugin.show(
      id: DateTime.now().millisecondsSinceEpoch ~/ 1000, // ID notifikasi unik
      title: 'Delete notification', // Judul notifikasi sesuai ketentuan contoh
      body: 'You deleted $spellName from your fav list!', // Pesan notifikasi
      notificationDetails: notificationDetails,
    );
  }
}
