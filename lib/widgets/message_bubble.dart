import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  final String message;
  final bool isMe;
  final String username;
  final String imageUrl;
  final bool isRepeated;

  const MessageBubble(
      {super.key,
      required this.username,
      required this.message,
      required this.isMe,
      required this.imageUrl,
      required this.isRepeated});

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Row(
      mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        if (!isMe && !isRepeated)
          Padding(
            padding: const EdgeInsets.only(bottom: 15, left: 4),
            child: CircleAvatar(
              backgroundImage: NetworkImage(imageUrl),
            ),
          ),
        if (!isMe && isRepeated)
          const Padding(
            padding: EdgeInsets.only(left: 4.0),
            child: CircleAvatar(
              backgroundColor: Colors.transparent,
            ),
          ),
        Container(
          decoration: BoxDecoration(
            color: isMe
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.secondary,
            borderRadius: BorderRadius.only(
              topLeft: !isMe && !isRepeated
                  ? Radius.zero
                  : const Radius.circular(12),
              topRight:
                  isMe && !isRepeated ? Radius.zero : const Radius.circular(12),
              bottomLeft: const Radius.circular(12),
              bottomRight: const Radius.circular(12),
            ),
          ),
          constraints: BoxConstraints(
            maxWidth: deviceSize.width * 0.7,
          ),
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
          margin: EdgeInsets.only(top: isRepeated ? 1 : 4, left: 8, right: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (!isMe && !isRepeated)
                Text(
                  username,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              Text(
                message,
                textWidthBasis: TextWidthBasis.longestLine,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSecondary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
