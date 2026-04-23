// ignore_for_file: use_super_parameters, deprecated_member_use

import 'package:flutter/material.dart';
import '../../models/moment_model.dart';
import '../widget/option_handle.dart';

class MomentItemWidget extends StatelessWidget {
  final MomentModel moment;
  final VoidCallback onDelete;

  const MomentItemWidget({
    Key? key,
    required this.moment,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool hasUnhandledReport = (moment.unhandledReportCount ?? 0) > 0;
    bool isReported =
        (moment.isReported ?? false) || (moment.reportCount ?? 0) > 0;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(moment.user.avatarUrl ?? ""),
                  backgroundColor: Colors.grey[200],
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        moment.user.fullname ?? "Unknown",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        _formatDate(moment.createdAt),
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.more_horiz),
                  onPressed: () {
                    OptionHandle.show(context, onDeleteConfirm: onDelete);
                  },
                ),
              ],
            ),
          ),

          if (hasUnhandledReport || isReported)
            Padding(
              padding: const EdgeInsets.only(left: 12, bottom: 8),
              child: Row(
                children: [
                  if (hasUnhandledReport)
                    _buildBadge(
                      'Chờ xử lý (${moment.unhandledReportCount})',
                      Colors.redAccent,
                    )
                  else if (isReported)
                    _buildBadge(
                      'Bị báo cáo (${moment.reportCount})',
                      Colors.orange,
                    ),
                ],
              ),
            ),

          // Caption
          if (moment.caption != null && moment.caption!.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              child: Text(moment.caption!),
            ),
          const SizedBox(height: 8),

          // Image
          Image.network(
            moment.imageUrl,
            width: double.infinity,
            height: 300,
            fit: BoxFit.cover,
            errorBuilder: (ctx, err, stack) => Container(
              height: 200,
              color: Colors.grey[300],
              child: const Icon(
                Icons.broken_image,
                size: 50,
                color: Colors.grey,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBadge(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.5)),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return "${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}";
  }
}
