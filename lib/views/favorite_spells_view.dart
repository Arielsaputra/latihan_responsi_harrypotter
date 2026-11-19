import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/spell_model.dart';
import '../services/notification_service.dart';
import '../utils/custom_snackbar.dart';

// Halaman Favorite Spells View
// Menampilkan daftar mantra yang telah difavoritkan menggunakan Hive
class FavoriteSpellsView extends StatelessWidget {
  const FavoriteSpellsView({super.key});

  @override
  Widget build(BuildContext context) {
    // Mengakses Hive box yang telah dibuka pada main.dart
    final Box favoriteBox = Hive.box('favorite_spells');

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        // Tombol kembali ke halaman sebelumnya
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Favorite Spell',
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
      // Menggunakan ValueListenableBuilder agar UI otomatis refresh saat data di Hive berubah
      body: ValueListenableBuilder(
        valueListenable: favoriteBox.listenable(),
        builder: (context, Box box, _) {
          // Jika belum ada mantra yang difavoritkan
          if (box.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.favorite_border,
                    size: 64,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 12),
                  Text(
                    'Belum ada mantra favorit.',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            );
          }

          // Mengambil semua item dari Hive dan mengubahnya menjadi List<Spell>
          final List<Spell> favoriteSpells = box.values.map((item) {
            final Map<dynamic, dynamic> map = item as Map<dynamic, dynamic>;
            return Spell.fromMap(map);
          }).toList();

          return ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            itemCount: favoriteSpells.length,
            separatorBuilder: (context, index) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final spell = favoriteSpells[index];

              return Card(
                elevation: 0,
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(color: Colors.grey.shade300),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 6,
                  ),
                  // Ikon buku mantra di sebelah kiri sesuai screenshot
                  leading: Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.book_outlined,
                      size: 20,
                      color: Colors.black87,
                    ),
                  ),
                  // Nama Mantra
                  title: Text(
                    spell.spell,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: Colors.black87,
                    ),
                  ),
                  // Kegunaan Mantra
                  subtitle: Text(
                    spell.use,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade700,
                    ),
                  ),
                  // Tombol Hapus (Ikon Tong Sampah Merah)
                  trailing: IconButton(
                    icon: const Icon(
                      Icons.delete,
                      color: Colors.redAccent,
                    ),
                    onPressed: () async {
                      await box.delete(spell.spell);

                      if (!context.mounted) return;

                      CustomSnackBar.showError(
                        context: context,
                        title: 'Remove!',
                        message: '${spell.spell} removed from fav list!',
                      );

                      await NotificationService.showDeleteNotification(
                        spellName: spell.spell,
                      );
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
