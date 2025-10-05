import 'package:ecozyne_mobile/data/models/region.dart';
import 'package:ecozyne_mobile/data/services/region_service.dart';
import 'package:flutter/material.dart';

class RegionProvider with ChangeNotifier {
  final RegionService _regionService = RegionService();

  bool _isLoading = false;
  List<Kecamatan> _kecamatanList = [];
  Kecamatan? _selectedKecamatan;
  Kelurahan? _selectedKelurahan;

  bool get isLoading => _isLoading;
  List<Kecamatan> get kecamatanList => _kecamatanList;
  Kecamatan? get selectedKecamatan => _selectedKecamatan;
  Kelurahan? get selectedKelurahan => _selectedKelurahan;

  List<Kelurahan> get kelurahanList {
    if (_selectedKecamatan == null) return [];
    return _selectedKecamatan!.kelurahan;
  }

  Future<void> loadRegions() async {
    _isLoading = true;
    notifyListeners();

    try {
      _kecamatanList = await _regionService.fetchRegions();
    } catch (e) {
      debugPrint('Gagal ambil region: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void selectKecamatan(Kecamatan? kecamatan) {
    _selectedKecamatan = kecamatan;
    _selectedKelurahan = null;
    notifyListeners();
  }

  void selectKelurahan(Kelurahan? kelurahan) {
    _selectedKelurahan = kelurahan;
    notifyListeners();
  }
}