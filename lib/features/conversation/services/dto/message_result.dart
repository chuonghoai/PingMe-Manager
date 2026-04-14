import 'package:pingme_manager/features/conversation/models/conversation_model.dart';

class ProcessedMessageResult {
  final bool isExisting;
  final int oldIndex;
  final ConversationModel? updatedConv;

  ProcessedMessageResult({
    required this.isExisting,
    this.oldIndex = -1,
    this.updatedConv,
  });
}
