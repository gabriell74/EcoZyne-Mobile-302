import 'package:flutter/material.dart';

class GiftSearchBar extends StatefulWidget {
  final Function(String)? onSearch;

  const GiftSearchBar({super.key, this.onSearch});

  @override
  State<GiftSearchBar> createState() => _GiftSearchBarState();
}

class _GiftSearchBarState extends State<GiftSearchBar> {
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
      hintText: "Cari hadiah untuk ditukar...",
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
