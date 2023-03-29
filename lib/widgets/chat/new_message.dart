import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NewMessage extends StatefulWidget {
  final String reciverId;
  const NewMessage({required this.reciverId, super.key});

  @override
  State<NewMessage> createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  final _controller = TextEditingController();
  String _enyeredMessage = '';

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(8),
      child: Row(
        children: [
          Expanded(
              child: TextField(
            maxLines: null,
            keyboardType: TextInputType.multiline,
            decoration: InputDecoration(
                isDense: true, // Added this

                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    borderSide:
                        BorderSide(color: Colors.teal.shade200, width: 2)),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
                filled: true,
                hintStyle: TextStyle(color: Colors.grey[800]),
                hintText: "Send a message...",
                fillColor: Colors.white),
            controller: _controller,
            onChanged: ((value) {
              setState(() {
                _enyeredMessage = value;
              });
            }),
          )),
          const SizedBox(
            width: 5,
          ),
          CircleAvatar(
            radius: 25,
            backgroundColor: Colors.teal,
            child: IconButton(
                color: Colors.white,
                onPressed: _enyeredMessage.trim().isEmpty
                    ? null
                    : () async {
                        String id = '';
                        FocusScope.of(context).unfocus();
                        final user = FirebaseAuth.instance.currentUser;
                        final userData = await FirebaseFirestore.instance
                            .collection('users')
                            .doc(user!.uid)
                            .get();
                        FirebaseFirestore.instance
                            .collection(
                                'users/${FirebaseAuth.instance.currentUser!.uid}/${widget.reciverId}')
                            .add({
                          'text': _enyeredMessage,
                          'date': Timestamp.now(),
                          'userName': userData['username'],
                          'userId': user.uid,
                          'seen': 'false'
                        }).then((DocumentReference docs) {
                          setState(() {
                            id = docs.id;
                          });

                          FirebaseFirestore.instance
                              .collection(
                                  'users/${widget.reciverId}/${FirebaseAuth.instance.currentUser!.uid}')
                              .doc(id)
                              .set({
                            'text': _enyeredMessage,
                            'date': Timestamp.now(),
                            'userName': userData['username'],
                            'userId': user.uid,
                            'seen': 'false'
                          });
                          _controller.clear();
                          _enyeredMessage = '';
                        });
                      },
                icon: const Icon(Icons.send)),
          )
        ],
      ),
    );
  }
}
