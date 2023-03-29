import 'package:chat/screens/chat.dart';
import 'package:chat/widgets/contacts/card_details.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ContactCards extends StatefulWidget {
  const ContactCards({super.key});

  @override
  State<ContactCards> createState() => _ContactCardsState();
}

class _ContactCardsState extends State<ContactCards> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('users').snapshots(),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        final docs = snapshot.data.docs;
        final user = FirebaseAuth.instance.currentUser;

        return Flex(direction: Axis.horizontal, children: [
          Expanded(
            child: ListView.builder(
                itemCount: docs.length,
                itemBuilder: (context, index) {
                  if (docs[index].id == user!.uid) {
                    return Container();
                  }
                  return InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  CatScreen(reciver: docs[index]),
                            ));
                      },
                      child: Column(
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CircleAvatar(
                                radius: 25,
                                backgroundColor: Colors.transparent,
                                backgroundImage:
                                    NetworkImage(docs[index]['image']),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 0, horizontal: 10),
                                    child: SizedBox(
                                      width: width - 90,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "${docs[index]['username'][0].toUpperCase()}${docs[index]['username'].substring(1)}",
                                            style: const TextStyle(
                                                fontWeight: FontWeight.w500,
                                                color: Colors.black,
                                                fontSize: 20),
                                          ),
                                          CardDetails(
                                              docs: docs,
                                              index: index,
                                              date: true),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 5, horizontal: 10),
                                    child:
                                        CardDetails(docs: docs, index: index),
                                  ),
                                ],
                              )
                            ],
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 20.0),
                            child: Divider(
                              thickness: 1,
                              color: Colors.grey[300],
                            ),
                          )
                        ],
                      ));
                }),
          ),
        ]);
      },
    );
  }
}
