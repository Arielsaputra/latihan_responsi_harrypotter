// Model data untuk Mantra (Spell) Harry Potter
// Digunakan untuk mengubah JSON dari API https://potterapi-fedeperin.vercel.app/en/spells menjadi objek Dart

class Spell {
  final String spell;
  final String use;
  final int index;

  Spell({
    required this.spell,
    required this.use,
    required this.index,
  });

  // Factory method untuk membuat instance Spell dari JSON Map
  factory Spell.fromJson(Map<String, dynamic> json) {
    return Spell(
      spell: json['spell'] ?? '',
      use: json['use'] ?? '',
      index: json['index'] ?? 0,
    );
  }

  // Method untuk mengubah instance Spell ke Map (berguna saat menyimpan ke Hive)
  Map<String, dynamic> toMap() {
    return {
      'spell': spell,
      'use': use,
      'index': index,
    };
  }

  // Factory method untuk membuat instance Spell dari Map Hive
  factory Spell.fromMap(Map<dynamic, dynamic> map) {
    return Spell(
      spell: map['spell'] ?? '',
      use: map['use'] ?? '',
      index: map['index'] ?? 0,
    );
  }
}
