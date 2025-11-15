import 'package:flutter/material.dart';
import 'package:ecozyne_mobile/data/models/answer.dart';
import 'package:ecozyne_mobile/data/services/answer_service.dart';

class AnswerProvider with ChangeNotifier {
  final AnswerService _answerService = AnswerService();

  List<Answer> _answers = [];
  bool _isLoading = false;
  bool _connected = true;
  String _message = "";

  List<Answer> get answers => _answers;
  bool get isLoading => _isLoading;
  bool get connected => _connected;
  String get message => _message;

  Future<void> fetchAnswers(int questionId) async {
    _isLoading = true;
    notifyListeners();

    final result = await _answerService.getAllAnswers(questionId);

    _isLoading = false;
    _connected = result["connected"] ?? false;

    if (result["success"] == true) {
      final data = result["data"];
      _answers = data != null ? List<Answer>.from(data) : [];
      _message = _answers.isNotEmpty ? "Berhasil mengambil jawaban" : "Belum ada jawaban";
    } else {
      _answers = [];
      _message = result["message"] ?? "Gagal memuat jawaban";
    }

    notifyListeners();
  }

  Future<bool> createAnswer(int questionId, String answerText) async {
    _isLoading = true;
    notifyListeners();

    final result = await _answerService.storeAnswer(questionId, answerText);

    _isLoading = false;
    _connected = result["connected"] ?? false;

    bool success = false;

    if (result["success"] == true && result["data"] != null) {
      final newAnswer = result["data"] as Answer;

      _answers.insert(0, newAnswer);

      _message = result["message"] ?? "Berhasil menambah jawaban";
      success = true;
    } else {
      _message = result["message"] ?? "Gagal menambah jawaban";
    }

    notifyListeners();
    return success;
  }

  Future<bool> editAnswer(int answerId, String answerText) async {
    _isLoading = true;
    notifyListeners();

    final result = await _answerService.updateAnswer(answerId, answerText);

    _isLoading = false;
    _connected = result["connected"] ?? false;

    bool success = false;

    if (result["success"] == true && result["data"] != null) {
      final index = _answers.indexWhere((a) => a.id == answerId);
      if (index != -1) {
        _answers[index] = result["data"];
      }
      _message = result["message"] ?? "Berhasil memperbarui jawaban";
      success = true;
    } else {
      _message = result["message"] ?? "Gagal memperbarui jawaban";
    }

    notifyListeners();
    return success;
  }

  Future<bool> deleteAnswer(int answerId) async {
    _isLoading = true;
    notifyListeners();

    final result = await _answerService.deleteAnswer(answerId);

    _isLoading = false;
    _connected = result["connected"] ?? false;

    bool success = false;

    if (result["success"] == true) {
      _answers.removeWhere((a) => a.id == answerId);
      _message = result["message"] ?? "Berhasil menghapus jawaban";
      success = true;
    } else {
      _message = result["message"] ?? "Gagal menghapus jawaban";
    }

    notifyListeners();
    return success;
  }
}
