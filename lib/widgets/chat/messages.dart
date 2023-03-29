import 'package:chat/widgets/chat/message_bubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:intl/intl.dart';

class Messages extends StatefulWidget {
  final reciver;

  const Messages({required this.reciver, super.key});
  @override
  State<Messages> createState() => _MessagesState();
}

class _MessagesState extends State<Messages> {
  bool animation = true;
  int y = 0;
  int x = 0;
  String url = '';
  String name = '';
  final user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    url = widget.reciver['image'];
    seen();

    name = widget.reciver['username'];
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection(
              'users/${FirebaseAuth.instance.currentUser!.uid}/${widget.reciver.id}')
          .orderBy('date', descending: true)
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        final docs = snapshot.data.docs;
        return ListView.builder(
            reverse: true,
            itemCount: docs.length,
            itemBuilder: (context, index) {
              if (y == 0) {
                x = docs.length;
                y++;
              }
              if (x != docs.length) {
                animation = false;
              }
              return AnimationConfiguration.staggeredList(
                position: index,
                duration: animation
                    ? const Duration(milliseconds: 1000)
                    : const Duration(milliseconds: 0),
                child: SlideAnimation(
                  horizontalOffset: animation
                      ? docs[index]['userId'] == user!.uid
                          ? 300
                          : -300
                      : 0,
                  child: InkWell(
                    onLongPress: () async {
                      return docs[index]['userId'] == user!.uid
                          ? _showSimpleDialog(docs[index].id)
                          : _showAlertDialog(name, docs[index].id);
                    },
                    child: MessageBubble(
                      Key1: ValueKey(docs[index].id),
                      isMe: docs[index]['userId'] == user!.uid,
                      message: docs[index]['text'],
                      userName: docs[index]['userName'],
                      date: DateFormat('yyyy-MM-dd HH:mm:ss').parse(
                          ((docs[index]['date'] as Timestamp).toDate())
                              .toString()),
                      url: url,
                      seen: docs[index]['seen'],
                    ),
                  ),
                ),
              );
            });
      },
    );
  }

  Future<void> _showAlertDialog(String name, String id) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          // <-- SEE HERE
          title: const Text('Delete message'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                  "Delete $name's message?",
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text(
                'Delete for me',
              ),
              onPressed: () async {
                Navigator.of(context).pop();

                await FirebaseFirestore.instance
                    .collection(
                        'users/${FirebaseAuth.instance.currentUser!.uid}/${widget.reciver.id}')
                    .doc(id)
                    .delete();
              },
            ),
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _showSimpleDialog(id) async {
    await showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            title: const Text('Delete message!'),
            children: <Widget>[
              SimpleDialogOption(
                onPressed: () async {
                  Navigator.of(context).pop();

                  await FirebaseFirestore.instance
                      .collection(
                          'users/${FirebaseAuth.instance.currentUser!.uid}/${widget.reciver.id}')
                      .doc(id)
                      .delete();

                  await FirebaseFirestore.instance
                      .collection(
                          'users/${widget.reciver.id}/${FirebaseAuth.instance.currentUser!.uid}')
                      .doc(id)
                      .delete();
                },
                child: const Text('Delete for everyone'),
              ),
              SimpleDialogOption(
                onPressed: () async {
                  Navigator.of(context).pop();

                  await FirebaseFirestore.instance
                      .collection(
                          'users/${FirebaseAuth.instance.currentUser!.uid}/${widget.reciver.id}')
                      .doc(id)
                      .delete();
                },
                child: const Text('Delete for me'),
              ),
              SimpleDialogOption(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Cancle'),
              ),
            ],
          );
        });
  }

  void seen() async {
    var collection = FirebaseFirestore.instance
        .collection(
            'users/${FirebaseAuth.instance.currentUser!.uid}/${widget.reciver.id}')
        .orderBy('date', descending: true);
    var querySnapshots = await collection.get();
    for (var doc in querySnapshots.docs) {
      if (doc['userId'] != user!.uid) {
        await doc.reference.update({
          'seen': 'true',
        });
      }
      var collection2 = FirebaseFirestore.instance.collection(
          'users/${widget.reciver.id}/${FirebaseAuth.instance.currentUser!.uid}');
      var querySnapshots2 = await collection2.get();
      for (var doc in querySnapshots2.docs) {
        await doc.reference.update({
          'seen': 'true',
        });
      }
    }
  }
}
