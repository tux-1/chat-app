// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables


import 'package:flutter/material.dart';
import 'package:form_validator/form_validator.dart';
import 'package:image_picker/image_picker.dart';

import '../services/firebase_helper.dart';
import 'custom_textformfield.dart';
import 'image_picker.dart';

class AuthForm extends StatefulWidget {
  const AuthForm({super.key});

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  late bool _isLogin;
  bool _isLoading = false;
  XFile? _userImageFile;

  void _pickedImage(XFile? image) {
    setState(() {
      _userImageFile = image;
    });
  }

  void _setLoading(bool newLoadingStatus) {
    setState(() {
      _isLoading = newLoadingStatus;
    });
  }

  void _trySubmit() async {
    FocusScope.of(context).unfocus();
    final isValid = _formKey.currentState?.validate();

    if (_userImageFile == null && !_isLogin) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Pick an image lol'),
        backgroundColor: Theme.of(context).colorScheme.error,
        showCloseIcon: true,
      ));
      return;
    }

    if (isValid == true) {
      _setLoading(true);

      

      await FireBaseHelper.submitAuthForm(
        email: _emailController.text,
        password: _passwordController.text.trim(),
        isLogin: _isLogin,
        username: _usernameController.text.trim(),
        file: _userImageFile,
      ).onError((error, stackTrace) {
        if (mounted) {
          _setLoading(false);
        }
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(error.toString()),
          showCloseIcon: true,
          backgroundColor: Theme.of(context).colorScheme.error,
          duration: Duration(seconds: 2),
        ));
      });
      if (mounted) {
        _setLoading(false);
      }
    }
  }

  @override
  void initState() {
    _isLogin = true;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        elevation: 5,
        margin: EdgeInsets.all(20),
        child: Padding(
          padding: EdgeInsets.all(15),
          child: AnimatedSize(
            duration: Durations.short3,
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(
                  decelerationRate: ScrollDecelerationRate.fast),
              child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (!_isLogin)
                        UserImagePicker(imagePickerFn: _pickedImage),
                      const SizedBox(height: 20),
                      // Email field
                      CustomTextField(
                        key: ValueKey('email'),
                        controller: _emailController,
                        labelText: 'Email',
                        validator: ValidationBuilder().email().build(),
                        keyboardType: TextInputType.emailAddress,
                      ),

                      // Username field
                      if (!_isLogin)
                        CustomTextField(
                          key: ValueKey('username'),
                          controller: _usernameController,
                          labelText: 'Username',
                          validator: ValidationBuilder().minLength(4).build(),
                        ),

                      // Password field
                      CustomTextField(
                        key: ValueKey('password'),
                        controller: _passwordController,
                        keyboardType: TextInputType.visiblePassword,
                        labelText: 'Password',
                        validator: ValidationBuilder().minLength(7).build(),
                        obscureText: true,
                      ),

                      // Confirm password field
                      if (!_isLogin)
                        CustomTextField(
                          key: ValueKey('confirmpassword'),
                          controller: _confirmPasswordController,
                          keyboardType: TextInputType.visiblePassword,
                          labelText: 'Confirm Password',
                          validator: (value) {
                            if (value != _passwordController.text) {
                              return 'Passwords must match!';
                            }
                            return null;
                          },
                          obscureText: true,
                        ),
                      SizedBox(height: 1),
                      // Login / Signup button
                      ElevatedButton(
                          onPressed: _isLoading ? null : _trySubmit,
                          child: _isLoading
                              ? LinearProgressIndicator()
                              : Text(_isLogin ? 'Login' : 'Signup')),

                      // Switch auth mode button
                      TextButton(
                          onPressed: () {
                            _formKey.currentState?.reset();
                            setState(() {
                              _isLogin = !_isLogin;
                            });
                          },
                          child: Text(_isLogin
                              ? 'Create new account'
                              : 'I already have an account'))
                    ],
                  )),
            ),
          ),
        ),
      ),
    );
  }
}
