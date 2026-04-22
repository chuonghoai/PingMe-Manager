// ignore_for_file: use_super_parameters, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:pingme_manager/features/moment/ui/moment_controller.dart';
import 'moment_item_widget.dart';

class ListMomentsComponent extends StatefulWidget {
  final MomentController controller;

  const ListMomentsComponent({Key? key, required this.controller})
    : super(key: key);

  @override
  State<ListMomentsComponent> createState() => _ListMomentsComponentState();
}

class _ListMomentsComponentState extends State<ListMomentsComponent> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.controller.fetchAllMoments(isRefresh: true);
    });

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200) {
        widget.controller.fetchAllMoments();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.controller,
      builder: (context, _) {
        if (widget.controller.isLoadingAll &&
            widget.controller.allMoments.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        return RefreshIndicator(
          onRefresh: () => widget.controller.fetchAllMoments(isRefresh: true),
          child: widget.controller.allMoments.isEmpty
              ? CustomScrollView(
                  slivers: [
                    SliverFillRemaining(
                      child: const Center(child: Text('Chưa có khoảnh khắc nào.')),
                    ),
                  ],
                )
              : ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.only(top: 8, bottom: 80),
                  itemCount:
                      widget.controller.allMoments.length +
                      (widget.controller.isLoadingAll ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index == widget.controller.allMoments.length) {
                      return const Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Center(child: CircularProgressIndicator()),
                      );
                    }
                    final moment = widget.controller.allMoments[index];
                    return MomentItemWidget(
                      moment: moment,
                      onDelete: () async {
                        bool success = await widget.controller.deleteMoment(
                          moment.id,
                        );
                        if (success && mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Đã xóa thành công!'),
                              backgroundColor: Colors.green,
                            ),
                          );
                        }
                      },
                    );
                  },
                ),
        );
      },
    );
  }
}
