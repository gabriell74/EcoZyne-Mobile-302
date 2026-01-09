import 'package:ecozyne_mobile/data/models/question.dart';
import 'package:ecozyne_mobile/data/services/question_service.dart';
import 'package:flutter/material.dart';

class QuestionProvider with ChangeNotifier {
  final QuestionService _questionService = QuestionService();

  List<Question> _questions = [];
  bool _isLoading = false;
  String _message = "";
  bool _connected = true;

  List<Question> get questions => _questions;
  bool get isLoading => _isLoading;
  String get message => _message;
  bool get connected => _connected;

  Future<void> getQuestions() async {
    _isLoading = true;
    notifyListeners();

    final result = await _questionService.fetchQuestions();

    _connected = result["connected"] ?? false;

    if (result["success"]) {
      final data = result["data"];
      if (data != null && data.isNotEmpty) {
        _questions = data;
        _message = result["message"];
      } else {
        _questions = [];
        _message = "Belum ada pertanyaan, jadilah yang pertama";
      }
    } else {
      _questions = [];
      _message = result["message"] ?? "Gagal memuat pertanyaan";
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<bool> addQuestion(String question) async {
    _isLoading = true;
    notifyListeners();

    final result = await _questionService.storeQuestion(question);

    bool success = false;

    if (result["success"] == true && result["data"] != null) {
      final newQuestion = result["data"] as Question;

      _questions.insert(0, newQuestion);
      _message = result["message"];
      success = true;
      notifyListeners();
    } else {
      _message = result["message"];
    }

    _isLoading = false;
    notifyListeners();
    return success;
  }

  Future<bool> updateQuestion(int questionId, String newQuestionText) async {
    _isLoading = true;
    notifyListeners();

    final index = _questions.indexWhere((q) => q.id == questionId);
    if (index == -1) {
      _isLoading = false;
      notifyListeners();
      return false;
    }

    final oldQuestion = _questions[index].question;

    _questions[index].question = newQuestionText;
    notifyListeners();

    final result = await _questionService.updateQuestion(questionId, newQuestionText);

    _connected = result["connected"] ?? false;

    if (!result["success"]) {
      _questions[index].question = oldQuestion;
      _message = result["message"];
      _isLoading = false;
      notifyListeners();
      return false;
    }

    _questions[index] = Question.fromJson(result["data"]);
    _message = result["message"];

    _isLoading = false;
    notifyListeners();
    return true;
  }

  Future<void> toggleLike(int questionId) async {
    final index = _questions.indexWhere((q) => q.id == questionId);
    if (index == -1) return;

    final oldStatus = _questions[index].isLiked;
    final oldTotal = _questions[index].totalLike;

    _questions[index].isLiked = !_questions[index].isLiked;
    _questions[index].totalLike += _questions[index].isLiked ? 1 : -1;
    notifyListeners();

    final result = await _questionService.toggleLike(questionId);

    if (!result["success"]) {
      _questions[index].isLiked = oldStatus;
      _questions[index].totalLike = oldTotal;
      notifyListeners();
    } else {
      _questions[index].isLiked = result["is_liked"];
      _questions[index].totalLike = result["total_like"];
      notifyListeners();
    }
  }

  Future<bool> deleteQuestion(int questionId) async {
    _isLoading = true;
    notifyListeners();

    final result = await _questionService.deleteQuestion(questionId);

    _connected = result["connected"] ?? false;

    bool success = false;

    if (result["success"] == true) {
      _questions.removeWhere((q) => q.id == questionId);
      _message = result["message"] ?? "Berhasil menghapus pertanyaan";
      success = true;
    } else {
      _message = result["message"] ?? "Gagal menghapus pertanyaan";
    }

    _isLoading = false;
    notifyListeners();

    return success;
  }
}
