class Perkembangan {
  final int? id;
  final int balitaId; // Relasi dengan Balita
  final DateTime tanggalUkur;
  final double lingkarKepala;
  final String caraUkur; // enum: terlentang, berdiri
  final double lingkarLenganAtas;
  final double beratBadan;
  final double tinggiBadan;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Perkembangan({
    this.id,
    required this.balitaId,
    required this.tanggalUkur,
    required this.lingkarKepala,
    required this.caraUkur,
    required this.lingkarLenganAtas,
    required this.beratBadan,
    required this.tinggiBadan,
    this.createdAt,
    this.updatedAt,
  });

  // Mapping ke database
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'balitaId': balitaId,
      'tanggalUkur': tanggalUkur.toIso8601String(),
      'lingkarKepala': lingkarKepala,
      'caraUkur': caraUkur,
      'lingkarLenganAtas': lingkarLenganAtas,
      'beratBadan': beratBadan,
      'tinggiBadan': tinggiBadan,
      'createdAt': createdAt?.toIso8601String(), // Sertakan createdAt
      'updatedAt': updatedAt?.toIso8601String(), // Sertakan updatedAt
    };
  }

  // Mapping dari database
  factory Perkembangan.fromMap(Map<String, dynamic> map) {
    return Perkembangan(
      id: map['id'],
      balitaId: map['balitaId'],
      tanggalUkur: DateTime.parse(map['tanggalUkur']),
      lingkarKepala: map['lingkarKepala'],
      caraUkur: map['caraUkur'],
      lingkarLenganAtas: map['lingkarLenganAtas'],
      beratBadan: map['beratBadan'],
      tinggiBadan: map['tinggiBadan'],
      createdAt: map['createdAt'] != null
          ? DateTime.parse(map['createdAt'])
          : null, // Handle null
      updatedAt: map['updatedAt'] != null
          ? DateTime.parse(map['updatedAt'])
          : null, // Handle null
    );
  }
}
