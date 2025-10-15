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
      onSubmitted: (value) {
        if (widget.onSearch != null) {
          widget.onSearch!(value);
        }
      },
    );
  }
}
