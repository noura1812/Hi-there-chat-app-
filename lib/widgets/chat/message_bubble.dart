import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MessageBubble extends StatelessWidget {
  const MessageBubble(
      {super.key,
      required this.Key1,
      required this.message,
      required this.userName,
      required this.isMe,
      required this.url,
      required this.date,
      required this.seen});
  final Key Key1;
  final String message;
  final String userName;
  final String url;
  final bool isMe;
  final DateTime date;
  final String seen;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        if (!isMe)
          CircleAvatar(
            radius: 25,
            backgroundColor: Colors.transparent,
            backgroundImage: NetworkImage(url),
          ),
        Flexible(
          child: Container(
            decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(14),
                    topRight: const Radius.circular(14),
                    bottomLeft: !isMe
                        ? const Radius.circular(0)
                        : const Radius.circular(14),
                    bottomRight: isMe
                        ? const Radius.circular(0)
                        : const Radius.circular(14))),
            width: 140,
            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 1),
            margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
            child: Column(
              crossAxisAlignment:
                  isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (!isMe)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 5.0),
                          child: Text(
                            "${userName[0].toUpperCase()}${userName.substring(1)}",
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                            textAlign: isMe ? TextAlign.end : TextAlign.start,
                          ),
                        ),
                      Text(
                        message,
                        style: const TextStyle(color: Colors.white),
                        textAlign: isMe ? TextAlign.end : TextAlign.start,
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      DateFormat("dd  h:mm a").format(date).toString(),
                      style: TextStyle(
                          color: isMe ? Colors.grey[300] : Colors.grey[400],
                          fontSize: 10),
                    ),
                    Icon(
                      Icons.check_outlined,
                      color: seen == 'true'
                          ? const Color(0xFFF48154)
                          : isMe
                              ? Colors.grey[300]
                              : Colors.grey[400],
                      size: 18,
                    ),
                  ],
                )
              ],
            ),
          ),
        )
      ],
    );
  }
}
