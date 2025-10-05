class Kelurahan {
  final int id;
  final int kecamatanId;
  final String kelurahan;

  Kelurahan({
    required this.id,
    required this.kecamatanId,
    required this.kelurahan,
  });

  factory Kelurahan.fromJson(Map<String, dynamic> json) => Kelurahan(
    id: json['id'],
    kecamatanId: json['kecamatan_id'],
    kelurahan: json['kelurahan'],
  );
}

class Kecamatan {
  final int id;
  final String kecamatan;
  final List<Kelurahan> kelurahan;

  Kecamatan({
    required this.id,
    required this.kecamatan,
    required this.kelurahan,
  });

  factory Kecamatan.fromJson(Map<String, dynamic> json) => Kecamatan(
    id: json['id'],
    kecamatan: json['kecamatan'],
    kelurahan: (json['kelurahan'] as List)
        .map((e) => Kelurahan.fromJson(e))
        .toList(),
  );
}
