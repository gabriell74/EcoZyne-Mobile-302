import 'package:ecozyne_mobile/data/models/question.dart';
import 'package:ecozyne_mobile/data/services/question_service.dart';
import 'package:flutter/cupertino.dart';

class QuestionProvider with ChangeNotifier {
  final QuestionService _questionService = QuestionService();

  List<Question> _questions = [];
  List<Question> _filteredQuestions = [];
  bool _isLoading = false;
  String _message = "";
  bool _connected = true;
  bool _isSearching = false;


  List<Question> get questions => _questions;
  List<Question> get filteredQuestions => _filteredQuestions;
  bool get isLoading => _isLoading;
  String get message => _message;
  bool get connected => _connected;
  bool get isSearching => _isSearching;

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

}