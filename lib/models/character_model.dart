// Model data untuk Karakter Harry Potter
// Digunakan untuk mengubah JSON dari API https://potterapi-fedeperin.vercel.app/en/characters menjadi objek Dart

class Character {
  final String fullName;
  final String nickname;
  final String hogwartsHouse;
  final String interpretedBy;
  final List<String> children;
  final String image;
  final String birthdate;
  final int index;

  Character({
    required this.fullName,
    required this.nickname,
    required this.hogwartsHouse,
    required this.interpretedBy,
    required this.children,
    required this.image,
    required this.birthdate,
    required this.index,
  });

  // Factory method untuk membuat instance Character dari JSON Map
  factory Character.fromJson(Map<String, dynamic> json) {
    return Character(
      fullName: json['fullName'] ?? '',
      nickname: json['nickname'] ?? '',
      hogwartsHouse: json['hogwartsHouse'] ?? '',
      interpretedBy: json['interpretedBy'] ?? '',
      // Konversi list dinamis menjadi List<String>
      children: (json['children'] as List<dynamic>?)
              ?.map((item) => item.toString())
              .toList() ??
          [],
      image: json['image'] ?? '',
      birthdate: json['birthdate'] ?? '',
      index: json['index'] ?? 0,
    );
  }

  // Method untuk mengubah instance Character kembali ke format Map/JSON
  Map<String, dynamic> toJson() {
    return {
      'fullName': fullName,
      'nickname': nickname,
      'hogwartsHouse': hogwartsHouse,
      'interpretedBy': interpretedBy,
      'children': children,
      'image': image,
      'birthdate': birthdate,
      'index': index,
    };
  }
}
