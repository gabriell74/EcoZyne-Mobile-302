import 'package:dio/dio.dart';
import 'package:ecozyne_mobile/data/api_client.dart';
import 'package:ecozyne_mobile/data/models/region.dart';

class RegionService {
  final Dio _dio = ApiClient.dio;

  Future<List<Kecamatan>> fetchRegions() async {
    try {
      final response = await _dio.get('/regions');

      if (response.statusCode == 200 && response.data['data'] != null) {
        final List data = response.data['data'];
        return data.map((e) => Kecamatan.fromJson(e)).toList();
      } else {
        throw Exception('Data tidak ditemukan');
      }
    } on DioException catch (e) {
      throw Exception(
        e.response?.data['message'] ?? 'Gagal mengambil data region',
      );
    }
  }
}
