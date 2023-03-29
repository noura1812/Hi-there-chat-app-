import 'package:chat/widgets/chat/messages.dart';
import 'package:chat/widgets/chat/new_message.dart';
import 'package:flutter/material.dart';

class CatScreen extends StatelessWidget {
  final reciver;

  const CatScreen({required this.reciver, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: CircleAvatar(
                radius: 20,
                backgroundColor: Colors.transparent,
                backgroundImage: NetworkImage(reciver['image']),
              ),
            ),
            Text(
              "${reciver['username'][0].toUpperCase()}${reciver['username'].substring(1)}",
            ),
          ],
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            Expanded(
                child: Messages(
              reciver: reciver,
            )),
            NewMessage(
              reciverId: reciver.id,
            )
          ],
        ),
      ),
    );
  }
}
