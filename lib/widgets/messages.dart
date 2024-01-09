import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'message_bubble.dart';

class Messages extends StatelessWidget {
  const Messages({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('chats/')
            .orderBy('createdAt', descending: true)
            .snapshots(),
        builder: (context, chatSnapshot) {
          if (chatSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          final chatDocs = chatSnapshot.data?.docs;
          return ListView.builder(
              reverse: true,
              itemCount: chatDocs?.length,
              itemBuilder: (context, index) {
                return MessageBubble(
                  key: ValueKey(chatDocs?[index].id),
                  message: chatDocs?[index]['text'],
                  username: chatDocs?[index]['username'],
                  isMe: chatDocs?[index]['userId'] ==
                      FirebaseAuth.instance.currentUser?.uid,
                );
              });
        });
  }
}
