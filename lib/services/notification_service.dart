import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// Service untuk mengelola notifikasi lokal pada perangkat
class NotificationService {
  // Instance singleton dari FlutterLocalNotificationsPlugin
  static final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  // Inisialisasi pengaturan notifikasi untuk Android
  static Future<void> initializeNotification() async {
    // flutter_local_notifications tidak menyediakan implementasi untuk web.
    if (kIsWeb) return;

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
    if (defaultTargetPlatform == TargetPlatform.android) {
      final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
          _flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>();
      await androidImplementation?.requestNotificationsPermission();
    }
  }

  static Future<void> showAddNotification({required String spellName}) async {
    await _showNotification(
      channelId: 'add_channel_id',
      channelName: 'Add Notification',
      channelDescription: 'Notifikasi ketika mantra ditambahkan ke favorit',
      title: 'Add notification',
      body: 'You added $spellName to your fav list!',
    );
  }

  // Menampilkan notifikasi langsung (Immediate Notification) saat spell dihapus
  static Future<void> showDeleteNotification({required String spellName}) async {
    await _showNotification(
      channelId: 'delete_channel_id',
      channelName: 'Delete Notification',
      channelDescription: 'Notifikasi ketika mantra favorit dihapus',
      title: 'Delete notification',
      body: 'You deleted $spellName from your fav list!',
    );
  }

  static Future<void> _showNotification({
    required String channelId,
    required String channelName,
    required String channelDescription,
    required String title,
    required String body,
  }) async {
    if (kIsWeb) return;

    final AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      channelId,
      channelName,
      channelDescription: channelDescription,
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
    );

    final NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
    );

    await _flutterLocalNotificationsPlugin.show(
      id: DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title: title,
      body: body,
      notificationDetails: notificationDetails,
    );
  }
}
