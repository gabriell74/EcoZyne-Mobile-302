class Validators {
  static String? requiredField(String? value, {String fieldName = "Field"}) {
    if (value == null || value.isEmpty) {
      return "$fieldName wajib diisi";
    }
    return null;
  }

  static String? email(String? value) {
    if (value == null || value.isEmpty) return "Email wajib diisi";
    final regex = RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$");
    if (!regex.hasMatch(value)) return "Format email tidak valid";
    return null;
  }

  static String? password(String? value) {
    if (value == null || value.isEmpty) return "Password wajib diisi";
    if (value.length < 6) return "Minimal 8 karakter";
    return null;
  }

  static String? username(String? value) {
    if (value == null || value.isEmpty) return "Nama pengguna wajib diisi";
    if (value.length < 3) return "Minimal 3 karakter";
    return null;
  }

  static String? whatsapp(String? value) {
    if (value == null || value.isEmpty) return "No WhatsApp wajib diisi";
    if (!RegExp(r'^[0-9]+$').hasMatch(value)) return "Hanya angka";
    if (value.length < 10) return "Nomor terlalu pendek";
    return null;
  }

  static String? address(String? value) {
    if (value == null || value.isEmpty) return "Alamat wajib diisi";
    return null;
  }
}
