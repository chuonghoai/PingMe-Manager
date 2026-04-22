// ignore_for_file: use_super_parameters, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:pingme_manager/features/moment/ui/components/moment_report_detail.dart';
import 'package:pingme_manager/features/moment/ui/moment_controller.dart';
import 'moment_item_widget.dart';

class ListMomentsReportedComponent extends StatefulWidget {
  final MomentController controller;

  const ListMomentsReportedComponent({Key? key, required this.controller})
    : super(key: key);

  @override
  State<ListMomentsReportedComponent> createState() =>
      _ListMomentsReportedComponentState();
}

class _ListMomentsReportedComponentState
    extends State<ListMomentsReportedComponent> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.controller.fetchReportedMoments(isRefresh: true);
    });

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200) {
        widget.controller.fetchReportedMoments();
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
        if (widget.controller.isLoadingReported &&
            widget.controller.reportedMoments.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        return RefreshIndicator(
          onRefresh: () =>
              widget.controller.fetchReportedMoments(isRefresh: true),
          child: widget.controller.reportedMoments.isEmpty
              ? CustomScrollView(
                  slivers: [
                    SliverFillRemaining(
                      child: const Center(
                        child: Text('Không có khoảnh khắc nào bị báo cáo.'),
                      ),
                    ),
                  ],
                )
              : ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.only(top: 8, bottom: 80),
                  itemCount:
                      widget.controller.reportedMoments.length +
                      (widget.controller.isLoadingReported ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index == widget.controller.reportedMoments.length) {
                      return const Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Center(child: CircularProgressIndicator()),
                      );
                    }
                    final moment = widget.controller.reportedMoments[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MomentReportDetail(
                              momentId: moment.id,
                              controller: widget.controller,
                            ),
                          ),
                        );
                      },
                      child: MomentItemWidget(
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
                      ),
                    );
                  },
                ),
        );
      },
    );
  }
}
