import 'package:flutter/material.dart';

class MarketplaceSearchBar extends StatefulWidget {
  final Function(String)? onSearch;

  const MarketplaceSearchBar({super.key, this.onSearch});

  @override
  State<MarketplaceSearchBar> createState() => _MarketplaceSearchBarState();
}

class _MarketplaceSearchBarState extends State<MarketplaceSearchBar> {
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
      hintText: "Cari produk...",
      backgroundColor: const WidgetStatePropertyAll(Colors.white),
      elevation: const WidgetStatePropertyAll(1),
      leading: const Icon(Icons.search_rounded),
      shape: WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
      onSubmitted:(value) {
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
