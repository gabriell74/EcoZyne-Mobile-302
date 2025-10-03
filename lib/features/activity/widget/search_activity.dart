import 'package:flutter/material.dart';

class SearchActivity extends StatefulWidget {
  final Function(String)? onSearch;

  const SearchActivity({super.key, this.onSearch});

  @override
  State<SearchActivity> createState() => _SearchActivityState();
}

class _SearchActivityState extends State<SearchActivity> {
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
      hintText: "Cari artikel...",
      backgroundColor: const WidgetStatePropertyAll(Colors.white),
      elevation: const WidgetStatePropertyAll(1),
      leading: const Icon(Icons.search_rounded),
      onSubmitted: (value) {
        if (widget.onSearch != null) {
          widget.onSearch!(value);
        }
      },
    );
  }
}
