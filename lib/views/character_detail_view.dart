import 'package:flutter/material.dart';
import '../models/character_model.dart';

// Halaman Detail Karakter Harry Potter
// Menampilkan semua property atau data karakter sesuai ketentuan responsi
class CharacterDetailView extends StatelessWidget {
  final Character character;

  const CharacterDetailView({super.key, required this.character});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        // Tombol kembali
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        // Judul AppBar menampilkan nama lengkap karakter
        title: Text(
          character.fullName,
          style: const TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Foto Karakter
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  width: 220,
                  height: 280,
                  color: Colors.grey.shade200,
                  child: Image.network(
                    character.image,
                    fit: BoxFit.cover,
                    // Placeholder saat memuat gambar
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    },
                    // Tampilan alternatif jika gambar gagal dimuat
                    errorBuilder: (context, error, stackTrace) {
                      return const Center(
                        child: Icon(
                          Icons.person,
                          size: 80,
                          color: Colors.grey,
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Nama Karakter & Rumah Hogwarts
            Text(
              character.fullName,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
            if (character.hogwartsHouse.isNotEmpty) ...[
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                decoration: BoxDecoration(
                  color: _getHouseColor(character.hogwartsHouse).withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: _getHouseColor(character.hogwartsHouse),
                    width: 1,
                  ),
                ),
                child: Text(
                  character.hogwartsHouse,
                  style: TextStyle(
                    color: _getHouseColor(character.hogwartsHouse),
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
              ),
            ],
            const SizedBox(height: 24),

            // Card rincian semua properti karakter
            Card(
              elevation: 0,
              color: Colors.grey.shade50,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: BorderSide(color: Colors.grey.shade200),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    _buildDetailRow(
                      icon: Icons.badge_outlined,
                      label: 'Full Name',
                      value: character.fullName,
                    ),
                    const Divider(height: 20),
                    _buildDetailRow(
                      icon: Icons.person_outline,
                      label: 'Nickname',
                      value: character.nickname.isNotEmpty ? character.nickname : '-',
                    ),
                    const Divider(height: 20),
                    _buildDetailRow(
                      icon: Icons.shield_outlined,
                      label: 'Hogwarts House',
                      value: character.hogwartsHouse.isNotEmpty ? character.hogwartsHouse : '-',
                    ),
                    const Divider(height: 20),
                    _buildDetailRow(
                      icon: Icons.movie_outlined,
                      label: 'Interpreted By (Actor)',
                      value: character.interpretedBy.isNotEmpty ? character.interpretedBy : '-',
                    ),
                    const Divider(height: 20),
                    _buildDetailRow(
                      icon: Icons.cake_outlined,
                      label: 'Birthdate',
                      value: character.birthdate.isNotEmpty ? character.birthdate : '-',
                    ),
                    const Divider(height: 20),
                    _buildDetailRow(
                      icon: Icons.family_restroom_outlined,
                      label: 'Children',
                      value: character.children.isNotEmpty
                          ? character.children.join(', ')
                          : 'None',
                    ),
                    const Divider(height: 20),
                    _buildDetailRow(
                      icon: Icons.tag_outlined,
                      label: 'Character Index',
                      value: character.index.toString(),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper widget untuk membuat baris detail dengan ikon, label, dan value
  Widget _buildDetailRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: Colors.grey.shade700),
        const SizedBox(width: 12),
        Expanded(
          flex: 2,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          flex: 3,
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 13,
              color: Colors.black87,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.end,
          ),
        ),
      ],
    );
  }

  // Helper warna berdasarkan asrama Hogwarts
  Color _getHouseColor(String house) {
    switch (house.toLowerCase()) {
      case 'gryffindor':
        return Colors.red.shade800;
      case 'slytherin':
        return Colors.green.shade800;
      case 'ravenclaw':
        return Colors.blue.shade800;
      case 'hufflepuff':
        return Colors.amber.shade900;
      default:
        return Colors.deepPurple;
    }
  }
}
