import 'dart:convert';
import 'package:dio/dio.dart';

class OpenStreetMapService {
  static const String _baseUrl = 'https://nominatim.openstreetmap.org';
  final Dio _dio;

  OpenStreetMapService({Dio? dio}) : _dio = dio ?? Dio(BaseOptions(
    baseUrl: _baseUrl,
    headers: {
      'User-Agent': 'EcoZyneMobileApp/1.0',
      'Accept-Language': 'id',
      'Referer': 'ecozyne.app',
    },
  ));

  /// Reverse Geocoding: Dapatkan alamat dari koordinat
  Future<Map<String, dynamic>?> reverseGeocode(double lat, double lon) async {
    try {
      final response = await _dio.get(
        '/reverse',
        queryParameters: {
          'format': 'json',
          'lat': lat,
          'lon': lon,
          'addressdetails': 1,
          'zoom': 18,
        },
      );

      if (response.statusCode == 200) {
        return response.data;
      }
    } on DioException catch (e) {
      print('OpenStreetMap Reverse Geocode Error: ${e.message}');
    }

    return null;
  }

  /// Ambil kode pos dari hasil reverse geocode
  Future<String?> getPostalCode(double lat, double lon) async {
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

  /// Ambil alamat lengkap
  Future<Map<String, String>?> getFullAddress(double lat, double lon) async {
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