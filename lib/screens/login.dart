import 'dart:io';

import 'package:chat/widgets/Auth/auth_form.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _auth = FirebaseAuth.instance;
  bool _isloading = false;
  void _submitAuthForm(String email, String password, String username,
      bool islogin, BuildContext ctx,
      [File? image]) async {
    UserCredential userCredential;
    String error = '';
    try {
      setState(() {
        _isloading = true;
      });
      if (!islogin) {
        userCredential = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);

        final ref = FirebaseStorage.instance
            .ref()
            .child('user_images')
            .child('${userCredential.user!.uid}.jpg');
        await ref.putFile(image!);
        String url = await ref.getDownloadURL();
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userCredential.user!.uid)
            .set({'username': username, 'password': password, 'image': url});
      } else {
        userCredential = await _auth.signInWithEmailAndPassword(
            email: email, password: password);
      }
    } on FirebaseAuthException catch (e) {
      setState(() {
        _isloading = false;
      });
      if (e.code == 'weak-password') {
        error = 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        error = 'The account already exists for that email.';
      } else if (e.code == 'user-not-found') {
        error = 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        error = 'Wrong password provided for that user.';
      } else {
        error = e.code;
      }

      final snackBar = SnackBar(
        content: Text(
          error,
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: (Colors.black12),
      );
      ScaffoldMessenger.of(ctx).showSnackBar(snackBar);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: AuthForm(_submitAuthForm, _isloading),
    );
  }
}
