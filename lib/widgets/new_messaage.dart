import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NewMessage extends StatefulWidget {
  const NewMessage({super.key});

  @override
  State<NewMessage> createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  final TextEditingController _messageController = TextEditingController();

  void _sendMessage() async {
    FocusScope.of(context).unfocus();
    final userId = FirebaseAuth.instance.currentUser?.uid;

    final userData =
        await FirebaseFirestore.instance.collection('users/').doc(userId).get();
        
    if (_messageController.text.trim().isEmpty) {
      return;
    }
    FirebaseFirestore.instance.collection('/chats/').add({
      'text': _messageController.text.trim(),
      'createdAt': Timestamp.now(),
      'userId': userId,
      'username': userData['username'],
      'userImage': userData['image_url']
    });
    _messageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.only(left: 8, bottom: 8),
      child: Row(children: [
        Expanded(
            child: TextField(
          controller: _messageController,
          decoration: InputDecoration(
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(7),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(7),
            ),
            labelText: 'Send message..',
          ),
        )),
        IconButton(
          onPressed: () {
            if (_messageController.text.isEmpty) {
              return;
            }
            _sendMessage();
          },
          icon: Icon(
            Icons.send,
            color: Theme.of(context).primaryColor,
          ),
        )
      ]),
    );
  }
}
