import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/spell_model.dart';
import '../services/api_service.dart';
import '../services/notification_service.dart';
import '../utils/custom_snackbar.dart';
import 'favorite_spells_view.dart';
import 'login_view.dart';

// Halaman Spells View
// Menampilkan daftar mantra dari API dan fitur toggle favorite dengan Hive
class SpellsView extends StatefulWidget {
  const SpellsView({super.key});

  @override
  State<SpellsView> createState() => _SpellsViewState();
}

class _SpellsViewState extends State<SpellsView> {
  late Future<List<Spell>> _spellsFuture;
  final Box _favoriteBox = Hive.box('favorite_spells');

  @override
  void initState() {
    super.initState();
    // Memanggil API spells saat halaman pertama kali dibuka
    _spellsFuture = ApiService.getSpells();
  }

  // Fungsi untuk toggle (tambah / hapus) favorite di Hive
  Future<void> _toggleFavorite(Spell spell) async {
    final bool isFavorite = _favoriteBox.containsKey(spell.spell);

    if (isFavorite) {
      // Jika sudah ada di favorit, hapus dari Hive
      await _favoriteBox.delete(spell.spell);

      if (!mounted) return;
      // Tampilkan SnackBar warna merah sesuai contoh
      CustomSnackBar.showError(
        context: context,
        title: 'Remove!',
        message: '${spell.spell} removed from fav list!',
      );
    } else {
      // Jika belum ada di favorit, simpan ke Hive
      await _favoriteBox.put(spell.spell, spell.toMap());

      if (!mounted) return;
      // Tampilkan SnackBar warna hijau sesuai contoh
      CustomSnackBar.showSuccess(
        context: context,
        title: 'Add!',
        message: '${spell.spell} successfully added to fav list!',
      );
      await NotificationService.showAddNotification(spellName: spell.spell);
    }
  }

  // Fungsi logout untuk menghapus session dan kembali ke login
  Future<void> _handleLogout() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('is_logged_in', false);
    await prefs.remove('username');

    if (!mounted) return;

    // Tampilkan snackbar logout sukses
    CustomSnackBar.showSuccess(
      context: context,
      title: 'Success!',
      message: 'Logged out Successfully',
    );

    // Navigasi kembali ke LoginView dan bersihkan stack halaman
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginView()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading:
            false, // Menghilangkan tombol back default jika ada
        title: const Text(
          'Harry Potter Spells Gallery',
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        actions: [
          // Tombol navigasi ke Halaman Favorite Spell
          IconButton(
            icon: const Icon(Icons.favorite, color: Colors.redAccent),
            tooltip: 'Favorite Spells',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const FavoriteSpellsView(),
                ),
              );
            },
          ),
          // Tombol Logout pada AppBar sesuai ketentuan
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.black87),
            tooltip: 'Logout',
            onPressed: _handleLogout,
          ),
        ],
      ),
      body: FutureBuilder<List<Spell>>(
        future: _spellsFuture,
        builder: (context, snapshot) {
          // Status saat masih memuat data dari API
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // Status jika terjadi error
          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 48, color: Colors.red),
                  const SizedBox(height: 12),
                  Text('Terjadi kesalahan: ${snapshot.error}'),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _spellsFuture = ApiService.getSpells();
                      });
                    },
                    child: const Text('Coba Lagi'),
                  ),
                ],
              ),
            );
          }

          // Status jika data berhasil dimuat
          final spells = snapshot.data ?? [];

          return ValueListenableBuilder(
            valueListenable: _favoriteBox.listenable(),
            builder: (context, Box box, _) {
              return ListView.separated(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 80),
                itemCount: spells.length,
                separatorBuilder: (context, index) => const SizedBox(height: 8),
                itemBuilder: (context, index) {
                  final spell = spells[index];
                  // Cek apakah spell ini sudah ada di dalam Hive box
                  final bool isFav = box.containsKey(spell.spell);

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
                        vertical: 4,
                      ),
                      // Nama Mantra
                      title: Text(
                        spell.spell,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: Colors.black87,
                        ),
                      ),
                      // Kegunaan Mantra
                      subtitle: Text(
                        spell.use,
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey.shade700,
                        ),
                      ),
                      // Tombol icon hati untuk toggle favorite
                      trailing: IconButton(
                        icon: Icon(
                          isFav ? Icons.favorite : Icons.favorite_border,
                          color: isFav ? Colors.red : Colors.black87,
                          size: 22,
                        ),
                        onPressed: () => _toggleFavorite(spell),
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
      // Tombol mengambang di bawah untuk pindah kembali ke Characters
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              OutlinedButton(
                onPressed: () {
                  Navigator.pop(context); // Kembali ke CharacterView
                },
                style: OutlinedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  side: BorderSide(color: Colors.grey.shade400),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 10,
                  ),
                ),
                child: const Text(
                  'Characters',
                  style: TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
