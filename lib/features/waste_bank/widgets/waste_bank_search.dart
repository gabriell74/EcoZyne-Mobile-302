import 'package:flutter/material.dart';

class SearchWasteBank extends StatefulWidget {
  final Function(String)? onSearch;

  const SearchWasteBank({super.key, this.onSearch});

  @override
  State<SearchWasteBank> createState() => _SearchActivityState();
}

class _SearchActivityState extends State<SearchWasteBank> {
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
      hintText: "Cari bank sampah...",
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
