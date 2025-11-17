class Validators {
  static Map<String, dynamic>? _serverErrors;

  static void setServerErrors(Map<String, dynamic>? errors) {
    _serverErrors = errors;
  }

  static void clearFieldError(String field) {
    _serverErrors?.remove(field);
  }

  static void clearServerErrors() {
    _serverErrors = null;
  }

  static String? validationError(String field) {
    if (_serverErrors == null) return null;
    final errorList = _serverErrors![field];
    if (errorList == null || errorList.isEmpty) return null;
    return errorList.first;
  }

  static String? emailLogin(String? value) {
    value = value?.trim();
    if (value == null || value.isEmpty) return "Email wajib diisi";
    final regex = RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$");
    if (!regex.hasMatch(value)) return "Format email tidak valid";

    return null;
  }

  static String? email(String? value) {
    value = value?.trim();
    if (value == null || value.isEmpty) return "Email wajib diisi";
    final regex = RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$");
    if (!regex.hasMatch(value)) return "Format email tidak valid";

    final validateField = validationError("email");
    if (validateField != null) return validateField;

    return null;
  }

  static String? password(String? value) {
    value = value?.trim();
    if (value == null || value.isEmpty) return "Password wajib diisi";
    if (value.length < 8) return "Minimal 8 karakter";

    if (value.contains(' ')) {
      return "Password tidak boleh mengandung spasi";
    }

    // Validasi huruf kecil dan huruf besar
    final hasUpperLower = RegExp(r'^(?=.*[a-z])(?=.*[A-Z])');
    if (!hasUpperLower.hasMatch(value)) {
      return "Harus mengandung huruf besar dan huruf kecil";
    }

    // Validasi angka
    final hasNumber = RegExp(r'(?=.*\d)');
    if (!hasNumber.hasMatch(value)) {
      return "Harus mengandung angka";
    }

    // Valdiasi simbol
    final hasSymbol = RegExp(r'(?=.*[@$!%*?&._\-])');
    if (!hasSymbol.hasMatch(value)) {
      return "Harus mengandung simbol (cont. @, #, !, &)";
    }

    final validateField = validationError("password");
    if (validateField != null) return validateField;

    return null;
  }

  static String? username(String? value) {
    value = value?.trim();
    if (value == null || value.isEmpty) return "Nama pengguna wajib diisi";

    final validateField = validationError("username");
    if (validateField != null) return validateField;

    return null;
  }

  static String? postalCode(String? value) {
    value = value?.trim();
    if (value == null || value.isEmpty) return "Kode pos wajib diisi";
    if (value.length != 5) return "Kode pos tidak valid";

    final validateField = validationError("postal_code");
    if (validateField != null) return validateField;

    return null;
  }

  static String? name(String? value) {
    value = value?.trim();
    if (value == null || value.isEmpty) return "Nama wajib diisi";

    final validateField = validationError("name");
    if (validateField != null) return validateField;

    return null;
  }

  static String? whatsapp(String? value) {
    value = value?.trim();
    if (value == null || value.isEmpty) return "Nomor WhatsApp wajib diisi";
    if (!RegExp(r'^[0-9]+$').hasMatch(value)) return "Hanya angka";
    if (value.length < 10) return "Nomor terlalu pendek";

    final validateField = validationError("phone_number");
    if (validateField != null) return validateField;

    return null;
  }

  static String? address(String? value) {
    value = value?.trim();
    if (value == null || value.isEmpty) return "Alamat wajib diisi";

    final validateField = validationError("address");
    if (validateField != null) return validateField;

    return null;
  }

  static String? bankName(String? value) {
    value = value?.trim();
    if (value == null || value.isEmpty) return "Nama bank sampah wajib diisi";

    final validateField = validationError("bank_name");
    if (validateField != null) return validateField;

    return null;
  }

  static String? documentFile(String? value) {
    if (value == null || value.isEmpty) {
      return "File persetujuan wajib diunggah (format PDF)";
    }
    if (!value.toLowerCase().endsWith(".pdf")) {
      return "File harus berformat PDF";
    }

    final validateField = validationError("document_file");
    if (validateField != null) return validateField;

    return null;
  }

  static String? description(String? value) {
    value = value?.trim();
    if (value == null || value.isEmpty) return "Deskripsi wajib diisi";

    final validateField = validationError("description");
    if (validateField != null) return validateField;

    return null;
  }
}
