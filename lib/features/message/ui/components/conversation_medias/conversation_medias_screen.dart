import 'package:flutter/material.dart';
import 'conversation_medias_controller.dart';

class ConversationMediasScreen extends StatefulWidget {
  final String conversationId;

  const ConversationMediasScreen({super.key, required this.conversationId});

  @override
  State<ConversationMediasScreen> createState() =>
      _ConversationMediasScreenState();
}

class _ConversationMediasScreenState extends State<ConversationMediasScreen> {
  final ConversationMediasController _controller =
      ConversationMediasController();
  final ScrollController _scrollController = ScrollController();
  final Color amberGold = const Color(0xFFF5A623);

  @override
  void initState() {
    super.initState();
    _controller.loadInitialMedia(widget.conversationId);

    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _controller.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      _controller.loadMoreMedia(widget.conversationId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: amberGold),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Phương tiện đã chia sẻ',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: false,
      ),
      body: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          if (_controller.isLoadingInitial) {
            return Center(child: CircularProgressIndicator(color: amberGold));
          }

          if (_controller.errorMessage != null &&
              _controller.mediaList.isEmpty) {
            return Center(
              child: Text(
                _controller.errorMessage!,
                style: const TextStyle(color: Colors.red),
              ),
            );
          }

          if (_controller.mediaList.isEmpty) {
            return const Center(
              child: Text(
                'Chưa có phương tiện nào được chia sẻ.',
                style: TextStyle(color: Colors.grey, fontSize: 16),
              ),
            );
          }

          return Column(
            children: [
              Expanded(
                child: GridView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(4),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 4,
                    mainAxisSpacing: 4,
                  ),
                  itemCount: _controller.mediaList.length,
                  itemBuilder: (context, index) {
                    final mediaUrl =
                        _controller.mediaList[index].media?.secureUrl ?? '';

                    return Container(
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: mediaUrl.isNotEmpty
                            ? Image.network(
                                mediaUrl,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) =>
                                    const Icon(
                                      Icons.broken_image,
                                      color: Colors.grey,
                                    ),
                              )
                            : const Icon(Icons.image, color: Colors.grey),
                      ),
                    );
                  },
                ),
              ),

              if (_controller.isFetchingMore)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Center(
                    child: SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        color: amberGold,
                        strokeWidth: 2,
                      ),
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
