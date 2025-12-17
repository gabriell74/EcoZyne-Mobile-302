import 'dart:convert';
import 'package:http/http.dart' as http;

class OpenStreetMapService {
  static const String _baseUrl = 'https://nominatim.openstreetmap.org';
  
  /// Reverse Geocoding: Dapatkan alamat dari koordinat
  static Future<Map<String, dynamic>?> reverseGeocode(double lat, double lon) async {
    final url = Uri.parse(
      '$_baseUrl/reverse?format=json&lat=$lat&lon=$lon&addressdetails=1&zoom=18'
    );
    
    try {
      final response = await http.get(
        url,
        headers: {
          'User-Agent': 'EcoZyneMobileApp/1.0', // WAJIB untuk Nominatim
          'Accept-Language': 'id', // Bahasa Indonesia
          'Referer': 'ecozyne.app', // Domain app Anda
        },
      );
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data;
      }
    } catch (e) {
      print('OpenStreetMap Reverse Geocode Error: $e');
    }
    
    return null;
  }
  
  /// Ambil kode pos dari hasil reverse geocode
  static Future<String?> getPostalCode(double lat, double lon) async {
    final data = await reverseGeocode(lat, lon);
    
    if (data != null && data['address'] != null) {
      final address = data['address'] as Map<String, dynamic>;
      
      // Coba berbagai key untuk kode pos
      return address['postcode'] ?? 
             address['postal_code'] ?? 
             address['postalcode'];
    }
    
    return null;
  }
  
  /// Ambil kecamatan dari hasil reverse geocode
  static Future<String?> getKecamatan(double lat, double lon) async {
    final data = await reverseGeocode(lat, lon);
    
    if (data != null && data['address'] != null) {
      final address = data['address'] as Map<String, dynamic>;
      
      // Untuk Indonesia, kecamatan biasanya di 'subdistrict' atau 'county'
      return address['subdistrict'] ?? 
             address['county'] ?? 
             address['city_district'];
    }
    
    return null;
  }
  
  /// Ambil kelurahan dari hasil reverse geocode
  static Future<String?> getKelurahan(double lat, double lon) async {
    final data = await reverseGeocode(lat, lon);
    
    if (data != null && data['address'] != null) {
      final address = data['address'] as Map<String, dynamic>;
      
      // Untuk Indonesia, kelurahan biasanya di 'village' atau 'suburb'
      return address['village'] ?? 
             address['suburb'] ?? 
             address['hamlet'];
    }
    
    return null;
  }
  
  /// Ambil alamat lengkap
  static Future<Map<String, String>?> getFullAddress(double lat, double lon) async {
    final data = await reverseGeocode(lat, lon);
    
    if (data != null && data['address'] != null) {
      final address = data['address'] as Map<String, dynamic>;
      
      return {
        'jalan': address['road'] ?? '',
        'kelurahan': address['village'] ?? address['suburb'] ?? '',
        'kecamatan': address['subdistrict'] ?? address['county'] ?? '',
        'kota': address['city'] ?? address['town'] ?? '',
        'provinsi': address['state'] ?? '',
        'kode_pos': address['postcode'] ?? address['postal_code'] ?? '',
        'negara': address['country'] ?? '',
        'display_name': data['display_name'] ?? '',
      };
    }
    
    return null;
  }
}