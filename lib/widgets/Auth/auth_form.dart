import 'dart:io';

import 'package:flutter/material.dart';

import 'package:chat/widgets/pickers/user_imagepicker.dart';

class AuthForm extends StatefulWidget {
  void Function(String email, String password, String username, bool islogin,
      BuildContext ctx,
      [File? image]) submitAuthFn;
  final bool _isloading;
  AuthForm(this.submitAuthFn, this._isloading, {super.key});

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  bool _isLogin = true;
  String _email = '';
  String _password = '';
  String _urename = '';
  bool showpassword = false;
  File? _uerImageFile;
  void pickedImage(File pickedImage) {
    _uerImageFile = pickedImage;
  }

  void _subnmit() {
    final isvalid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();
    if (_uerImageFile == null && !_isLogin) {
      const snackBar = SnackBar(
        content: Text(
          'Please select a personal image',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: (Colors.black12),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return;
    }
    if (isvalid) {
      _formKey.currentState!.save();

      widget.submitAuthFn(_email.trim(), _password.trim(), _urename.trim(),
          _isLogin, context, _uerImageFile);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (!_isLogin) UserImagePicker(pickedImage),
                TextFormField(
                  key: const ValueKey('email'),
                  validator: (value) {
                    if (value == null ||
                        value.isEmpty ||
                        !value.contains('@')) {
                      return 'Pleas enter a valid email address';
                    }
                    return null;
                  },
                  onSaved: ((newValue) => _email = newValue!),
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(labelText: 'Email Address'),
                ),
                if (!_isLogin)
                  TextFormField(
                    key: const ValueKey('user name'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Pleas enter a valid user name';
                      }
                      return null;
                    },
                    onSaved: ((newValue) => _urename = newValue!),
                    decoration: const InputDecoration(labelText: 'User name'),
                  ),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Password',
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          showpassword = !showpassword;
                        });
                      },
                      icon: !showpassword
                          ? const Icon(Icons.visibility)
                          : const Icon(Icons.visibility_off),
                    ),
                  ),
                  key: const ValueKey('password'),
                  validator: (value) {
                    if (value == null || value.isEmpty || value.length < 7) {
                      return 'Password must be at leas 7 characters';
                    }
                    return null;
                  },
                  onSaved: ((newValue) => _password = newValue!),
                  obscureText: !showpassword,
                ),
                const SizedBox(
                  height: 12,
                ),
                if (widget._isloading)
                  const SizedBox(
                    height: 20.0,
                    width: 20.0,
                    child: CircularProgressIndicator(
                      strokeWidth: 3.5,
                    ),
                  ),
                if (!widget._isloading)
                  ElevatedButton(
                      onPressed: _subnmit,
                      child: Text(_isLogin ? 'Log in' : 'Sign Up')),
                if (!widget._isloading)
                  TextButton(
                      onPressed: () {
                        setState(() {
                          _isLogin = !_isLogin;
                        });
                      },
                      child: Text(_isLogin
                          ? 'Creat new account'
                          : 'I already have an account'))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
