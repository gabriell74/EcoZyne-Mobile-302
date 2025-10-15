import 'package:flutter/material.dart';

class SearchArticle extends StatefulWidget {
  final Function(String)? onSearch;

  const SearchArticle({super.key, this.onSearch});

  @override
  State<SearchArticle> createState() => _SearchArticleState();
}

class _SearchArticleState extends State<SearchArticle> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SearchBar(
      controller: _controller,
      hintText: "Cari artikel atau topik...",
      backgroundColor: const WidgetStatePropertyAll(Colors.white),
      elevation: const WidgetStatePropertyAll(1),
      leading: const Icon(Icons.search_rounded),
      shape: WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
      onSubmitted: (value) {
        if (widget.onSearch != null) {
          widget.onSearch!(value);
        }
      },
    );
  }
}
