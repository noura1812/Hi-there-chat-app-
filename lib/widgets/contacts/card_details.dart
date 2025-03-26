import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// ignore: must_be_immutable
class CardDetails extends StatelessWidget {
  final docs;
  final int index;
  bool? date;
  CardDetails({super.key, required this.docs, required this.index, this.date});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    final user = FirebaseAuth.instance.currentUser;

    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection(
              'users/${FirebaseAuth.instance.currentUser!.uid}/${docs[index].id}')
          .orderBy('date', descending: true)
          .limit(1)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.waiting &&
            date == null) {
          if (snapshot.data!.docs.isEmpty) {
            return Container();
          } else if (snapshot.hasData) {
            // print(snapshot);
            return Row(children: [
              if (snapshot.data!.docs[0]['userId'] == user!.uid)
                Icon(
                  Icons.check_outlined,
                  color: snapshot.data!.docs[0]['seen'] == 'true'
                      ? const Color(0xFFF48154)
                      : Colors.grey,
                  size: 18,
                ),
              SizedBox(
                width: 200,
                child: Text(
                  "${snapshot.data!.docs[0]['text']}",
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: Colors.grey),
                ),
              ),
              SizedBox(
                width: width - 315,
              ),
              snapshot.data!.docs[0]['seen'] != 'true'
                  ? snapshot.data!.docs[0]['userId'] != user.uid
                      ? const Icon(
                          Icons.circle,
                          color: Color(0xFFF48154),
                        )
                      : Container()
                  : Container()
            ]);
          }
        }
        if (snapshot.connectionState != ConnectionState.waiting &&
            date == true) {
          if (snapshot.data!.docs.isEmpty) {
            return Container();
          } else if (snapshot.hasData) {
            // print(snapshot);
            return Text(
              DateFormat("h:mm a")
                  .format(DateFormat('yyyy-MM-dd HH:mm:ss').parse(
                      ((snapshot.data!.docs[0]['date'] as Timestamp).toDate())
                          .toString()))
                  .toString(),
              style: TextStyle(
                  fontSize: 12,
                  color: snapshot.data!.docs[0]['seen'] != 'true'
                      ? snapshot.data!.docs[0]['userId'] != user!.uid
                          ? const Color(0xFFF48154)
                          : Colors.grey
                      : Colors.grey),
            );
          }
        }
        return Container();
      },
    );
  }
}
