import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:validators/validators.dart';

import '../../../../zds_flutter.dart';

/// Type of message for [ZdsChatMessage].
enum MessageType {
  /// Text only message.
  text,

  /// Attachment only message.
  attachment,

  /// Information message. Not from a user.
  info,
}

/// Status of message for [ZdsChatMessage].
enum MessageStatus {
  /// Message not yet sent.
  notSent,

  /// Message sent, not yet delivered.
  sent,

  /// Message delivered, not yet read.
  delivered,

  /// Message read.
  read,

  /// Message status unknown.
  unknown
}

/// Message model for [ZdsChatMessage].
class Message {
  /// Constructs a [Message].
  ///
  /// For data safety, please use a named constructor: [Message.text], [Message.attachment] or [Message.info].
  const Message({
    required this.time,
    this.status = MessageStatus.unknown,
    this.senderName = '',
    this.content,
    this.isDeleted = false,
    this.reacts = const {},
    this.senderColor,
    this.tags = const [],
    this.attachment,
    this.isInfo = false,
    this.isForwarded = false,
    this.replyMessageInfo,
    this.id = '',
    this.attachmentType,
  });

  /// Constructs a Text only message.
  const Message.text({
    required this.status,
    required this.time,
    required this.content,
    this.senderName = '',
    this.isDeleted = false,
    this.reacts = const {},
    this.senderColor,
    this.tags = const [],
    this.isForwarded = false,
    this.replyMessageInfo,
    this.id = '',
  })  : attachment = null,
        isInfo = false,
        attachmentType = null;

  /// Constructs an info message used to display updates to user. Message not from another user.
  const Message.info({
    required this.content,
    this.time,
    this.id = '',
  })  : attachment = null,
        replyMessageInfo = null,
        reacts = const {},
        senderColor = null,
        isDeleted = false,
        senderName = '',
        isForwarded = false,
        isInfo = true,
        tags = const [],
        status = MessageStatus.notSent,
        attachmentType = null;

  /// Constructs a blank message. Should not normally be used.
  ///
  /// Used for [ZdsChatMessage.wrapper].
  const Message.blank()
      : attachment = null,
        content = null,
        senderColor = null,
        time = null,
        isDeleted = false,
        reacts = const {},
        senderName = '',
        status = MessageStatus.unknown,
        tags = const [],
        isInfo = false,
        isForwarded = false,
        replyMessageInfo = null,
        id = '',
        attachmentType = null;

  /// Text content of message.
  final String? content;

  /// True if message has been deleted.
  final bool isDeleted;

  /// Map of reactions to number of times received.
  final Map<String, int> reacts;

  /// Name to display for sender.
  final String senderName;

  /// Optional custom color used to display sender name.
  ///
  /// Defaults to using [ZetaColors.textDefault].
  final Color? senderColor;

  /// [MessageStatus] of message.
  final MessageStatus status;

  /// Time message was sent.
  final DateTime? time;

  /// List of tags.
  final List<String> tags;

  /// Attachment. Typically a document, image, video or voice note. //TODO(thelukwalton): UX-941
  final dynamic attachment;

  /// True if message is an information message, not a chat message.
  final bool isInfo;

  /// True if message has been forwarded.
  final bool isForwarded;

  /// Contents of message that is being replied to.
  final Message? replyMessageInfo;

  /// Unique ID of message.
  final String id;

  /// Type of file attached to message.
  final dynamic attachmentType;

  /// [MessageType] of message.
  MessageType get type => attachment != null
      ? MessageType.attachment
      : isInfo
          ? MessageType.info
          : MessageType.text;

  /// True if message has any reacts.
  bool get hasReacts => reacts.isNotEmpty && reacts.values.any((element) => element > 0);

  /// Returns formatted Date / Time string based on device preference.
  String timeString(BuildContext context) {
    if (time != null) {
      if (MediaQuery.of(context).alwaysUse24HourFormat) {
        return DateFormat('HH:mm').format(time!);
      } else {
        return DateFormat('hh:mm a').format(time!);
      }
    }
    return '';
  }
}

/// Extension on [String] for [ZdsChatMessage].
extension ChatString on String {
  /// Gets all URLs from a string.
  List<String> get urls {
    final RegExp exp = RegExp(
      r'(\b(((https?|ftp|file|):\/\/)|www[.])[-A-Z0-9+&@#\/%?=~_|!:,.;]*[-A-Z0-9+&@#\/%=~_|])',
      caseSensitive: false,
    );

    final List<String> urls = [];
    replaceAllMapped(exp, (Match match) {
      final urlMatch = match.group(0);

      if (urlMatch != null && isURL(urlMatch)) {
        urls.add(urlMatch);
      }
      return urlMatch ?? '';
    });

    return urls;
  }
}

/// Extension on [MessageStatus].
extension MessageStatusExtension on MessageStatus {
  /// Returns localized semantic label for message status.
  String label(BuildContext context) {
    switch (this) {
      case MessageStatus.notSent:
        return ComponentStrings.of(context).get('MSG_NOT_SENT', 'Message not sent');
      case MessageStatus.sent:
        return ComponentStrings.of(context).get('MSG_SENT', 'Message sent');
      case MessageStatus.delivered:
        return ComponentStrings.of(context).get('MSG_DELIVERED', 'Message delivered');
      case MessageStatus.read:
        return ComponentStrings.of(context).get('MSG_READ', 'Message read');
      case MessageStatus.unknown:
        return ComponentStrings.of(context).get('MSG_ERR', 'Message status unknown');
    }
  }
}
