import 'package:ecozyne_mobile/core/widgets/app_background.dart';
import 'package:ecozyne_mobile/core/widgets/empty_state.dart';
import 'package:ecozyne_mobile/core/widgets/loading_widget.dart';
import 'package:ecozyne_mobile/data/providers/comic_provider.dart';
import 'package:ecozyne_mobile/features/comic/screens/comic_detail_screen.dart';
import 'package:ecozyne_mobile/features/comic/widgets/comic_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class KeepAliveWrapper extends StatefulWidget {
  final Widget child;

  const KeepAliveWrapper({super.key, required this.child});

  @override
  State<KeepAliveWrapper> createState() => _KeepAliveWrapperState();
}

class _KeepAliveWrapperState extends State<KeepAliveWrapper>
    with AutomaticKeepAliveClientMixin {

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return widget.child;
  }
}

class ComicScreen extends StatefulWidget {
  const ComicScreen({super.key});

  @override
  State<ComicScreen> createState() => _ComicScreenState();
}

class _ComicScreenState extends State<ComicScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ComicProvider>().getComics();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text('Komik'),
        centerTitle: true,
        backgroundColor: const Color(0xFF55C173),
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: AppBackground(
        child: Consumer<ComicProvider>(
          builder: (context, provider, child) {
            if (provider.isLoadingList) {
              return const Center(child: LoadingWidget());
            }

            if (provider.comics.isEmpty) {
              return Center(
                child: EmptyState(
                  connected: provider.connectedList,
                  message: provider.messageList,
                ),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: provider.comics.length,
              itemBuilder: (context, index) {
                final comic = provider.comics[index];

                return KeepAliveWrapper(
                  child: ComicCard(
                    title: comic.title,
                    imagePath: comic.coverPhoto,
                    createdAt: comic.createdAt,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ComicDetailScreen(
                            comicId: comic.id,
                            title: comic.title,
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}