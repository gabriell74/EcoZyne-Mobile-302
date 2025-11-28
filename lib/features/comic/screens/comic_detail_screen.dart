import 'package:ecozyne_mobile/core/widgets/loading_widget.dart';
import 'package:ecozyne_mobile/core/widgets/empty_state.dart';
import 'package:ecozyne_mobile/data/providers/comic_provider.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';

class ComicDetailScreen extends StatefulWidget {
  final int comicId;
  final String title;

  const ComicDetailScreen({
    super.key,
    required this.comicId,
    required this.title,
  });

  @override
  State<ComicDetailScreen> createState() => _ComicDetailScreenState();
}

class _ComicDetailScreenState extends State<ComicDetailScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ComicProvider>().getComicDetail(widget.comicId);
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text(widget.title, style: const TextStyle(color: Colors.black)),
        centerTitle: true,
        backgroundColor: const Color(0xFF55C173),
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Consumer<ComicProvider>(
        builder: (context, provider, child) {

          if (provider.isLoadingDetail) {
            return const Center(child: LoadingWidget());
          }

          if (!provider.connectedDetail) {
            return Center(
              child: EmptyState(
                connected: false,
                message: provider.messageDetail,
              ),
            );
          }

          if (provider.comicDetail == null) {
            return const Center(child: LoadingWidget());
          }

          if (provider.comicDetail!.photos.isEmpty) {
            return Center(
              child: EmptyState(
                connected: provider.connectedDetail,
                message: "Tidak ada halaman komik",
              ),
            );
          }

          final photos = provider.comicDetail!.photos;

          return ListView.builder(
            controller: _scrollController,
            padding: EdgeInsets.zero,
            physics: const BouncingScrollPhysics(),
            itemCount: photos.length,
            itemBuilder: (context, index) {
              final img = photos[index];

              if (index + 2 < photos.length) {
                precacheImage(CachedNetworkImageProvider(photos[index + 2]), context);
              }

              return CachedNetworkImage(
                imageUrl: img,
                width: double.infinity,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  color: Colors.grey[300],
                  child: const Center(child: LoadingWidget()),
                ),
                errorWidget: (context, url, error) => Container(
                  color: Colors.grey[300],
                  height: 400,
                  child: const Center(
                    child: Icon(Icons.broken_image, size: 50, color: Colors.grey),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
