import 'package:flutter/material.dart';

// Helper class untuk menampilkan custom SnackBar di bagian atas layar sesuai screenshot latihan
class CustomSnackBar {
  // Menampilkan snackbar sukses / tambah data (warna hijau)
  static void showSuccess({
    required BuildContext context,
    required String title,
    required String message,
  }) {
    _showCustomSnackBar(
      context: context,
      title: title,
      message: message,
      backgroundColor: const Color(0xFF4CAF50), // Warna hijau
    );
  }

  // Menampilkan snackbar gagal / hapus data (warna merah)
  static void showError({
    required BuildContext context,
    required String title,
    required String message,
  }) {
    _showCustomSnackBar(
      context: context,
      title: title,
      message: message,
      backgroundColor: const Color(0xFFE53935), // Warna merah
    );
  }

  // Fungsi internal untuk membuat SnackBar melayang di bagian atas
  static void _showCustomSnackBar({
    required BuildContext context,
    required String title,
    required String message,
    required Color backgroundColor,
  }) {
    // Sembunyikan snackbar aktif sebelumnya agar tidak menumpuk
    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    final screenHeight = MediaQuery.of(context).size.height;
    // Menempatkan SnackBar di atas seperti pada gambar soal
    final topMargin = (screenHeight - 140).clamp(16.0, screenHeight);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.only(
          bottom: topMargin,
          left: 16,
          right: 16,
        ),
        backgroundColor: backgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        duration: const Duration(seconds: 2),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              message,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
