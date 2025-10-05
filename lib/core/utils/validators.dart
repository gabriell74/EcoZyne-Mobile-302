class Validators {
  static String? requiredField({String fieldName = "Field"}) {
    return "$fieldName wajib diisi";
  }

  static String? email(String? value) {
    if (value == null || value.isEmpty) return requiredField(fieldName: "Email");
    final regex = RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$");
    if (!regex.hasMatch(value.trim())) return "Format email tidak valid";
    return null;
  }

  static String? password(String? value) {
    if (value == null || value.isEmpty) return requiredField(fieldName: 'Password');
    if (value.length < 6) return "Minimal 8 karakter";
    return null;
  }

  static String? username(String? value) {
    if (value == null || value.isEmpty) return requiredField(fieldName: 'Nama Pengguna');
    if (value.length < 3) return "Minimal 3 karakter";
    return null;
  }

  static String? name(String? value) {
    if (value == null || value.isEmpty) return requiredField(fieldName: 'Nama');
    if (value.length < 3) return "Minimal 3 karakter";
    return null;
  }

  static String? whatsapp(String? value) {
    if (value == null || value.isEmpty) return requiredField(fieldName: 'No Whatsapp');
    if (!RegExp(r'^[0-9]+$').hasMatch(value)) return "Hanya angka";
    if (value.length < 10) return "Nomor terlalu pendek";
    return null;
  }

  static String? address(String? value) {
    if (value == null || value.isEmpty) return requiredField(fieldName: 'Alamat');
    return null;
  }
}
