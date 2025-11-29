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
  void initState() {
    super.initState();
    _controller.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SearchBar(
      controller: _controller,
      hintText: "Cari kegiatan...",
      backgroundColor: const WidgetStatePropertyAll(Colors.white),
      elevation: const WidgetStatePropertyAll(1),
      leading: const Icon(Icons.search_rounded),
      shape: WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
      onSubmitted: (value) {
        widget.onSearch?.call(value);
      },
      trailing: [
        if (_controller.text.isNotEmpty)
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {
              _controller.clear();
              widget.onSearch?.call('');
            },
          ),
      ],
    );
  }
}
