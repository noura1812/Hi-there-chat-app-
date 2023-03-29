import 'package:chat/widgets/contacts/card.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Contacts extends StatelessWidget {
  const Contacts({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contacts'),
        actions: [
          DropdownButton(
              underline: Container(),
              icon: const Icon(Icons.more_vert, color: Colors.white),
              items: [
                DropdownMenuItem(
                    value: 'log out',
                    child: Row(
                      children: const [
                        Icon(Icons.exit_to_app, color: Colors.black),
                        SizedBox(
                          width: 8,
                        ),
                        Text('Log out')
                      ],
                    ))
              ],
              onChanged: ((value) {
                if (value == 'log out') {
                  FirebaseAuth.instance.signOut();
                }
              }))
        ],
      ),
      body: Container(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: const [
            Expanded(child: ContactCards()),
          ],
        ),
      ),
    );
  }
}
